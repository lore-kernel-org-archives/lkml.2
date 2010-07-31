Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0GaRj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 13:39:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64477 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab0GaRjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 13:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QMwvmcrRfC8s7IC8A1DHUUp+5dM8WDvWFjW4ilm3Kycq8AjJAoCrwtX7YYT5EJX9b7
         yVa7NJKcaKRUxt8EHm307unwOia8DxJZcaE3yGvDT8kbUBCiRHCYtnwdqK0fs+b8EPCN
         6c5BAI1xY4/+SktGZCdvo88/bokX7Ve4tVcYs=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Marc Singer <elf@buici.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] usb: lh7a40x_udc: check return value of create_proc_read_entry()
Date: Sat, 31 Jul 2010 21:39:03 +0400
Message-Id: <1280597943-8485-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_proc_read_entry() may fail, if so return -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/usb/gadget/lh7a40x_udc.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/lh7a40x_udc.c b/drivers/usb/gadget/lh7a40x_udc.c
index fded3fc..b04a62f 100644
--- a/drivers/usb/gadget/lh7a40x_udc.c
+++ b/drivers/usb/gadget/lh7a40x_udc.c
@@ -244,7 +244,7 @@ udc_proc_read(char *page, char **start, off_t off, int count,
 
 #else	/* !CONFIG_USB_GADGET_DEBUG_FILES */
 
-#define create_proc_files() do {} while (0)
+#define create_proc_files() ({ (void *)1; })
 #define remove_proc_files() do {} while (0)
 
 #endif	/* CONFIG_USB_GADGET_DEBUG_FILES */
@@ -2092,7 +2092,12 @@ static int lh7a40x_udc_probe(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
-	create_proc_files();
+	if (create_proc_files() == NULL) {
+		DEBUG(KERN_ERR "%s: can't get irq %i, err %d\n", driver_name,
+		      IRQ_USBINTR, retval);
+		free_irq(IRQ_USBINTR, dev);
+		return -ENOMEM;
+	}
 
 	return retval;
 }
-- 
1.7.0.4

