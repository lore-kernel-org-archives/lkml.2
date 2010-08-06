Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965697Ab0HFTtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:49:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54235 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935081Ab0HFTtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nyV4GE+Qb7LuoBHy0UZGfOEffgBaMvaCyXQFU9E9SIumGDbr3JyIIOwaz5uOT7zIlA
         a7zh53vy1OTzbd3VEQXEM+VnAsFKsjzFLlQ2Wir/3VpWWiIRJ+YWhS8L+rc3xLGzUw0U
         HfZcoi5HGMN3zWZS8x1K6XFgvafs/h/Jlf+qA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] char: stallion: call disable_pci_device() if pci_probe() failed
Date: Fri,  6 Aug 2010 23:49:23 +0400
Message-Id: <1281124165-12711-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error. Also it must not be called if request_region() fails as
it means that somebody uses device resources and rules the device.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/char/stallion.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index f2167f8..abbe335 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -2151,7 +2151,7 @@ static int __devinit stl_pciprobe(struct pci_dev *pdev,
 	brdp = stl_allocbrd();
 	if (brdp == NULL) {
 		retval = -ENOMEM;
-		goto err;
+		goto err_disable;
 	}
 	mutex_lock(&stl_brdslock);
 	brdnr = stl_getbrdnr();
@@ -2207,6 +2207,9 @@ err_null:
 	stl_brds[brdp->brdnr] = NULL;
 err_fr:
 	kfree(brdp);
+err_disable:
+	if (retval != -EBUSY)
+		pci_disable_device(pdev);
 err:
 	return retval;
 }
-- 
1.7.0.4

