Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab0LQURF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:17:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38594 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab0LQURB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:17:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 17 Dec 2010 21:15:56 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@lists.linux-foundation.org, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] 2.6.37-rc5, pata_atiixp, DVD-ROM: kernel log flooded
 with "rpm_resume flags 0x4", "rpm_resume returns 1"
Message-ID: <20101217211556.2789cb80@stein>
In-Reply-To: <Pine.LNX.4.44L0.1012111425520.14704-100000@netrider.rowland.org>
References: <20101211173234.77617d3a@stein>
	<Pine.LNX.4.44L0.1012111425520.14704-100000@netrider.rowland.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11 Alan Stern wrote:
> On Sat, 11 Dec 2010, Stefan Richter wrote:
> 
> > Hi,
> > 
> > I just booted from 2.6.36 (without PM debugging configured) into
> > 2.6.37-rc5 (with PM debugging enabled).  There is endless log spam like
> > this:
> > 
> > Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume flags 0x4
> > Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume returns 1
> > Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume flags 0x4
> > Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume returns 1
> ...
> 
> > Why is rpm_resume performed 6 times every two seconds?
> 
> This is probably because hal probes the DVD drive every two seconds
> looking for media changes.  However that's not supposed to cause
> rpm_resume to be called for the host unless runtime PM is allowed for
> the DVD drive, which it isn't according to your listings below.  So
> there's a bug somewhere.

I had 2.6.36 running since then and have now booted into 2.6.37-rc6.

Yes, it is hal indeed.  Shutting hal down avoids this logging activity.

> > host6 is pata_atiixp with an:
> > 
> > 00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
> > (prog-if 8a [Master SecP PriP])
> > 
> > # grep . /sys/class/scsi_host/host6/power/*
> > /sys/class/scsi_host/host6/power/async:enabled
> > grep: /sys/class/scsi_host/host6/power/autosuspend_delay_ms: Input/output error
> > /sys/class/scsi_host/host6/power/control:auto
> > /sys/class/scsi_host/host6/power/runtime_active_kids:0
> > /sys/class/scsi_host/host6/power/runtime_active_time:0
> > /sys/class/scsi_host/host6/power/runtime_enabled:disabled
> > /sys/class/scsi_host/host6/power/runtime_status:unsupported
> > /sys/class/scsi_host/host6/power/runtime_suspended_time:0
> > /sys/class/scsi_host/host6/power/runtime_usage:0
> 
> This is the wrong directory (the class device, not the device itself).  
> You should look at /sys/class/scsi_host/host6/device/power instead.  
> And also /sys/class/scsi_host/host6/device/target6:0:0/power.

OK, correct directory follows below.

Actually, this time I see once every two seconds a message about
logical unit 6:0:0:0 and 6 times every two seconds a message about
host7:

Dec 17 20:22:08 stein kernel: sd 6:0:0:0: rpm_resume flags 0x4
Dec 17 20:22:08 stein kernel: sd 6:0:0:0: rpm_resume returns 1
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:08 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:10 stein kernel: sd 6:0:0:0: rpm_resume flags 0x4
Dec 17 20:22:10 stein kernel: sd 6:0:0:0: rpm_resume returns 1
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume returns 1
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume flags 0x4
Dec 17 20:22:10 stein kernel: scsi host7: rpm_resume returns 1

sd 6:0:0:0 is a USB card reader built into a monitor:
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic  Model: Ultra HS-SD/MMC  Rev: 1.88
  Type:   Direct-Access                    ANSI  SCSI revision: 00

This is from the power/ directory of the "6:0:0:0" device which is
bound to driver sd:

/sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/host6/target6:0:0/6:0:0:0/power/async:enabled
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/host6/target6:0:0/6:0:0:0/power/control:on
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/host6/target6:0:0/6:0:0:0/power/runtime_active_kids:0
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/host6/target6:0:0/6:0:0:0/power/runtime_active_time:1650131
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/host6/target6:0:0/6:0:0:0/power/runtime_enabled:forbidden
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/host6/target6:0:0/6:0:0:0/power/runtime_status:active
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/host6/target6:0:0/6:0:0:0/power/runtime_suspended_time:0
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-1/1-1.1/1-1.1.1/1-1.1.1:1.0/host6/target6:0:0/6:0:0:0/power/runtime_usage:1

host7 is the mentioned ATI SB700/SB800 IDE controller.  Here is the
power/ directory of the scsi_host device (rather than scsi_host class
device):

/sys/devices/pci0000:00/0000:00:14.1/host7/power/async:enabled
/sys/devices/pci0000:00/0000:00:14.1/host7/power/control:auto
/sys/devices/pci0000:00/0000:00:14.1/host7/power/runtime_active_kids:1
/sys/devices/pci0000:00/0000:00:14.1/host7/power/runtime_active_time:1935478
/sys/devices/pci0000:00/0000:00:14.1/host7/power/runtime_enabled:enabled
/sys/devices/pci0000:00/0000:00:14.1/host7/power/runtime_status:active
/sys/devices/pci0000:00/0000:00:14.1/host7/power/runtime_suspended_time:0
/sys/devices/pci0000:00/0000:00:14.1/host7/power/runtime_usage:0

The parent device 0000:00:14.1 is bound to the mentioned pata_atiixp,
if this is of any importance at all.

>From the child device:

/sys/devices/pci0000:00/0000:00:14.1/host7/target7:0:0/power/async:enabled
/sys/devices/pci0000:00/0000:00:14.1/host7/target7:0:0/power/control:auto
/sys/devices/pci0000:00/0000:00:14.1/host7/target7:0:0/power/runtime_active_kids:1
/sys/devices/pci0000:00/0000:00:14.1/host7/target7:0:0/power/runtime_active_time:2402125
/sys/devices/pci0000:00/0000:00:14.1/host7/target7:0:0/power/runtime_enabled:enabled
/sys/devices/pci0000:00/0000:00:14.1/host7/target7:0:0/power/runtime_status:active
/sys/devices/pci0000:00/0000:00:14.1/host7/target7:0:0/power/runtime_suspended_time:0
/sys/devices/pci0000:00/0000:00:14.1/host7/target7:0:0/power/runtime_usage:0

--------

On Dec 11 Rafael J. Wysocki wrote:
> On Saturday, December 11, 2010, Stefan Richter wrote:
> > Hi,
> > 
> > I just booted from 2.6.36 (without PM debugging configured) into
> > 2.6.37-rc5 (with PM debugging enabled).  There is endless log spam like
> > this:
> 
> I guess you have either CONFIG_PM_VERBOSE set or CONFIG_PM_DEBUG unset.
> 
> Which is the case?

I have both options off on 2.6.36 and older kernels.  I have both
options on on 2.6.37-rc5/-rc6 (because I wanted to check something
unrelated on 2.6.37).
-- 
Stefan Richter
-=====-==-=- ==-- =---=
http://arcgraph.de/sr/
