Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab1GBUFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 16:05:20 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43784 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754051Ab1GBUFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 16:05:17 -0400
Date: Sat, 2 Jul 2011 16:05:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Dave Jones <davej@redhat.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <axboe@kernel.dk>, <rjw@sisk.pl>,
        <linux-usb@vger.kernel.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
In-Reply-To: <20110702181501.GN23059@one.firstfloor.org>
Message-ID: <Pine.LNX.4.44L0.1107021559250.16190-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jul 2011, Andi Kleen wrote:

> > And the transition after unplug goes
> > 
> > 13->12->10->8->7->6->5->3
> > 
> > implying we're missing put events.
> 
> Don't know why. I used this check (with trace_scsi_dev containing the name)
> in put_device:
> 
> if (trace_scsi && dev->type == &scsi_dev_type &&
>      trace_scsi_dev[0] == 0 || !strcmp(dev_name(dev), trace_scsi_dev))) {
> 	dev_printk ...

These extra puts could be coming from deep inside the device-model
core, where they operate directly on the underlying kobject instead of
going through put_device().  For example, removal of sysfs symlinks
could have this effect.

> If you want instrumentation somewhere else please let me know.
> 
> Maybe there simply isn't a put_device to 0 and the NULL pointer happens
> for some other reason?

On my system, at least, the scsi_device's refcount dropped to 0 at the 
right time.  That wasn't the problem.  The NULL pointer occurs because 
the request_queue is used after the scsi_device has been removed from 
visibility; among other things, __scsi_remove_device() sets 
sdev->request_queue->queuedata to NULL.

As the comment says, this causes the request function to reject all I/O 
requests -- but not before trying to dereference the NULL pointer!

Alan Stern

