Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2GCPQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:16:51 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40053 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GCPQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:16:50 -0400
MIME-Version: 1.0
Date: Tue, 3 Jul 2012 10:16:48 -0500
Message-ID: <CAJvUf-A6JuEGt_zUe=vC--Cv0Oq_CGeCQCSRdHZLfaXT=5SOzA@mail.gmail.com>
Subject: sandy bridge slower w/pthread condition variables, contended mutexes
From: Matt Garman <matthew.garman@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been looking at the performance of two servers:
    - dual Xeon X5550 2.67GHz (Nehalem, Dell R610)
    - dual Xeon E5-2690 2.90 GHz (Sandy Bridge, Dell R620 & HP dl360g8p)

For my particular (proprietary) application, the Sandy Bridge systems
are significantly slower.  At least one facet of this problem has to
do with:
    - pthread condition variable signaling
    - pthread mutex lock contention

I wrote a simple (<300 lines) C program that demonstrates this:
http://pastebin.com/0jPt0AJS

The program has two tests:
    - "lc", a lock contention test, where two threads "fight" over
incrementing and decrementing an integer, arbitrated with a
pthread_mutex_t
    - "cv", a condition variable signaling test, where two threads
"politely" take turns incrementing and decrementing an integer,
signaling each other with a condition variable

The program uses pthread_setaffinity_np() to pin each thread to its
own CPU core.

I would expect the SNB-based servers to be faster, since they have a
clockspeed and architecture advantage.

Results of X5550 @ 2.67 GHz server under CentOS 5.7:
# ./snb_slow_demo -c 3 -C 5 -t cv -n 50000000
runtime, seconds ........ 143.339958

# ./snb_slow_demo -c 3 -C 5 -t lc -n 500000000
runtime, seconds ........ 58.278671

Results of Dell E5-2690 @ 2.90 GHz under CentOS 5.7:
# ./snb_slow_demo -c 2 -C 4 -t cv -n 50000000
runtime, seconds ........ 179.272697

# ./snb_slow_demo -c 2 -C 4 -t lc -n 500000000
runtime, seconds ........ 103.437226

I upgraded the E5-2690 server to CentOS 6.2, then tried both the
current release kernel.org kernel version 3.4.4, and also 3.5.0-rc5.
The "lc" test results are about the same, but the "cv" tests are worse
yet: the same test takes about 229 seconds to run.

Also noteworthy is that the HP has generally better performance than
the Dell.  But the HP E5-2690 is still worse than the X5550.

In all cases, for all servers, I disabled power-saving features (cpu
frequency scaling, C-states, C1E).  I verified with i7z that all CPUs
spend 100% of their time in state C0.

Is this simply a corner case where Sandy Bridge is worse than its
predecessor?  Or is there an implementation problem?

Thanks,
Matt
