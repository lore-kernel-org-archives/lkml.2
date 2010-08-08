Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0HHNfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 09:35:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47600 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab0HHNfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 09:35:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=brj3INEDaMR1JzFnZNG3OQBC30nqj+YaEhz5ct7AQephN6BbM/lA0j1qRwCqj8m4eG
         Td0RDJX8bTZvs7GbKr0TNVszYbhfn9apYu1gUSo29pg2hDnebVXgSpw2o/vImQhsqfDh
         Kk3FSEJUHA+DJi3/0WtIFFUuk/vic7AGKAN0E=
MIME-Version: 1.0
In-Reply-To: <20100807062828.GB28087@thunk.org>
References: <alpine.DEB.2.00.1008051715520.30632@asgard.lang.hm>
	<AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com>
	<alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
	<20100806123047.GE31326@sirena.org.uk>
	<20100806172226.GH2432@linux.vnet.ibm.com>
	<20100806173325.GA25367@rakim.wolfsonmicro.main>
	<20100806181832.GJ2432@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061517130.30564@asgard.lang.hm>
	<20100807001431.GA3252@opensource.wolfsonmicro.com>
	<alpine.DEB.2.00.1008061741460.30564@asgard.lang.hm>
	<20100807062828.GB28087@thunk.org>
Date: Sun, 8 Aug 2010 16:35:13 +0300
Message-ID: <AANLkTinTfKRfAUJqggcK9Cgo9BTXfqMjJ2SXZS=D1bmT@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        "Arve Hj?nnev?g" <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 7, 2010 at 9:28 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Aug 06, 2010 at 06:00:34PM -0700, david@lang.hm wrote:
>>
>> today there are two ways of this happening, via the idle approach
>> (on everything except Android), or via suspend (on Android)
>
> Most other devices use a lot more power at idle; in some cases it's
> because the hardware just isn't as power optimized (why bother, when
> you have 94,000 mWh of power at your disposal with a 6 cell laptop
> battery, as opposed to the 800-1000 mWh that you might have on a cell
> phone battery).  In other cases, it's because the kernel and the
> low-level software stack (never mind the applications) are waking up
> the CPU too darned often --- in other words, idle simply isn't idle
> enough.
>
> So you may want to consider whether part of the problem is that
> general purpose Linux systems need a radical redesign to get power
> utilization down to those sorts of levels --- where the CPU might only
> be waking up once every half-hour or so, and then only do actual
> useful work.
>
> Can you get there by assuming that every single application is
> competently written?  In an idle approach, you have to.  That way lies
> Maemo, where installing just one bad application will cut your battery
> life time by a factor of 2-3.

Exactly the same happens on Android.

Install one bad application, a request for PM permissions is made, you
click Yes. There's no difference at all.

> You could try stopping processes by
> using kill -STOP, but this at that point, you've moved into Android
> strategy of "suspend".  And the only question is what is the most
> efficient way to allow the system to run when there is true work that
> needs to be done, and how to avoid deadlocks by stopping processes
> that might be holding user space locks --- and to administer when and
> how to suspend the processes.

No. You are assuming that PM permissions will be magically set
appropriately; that's not the case.

1) Install a bad application that requests PM permissions and is granted those

In this case you've gained nothing with user-space suspend blockers.

2) Install a good application that is not requesting PM permissions
(or is denied them)

Imagine this application requires expensive initialization, but
afterwards it only needs to send a small packet each minute to a
server. If this application forgets to request PM permission (or is
denied them), then it might miss the 1 minute mark, and would have to
re-initialize when a trusted app starts some work.

In this case suspend blockers cause more battery drain (and the
application to behave poorly).


There's only one case when suspend blockers might actually help:
a) The application is badly written (most probably a UI app drawing
when it shouldn't, which incidentally is not a problem in Android
since it's not multi-tasking)
b) The application is either not requesting, or denied PM permissions
c) The application is not affected too badly if it's not running all
the time (piggy-backing on trusted apps is ok)

For that it's much better to have a different strategy: all
applications are trusted, bad applications must be manually tagged.
Also, instead of having each and every user figure out which are the
bad apps, such information is more pertinent in the app store, where
users could vote when an app is bad PM-use or not; crowd-sourcing the
problem.

But guess what; once you have an app store system that can detect when
an application is badly written, why would you expose the users to
such bad apps?

In Maemo, 3rd party applications have to go trough a community review
(maemo.org extras testing) before they go into the main repository,
and this way bad applications (functionality or PM-wise) don't make it
to the general public.

Also, on mobile phones in general there are 3 kinds of applications.
1) desktop widgets: by far the ones with the most danger of drawing the battery
2) foreground UI apps: also have some danger, but only on
multi-tasking systems (not Android)
3) background services: usually don't do unnecessary work

Suspend blockers are mostly useful for 1), but desktop widgets are
platform-specific, so they are written for embedded anyway, and if you
are writing for embedded, there's no point in relying on
suspend-blockers; just write it PM optimized.

-- 
Felipe Contreras
