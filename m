Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab2JCQ5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:57:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36790 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932581Ab2JCQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:57:28 -0400
X-Sasl-enc: 0Ag5cCTX5YTcIKY4Gf/EyvvYKKIC4sVMBs1Vy5yAMZ1A 1349283447
Date: Wed, 3 Oct 2012 09:57:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20121003165726.GA24577@kroah.com>
References: <4FE37194.30407@redhat.com>
 <4FE8B8BC.3020702@iki.fi>
 <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com>
 <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com>
 <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com>
 <CAPXgP11UQUHyCAo=GbAigQMqKWta12L19EsVaocU0ia6JKmd1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP11UQUHyCAo=GbAigQMqKWta12L19EsVaocU0ia6JKmd1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:36:53PM +0200, Kay Sievers wrote:
> On Wed, Oct 3, 2012 at 12:12 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > Mauro, what version of udev are you using that is still showing this
> > issue?
> >
> > Kay, didn't you resolve this already?  If not, what was the reason why?
> 
> It's the same in the current release, we still haven't wrapped our
> head around how to fix it/work around it.

Ick, as this is breaking people's previously-working machines, shouldn't
this be resolved quickly?

> Unlike what the heated and pretty uncivilized and rude emails here
> claim, udev does not dead-lock or "break" things, it's just "slow".
> The modprobe event handling runs into a ~30 second event timeout.
> Everything is still fully functional though, there's only this delay.

Mauro said it broke the video drivers.  Mauro, if you wait 30 seconds,
does everything then "work"?

Not to say that waiting 30 seconds is a correct thing here...

> Udev ensures full dependency resolution between parent and child
> events. Parent events have to finish the event handling and have to
> return, before child event handlers are started. We need to ensure
> such things so that (among other things) disk events have finished
> their operations before the partition events are started, so they can
> rely and access their fully set up parent devices.
> 
> What happens here is that the module_init() call blocks in a userspace
> transaction, creating a child event that is not started until the
> parent event has finished. The event handler for modprobe times out
> then the child event loads the firmware.

module_init() can do lots of "bad" things, sleeping, asking for
firmware, and lots of other things.  To have userspace block because of
this doesn't seem very wise.

> Having kernel module relying on a running and fully functional
> userspace to return from module_init() is surely a broken driver
> model, at least it's not how things should work. If userspace does not
> respond to firmware requests, module_init() locks up until the
> firmware timeout happens.

But previously this all "just worked" as we ran 'modprobe' in a new
thread/process right?  What's wrong with going back to just execing
modprobe and letting that process go off and do what ever it wants to
do?  It can't be that "expensive" as modprobe is a very slow thing, and
it should solve this issue.  udev will then have handled the 'a device
has shown up, run modprobe' event in the correct order, and then
anything else that the module_init() process wants to do, it can do
without worrying about stopping anything else in the system that might
want to happen at the same time (like load multiple modules in a row).

> This all is not so much about how probe() should behave, it's about a
> fragile dependency on a specific userspace transaction to link a
> loadable module into the kernel. Drivers should avoid such loops for
> many reasons. Also, it's unclear in many cases how such a model should
> work at all if the module is compiled in and initialized when no
> userspace is running.
> 
> If that unfortunate module_init() lockup can't be solved properly in
> the kernel, we need to find out if we need to make the modprobe
> handling in udev async, or let firmware events bypass dependency
> resolving. As mentioned, we haven't decided as of now which road to
> take here.

It's not a lockup, there have never been rules about what a driver could
and could not do in its module_init() function.  Sure, there are some
not-nice drivers out there, but don't halt the whole system just because
of them.

I recommend making module loading async, like it used to be, and then
all should be fine, right?

That's also the way the mdev works, and I don't think that people have
been having problems there. :)

thanks,

greg k-h
