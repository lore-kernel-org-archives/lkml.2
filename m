Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab1ESJ1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:27:11 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:61720 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab1ESJ1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:27:09 -0400
Date: Thu, 19 May 2011 11:26:25 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/4] PM / Loss: power loss management
Message-ID: <20110519092625.GB1446@mail.gnudd.com>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <201105122157.46895.rjw@sisk.pl> <20110513130212.GF29259@mail.gnudd.com> <201105180132.30802.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201105180132.30802.rjw@sisk.pl>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 01:32:30AM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> Sorry for the delay.
>
hi,

no problem. I'm having some extremely busy days at the moment, so I'm always 
late too (as you see).

... 

> > That was one of the two main reasons why we chose to put this stuff inside 
> > the kernel. The other reason was that the mmc request queue can be easily 
> > stopped from kernel space.
> 
> OK, but it's not really sufficient to notify drivers in that case, because
> they may crash user space if they simply switch off devices.  Now, if the
> power loss actually happens, that probably doesn't matter, but if power is
> restored afterwards, that won't be nice.
> 
> The mmc request queue is a special case that shouldn't affect user space
> directly, but other devices may be accessed in many different ways and
> not all of them are safe to intercept forcibly.
> 

well, I don't know if this is completely correct, but my initial idea was to 
find some way to just block user space processes when we're not sure about 
power. Most devices can be accessed via some form of read()/write() or 
enqueue/dequeue mechanism. What I would like to do is to temporarily blocking 
such operations (or returning -EAGAIN in case of non-blocking open, for 
instance). This should slightly reduce power consumption
anyway, because user space processes cannot run. Then, each single driver 
should decide whether it is safe or not to actually turn its device off,
and then restore its state in case of power resume.

> However, even for the mmc case you'd need a mechanism that will force
> the filesystem on it to flush everything to the storage immediately.
> 

I'm not completely sure about this. What we wanted to do was to avoid powering
down the mmc while it is physically writing data into its internal memory.
If we force a sync when the power loss warning event warning happens,
it is very difficult to be able to guarantee that all buffered data will be 
written before power actually dies. So we preferred to follow another strategy:
let the mmc finish any running write operation, and then stop its request 
queue. If power really goes down, then we hope that the file system journal 
will fix things on next boot (yes, some data could get lost, but the fs should
still be mountable). On the other hand, if power resumes, nothing bad should 
happen for user space processes.

> > Since forcing a given policy seemed the wrong thing to do, we chose to adopt
....
> > 
> > maybe this is design choice comes from our little knowledge of pm_runtime, 
> > but the reason why we didn't use the existing callbacks was that we wanted 
> > to avoid any possible conflict.
> > In our understanding, pm_runtime works more or less like this: "when 
> > you're done with a peripheral, turn it off" (well, maybe also wait a little 
> > while to avoid continuously toggling power on and off, thus wasting more 
> > power than just doing nothing). This is because its goal is to save power 
> > during normal operation.
> > On the other hand, we needed something like this: "when some external event 
> > takes place, just turn off anything you can as fast as you can".
> 
> This is more similar to system suspend than to runtime PM.
> 
> > Actually, one of the attempts we made before adding pm_loss was to implement 
> > it via pm_runtime, by just immediately stopping devices on idle and refusing
> > to turn them on again in case a power loss event took place in the meanwhile.
> > This worked, and was ok for drivers with no implementation of the pm_runtime 
> > callbacks, but introduced a potential conflict as far as pm_runtime enabled 
> > drivers were concerned. That's why we (maybe wrongfully) thought a new 
> > callback was needed.
> 
> Having considered that for a while I think that additional callbacks may be
> necessary, because they generally may need to do more than just suspending
> devices.
> 

ok.

> > > > +This function can be optionally invoked by power loss policies in case of
> > > > +system power changes (loss and/or resume). Of course every bus or device driver
> > > > +can react to such events in some specific way. For instance the mmc block
> > > > +driver will probably block its request queue during a temporary power loss.
> > > 
> > > I think you'd have to deal with user space somehow before suspending devices.
> > > Runtime PM suspends devices when they aren't in use (as indicated by the
> > > usage counters), but in this power loss case we may really end up suspending
> > > devices that _are_ in use, right?
> > > 
> > yes. This is not a problem for us right now, because when a power loss happens,
> > the "power bad" condition just lasts for about 100ms. At present, pm_loss
> > callbacks are implemented for the mmc block device and a video capture device
> > only.
> 
> While that may not be a problem to you, it is a problem in general and it
> should be taken into account if we are to provide a generic framework for
> such things.
> 
> > In practice what happens on our platform is that processes accessing the mmc 
> > can be put to sleep until either the board dies or a power resume event takes 
> > place. If video capture is running, some "black" frames are generated, but 
> > that is not considered a real fault because power losses should not occur 
> > during normal operation (unless you really turn the board off, of course).
> > 
> > That said, I think you're right anyway, userspace should be notified somehow.
> > SIGPWR to init ?. As far as I know, there's no single place in the kernel 
> > where SIGPWR is sent to init:
> > 
> > find . -name \*.c  | xargs grep SIGPWR
> > ...
> > ./drivers/char/snsc_event.c:            kill_cad_pid(SIGPWR, 0);
> > ...
> > ./arch/s390/kernel/nmi.c:               kill_cad_pid(SIGPWR, 1);
> > 
> > Maybe pm_loss could become such a place ?
> 
> I think so.  SIGPWR seems to be a good candidate, but that would change the
> current (documented) behavior where SIGPWR is a synonym for SIGINFO.
> 
ok, I'll think about this.

A new version of the patchset is underway, but as I told you I'm having quite
a busy time, so I need some more days to finish and do some test.

Thanks and regards
Davide
