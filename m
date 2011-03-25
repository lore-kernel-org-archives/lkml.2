Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012Ab1CYKFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:05:21 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:42048 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1CYKFT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:11:1>);
	Fri, 25 Mar 2011 06:05:19 -0400
Message-Id: <4D8C772202000078000384E1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 25 Mar 2011 10:06:10 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Jack Steiner" <steiner@sgi.com>
Cc: "Borislav Petkov" <bp@amd64.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Nick Piggin" <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        "Ingo Molnar" <mingo@redhat.com>, <tee@sgi.com>,
        "Nikanth Karthikesan" <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
	 test_and_set_bit_lock if possible
References: <201103241026.01624.knikanth@suse.de>
 <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab>
 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
 <20110324171924.GC2414@elte.hu>
In-Reply-To: <20110324171924.GC2414@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.03.11 at 18:19, Ingo Molnar <mingo@elte.hu> wrote:
> * Jan Beulich <JBeulich@novell.com> wrote:
>> Are you certain? Iirc the lock prefix implies minimally a read-for-
>> ownership (if CPUs are really smart enough to optimize away the
>> write - I wonder whether that would be correct at all when it
>> comes to locked operations), which means a cacheline can still be
>> bouncing heavily.
> 
> Yeah. On what workload was this?
> 
> Generally you use test_and_set_bit() if you expect it to be 'owned' by 
> whoever calls it, and released by someone else.
> 
> It would be really useful to run perf top on an affected box and see which 
> kernel function causes this. It might be better to add a test_bit() to the 
> affected codepath - instead of bloating all test_and_set_bit() users.

Indeed, I agree with you and Linus in this aspect.

> Note that the patch can also cause overhead: the test_bit() can miss the 
> cache, it will bring in the cacheline shared, and the subsequent test_and_set() 
> call will then dirty the cacheline - so the CPU might miss again and has to wait 
> for other CPUs to first flush this cacheline.
> 
> So we really need more details here.

The problem was observed with __lock_page() (in a variant not
upstream for reasons not known to me), and prefixing e.g.
trylock_page() with an extra PageLocked() check yielded the
below quoted improvements.

Jack - were there any similar measurements done on upstream
code?

Jan


**** Quoting Jack Steiner <steiner@sgi.com> ****

The following tests were run on UVSW :
	768p Westmere
	 128 nodes


Boot times - greater than 2X reduction in boot time:
	2286s PTF #8
	1899s PTF #8
	 975s new algorithm
	 962s new algorithm

Boot messages referring to udev timeouts - eliminated:
	(After the udevadm settle timeout, the events queue contains):

	7174 PTF #8
	9435 PTF #8
	   0 new algorithm
	   0 new algorithm

AIM7 results - no difference at low numbers of tasks. Improvements at high counts:
	Jobs/Min at 2000 users
		 5100 PTF #8
		17750 new algorithm

	Wallclock seconds to run test at 2000 users
		2250s PTF #8
	 	 650s new algorithm

	CPU Seconds at 2000 users
		1300000 PTF #8
		  14000 new algorithm


Test of large parallel app faulting for text.

	Text resident in page cache (10000 pages):
		REAL	USER		SYS
		22.830s	23m5.567s	 85m59.042s	PTF #8 run1
		26.267s	34m3.536s	104m20.035s	PTF #8 run2
		10.890s	19m27.305s	 39m50.949s	new algorithm run1
		10.860s	20m42.698s	 40m48.889s	new algorithm run2

	Text on Disk (1000 pages)
		REAL	USER		SYS
		31.658s	9m25.379s	71m11.967s	PTF #8
		24.348s	6m15.323s	45m27.578s	new algorithm

_________________________________________________________________________________
The following tests were run on UV48:
	    4 racks
	  256 sockets
	2452p westmere

Boot time:
	4562 sec PTF#8
	1965 sec new

MPI "helloworld" with 1024 ranks
	35 sec PTF #8
	22 sec new


Test of large parallel app faulting for text.
	Text resident in page cache (10000 pages):
		REAL	USER		SYS
		46.394s	141m19s		366m53s		PTF #8
		38.986s	137m36		264m52s		PTF #8
		 7.987s	 34m50s		 42m36s		new algorithm
		10.550s	 43m31s		 59m45s		new algorithm


AIM7 Results (this is the original AIM7 - not the recent opensource version)
	------------------------------
	Jobs/Min
	 TASKS      PTF #8         new
	     1       487.8       486.6
	    10      4405.8      4940.6
	   100     18570.5     18198.9
	  1000     17262.3     17167.1
	  2000      4879.3     18163.9
	  4000        **       18846.2
	------------------------------
	Real Seconds
	 TASKS      PTF #8         new
	     1        11.9        12.0
	    10        13.2        11.8
	   100        31.3        32.0
	  1000       337.2       339.0
	  2000      2385.6       640.8
	  4000        **        1235.3
	------------------------------
	CPU Seconds
	 TASKS      PTF #8         new
	     1         1.6         1.6
	    10        11.5        12.9
	   100       132.2       137.2
	  1000      4486.5      6586.3
	  2000   1758419.7     27845.7
	  4000        **       65619.5

           ** Timed out


