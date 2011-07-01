Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1GATUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 15:20:49 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48580 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755428Ab1GATUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 15:20:46 -0400
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk,
        rjw@sisk.pl
In-Reply-To: <20110701170531.GA3693@tassilo.jf.intel.com>
References: <20110701170531.GA3693@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 14:20:44 -0500
Message-ID: <1309548044.2722.35.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 10:05 -0700, Andi Kleen wrote:
> Hi,
> 
> I found I can reliably crash a 3.0 system by pulling the
> USB cable of a mounted USB cdrom (or rather a USB device which
> has a builtin fake CD-ROM) 
> 
> I suspect it's a regression too.
> 
> It ends with a NULL pointer reference on a NULL sdev in 
> scsi_prep_state_check. 
> 
> Here's a somewhat incomplete backtrace (written down by hand)
> 
> scsi_prep_state_check
> scsi_setup_blk_pc_cmnd
> blk_peek_request
> ...
> scsi_request_fn
> ...
> ioctl_internal_command
> ...
> scsi_set_medium_removal
> sr_lock_door
> cdrom_release
> ...
> umount
> 
> I tried adding a 
> 
> 	if (!sdev) 
> 		return BLKPREP_KILL;
> 
> to scsi_prep_state_check, but that caused a RCU CPU stall 
> and a generally unhappy system instead.

Right, that wouldn't work.  The sdev in question comes from
request_queue->queuedata.  That only goes to null when the last
reference to the sdev has been released.  So the root cause is something
in sd holding a reference to sdev without actually getting an additional
refcount.

> The sdev must be still there in scsi_set_medium_removal because it's 
> referenced, so it must get lost somewhere in SCSI or in the block layer.
> 
> Any ideas how to fix this?

I'll see if I can find the refcounting problem.

Likely it's a longstanding bug which we didn't actually notice until
now.

James


