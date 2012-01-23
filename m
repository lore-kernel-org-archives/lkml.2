Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab2AXABF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:01:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab2AWXtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:49:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:25 2012
Message-Id: <20120123234024.998815521@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [24/90] SCSI: mpt2sas: Release spinlock for the raid device list before blocking it
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "nagalakshmi.nandigama@lsi.com" <nagalakshmi.nandigama@lsi.com>

commit 30c43282f3d347f47f9e05199d2b14f56f3f2837 upstream.

Added code to release the spinlock that is used to protect the
raid device list before calling a function that can block. The
blocking was causing a reschedule, and subsequently it is tried
to acquire the same lock, resulting in a panic (NMI Watchdog
detecting a CPU lockup).

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -6425,6 +6425,7 @@ _scsih_mark_responding_raid_device(struc
 			} else
 				sas_target_priv_data = NULL;
 			raid_device->responding = 1;
+			spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 			starget_printk(KERN_INFO, raid_device->starget,
 			    "handle(0x%04x), wwid(0x%016llx)\n", handle,
 			    (unsigned long long)raid_device->wwid);
@@ -6435,16 +6436,16 @@ _scsih_mark_responding_raid_device(struc
 			 */
 			_scsih_init_warpdrive_properties(ioc, raid_device);
 			if (raid_device->handle == handle)
-				goto out;
+				return;
 			printk(KERN_INFO "\thandle changed from(0x%04x)!!!\n",
 			    raid_device->handle);
 			raid_device->handle = handle;
 			if (sas_target_priv_data)
 				sas_target_priv_data->handle = handle;
-			goto out;
+			return;
 		}
 	}
- out:
+
 	spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 }
 


