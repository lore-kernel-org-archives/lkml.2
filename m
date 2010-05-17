Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0EQRrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:47:07 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:60014 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab0EQRrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:47:05 -0400
Date: Mon, 17 May 2010 20:47:31 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100517174647.GA11512@gandalf>
Reply-To: me@felipebalbi.com
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
 <87hbm6cz90.fsf@deeprootsystems.com>
 <1274115885.4418.59.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274115885.4418.59.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 01:04:45PM -0400, James Bottomley wrote:
> > For userspace, apps that have polling behavior or are ill-behaved must
> > be found and fixed.  Thanks to tools like powertop, this is a farily
> > easy task.
> 
> That's a bit glib ... powertop can detect power consumption stats on a
> running system ... if you have a polling app preventing your system from
> suspending, powertop isn't necessarily going to find it ... especially
> if the polling interval is of the order of powertop's.  Powertop can
> find the bad tens of wakeups per second, but it only takes one wakup
> every few seconds or so to drain the battery significantly when
> operating on suspend from idle.

you can always increase powertop's interval through command line and
once you went down to 1 wakeup every two seconds, you increase
powertop's interval and try to cut down 10 more ill-behaved apps. And
you keep going until you have e.g. 1 wakeup per minute or whatever your
target is.

> > But really, I don't consider the "ill-behaved app" problem to be a
> > real-world problem.  Both in maemo/meego and Android, if someone
> > writes an app that kills battery life, it will get reported as a bug,
> > or get bad ratings etc.  On these kinds of devices, there is a *stong*
> > developer incentive to not write battery sucking apps.
> 
> I'm not sure this is real world, either.  Developers can fire up
> powertop from the command line when their phone isn't idling for as long
> as it should.  But a phone is a consumer device: the average smart phone
> user just wants to browse the web, get email, go to facebook and play
> with some cool apps.  If one of those cool apps is rogue, they're not
> really going to know which one or how to find it (and firing up powertop
> from the command line isn't something which will occur to them as a
> matter of routine).

Agree with you here.

> One of the nice things that suspend blockers actually does is to give
> the kernel a clear name for the process blocking suspend (and thus
> consuming power).  This allows a nice way to assign power budget to the
> application and present who's using what in a nice visible form, which
> does facilitate the reporting of bad apps, even for the non-developer
> user.

if that's the only thing we want suspend_blockers for, there are other
simpler ways to do it. Just add a kernel debugging option for anyone
doing poll() or keeping a device open() or whatever and you have the
name the of the processes consuming power and preventing system from
going into sleep.

IMO, suspend_blocker is trying to fix application problems in kernel
space by unconditionaly (well sort of) freezing userspace if there are
no suspen_blockers held. So even if application is doing
poll(pfds, ARRAY_SIZE(pfds), 2); that won't be noticed because as long as
the suspend_blocker is released, that poll() will be frozen, no ?

IMO the real fix would be on that particular poll(), changing the
timeout e.g. based on cpufreq notifications or even relying completely
on IRQs with poll(pdfs, ARRAY_SIZE(pfds), -1); Of course, this is only a
crude example trying to show that the real issue lies on the application
rather than on kernel.

-- 
balbi
