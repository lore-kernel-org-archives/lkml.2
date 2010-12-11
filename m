Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab0LKTiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 14:38:18 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41014 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751293Ab0LKTiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 14:38:18 -0500
Date: Sat, 11 Dec 2010 14:38:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux-pm@lists.linux-foundation.org, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] 2.6.37-rc5, pata_atiixp, DVD-ROM: kernel log flooded
 with "rpm_resume flags 0x4", "rpm_resume returns 1"
In-Reply-To: <20101211173234.77617d3a@stein>
Message-ID: <Pine.LNX.4.44L0.1012111425520.14704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Dec 2010, Stefan Richter wrote:

> Hi,
> 
> I just booted from 2.6.36 (without PM debugging configured) into
> 2.6.37-rc5 (with PM debugging enabled).  There is endless log spam like
> this:
> 
> Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume returns 1
> Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume flags 0x4
> Dec 11 17:11:31 stein kernel: scsi host6: rpm_resume returns 1
...

> Why is rpm_resume performed 6 times every two seconds?

This is probably because hal probes the DVD drive every two seconds
looking for media changes.  However that's not supposed to cause
rpm_resume to be called for the host unless runtime PM is allowed for
the DVD drive, which it isn't according to your listings below.  So
there's a bug somewhere.

> host6 is pata_atiixp with an:
> 
> 00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
> (prog-if 8a [Master SecP PriP])
> 
> # grep . /sys/class/scsi_host/host6/power/*
> /sys/class/scsi_host/host6/power/async:enabled
> grep: /sys/class/scsi_host/host6/power/autosuspend_delay_ms: Input/output error
> /sys/class/scsi_host/host6/power/control:auto
> /sys/class/scsi_host/host6/power/runtime_active_kids:0
> /sys/class/scsi_host/host6/power/runtime_active_time:0
> /sys/class/scsi_host/host6/power/runtime_enabled:disabled
> /sys/class/scsi_host/host6/power/runtime_status:unsupported
> /sys/class/scsi_host/host6/power/runtime_suspended_time:0
> /sys/class/scsi_host/host6/power/runtime_usage:0

This is the wrong directory (the class device, not the device itself).  
You should look at /sys/class/scsi_host/host6/device/power instead.  
And also /sys/class/scsi_host/host6/device/target6:0:0/power.

> Attached to it is one device:
> 
> Host: scsi6 Channel: 00 Id: 00 Lun: 00
>   Vendor: PLEXTOR  Model: DVD-ROM PX-130A  Rev: 1.01
>   Type:   CD-ROM                           ANSI  SCSI revision: 05
> 
> # grep . /sys/class/scsi_host/host6/device/target6\:0\:0/6\:0\:0\:0/power/*
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/async:enabled
> grep: /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/autosuspend_delay_ms: Input/output error
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/control:on
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_active_kids:0
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_active_time:2689146
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_enabled:forbidden
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_status:active
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_suspended_time:0
> /sys/class/scsi_host/host6/device/target6:0:0/6:0:0:0/power/runtime_usage:2

These values are correct; they show that the DVD drive is forbidden 
from doing a runtime suspend.

Alan Stern

