Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116Ab2AFURo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:17:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47964 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082Ab2AFURm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:17:42 -0500
Date: Fri, 6 Jan 2012 12:17:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: evdev - Add EVIOC mechanism to extract the MT
 slot state
Message-ID: <20120106201735.GA23818@core.coreip.homeip.net>
References: <1325863019-2242-1-git-send-email-rydberg@euromail.se>
 <CAN+gG=FUEH851Um4Lco0avqdE2Eup3Jo79Ti4T7XhxT=PO6WeQ@mail.gmail.com>
 <20120106181845.GA22653@core.coreip.homeip.net>
 <4F0743EE.6080302@canonical.com>
 <20120106195846.GA23619@core.coreip.homeip.net>
 <4F075500.3020601@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F075500.3020601@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 12:09:36PM -0800, Chase Douglas wrote:
> On 01/06/2012 11:58 AM, Dmitry Torokhov wrote:
> > On Fri, Jan 06, 2012 at 10:56:46AM -0800, Chase Douglas wrote:
> >> On 01/06/2012 10:18 AM, Dmitry Torokhov wrote:
> >>> Hi Benjamin,
> >>>
> >>> On Fri, Jan 06, 2012 at 07:00:22PM +0100, Benjamin Tissoires wrote:
> >>>> Hi guys,
> >>>> I read somewhere in the code of Android a comment in which they
> >>>> complain about not being able to retrieve the slots states. So they
> >>>> assume they are all at 0.
> >>>> So this mechanism is good to have.
> >>>> However, back in January 2011, Dmitry raised the problem that this
> >>>> code was not thread safe.What happens if 2 applications ask for
> >>>> different slots values (let say X.org and utouch-frame)?
> >>>
> >>> 2 different processes should be fine; the problem would be if 2 threads
> >>> of the same process share the same file descriptor. So far the rest of
> >>> evdev copes just fine with multiple threads using the same fd (all
> >>> operations are atomic in this regard), setting ABS_MT_SLOT before
> >>> fetching the state break this property.
> >>
> >> How is this any different than two threads trying to set a different
> >> property, like the fuzz factor of an axis? This seems like something
> >> that should be guarded by a lock in userspace, essentially.
> > 
> > From kernel POV both operations succeed and produce consistent reults.
> > Consider EVIOCSABS when one thread using the same FD sets range 0-100
> > and another 200-1000. At no time in the kernel we get to state of
> > min = 200 and max = 1000. In the end we'll end up with either 0-100 or
> > 200-1000 but not mix of both. So the kernle state is internally
> > consistent.
> 
> I don't see how modifying the slot requested could ever get the kernel
> into an inconsistent state.

It may cause client get data that it did not request. In other worse it
kernel may supply wrong data to the caller.

> 
> > With proposed solution one client may request data for slot 2 but
> > instead get info for slot 5 if another client manages to slide in.
> 
> You can do the same thing with EVIOCSABS. If you don't do proper locking
> and handling, two threads can assume they wrote a value to evdev and it
> was successful, when in reality only the second thread to make the call
> has any effect.

As with pretty much any other resource; but there is a reason we have
atomic variables and operations. The distinction is that both operations
carried out completely and consistently.

> 
> I know there's a slight distinction between these two scenarios, but my
> point is that if you are doing multithreaded evdev reading from the same
> evdev fd, you are asking for trouble and you need to be careful. That
> even goes for modifying any of the other state through EVIOCSABS from
> multiple processes. And really, how many programs are out there reading
> from the same evdev fd in multiple threads. I'd wager a fair amount of
> money the answer is 0.

I am really not concerned about what userspace might do - I've looked at
enough code to see all kinds of weird stuff. My task is to make sure
that kernel interface is sane and since it is userspace ABI matter I
want to be extra careful.

Thanks.

-- 
Dmitry
