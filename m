Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab1FPVER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:04:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013Ab1FPVEO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:04:14 -0400
MIME-Version: 1.0
In-Reply-To: <4DFA6442.9000103@linux.intel.com>
References: <1308097798.17300.142.camel@schen9-DESK> <1308101214.15392.151.camel@sli10-conroe>
 <1308138750.15315.62.camel@twins> <20110615161827.GA11769@tassilo.jf.intel.com>
 <1308156337.2171.23.camel@laptop> <1308163398.17300.147.camel@schen9-DESK>
 <1308169937.15315.88.camel@twins> <4DF91CB9.5080504@linux.intel.com>
 <1308172336.17300.177.camel@schen9-DESK> <1308173849.15315.91.camel@twins>
 <87ea4bd7-8b16-4b24-8fcb-d8e9b6f421ec@email.android.com> <4DF92FE1.5010208@linux.intel.com>
 <BANLkTi=Tw6je7zpi4L=pE0JJpZfeEC9Jsg@mail.gmail.com> <4DFA6442.9000103@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 16 Jun 2011 13:37:47 -0700
Message-ID: <BANLkTin_46==epHKUbWJ55bt3mPaJieV2Q@mail.gmail.com>
Subject: Re: REGRESSION: Performance regressions from switching anon_vma->lock
 to mutex
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        "Luck, Tony" <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, "Shi, Alex" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 1:14 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> I haven't analyzed it in detail, but I suspect it's some cache line bounce,
> which
> can slow things down quite a lot.  Also the total number of invocations
> is quite high (hundreds of messages per core * 32 cores)

The fact is, glibc is just total crap.

I tried to send uli a patch to just add caching. No go. I sent
*another* patch to at least make glibc use a sane interface (and the
cache if it needs to fall back on /proc/stat for some legacy reason).
We'll see what happens.

Paul Eggbert suggested "caching for one second" - by just calling
"gettimtofday()" to see how old the cache is. That would work too.

The point I'm making is that it really is a glibc problem. Glibc is
doing stupid expensive things, and not trying to correct for the fact
that it's expensive.

> I did, but I gave up fully following that code path because it's so
> convoluted :-/

I do agree that glibc sources are incomprehensible, with multiple
layers of abstraction (sysdeps, "posix", helper functions etc etc).

In this case it was really trivial to find the culprit with a simple

   git grep /proc/stat

though. The code is crap. It's insane. It's using
/sys/devices/system/cpu for _SC_NPROCESSORS_CONF, which is at least a
reasonable interface to use. But it does it in odd ways, and actually
counts the CPU's by doing a readdir call. And it doesn't cache the
result, even though that particular result had better be 100% stable -
it has nothing to do with "online" vs "offline" etc.

But then for _SC_NPROCESSORS_ONLN, it doesn't actually use
/sys/devices/system/cpu at all, but the /proc/stat interface. Which is
slow, mostly because it has all the crazy interrupt stuff in it, but
also because it has lots of legacy stuff.

I wrote a _much_ cleaner routine (loosely based on what we do in
tools/prof) to just parse /sys/devices/system/cpu/online. I didn't
even time it, but I can almost guarantee that it's an order of
magnitude faster than /proc/stat. And if that doesn't work, you can
fall back on a cached version of the /proc/stat parsing, since if
those files don't exist, you can forget about CPU hotplug.

> So you mean caching it at startup time? Otherwise the parent would
> need to do sysconf() at least , which it doesn't do (the exim source doesn't
> really know anything about libdb internals)

Even if you do it in the children, it will help. At least it would be
run just _once_ per fork.

But actually looking at glibc just shows that they are simply doing
stupid things. And I absolutely _refuse_ to add new interfaces to the
kernel only because glibc is being a moron.

                       Linus
