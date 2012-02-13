Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2BMPUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 10:20:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41619 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756905Ab2BMPUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 10:20:50 -0500
Date: Mon, 13 Feb 2012 10:20:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Huang Ying <ying.huang@intel.com>, <ming.m.lin@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
In-Reply-To: <201202131028.45806.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1202131002210.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012, Oliver Neukum wrote:

> Am Montag, 13. Februar 2012, 02:42:24 schrieb Alan Stern:
> > On Sun, 12 Feb 2012, Oliver Neukum wrote:
> > 
> > > Yes, we can use the same heuristics as everywhere.
> > > command queued -> autopm_get
> > > command finished -> autopm_put
> > > 
> > > but for the USB host adapter, not the sr device
> > 
> > I still don't fully understand.  Are you suggesting that we use the 
> > normal autosuspend timeout mechanism for the disk drive (for example, 
> > spin down the disk if it hasn't been used for five minutes), and then
> 
> Yes. The key here is to realize that from a view point of functionality
> they are not suspended. But they will be ready to be suspended.

We appear to be using the word "suspended" in different ways.

When I say a device is suspended, I mean that dev->power.runtime_status
is set to RPM_SUSPENDED, the subsystem's or driver's runtime_suspend
method has been called, and the driver is not ready to carry out I/O
requests immediately (it would have to call pm_runtime_get first).  I
do not necessarily mean that the device is at a low power setting.

It seems that you are using the word "suspended" to mean something
else, but it's hard to tell what.  Regardless, let's stick to my
meaning.  Once the runtime_suspend method for the drive has returned
successfully, the drive is indeed suspended.

> > autosuspend a USB mass-storage device whenever its children are 
> > suspended and no commands are in progress?  (In fact, there can't be 
> > any commands in progress if all the children are suspended.)
> 
> Really? It is currently true because the device must be opened to issue
> commands.
> In fact now that you put it this way, it seems to me that this is the
> preconception we must shed.

It is true because all SCSI commands are directed toward one of the
children, i.e., to a particular LUN.  If that LUN is suspended then
its driver won't allow any commands to be sent to it.  As you say,
right now this is true because the device file must be opened before
commands can be issued -- but even if we remove that restriction, it
will still be true that commands won't be issued while the device is
suspended.

It's not a preconception; it is a basic design principle of the
kernel's Runtime PM implementation.

> > The SCSI drivers don't know much about the request queue -- the block
> > layer manages it.  That's another reason for handling this at the block
> > layer.
> 
> That was refering to SCSI requests.

That's the same thing.  The SCSI layer doesn't have its own request
queues; it uses the queues provided by the block layer.

Alan Stern

