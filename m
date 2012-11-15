Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993229Ab2KOEku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:40:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:48816 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992869Ab2KOELE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kelsey Prantis <kelsey.prantis@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 12/66] target: Re-add explict zeroing of INQUIRY bounce buffer memory
Date: Wed, 14 Nov 2012 20:10:17 -0800
Message-Id: <20121115040939.894865376@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit dea5f0998aa82bdeca260b87c653db11e91329b2 upstream.

This patch fixes a regression in spc_emulate_inquiry() code where the
local scope bounce buffer was no longer getting it's memory zeroed,
causing various problems with SCSI initiators that depend upon areas
of INQUIRY EVPD=0x83 payload having been zeroed.

This bug was introduced with the following v3.7-rc1 patch + CC'ed
stable commit:

commit ffe7b0e9326d9c68f5688bef691dd49f1e0d3651
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri Sep 7 17:30:38 2012 +0200

    target: support zero allocation length in INQUIRY

Go ahead and re-add the missing memset of bounce buffer memory to be
copied into the outgoing se_cmd descriptor kmapped SGL payload.

Reported-by: Kelsey Prantis <kelsey.prantis@intel.com>
Cc: Kelsey Prantis <kelsey.prantis@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_spc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -605,6 +605,8 @@ static int spc_emulate_inquiry(struct se
 	unsigned char buf[SE_INQUIRY_BUF];
 	int p, ret;
 
+	memset(buf, 0, SE_INQUIRY_BUF);
+
 	if (dev == tpg->tpg_virt_lun0.lun_se_dev)
 		buf[0] = 0x3f; /* Not connected */
 	else


