Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2HUPTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:19:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44400 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2HUPTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:19:06 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: davem@davemloft.net
Subject: [PATCH] ide: fix generic_ide_suspend/resume Oops
CC: rjw@sisk.pl, stern@rowland.harvard.edu, hdegoede@redhat.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-ide@vger.kernel.org
Date: Tue, 21 Aug 2012 17:20:30 +0200
Message-ID: <87txvwgtkx.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This patch fixes a regresion introduced by commit 0998d063 (device-core: Ensure
drvdata = NULL when no driver is bound).

Suspend oopses in generic_ide_suspend() because dev_get_drvdata()
returns NULL (dev->p->driver_data == NULL) and this function is not
prepared for this.

Fix is based on Alan Stern's suggestion.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/ide/ide-pm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 9240609..8d1e32d 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -4,7 +4,7 @@
 
 int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 {
-	ide_drive_t *drive = dev_get_drvdata(dev);
+	ide_drive_t *drive = to_ide_device(dev);
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
@@ -40,7 +40,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 
 int generic_ide_resume(struct device *dev)
 {
-	ide_drive_t *drive = dev_get_drvdata(dev);
+	ide_drive_t *drive = to_ide_device(dev);
 	ide_drive_t *pair = ide_get_pair_dev(drive);
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq;
-- 
1.7.7

