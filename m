Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0DAQbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:31:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757663Ab0DAQbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:31:05 -0400
Message-ID: <4BB4ABBB.4000909@redhat.com>
Date: Thu, 01 Apr 2010 17:20:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Darren Hart <dvhltc@us.ibm.com>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Peter Morreale <pmorreale@novell.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: RFC: Ideal Adaptive Spinning Conditions
References: <4BB3D90C.3030108@us.ibm.com>
In-Reply-To: <4BB3D90C.3030108@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 02:21 AM, Darren Hart wrote:
> I'm looking at some adaptive spinning with futexes as a way to help 
> reduce the dependence on sched_yield() to implement userspace 
> spinlocks. Chris, I included you in the CC after reading your comments 
> regarding sched_yield() at kernel summit and I thought you might be 
> interested.
>
> I have an experimental patchset that implements FUTEX_LOCK and 
> FUTEX_LOCK_ADAPTIVE in the kernel and use something akin to 
> mutex_spin_on_owner() for the first waiter to spin. What I'm finding 
> is that adaptive spinning actually hurts my particular test case, so I 
> was hoping to poll people for context regarding the existing adaptive 
> spinning implementations in the kernel as to where we see benefit. 
> Under which conditions does adaptive spinning help?
>
> I presume locks with a short average hold time stand to gain the most 
> as the longer the lock is held the more likely the spinner will expire 
> its timeslice or that the scheduling gain becomes noise in the 
> acquisition time. My test case simple calls "lock();unlock()" for a 
> fixed number of iterations and reports the iterations per second at 
> the end of the run. It can run with an arbitrary number of threads as 
> well. I typically run with 256 threads for 10M iterations.
>
>          futex_lock: Result: 635 Kiter/s
> futex_lock_adaptive: Result: 542 Kiter/s

A lock(); unlock(); loop spends most of its time with the lock held or 
contended.  Can you something like this:


    lock();
    for (i = 0; i < 1000; ++i)
         asm volatile ("" : : : "memory");
    unlock();
    for (i = 0; i < 10000; ++i)
         asm volatile ("" : : : "memory");

This simulates a lock hold ratio of 10% with the lock hold time 
exceeding the acquisition time.  Will be interesting to lower both loop 
bounds as well.

-- 
error compiling committee.c: too many arguments to function

