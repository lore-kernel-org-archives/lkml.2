Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab1HXOlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:41:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40058 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1HXOlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:41:07 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Date: Wed, 24 Aug 2011 17:41:05 +0300
Message-ID: <CAOtvUMdgPoL_gnOTq8DwS9RxSFagQN_kAze3guD8O3xFHfnfHg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 15, 2011 at 6:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> For those who want to play:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
>        nohz/cpuset-v1


You caught me in playful mood, so I took it for a spin... :-)

I know this is far from being production ready, but I hope you'll find
the feedback useful.

First a short description of my testing setup is in order, I believe:

I've set up a small x86 VM with 4 CPUs running your git tree and a
minimal buildroot system. I've created 2 cpusets: sys and nohz, and
then assigned every task I could to the sys cpuset and set
adaptive_nohz on the nohz set.

To make double sure I have no task on my nohz cpuset CPU, I've booted
the system with the isolcpus command line isolating the same cpu I've
assigned to the nohz set. This shouldn't be needed of course, but just
in case.

I then ran a silly program I've written that basically eats CPU cycles
(https://github.com/gby/cpueat) and assigned it to the nohz set and
monitored the number of interrupts using /proc/interrupts

Now, for the things I've noticed -

1. Before I turn adaptive_nohz to 1, when no task is running on the
nohz cpuset cpu, the tick is indeed idle (regular nohz case) and very
few function call IPIs are seen. However, when I turn adaptive_nohz to
1 (but still with no task running on the CPU), the tick remains idle,
but I get an IPI function call interrupt almost in the rate the tick
would have been.

2. When I run my little cpueat program on the nohz CPU, the tick does
not actually goes off. Instead it ticks away as usual. I know it is
the only legible task to run, since as soon as I kill it  the tick
turns off (regular nohz mode again). I've tinkered around and found
out that what stops the tick going away is the check for rcu_pending()
in cpuset_nohz_can_stop_tick(). It seems to always be true. When I
removed that check experimentally and repeat the test, the tick indeed
stops with my cpueat task running. Of course, I don't suggest this is
the sane thing to do - I just wondered if that what stopped the tick
going away and it seems that it is.

3. My little cpueat program tries to fork a child process after 100k
iteration of some CPU bound loop. It usually takes a few seconds to
happen. The idea is to make sure that the tick resumes when nr_running
> 1. In my case, I got a kernel panic. Since it happened with some
debug code I added and with aforementioned experimental removal of
rcu_pending check, I'm assuming for now it's all my fault but will
look into verifying it further and will send panic logs if it proves
useful.

Cheers,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com
"Dance like no one is watching, love like you'll never be hurt, sing
like no one is listening... but for BEEP sake you better code like
you're going to maintain it for years!"
