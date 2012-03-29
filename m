Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab2C2PA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:00:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34130 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933376Ab2C2PAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:00:22 -0400
Date: Thu, 29 Mar 2012 11:00:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@amd.com>
cc: Lin Ming <ming.m.lin@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] [SCSI] sr: adds Zero-power ODD support
In-Reply-To: <CAOzJMDRajsjHwCC66XB6Mv-Deuy-wD4GiZbeuEqCQePSLw-Xxw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1203291050580.1417-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012, Aaron Lu wrote:

> >>> @@ -216,6 +244,11 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
> >>>       unsigned int events;
> >>>       int ret;
> >>>
> >>> +     /* Not necessary to check events if enter ZPODD state */
> >>> +     if (cd->device->power_off &&
> >>> +                     pm_runtime_suspended(&cd->device->sdev_gendev))
> >>> +             return 0;
> >>
> >> The comment is wrong and the new code does the wrong thing.  You _do_
> >> have to check for events even in the ZPODD state, which means
> >> sr_check_events must power-up the device if necessary.
> >> sd_check_events in James Bottomley's scsi-misc tree now does the right
> >> thing; see commit 4e2247b2bd289f079349d6c69755f8cff4e31f2b.
> >
> > The problem is userspace(GNOME, for example) will check for events
> > every seconds.
> > If sr is power up so frequently then we lost the expected power
> > savings from ZPODD.

That's true.  There's nothing you can do about it in the kernel; it's 
up to userspace to change the frequency of event polling.

> Agreed.
> BTW, it's udevd on my Linux box that changed the default poll msecs kernel param
> which caused sr_check_events being called every 2 seconds.

Indeed.

> > There are 2 events:
> >
> > DISK_EVENT_MEDIA_CHANGE
> > DISK_EVENT_EJECT_REQUEST
> >
> > In current implementation, if sr is in ZPODD state, then it means
> > there is no disk in the CDROM.
> > So if sr is in ZPODD state, MEDIA_CHANGE would never happen.

Sure it will: when the user inserts a disc.

> > EJECT_REQUEST seems can be ignored, since there is no disk in the CDROM at all.
> >
> 
> For the ODD to be put into suspend state, the conditions should be:
> 1 tray closed
> 2 no media inside
> I think we missed the condition 1 check now.
> 
> And if we follow the two conditions, the events can be safely ignored.

No, they can't.  Otherwise the device won't power back up when the user 
inserts a new disc.

> What do you think of blocking events for it when going to suspend and unblocking
> when resume? This could erase the unnecessary calls of the check events function
> when ODD is suspended.
> But disk_(un)block_events are not exported and can't be used in sr
> module. So I'm
> not sure how to do this.
> 
> Another thing to consider is, user might want to eject the tray by
> software like the
> eject /dev/sr0 command or some UI mouse clicks against the cdrom icon. I'm still
> thinking how to do this correctly.

What's the problem?  Can't the user already eject the tray via 
software?

> >>> @@ -260,6 +293,11 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
> >>>       cd->media_present = scsi_status_is_good(ret) ||
> >>>               (scsi_sense_valid(&sshdr) && sshdr.asc != 0x3a);
> >>>
> >>> +     if (!cd->media_present && cd->device->power_off && !cd->poweroff_event) {
> >>> +             scsi_autopm_put_device(cd->device);
> >>
> >> You can see your mistake here.  You call scsi_autopm_put_device here
> >> without calling scsi_autopm_get_device earlier.
> >
> > Let me check this.
> 
> I guess the earlier call of get device is this?
> 
>  869 int scsi_sysfs_add_sdev(struct scsi_device *sdev)
> ... ...
>  891
>  892        /* The following call will keep sdev active indefinitely, until
>  893         * its driver does a corresponding scsi_autopm_pm_device().  Only
>  894         * drivers supporting autosuspend will do this.
>  895         */
>  896        scsi_autopm_get_device(sdev);
>  897

You have to do this correctly.  Currently sr doesn't support runtime PM 
at all.  If you do want to support it, then the driver should call 
scsi_autopm_put_device at the end of the probe routine (or whenever it 
is ready to allow runtime suspends) and scsi_autopm_get_device at the 
start of the remove routine (or whenever it wants to prevent runtime 
suspends).

The idea is that the driver is probed with the PM usage counter set to
1, so a runtime suspend won't occur until you do a put.  Similarly, in
the remove routine, you must make sure that your gets and puts balance
out.

Alan Stern

