Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2DNWcY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 18:32:24 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36032 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab2DNWcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 18:32:23 -0400
Message-ID: <4F89FADD.7050903@linux.vnet.ibm.com>
Date: Sun, 15 Apr 2012 04:01:57 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [RFC 0/3] Extend type checking macros
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com> <4F89E9A3.3020800@linux.vnet.ibm.com>
In-Reply-To: <4F89E9A3.3020800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041422-8256-0000-0000-000001FEDE3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2012 02:48 AM, Srivatsa S. Bhat wrote:

> On 04/15/2012 03:44 AM, Sasha Levin wrote:
> 
>> Commit e3831ed ("sched: Fix incorrect usage of for_each_cpu_mask() in
>> select_fallback_rq()") fixes a very non obvious bug in select_fallback_rq()
>> which was caused by passing 'struct cpumask' instead of 'struct cpumask *'
>> to a macro in include/linux/cpumask.h
>>
> 
> 
> Good heavens! I just found out that *each* *and* *every* *one* of the
> existing 12 users of for_each_cpu_mask() are wrong!! Unbelievable!
> 


Never mind.. I think I was blind! Gah, having 2 helpers to do the same
thing is confusing, no doubt!

So, looking again, for_each_cpu_mask() does expect the second value to
be struct cpumask, and not struct cpumask *. Which means, we saw the
warning (http://thread.gmane.org/gmane.linux.kernel/1274579/) for an
entirely different reason than what the changelog of commit e3831ed says!

Looking further, the problem is fairly simple:
for_each_cpu() and friends (eg: cpumask_next) cap at nr_cpu_ids.
for_each_cpu_mask() and friends (eg: __next_cpu) cap at NR_CPUS.

And cpumask_test_cpu() that was used in select_fallback_rq() essentially
boils down to cpumask_check(), which uses nr_cpumask_bits as the cap,
which can be either nr_cpu_ids or NR_CPUS depending on whether we have
CONFIG_CPUMASK_OFFSTACK set or unset.

IOW, we got the warning because we mixed up NR_CPUS and nr_cpu_ids.
And commit e3831ed fixed it because it properly matched the functions
used, so that they cap at, and check for the same value; and not because
of a mismatch between the type of arguments expected vs sent to
for_each_cpu_mask(), as its changelog states.
(No wonder Peter's code compiled without problems...)

One more thing: the old interface decides between nr_cpu_ids vs NR_CPUS
depending on whether NR_CPUS > 64, whereas the new interface decides
based on the config option - CPUMASK_OFFSTACK.
All in all, lots of confusion and incompatibility.

So I think we need to standardize the values - use nr_cpumask_bits
everywhere (since it can become nr_cpu_ids or NR_CPUS depending on our
config options), and be done with it. Then we wouldn't have such
mismatches and bugs.

Don't know how many more places have got these mixed up.. All the more
reason to get rid of for_each_cpu_mask(), if you ask me..

Regards,
Srivatsa S. Bhat

