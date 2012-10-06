Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2JFQKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 12:10:38 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54265 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2JFQKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 12:10:37 -0400
MIME-Version: 1.0
In-Reply-To: <20121005164642.GA10711@linux.vnet.ibm.com>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003132538.GE13192@linux.vnet.ibm.com>
	<20121003161702.GA22008@kroah.com>
	<20121003164712.GF2527@linux.vnet.ibm.com>
	<CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
	<20121003200314.GR2527@linux.vnet.ibm.com>
	<20121004015539.GA19958@srcf.ucam.org>
	<20121004143150.GA2464@linux.vnet.ibm.com>
	<20121005164642.GA10711@linux.vnet.ibm.com>
Date: Sat, 6 Oct 2012 18:10:36 +0200
Message-ID: <CAFTL4hy434CQhT8WTvKmNzkO4k_isfKQOrCjgfYFYfMVgS7QDw@mail.gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/5 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Thu, Oct 04, 2012 at 07:31:50AM -0700, Paul E. McKenney wrote:
>> On Thu, Oct 04, 2012 at 02:55:39AM +0100, Matthew Garrett wrote:
>> > On Wed, Oct 03, 2012 at 01:03:14PM -0700, Paul E. McKenney wrote:
>> >
>> > > That has not proven sufficient for me in the past, RCU_FAST_NO_HZ
>> > > being a case in point.
>> >
>> > Taint the kernel at boot time? That'd be sufficient to force distros to
>> > disable it.
>>
>> Cool!  That does sound much more socially responsible than my thought
>> of forcing a splat (e.g., WARN_ON(1)) during boot.  ;-)
>
> So, from what I can see, here is the list of the ways of warning distros
> off of a given kernel config option, taken in terms of CONFIG_RCU_USER_QS:
>
> 1.      Make CONFIG_RCU_USER_QS depend on CONFIG_BROKEN.
>
>         It sounds to me like distros would avoid adding this (do they?),
>         but tester would probably avoid it as well.
>
> 2.      Make CONFIG_RCU_USER_QS depend on CONFIG_STAGING.
>
>         As Frederic noted, this is more of a driver thing than a
>         core-kernel thing, so probably not appropriate.
>
> 3.      Boot-time WARN_ON() if CONFIG_RCU_USER_QS=y.
>
>         This seems to me to be a tad excessive.  But the place to do it
>         might be rcu_bootup_announce_oddness() in kernel/rcutree_plugin.h.
>
> 4.      Remove CONFIG_RCU_USER_QS from Kconfig, so that users have to
>         patch their kernel to enable it.
>
>         This also seems a tad excessive.
>
> 5.      Maintain CONFIG_RCU_USER_QS out of tree, for example in the
>         -rt patchset.
>
>         This is a good place to start, but it has been where
>         CONFIG_RCU_USER_QS has been for some time, and although it
>         got some good testing, it clearly needs more.  In my view,
>         CONFIG_RCU_USER_QS has outgrown its out-of-tree roots.
>
> 6.      Boot-time add_taint() if CONFIG_RCU_USER_QS=y, as suggested
>         by Matthew Garrett.  The taint value might be TAINT_CRAP,
>         TAINT_OOT_MODULE, TAINT_WARN, or TAINT_FIRMWARE_WORKAROUND --
>         all the other taint values disable lockdep.  Of these four,
>         TAINT_OOT_MODULE and TAINT_FIRMWARE_WORKAROUND are clearly
>         off-topic, leaving TAINT_CRAP and TAINT_WARN.  Taking them one
>         at a time:
>
>         TAINT_CRAP: Used when loading modules from staging.
>
>         TAINT_WARN: Used when "scheduling while atomic" is encountered.
>
>         So I have my tongue only halfway in my cheek when I suggest
>         starting with TAINT_CRAP, then moving to TAINT_WARN, then
>         removing the tainting altogether.  The place to do this might
>         be rcu_bootup_announce_oddness() in kernel/rcutree_plugin.h.
>
> So how about the following progression?
>
> A.      Early days, only a few crazies should test.  In this case, the
>         code should be out of tree, perhaps in something like -rt,
>         perhaps as a set of patches.
>
> B.      Need more testers, but still not expected to work reasonably.
>         Mainline, but depending on CONFIG_BROKEN.  (I am not all that
>         enthusiastic about this option, but am including it for
>         completeness.)

Yeah neither am I. With a dependency on CONFIG_BROKEN, it considerably
reduce the testing coverage too.

>
> C.      Need wide testing, but don't want 100,000,000 unsuspecting
>         test subjects.  Taint the kernel with TAINT_CRAP.
>
> D.      OK for production in special situations, but definitely not
>         for typical users.  Taint the kernel with TAINT_WARN.
>
> E.      Ready for general production use.  Mainlined without restrictions.
>
> I would say that CONFIG_RCU_USER_QS is currently at point C above, it
> clearly now needs testing on a wide variety of hardware, but also is
> clearly not ready for 100,000,000 users.
>
> Thoughts?

Really I would much prefer to add some "Don't enable it unless you're
doing kernel hacking.
If unsure say N" text in the Kconfig.

I can understand that distros want to cover as much feature as they
can for their users. But
should it be an excuse for not reading outstanding warnings in Kconfig
help text?

Or may be add some specific warning yeah. I wouldn't mind much.
