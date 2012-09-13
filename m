Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab2IMLgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:36:06 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39783 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614Ab2IMLgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:36:02 -0400
Message-ID: <5051C44B.3000707@parallels.com>
Date: Thu, 13 Sep 2012 15:32:27 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cgroups <cgroups@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>,
        Konstantin Khorenko <khorenko@parallels.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: kmemcg benchmarks
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody.

I've just finished a round of benchmarks for kmemcg code. All the
results can be found at: http://glommer.net/kmemcg-benchmarks-13092012/

The benchmarks were run in a 2-socket, 24-cpu machine. I haven't run all
possible configurations I have envisioned, because I wanted this posted
early rather than later. I've also had un-official runs in my 4-cpu i7
laptop and in a 6-way single socket AMD box. They would need to be
re-run to be publishable, since they are quite raw and ad-hoc (like, I
was not running perf stat always in the same way, doing some things
manually, etc) But they overall point to consistent results.

You can find a guide to that data in the README file in that dir, and
the actual data in the results* dir. The chosen allocator for this is
the SLAB.

A summary and discussion of the data follows:

fork intensive workload, elapsed time:
===============================================
base-NotCompiled  : 16.76 +- 0.87% [ + 0.00 % ]
kmemcg-stack-Unset: 16.28 +- 1.10% [ - 2.86 % ]
kmemcg-stack-Set  : 16.96 +- 0.65% [ + 1.19 % ]
kmemcg-slab-Unset : 16.71 +- 1.16% [ + 0.28 % ]
kmemcg-slab-Set   : 17.11 +- 0.48% [ + 2.08 % ]


fork + user mem, elapsed time:
===============================================
base-NotCompiled  :  4.88 +- 0.35% [ + 0.00 % ]
kmemcg-stack-Unset:  4.87 +- 0.36% [ - 0.34 % ]
kmemcg-stack-Set  :  4.85 +- 0.37% [ - 0.76 % ]
kmemcg-slab-Unset :  4.84 +- 0.39% [ - 0.79 % ]
kmemcg-slab-Set   :  4.84 +- 0.35% [ - 0.78 % ]


So in general, I don't see a big difference, with almost all
measurements falling inside the 2-sigma range.

>From the fork intensive workload, two things pop out: first, kmem
patches applied, but kmem not used, actually performs slightly better
than no patches at all. I don't know why this is, and it might even be a
glitch. But it consistently happened in my laptop and in the 6-way AMD
machine.

Also, we can see that in that workload, which is slab intensive,
kmemcg-slab-Set performs slightly worse. Being worse is inline with
expectations, but I don't consider the hit to be too big.

Please let me know of any additional work you would like to see done here.
