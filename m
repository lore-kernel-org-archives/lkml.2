Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0KTNLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 08:11:46 -0500
Received: from 5accd750.bb.sky.com ([90.204.215.80]:44176 "EHLO mayday.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752797Ab0KTNLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 08:11:45 -0500
Date: Sat, 20 Nov 2010 13:11:41 +0000 (GMT)
From: Robert de Bath <robert$@debath.co.uk>
To: Linus Walleij <linus.ml.walleij@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups ... ps
 jaxk sid ... You are using the wrong number.
In-Reply-To: <AANLkTinF7BtYJwowfke+q0qjaXUc19EYRioAORU7YSAd@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.1011201009530.8468@mayday.local>
References: <Pine.LNX.4.61.1011190750500.8468@mayday.local>
 <AANLkTinF7BtYJwowfke+q0qjaXUc19EYRioAORU7YSAd@mail.gmail.com>
X-Mailer: Pine for Linux
Reply-By: 01 jan 2001 00:00:00
X-Message-Flag: Linux: The choice of a GNU generation.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Nov 2010, Linus Walleij wrote:

> 2010/11/19 Robert de Bath <robert$@debath.co.uk>:
>
>> Using the SID solves the "all GUI programs are in the same group" problem
>> but still keeps "make -j99" in one group and different [a-z]terms in
>> different groups. What's more setsid(1) and setsid(2) make userspace
>> control really easy.
>
> I grouped all the processes on my system but a few into per-session
> control groups by a quick python hack into CGFreak. It looks very
> funny atleast, I never spawned so many groups before:
> http://www.df.lth.se/~triad/sidgroups/

Sure looks like I would expect; after all 99% of the processes a system
has running are completely idle.  With a normal cgroups setup you're
only interested in the processes that are actually being a problem,
the ones that you know want to eat CPUs, like "make -j99+gcc", like
"apache+php". But here we're not using those extra assumptions, so you
have to cut up the process list at every reasonable boundry.

If you're in userspace (eg your python script) it might be reasonable
to have an idleness test and arrange things so that only if you find a
process that's busy (for a few seconds) do you move the SID group into
it's own cgroup, then for idle processes you might start with the old
group per user id. Or you could try per user id for system processes
(uid < 1000) and SID for user processes. Or .. or .. some complicated
cgroups deamon that can do all of the above.

But in kernel space this kind of complexity feels like a bad idea. 
(probably proven bad too)

As an aside, the CPU time allocation per SID concept seems like a
pretty good complement to Con Kolivas's BF Scheduler; after all BFS
is supposed to be happier with what amounts to lower "load average"
values and if all the processes under a given SID value get treated as
one 'job' for global scheduling, that's what you get.
  (NB: Yes I know, BFS breaks cgroups)

> The big circle in the middle shows the cgroups alottment, the
> satellites show the processes inside each cgroup. The number
> on the perimeter is the SID.

> Linus Walleij

-- 
Rob.                          (Robert de Bath <robert$ @ debath.co.uk>)
                                              <http://www.debath.co.uk/>


