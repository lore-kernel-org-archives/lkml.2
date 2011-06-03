Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1FCXoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:44:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:11551 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427Ab1FCXoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:44:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,317,1304319600"; 
   d="scan'208";a="13344070"
From: Russ Gorby <russ.gorby@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Russ Gorby <russ.gorby@intel.com>,
        linux-kernel@vger.kernel.org
Cc: suhail.ahmed@intel.com, russ.gorby@intel.com
Subject: [PATCHv2 7/7] char: n_gsm: improper skb_pull() use was leaking framed data
Date: Fri,  3 Jun 2011 16:44:02 -0700
Message-Id: <1307144642-5915-8-git-send-email-russ.gorby@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2>
References: <[PATCHv2 0/5] N_GSM patchset : 06/03/2011: v2>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gsm_dlci_data_output_framed() was doing:
memcpy(dp, skb_pull(dlci->skb, len), len);

The problem is skb_pull() returns the post-increment skb->data ptr
so the first chunk can be leaked.

Signed-off-by: Russ Gorby <russ.gorby@intel.com>
---
 drivers/tty/n_gsm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 7f95bfd..660c5ca 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -903,7 +903,8 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 		*dp++ = last << 7 | first << 6 | 1;	/* EA */
 		len--;
 	}
-	memcpy(dp, skb_pull(dlci->skb, len), len);
+	memcpy(dp, dlci->skb->data, len);
+	skb_pull(dlci->skb, len);
 	__gsm_data_queue(dlci, msg);
 	if (last) {
 		kfree_skb(dlci->skb);
-- 
1.7.0.4

