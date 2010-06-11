Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455Ab0FKVAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:00:52 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56363 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752861Ab0FKVAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:00:51 -0400
Date: Fri, 11 Jun 2010 17:00:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: linux-mmc <linux-mmc@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philip Langdale <philipl@overt.org>
Subject: Re: [linux-pm] [PATCH] Fix the outstanding issue with hangs on
 insert/removal of mmc cards
In-Reply-To: <1276282801.8557.20.camel@maxim-laptop>
Message-ID: <Pine.LNX.4.44L0.1006111648590.19894-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010, Maxim Levitsky wrote:

> Hi,
> 
> After thinking a lot about how to fix properly the hangs caused by
> insert/removal of mmc card during suspend/resume, and default behavior
> of not trusting the card persistence over suspend, I finally come to
> conclusion that changing the del_gendisk is wrong.
> 
> First of all there are 2 types of removal possible. First one happens
> when system detects that some device is gone. At that point there is
> really no point in syncing it.
> 
> The other type of removal is controlled removal, usually on user
> request. Surly we must sync the device of this request.
> This type of removal _shouldn't_ happen during suspend/resume
> transaction. The only case when it does is today to protect against user
> carelessness of switching the cards during suspend.

There are other pathological cases which can cause it to happen, but 
they are pretty unlikely.

> I think that it is just wrong to sync the device in suspend/resume time.
> At that time userspace is frozen, but also its not known which drivers
> are still running. They might even suspend asynchronously...
> So, such cases should be moved to pm-notifier, thing that my patch does
> for mmc.
> Other users should be fixed as well.
> 
> We can, in addition to that, add a temporary hack to del_gendisk with
> loud WARN_ON though.
> 
> If card is really removed during suspend, then we can just introduce
> del_gendisk_dead or something like that which will be safe to call
> during suspend.
> 
> I didn't do that but rather I made the card detection thread freezeable,
> thus eliminated the whole problem.
> If you remove the card during suspend, system will notice at end of
> resume.

I don't know why the mmc subsystem works differently from USB.  In USB,
the equivalent of UNSAFE_RESUME is a per-device flag that can be
controlled via sysfs (see Documentation/usb/persist.txt).  And it
almost always defaults to ON, i.e., the kernel assumes that if a device
is present before suspend and after resume it is the same device --
although some checking is done to try to verify this (the descriptors
have to remain the same).  We started out being more cautious (the
default was OFF), but Linus complained about it being _too_ cautious.

And like you have done here, in USB the kernel thread that handles
registering and unregistering devices is freezable, so things never get
added or removed at an unsafe time.

Alan Stern

