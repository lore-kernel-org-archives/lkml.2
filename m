Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965977Ab1KJDrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:47:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936127Ab1KJDrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:04 2011
Message-Id: <20111109213204.322451799@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [217/264] [SCSI] mpt2sas: Fix for system hang when discovery in progress
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "nagalakshmi.nandigama@lsi.com" <nagalakshmi.nandigama@lsi.com>

commit 0167ac67ff6f35bf2364f7672c8012b0cd40277f upstream.

Fix for issue : While discovery is in progress, hot unplug and hot plug of
enclosure connected to the controller card is causing system to hang.

When a device is in the process of being detected at driver load time then
if it is removed, the device that is no longer present will not be added
to the list. So the code in _scsih_probe_sas() is rearranged as such so
the devices that failed to be detected are not added to the list.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7461,22 +7461,27 @@ _scsih_probe_sas(struct MPT2SAS_ADAPTER
 	/* SAS Device List */
 	list_for_each_entry_safe(sas_device, next, &ioc->sas_device_init_list,
 	    list) {
-		spin_lock_irqsave(&ioc->sas_device_lock, flags);
-		list_move_tail(&sas_device->list, &ioc->sas_device_list);
-		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
 		if (ioc->hide_drives)
 			continue;
 
 		if (!mpt2sas_transport_port_add(ioc, sas_device->handle,
 		    sas_device->sas_address_parent)) {
-			_scsih_sas_device_remove(ioc, sas_device);
+			list_del(&sas_device->list);
+			kfree(sas_device);
+			continue;
 		} else if (!sas_device->starget) {
 			mpt2sas_transport_port_remove(ioc,
 			    sas_device->sas_address,
 			    sas_device->sas_address_parent);
-			_scsih_sas_device_remove(ioc, sas_device);
+			list_del(&sas_device->list);
+			kfree(sas_device);
+			continue;
+
 		}
+		spin_lock_irqsave(&ioc->sas_device_lock, flags);
+		list_move_tail(&sas_device->list, &ioc->sas_device_list);
+		spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 	}
 }
 


