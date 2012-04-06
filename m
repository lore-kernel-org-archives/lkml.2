Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2DFIBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:01:43 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:55822
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754533Ab2DFIBl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:01:41 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dK4015I179dNzz1202hzzz2dh668h839hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M21SYJ-02-1XB-02
X-M-MSG: 
Date: Sat, 7 Apr 2012 00:01:27 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
Message-ID: <20120406160126.GA4835@localhost.amd.com>
References: <1332915722-15963-8-git-send-email-ming.m.lin@intel.com>
 <Pine.LNX.4.44L0.1203281023380.1599-100000@iolanthe.rowland.org>
 <CAF1ivSahEvZ9+5gcNHiJGaJtwO94fT9XYEOkT2YH-Ej11==h+w@mail.gmail.com>
 <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
 <CAF1ivSZ6cZ0G9uYSRsz=h0iTYarb1kx=k6_UOqCuBX+0OMOXSw@mail.gmail.com>
 <20120405083245.GA19508@localhost.amd.com>
 <CAF1ivSaAm4pTTKpjipYZxfvCrPhxnpH6WtxpDoaHFhC5kwA5Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAF1ivSaAm4pTTKpjipYZxfvCrPhxnpH6WtxpDoaHFhC5kwA5Lw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 06 Apr 2012 08:01:26.0099 (UTC) FILETIME=[77186A30:01CD13CB]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Apr 06, 2012 at 02:10:31PM +0800, Lin Ming wrote:
> >
> > I prefer we do this in sr_block_ioctl.
> > Suppose the ODD is now runtime suspended and received an ioctl:
> > if the ioctl's cmd is CDROMEJECT, resume it.
> > For other cases, return an error code like EPERM.
> > When done, according to the result of ioctl: if success, leave it resumed;
> > if failed, put it back to sleep.
> >
> > Something like this:
> >
> > diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> > index 5fc97d2..aa6e920 100644
> > --- a/drivers/scsi/sr.c
> > +++ b/drivers/scsi/sr.c
> > @@ -45,6 +45,7 @@
> >  #include <linux/blkdev.h>
> >  #include <linux/mutex.h>
> >  #include <linux/slab.h>
> > +#include <linux/pm_runtime.h>
> >  #include <asm/uaccess.h>
> >
> >  #include <scsi/scsi.h>
> > @@ -538,10 +539,21 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
> >        struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
> >        struct scsi_device *sdev = cd->device;
> >        void __user *argp = (void __user *)arg;
> > -       int ret;
> > +       int ret, rpm_resumed = 0;
> >
> >        mutex_lock(&sr_mutex);
> >
> > +       if (pm_runtime_suspended(&sdev->sdev_gendev)) {
> > +               if (cmd == CDROMEJECT) {
> > +                       scsi_autopm_get_device(sdev);
> > +                       rpm_resumed = 1;
> > +               }
> > +               else {
> > +                       ret = -EPERM;
> > +                       goto out;
> > +               }
> > +       }
> > +
> >        /*
> >         * Send SCSI addressing ioctls directly to mid level, send other
> >         * ioctls to cdrom/block level.
> > @@ -570,6 +582,9 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
> >        ret = scsi_ioctl(sdev, cmd, argp);
> >
> >  out:
> > +       if (rpm_resumed && ret)
> > +               scsi_autopm_put_device(sdev);
> > +
> >        mutex_unlock(&sr_mutex);
> >        return ret;
> >  }
> >
> > Does this work?
> 
> I have tested this patch.
> Unfortunately, this does not work.
> 
> int fd = open("/dev/sr0", ...)
> ioctl(fd, COMMAND)
> 
> Actually, the open() code path requires CDROM to be in active state, for example
> 
> sr_block_open
>   cdrom_open
>     open_for_data
>        cdo->drive_status
>          scsi_test_unit_ready
>            scsi_execute_req
> 
Hmm... This is not the case on my Linux box.
eject will use O_NONBLOCK when open, which would results in the
following code path:
sr_block_open
  cdrom_open
    cdi->ops->open(sr_open)
      done

Maybe your eject is old and doesn't use the O_NONBLOCK flag?
If it is the case, then we may need to avoid this solution since we
can't depend on the user space tools.

> I'm thinking 3 solutions.
> 
> Solution 1:
> sr_block_open() always return failure in ZPODD state.
> But "eject /dev/sr0" won't work in this solution.
> 
Right, so, not an option.

> Solution 2:
> sr_block_open() always return success in ZPODD state.
> Then we have to insert ODD status check in many entries accessing it.
> For example, sr_drive_status(), sr_check_events(),  sr_lock_door() etc.
> And only runtime resume ODD for some special case, for example,
> CDROMEJECT ioctl.
Sounds like pretty complicated :-)

> 
> Solution 3:
> Runtime resume ODD in sr_block_open(), as Alan suggested.
> But the big problem is userspace will open ODD every seconds, so ODD
> is frequently
> resumed and we lose the expected power savings from ZPODD.
Yes, the udisks-daemon will constantly open the ODD's block device,
dunno why it would do this, need to check its code later.

Another problem I can think of doing suspend/resume in open/release is,
it's not that easy to determine if we should suspend the ODD in release
function. We may need to do some extra house keeping to achieve this
based on information like if the door is open and/or if there is media
inside, etc.

Thanks,
Aaron

