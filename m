Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0DXHWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 03:22:01 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:51647 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab0DXHV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 03:21:59 -0400
MIME-Version: 1.0
In-Reply-To: <4BD290CC.4080601@kernel.org>
References: <1271984938-13920-1-git-send-email-arve@android.com>
	 <1271984938-13920-4-git-send-email-arve@android.com>
	 <1271984938-13920-5-git-send-email-arve@android.com>
	 <1271984938-13920-6-git-send-email-arve@android.com>
	 <1271984938-13920-7-git-send-email-arve@android.com>
	 <1271984938-13920-8-git-send-email-arve@android.com>
	 <4BD1576E.5070401@kernel.org> <20100423122032.GA23544@redhat.com>
	 <y2ud6200be21004231549q8e52c9c0z441d82b5a15e177d@mail.gmail.com>
	 <4BD290CC.4080601@kernel.org>
Date: Sat, 24 Apr 2010 00:21:58 -0700
Message-ID: <r2zd6200be21004240021sfaec0f3ft8a1ea7c1b12ea52a@mail.gmail.com>
Subject: Re: [PATCH 7/9] PM: Add suspend blocking work.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/23 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On 04/24/2010 12:49 AM, Arve Hjønnevåg wrote:
>> I want the suspend blocker active when the work is pending or running.
>> I did not see a way to do this on top of the workqueue api without
>> adding additional locking.
>
> Well, then add additional locking.  suspend_blocker is far away from
> being a hot path and there's nothing wrong with additional locking as
> long as everything is wrapped inside proper APIs.  Adding stuff to the
> core code for things as specific as this is much worse.
>

OK, I'll try to do this. Do you want it in a separate header file as well?

>> If the work is both queued and starts running on another workqueue
>> between "get_wq_data(work) == cwq" and "!work_pending(work)", then
>> suspend_unblock will be called when it shouldn't. It should work fine
>> if I change to it check pending first though, since it cannot move
>> back to the current workqueue without locking cwq->lock first.
>
> The code is more fundamentally broken.  Once work->func has started
> executing, the work pointer can't be dereferenced as work callback is
> allowed to free or re-purpose the work data structure and in the same
> manner you can't check for pending status after execution has
> completed.
>

I only touch the work structure after the callback has returned for
suspend blocking work, which does not allow that.

>> Or are you talking about the race when the callback is running on
>> multiple (cpu) workqueues at the same time. In that case the suspend
>> blocker is released when the callback returns from the last workqueue
>> is was queued on, not when all the callbacks have returned. On that
>> note, is it ever safe to use flush_work and cancel_work_sync for work
>> queues on anything other than a single single threaded workqueue?
>
> flush_work() is guaranteed only to flush from the last queued cpu but
> cancel_work_sync() will guarantee that no cpu is executing or holding
> onto the work.  So, yeah, as long as the limitations of flush_work()
> is understood, it's safe.
>

Sorry, I didn't see the for_each_cpu(cpu, cpu_map) part of
wait_on_work(). cancel_work_sync() does look safe as long as the work
has not moved to completely different workqueue.

> Going back to the original subject, just add simplistic outside
> locking in suspend_blocker_work API (or whatever other name you
> prefer).  That will be much cleaner and safer.  Let's think about
> moving them into workqueue implementation proper after the number of
> the API users grows to hundreds.
>

OK.

-- 
Arve Hjønnevåg
