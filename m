Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2DEIdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:33:47 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:12235
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819Ab2DEIdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:33:41 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M1ZZRQ-02-143-02
X-M-MSG: 
Date: Thu, 5 Apr 2012 16:32:45 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Message-ID: <20120405083245.GA19508@localhost.amd.com>
References: <1332915722-15963-8-git-send-email-ming.m.lin@intel.com>
 <Pine.LNX.4.44L0.1203281023380.1599-100000@iolanthe.rowland.org>
 <CAF1ivSahEvZ9+5gcNHiJGaJtwO94fT9XYEOkT2YH-Ej11==h+w@mail.gmail.com>
 <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
 <CAF1ivSZ6cZ0G9uYSRsz=h0iTYarb1kx=k6_UOqCuBX+0OMOXSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAF1ivSZ6cZ0G9uYSRsz=h0iTYarb1kx=k6_UOqCuBX+0OMOXSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 05 Apr 2012 08:33:20.0051 (UTC) FILETIME=[C17C9030:01CD1306]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 05, 2012 at 02:00:57PM +0800, Lin Ming wrote:
> >
> > Another thing to consider is, user might want to eject the tray by
> > software like the
> > eject /dev/sr0 command or some UI mouse clicks against the cdrom icon. I'm still
> > thinking how to do this correctly.
> 
> Assume eject /dev/sr0 is implemented as:
> 
> int fd = open("/dev/sr0", ...)
> ioctl(fd, CDROMEJECT)
> 

Indeed, it is implemented as this :-)

> We may need to resume ODD in the ioctl handler(scsi_cmd_ioctl).
> 

I prefer we do this in sr_block_ioctl.
Suppose the ODD is now runtime suspended and received an ioctl:
if the ioctl's cmd is CDROMEJECT, resume it.
For other cases, return an error code like EPERM.
When done, according to the result of ioctl: if success, leave it resumed;
if failed, put it back to sleep.

Something like this:

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..aa6e920 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -538,10 +539,21 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
        struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
        struct scsi_device *sdev = cd->device;
        void __user *argp = (void __user *)arg;
-       int ret;
+       int ret, rpm_resumed = 0;
 
        mutex_lock(&sr_mutex);
 
+       if (pm_runtime_suspended(&sdev->sdev_gendev)) {
+               if (cmd == CDROMEJECT) {
+                       scsi_autopm_get_device(sdev);
+                       rpm_resumed = 1;
+               }
+               else {
+                       ret = -EPERM;
+                       goto out;
+               }
+       }
+
        /*
         * Send SCSI addressing ioctls directly to mid level, send other
         * ioctls to cdrom/block level.
@@ -570,6 +582,9 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
        ret = scsi_ioctl(sdev, cmd, argp);
 
 out:
+       if (rpm_resumed && ret)
+               scsi_autopm_put_device(sdev);
+
        mutex_unlock(&sr_mutex);
        return ret;
 }

Does this work?

-Aaron


