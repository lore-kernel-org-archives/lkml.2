Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2DFGKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 02:10:37 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42832 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2DFGKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 02:10:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120405083245.GA19508@localhost.amd.com>
References: <1332915722-15963-8-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1203281023380.1599-100000@iolanthe.rowland.org>
	<CAF1ivSahEvZ9+5gcNHiJGaJtwO94fT9XYEOkT2YH-Ej11==h+w@mail.gmail.com>
	<CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
	<CAF1ivSZ6cZ0G9uYSRsz=h0iTYarb1kx=k6_UOqCuBX+0OMOXSw@mail.gmail.com>
	<20120405083245.GA19508@localhost.amd.com>
Date: Fri, 6 Apr 2012 14:10:31 +0800
X-Google-Sender-Auth: reguyl_0Y534S3ESMeRA3peI6PA
Message-ID: <CAF1ivSaAm4pTTKpjipYZxfvCrPhxnpH6WtxpDoaHFhC5kwA5Lw@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
From: Lin Ming <ming.m.lin@intel.com>
To: Aaron Lu <aaron.lu@amd.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 4:32 PM, Aaron Lu <aaron.lu@amd.com> wrote:
> Hi,
>
> On Thu, Apr 05, 2012 at 02:00:57PM +0800, Lin Ming wrote:
>> >
>> > Another thing to consider is, user might want to eject the tray by
>> > software like the
>> > eject /dev/sr0 command or some UI mouse clicks against the cdrom icon. I'm still
>> > thinking how to do this correctly.
>>
>> Assume eject /dev/sr0 is implemented as:
>>
>> int fd = open("/dev/sr0", ...)
>> ioctl(fd, CDROMEJECT)
>>
>
> Indeed, it is implemented as this :-)
>
>> We may need to resume ODD in the ioctl handler(scsi_cmd_ioctl).
>>
>
> I prefer we do this in sr_block_ioctl.
> Suppose the ODD is now runtime suspended and received an ioctl:
> if the ioctl's cmd is CDROMEJECT, resume it.
> For other cases, return an error code like EPERM.
> When done, according to the result of ioctl: if success, leave it resumed;
> if failed, put it back to sleep.
>
> Something like this:
>
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 5fc97d2..aa6e920 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -45,6 +45,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
> +#include <linux/pm_runtime.h>
>  #include <asm/uaccess.h>
>
>  #include <scsi/scsi.h>
> @@ -538,10 +539,21 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>        struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
>        struct scsi_device *sdev = cd->device;
>        void __user *argp = (void __user *)arg;
> -       int ret;
> +       int ret, rpm_resumed = 0;
>
>        mutex_lock(&sr_mutex);
>
> +       if (pm_runtime_suspended(&sdev->sdev_gendev)) {
> +               if (cmd == CDROMEJECT) {
> +                       scsi_autopm_get_device(sdev);
> +                       rpm_resumed = 1;
> +               }
> +               else {
> +                       ret = -EPERM;
> +                       goto out;
> +               }
> +       }
> +
>        /*
>         * Send SCSI addressing ioctls directly to mid level, send other
>         * ioctls to cdrom/block level.
> @@ -570,6 +582,9 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>        ret = scsi_ioctl(sdev, cmd, argp);
>
>  out:
> +       if (rpm_resumed && ret)
> +               scsi_autopm_put_device(sdev);
> +
>        mutex_unlock(&sr_mutex);
>        return ret;
>  }
>
> Does this work?

I have tested this patch.
Unfortunately, this does not work.

int fd = open("/dev/sr0", ...)
ioctl(fd, COMMAND)

Actually, the open() code path requires CDROM to be in active state, for example

sr_block_open
  cdrom_open
    open_for_data
       cdo->drive_status
         scsi_test_unit_ready
           scsi_execute_req

I'm thinking 3 solutions.

Solution 1:
sr_block_open() always return failure in ZPODD state.
But "eject /dev/sr0" won't work in this solution.

Solution 2:
sr_block_open() always return success in ZPODD state.
Then we have to insert ODD status check in many entries accessing it.
For example, sr_drive_status(), sr_check_events(),  sr_lock_door() etc.
And only runtime resume ODD for some special case, for example,
CDROMEJECT ioctl.

Solution 3:
Runtime resume ODD in sr_block_open(), as Alan suggested.
But the big problem is userspace will open ODD every seconds, so ODD
is frequently
resumed and we lose the expected power savings from ZPODD.

Any other idea?

Thanks,
Lin Ming
