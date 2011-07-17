Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab1GQSrj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 14:47:39 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20755 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab1GQSri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 14:47:38 -0400
Date: Sun, 17 Jul 2011 20:47:36 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Darren Hart <dvhart@linux.intel.com>
cc: Chris Friesen <chris.friesen@genband.com>, linux-kernel@vger.kernel.org,
        Eric Dumazet <dada1@cosmosbay.com>, Darren Hart <dvhltc@us.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: App blocked in futex() burns 14% CPU.
In-Reply-To: <4E208C55.30507@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1107172043550.32359@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107150019580.26455@swampdragon.chaosbits.net> <4E1F72E1.3040102@genband.com> <4E208C55.30507@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jul 2011, Darren Hart wrote:

> 
> 
> On 07/14/2011 03:51 PM, Chris Friesen wrote:
> > On 07/14/2011 04:34 PM, Jesper Juhl wrote:
> >> So, I've recently started enabling the KDE desktop search on my box and it
> >> runs some indexing services (naturally) to keep track of changes to files.
> >> One of the apps it starts is a process named "virtuoso-t". This process
> >> burns a *lot* of CPU when it's just started, but once it has caught up
> >> with recent changes it quiets down. It doesn't quite quiet down to the
> >> level I'd expect though. I see it constantly using 12-14% CPU time in
> >> 'top' even when there is *nothing* going on on the machine :
> >>
> >> top - 00:25:09 up  2:38,  2 users,  load average: 0.01, 0.04, 0.05
> >> Tasks: 155 total,   1 running, 153 sleeping,   0 stopped,   1 zombie
> >> Cpu(s):  0.7%us,  0.8%sy,  3.7%ni, 94.6%id,  0.1%wa,  0.0%hi,  0.0%si,  0.0%st
> >> Mem:   3853028k total,  2154696k used,  1698332k free,   184280k buffers
> >> Swap:  4200992k total,        0k used,  4200992k free,   996824k cached
> >>
> >>    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >>   1952 jj        39  19  362m 263m 6544 S   14  7.0  25:09.54 virtuoso-t
> >>   1811 jj        20   0  635m  27m  17m S    2  0.7   2:49.78 knotify4
> >>   1928 jj        39  19  595m  26m  18m S    1  0.7   2:58.40 nepomukservices
> >>
> >> This box has a dual core Intel core i5-560M CPU with hyperthreading, so it
> >> is 12-14% of a fairly capable CPU - that's rather a lot more than I'd
> >> expect when the box is idle and there's nothing for the process to do.
> >>
> >> So, I tried strace'ing the process and it seems to just be blocked in
> >> futex() most of the time (like 99%) :
> >>
> >> [jj@dragon ~]$ strace -p 1952
> >> Process 1952 attached - interrupt to quit
> >> futex(0x3086424, FUTEX_WAIT_PRIVATE, 503, NULL
> 
> Try strace with -f. If you really want to collect statistics about where
> it is spending it's time, consider oprofile or perf.
> 
> >>
> >> So it's just sitting there doing nothing, which lead me to think that this
> >> is probably not a bug in the application - if it was doing some silly
> >> polling loop or similar I would not just see it blocked in a futex() call.
> >> So I'm guessing something must be happening in kernel space that's burning
> >> a lot of CPU.. I could be completely wrong of course, and if I am, please
> >> feel free to enlighten me.
> > 
> > You don't have enough kernel activity to account for 14% of a cpu.  Have 
> > you checked whether there's another thread within the process that's 
> > doing something in userspace?
> > 
> 
> Agreed.
> 

Ok, so I attempted to dig a bit deeper, but for some reason I'm now unable 
to reproduce the situation :-(

What I see now is that "virtuoso-t" uses 0-1% CPU and strace -f shows me 
this:

[jj@dragon ~]$ strace -f -p 3821
Process 3821 attached with 6 threads - interrupt to quit
[pid  3825] futex(0x7f66606eeb64, FUTEX_WAIT_PRIVATE, 243425, NULL <unfinished ...>
[pid  3824] select(17, [8 10 11 12 14 15 16], [], NULL, {1, 378259} <unfinished ...>
[pid  3848] futex(0x7f66606eeae4, FUTEX_WAIT_PRIVATE, 242407, NULL <unfinished ...>
[pid  3843] futex(0x7f66606eeb24, FUTEX_WAIT_PRIVATE, 242547, NULL <unfinished ...>
[pid  3822] futex(0x31621b4, FUTEX_WAIT_PRIVATE, 655, NULL <unfinished ...>
[pid  3821] futex(0x309f424, FUTEX_WAIT_PRIVATE, 181, NULL <unfinished ...>
[pid  3824] <... select resumed> )      = 0 (Timeout)
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] select(17, [8 10 11 12 14 15 16], [], NULL, {2, 0}) = 0 (Timeout)
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] select(17, [8 10 11 12 14 15 16], [], NULL, {2, 0}) = 0 (Timeout)
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] select(17, [8 10 11 12 14 15 16], [], NULL, {2, 0}) = 0 (Timeout)
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=2134, ...}) = 0
[pid  3824] select(17, [8 10 11 12 14 15 16], [], NULL, {2, 0}) = 0 (Timeout)
...

which is not what I'd call a problem.

I'll make sure to grab a lot more data if I see it again, but for now just 
forget about this.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

