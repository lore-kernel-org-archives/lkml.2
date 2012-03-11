Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2CKPUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 11:20:19 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:36327 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753124Ab2CKPT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 11:19:28 -0400
X-Authenticated: #5086196
X-Provags-ID: V01U2FsdGVkX192Bfx2QHZ2WbUBMIqQFmPXPUqX0RdCKu/TDTdMbc
	+CcFLPE/0ieLuA
Subject: Re: bug in thread_group_times (+possible patch)
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Fawzi Mohamed <fawzi@gmx.ch>
In-Reply-To: <CAJd=RBBnxKa+roD+G-G_bnVLBKCmw-wtW+pO8BtQRVmPkRoJpw@mail.gmail.com>
Date: Sun, 11 Mar 2012 16:19:24 +0100
Cc: linux-kernel@vger.kernel.org, Thomas Dargel <td@chemie.hu-berlin.de>
Content-Transfer-Encoding: 8BIT
Message-Id: <4EAF753B-6FBF-4EB8-A200-C7BCE7FDEEA0@gmx.ch>
References: <2C80D678-F219-4B4E-A7FB-D0F890ECC7DD@gmx.ch> <CAJd=RBBnxKa+roD+G-G_bnVLBKCmw-wtW+pO8BtQRVmPkRoJpw@mail.gmail.com>
To: Hillf Danton <dhillf@gmail.com>
X-Mailer: Apple Mail (2.1251.1)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 11, 2012, at 5:09 AM, Hillf Danton wrote:

> Hello Fawzi,
> 
> On Sun, Mar 11, 2012 at 7:11 AM, Fawzi Mohamed <fawzi@gmx.ch> wrote:
>> Hi,
>> 
>> a friend of mine asked me about a kernel crash that he was having on a linux cluster (always after long compute intensive task).
>> I found the bug causing it, and patched it (in an imperfect way), and as I have seen that in the current git the bug is still there, I am writing it here.
>> I am not into kernel development, so I did not subscribe to the list, please CC me if you want me to answer.
>> Sorry if this is not the correct way, but I hope this might help to squash just another little bug.
>> 
>> Now the bug is in kernel/sched/core.c in thread_group_times which if CONFIG_VIRT_CPU_ACCOUNTING is not defined looks like this
>> 
>> void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
>> {
>>        struct signal_struct *sig = p->signal;
>>        struct task_cputime cputime;
>>        cputime_t rtime, utime, total;
>> 
>>        thread_group_cputime(p, &cputime);
>> 
>>        total = cputime.utime + cputime.stime;
>>        rtime = nsecs_to_cputime(cputime.sum_exec_runtime);
>> 
>>        if (total) {
>>                u64 temp = (__force u64) rtime;
>> 
>>                temp *= (__force u64) cputime.utime;
> 
> Would you please try the tiny change?
> 
> -                do_div(temp, (__force u32) total);
> +                temp = div64_u64(temp, (__force u64) total);

that should also work, and be better than my solution (keeps the precision by shifting just as much as  needed).
I guess it can be tested on the kernel 2.6.32 (where the error did happen, and that cannot really be upgraded, as it is a production system, and has hardware that requires special drivers).
I just tested and div64_u64 was already available.
The case is not required in this case (because an up cast if required will be implicit), and it does not make sense to cast one argument but not the other, as they require the same conversion.
So
> +                temp = div64_u64(temp, total);
should work.
Now it is up to Thomas (the one administering the machines, and that found the crash), but while this should fix the problem we saw, don't hold your breath for a quick confirmation, it did require ~19 days of computation to happen.
 
ciao
Fawzi
> 
>>                utime = (__force cputime_t) temp;
>>        } else
>>                utime = rtime;
>> 

