Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab0F2EnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 00:43:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56421 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab0F2EnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 00:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QwNN1hYot70Rjwnt49vHZ+teJ47fpUOCSMmY2QVPGNHvff4u6xWJj1zBQZaOJLegMw
         wYB1azuwwCPq7rgo21+0RwwRYQz/Tg0HRJ7DJtlqlA+VhHcaXCZhkmXG4MQeCf7RQ0ok
         8QS5cqNrBs7bZSt8CCtb2yG/Pr1MaC+7Yoj8c=
Date: Mon, 28 Jun 2010 21:43:32 -0700
From: mark gross <640e9920@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <640e9920@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Mickler <florian@mickler.org>, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PM: Make it possible to avoid wakeup events from being
 lost
Message-ID: <20100629044332.GD6250@gvim.org>
Reply-To: markgross@thegnar.org
References: <201006261514.13491.rjw@sisk.pl>
 <20100627222804.GA5522@gvim.org>
 <201006281450.11285.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006281450.11285.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 02:50:10PM +0200, Rafael J. Wysocki wrote:
> On Monday, June 28, 2010, mark gross wrote:
> > Looks good to me!
> 
> Great, thanks!  May I add your "Acked-by" to the patch, then?
yes.

Acked-by: markgross <markgross@thegnar.org>

--mgross
 
> Rafael
> 
> 
> > On Sat, Jun 26, 2010 at 03:14:13PM +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > One of the arguments during the suspend blockers discussion was that
> > > the mainline kernel didn't contain any mechanisms making it possible
> > > to avoid losing wakeup events during system suspend.
> > > 
> > > Generally, there are two problems in that area.  First, if a wakeup
> > > event occurs exactly when /sys/power/state is being written to, it
> > > may be delivered to user space right before the freezer kicks in, so
> > > the user space consumer of the event may not be able to process it
> > > before the system is suspended.  Second, if a wakeup event occurs
> > > after user space has been frozen, it is not generally guaranteed that
> > > the ongoing transition of the system into a sleep state will be
> > > aborted.
> > > 
> > > To address these issues introduce a new global sysfs attribute,
> > > /sys/power/wakeup_count, associated with a running counter of wakeup
> > > events and three helper functions, pm_stay_awake(), pm_relax(), and
> > > pm_wakeup_event(), that may be used by kernel subsystems to control
> > > the behavior of this attribute and to request the PM core to abort
> > > system transitions into a sleep state already in progress.
> > > 
> > > The /sys/power/wakeup_count file may be read from or written to by
> > > user space.  Reads will always succeed (unless interrupted by a
> > > signal) and return the current value of the wakeup events counter.
> > > Writes, however, will only succeed if the written number is equal to
> > > the current value of the wakeup events counter.  If a write is
> > > successful, it will cause the kernel to save the current value of the
> > > wakeup events counter and to abort the subsequent system transition
> > > into a sleep state if any wakeup events are reported after the write
> > > has returned.
> > > 
> > > [The assumption is that before writing to /sys/power/state user space
> > > will first read from /sys/power/wakeup_count.  Next, user space
> > > consumers of wakeup events will have a chance to acknowledge or
> > > veto the upcoming system transition to a sleep state.  Finally, if
> > > the transition is allowed to proceed, /sys/power/wakeup_count will
> > > be written to and if that succeeds, /sys/power/state will be written
> > > to as well.  Still, if any wakeup events are reported to the PM core
> > > by kernel subsystems after that point, the transition will be
> > > aborted.]
> > > 
> > > Additionally, put a wakeup events counter into struct dev_pm_info and
> > > make these per-device wakeup event counters available via sysfs,
> > > so that it's possible to check the activity of various wakeup event
> > > sources within the kernel.
> > > 
> > > To illustrate how subsystems can use pm_wakeup_event(), make the
> > > low-level PCI runtime PM wakeup-handling code use it.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
