Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0KNJXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 04:23:06 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55345 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab0KNJW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 04:22:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BfOn6y0gNaIHFLeuj2DYGBXAuV8FBBJW83yPdyUtlUHRf5KhMyOHukOstCFzrigxDB
         DZuwy8j9/TKwoxsuf2S/7ePg10yGluEkmzoFM17qYoJVVYW2lkNd14qbgSCoYGtDmp1B
         kAdal/rRc//ftVqHlutWw40HwJVufS68MZI3E=
Date: Sun, 14 Nov 2010 12:22:52 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Roland Dreier <rdreier@cisco.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Roland Dreier <rolandd@cisco.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Alex Chiang <achiang@hp.com>, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] infiniband: core: fix information leak to userspace
Message-ID: <20101114092252.GA5323@albatros>
References: <1289054481-18145-1-git-send-email-segooon@gmail.com>
 <ada39r8ohiz.fsf@cisco.com>
 <20101112180844.GA11533@albatros>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B85224A6@orsmsx501.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B85224A6@orsmsx501.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ib_ucm_init_qp_attr() and ucma_init_qp_attr() pass struct ib_uverbs_qp_attr
with reserved, qp_state, {ah_attr,alt_ah_attr}{reserved,->grh.reserved}
fields uninitialized to copy_to_user().  It leads to leaking of contents of
kernel stack memory to userspace.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested.

 drivers/infiniband/core/uverbs_marshall.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index 5440da0..1b1146f 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -40,18 +40,21 @@ void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 	dst->grh.sgid_index        = src->grh.sgid_index;
 	dst->grh.hop_limit         = src->grh.hop_limit;
 	dst->grh.traffic_class     = src->grh.traffic_class;
+	memset(&dst->grh.reserved, 0, sizeof(dst->grh.reserved));
 	dst->dlid 	    	   = src->dlid;
 	dst->sl   	    	   = src->sl;
 	dst->src_path_bits 	   = src->src_path_bits;
 	dst->static_rate   	   = src->static_rate;
 	dst->is_global             = src->ah_flags & IB_AH_GRH ? 1 : 0;
 	dst->port_num 	    	   = src->port_num;
+	dst->reserved 		   = 0;
 }
 EXPORT_SYMBOL(ib_copy_ah_attr_to_user);
 
 void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 			     struct ib_qp_attr *src)
 {
+	dst->qp_state	        = src->qp_state;
 	dst->cur_qp_state	= src->cur_qp_state;
 	dst->path_mtu		= src->path_mtu;
 	dst->path_mig_state	= src->path_mig_state;
@@ -83,6 +86,7 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 	dst->rnr_retry		= src->rnr_retry;
 	dst->alt_port_num	= src->alt_port_num;
 	dst->alt_timeout	= src->alt_timeout;
+	memset(dst->reserved, 0, sizeof(dst->reserved));
 }
 EXPORT_SYMBOL(ib_copy_qp_attr_to_user);
 
-- 
1.7.0.4
