Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0JNQjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 12:39:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab0JNQjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 12:39:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=vnL3sQ6BAgb86/NYC1+Od267pXrgL24VaIFv7kR/EwaGBzXZOo9LpITsGIV0FQAN8Q
         gZowOTTrJRSCEjEF/MIt0CPPfL0GfbCgebOU3sk0Yfds3rYwF3pVjbPU9cm2hmh3QQYb
         Y4sVi+yUGBNXRUi3T756UvkSKDw2bnk08rTVE=
Date: Thu, 14 Oct 2010 18:38:49 +0200
From: Dan Carpenter <error27@gmail.com>
To: James Smart <james.smart@emulex.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -next] lpfc: unlock etc on error path
Message-ID: <20101014163849.GA6614@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	James Smart <james.smart@emulex.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Alex Iannicelli <alex.iannicelli@emulex.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the other error paths call sysfs_mbox_idle() and unlock before
returning. 

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f681eea..5f7d9e6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3789,8 +3789,11 @@ sysfs_mbox_read(struct file *filp, struct kobject *kobj,
 			break;
 		case MBX_SECURITY_MGMT:
 		case MBX_AUTH_PORT:
-			if (phba->pci_dev_grp == LPFC_PCI_DEV_OC)
+			if (phba->pci_dev_grp == LPFC_PCI_DEV_OC) {
+				sysfs_mbox_idle(phba);
+				spin_unlock_irq(&phba->hbalock);
 				return -EPERM;
+			}
 			break;
 		case MBX_READ_SPARM64:
 		case MBX_READ_LA:
