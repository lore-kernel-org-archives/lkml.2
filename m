Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab0KPTsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:48:08 -0500
Received: from smtp-out-174.synserver.de ([212.40.180.174]:1623 "HELO
	smtp-out-165.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756670Ab0KPTsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:48:04 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 23003
Date: Tue, 16 Nov 2010 20:42:32 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116194232.GA1607@arch.trippelsdorf.de>
References: <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com>
 <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com>
 <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116181603.GC19327@tango.0pointer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010.11.16 at 19:16 +0100, Lennart Poettering wrote:
> On Tue, 16.11.10 09:11, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> > 
> > On Tue, Nov 16, 2010 at 9:03 AM, Lennart Poettering
> > <mzxreary@0pointer.de> wrote:
> > >
> > > Binding something like this to TTYs is just backwards.
> > 
> > Numbers talk, bullshit walks.
> > 
> > The numbers have been quoted. The clear interactive behavior has been seen.
> 
> Here's my super-complex patch btw, to achieve exactly the same thing
> from userspace without involving any kernel or systemd patching and
> kernel-side logic. Simply edit your own ~/.bashrc and add this to the end:
> 
>   if [ "$PS1" ] ; then  
>           mkdir -m 0700 /sys/fs/cgroup/cpu/user/$$
>           echo $$ > /sys/fs/cgroup/cpu/user/$$/tasks
>   fi
> 
> Then, as the superuser do this:
> 
>   mount -t cgroup cgroup /sys/fs/cgroup/cpu -o cpu
>   mkdir -m 0777 /sys/fs/cgroup/cpu/user
> 
> Done. Same effect. However: not crazy.
> 
> I am not sure I myself will find the time to prep some 'numbers' for
> you. They'd be the same as with the kernel patch anyway. But I am sure
> somebody else will do it for you...

OK, I've done some tests and the result is that Lennart's approach seems
to work best. It also _feels_ better interactively compared to the
vanilla kernel and in-kernel cgrougs on my machine. Also it's really
nice to have an interface to actually see what is going on. With the
kernel patch you're totally in the dark about what is going on right
now.

Here are some numbers all recorded while running a make -j4 job in one
shell.

perf sched record sleep 30
perf trace -s /usr/libexec/perf-core/scripts/perl/wakeup-latency.pl :

vanilla kernel without cgroups:
total_wakeups: 44306
avg_wakeup_latency (ns): 36784
min_wakeup_latency (ns): 0
max_wakeup_latency (ns): 9378852

with in-kernel patch:
total_wakeups: 43836
avg_wakeup_latency (ns): 67607
min_wakeup_latency (ns): 0
max_wakeup_latency (ns): 8983036

with Lennart's approach:
total_wakeups: 51070
avg_wakeup_latency (ns): 29047
min_wakeup_latency (ns): 0
max_wakeup_latency (ns): 10008237
 
perf record -a -e sched:sched_switch -e sched:sched_wakeup sleep 10
perf trace -s /usr/libexec/perf-core/scripts/perl/wakeup-latency.pl :

without cgroups:
total_wakeups: 13195
avg_wakeup_latency (ns): 48484
min_wakeup_latency (ns): 0
max_wakeup_latency (ns): 8722497

with in-kernel approach:
total_wakeups: 14106
avg_wakeup_latency (ns): 92532
min_wakeup_latency (ns): 20
max_wakeup_latency (ns): 5642393

Lennart's approach:
total_wakeups: 22215
avg_wakeup_latency (ns): 24118
min_wakeup_latency (ns): 0
max_wakeup_latency (ns): 8001142
-- 
Markus
