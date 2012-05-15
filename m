Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965329Ab2EOCln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:41:43 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53484 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965287Ab2EOCRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 125/179] libsas: remove expander from dev list on error
Date: Mon, 14 May 2012 22:13:41 -0400
Message-ID: <1337048075-6132-126-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luben Tuikov <ltuikov@yahoo.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5911e963d3718e306bcac387b83e259aa4228896 upstream.

If expander discovery fails (sas_discover_expander()), remove the
expander from the port device list (sas_ex_discover_expander()),
before freeing it. Else the list is corrupted and, e.g., when we
attempt to send SMP commands to other devices, the kernel oopses.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
Reviewed-by: Jack Wang <jack_wang@usish.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/libsas/sas_expander.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index c65af02..fbf0a09 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -841,6 +841,9 @@ static struct domain_device *sas_ex_discover_expander(
 
 	res = sas_discover_expander(child);
 	if (res) {
+		spin_lock_irq(&parent->port->dev_list_lock);
+		list_del(&child->dev_list_node);
+		spin_unlock_irq(&parent->port->dev_list_lock);
 		kfree(child);
 		return NULL;
 	}
-- 
1.7.9.6

