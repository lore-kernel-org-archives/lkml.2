Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab0DWWt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 18:49:59 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:62670 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0DWWt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 18:49:58 -0400
MIME-Version: 1.0
In-Reply-To: <20100423122032.GA23544@redhat.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
	 <1271984938-13920-2-git-send-email-arve@android.com>
	 <1271984938-13920-3-git-send-email-arve@android.com>
	 <1271984938-13920-4-git-send-email-arve@android.com>
	 <1271984938-13920-5-git-send-email-arve@android.com>
	 <1271984938-13920-6-git-send-email-arve@android.com>
	 <1271984938-13920-7-git-send-email-arve@android.com>
	 <1271984938-13920-8-git-send-email-arve@android.com>
	 <4BD1576E.5070401@kernel.org> <20100423122032.GA23544@redhat.com>
Date: Fri, 23 Apr 2010 15:49:56 -0700
Message-ID: <y2ud6200be21004231549q8e52c9c0z441d82b5a15e177d@mail.gmail.com>
Subject: Re: [PATCH 7/9] PM: Add suspend blocking work.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 5:20 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 04/23, Tejun Heo wrote:
>>
>> On 04/23/2010 03:08 AM, Arve Hjønnevåg wrote:
>> > Allow work to be queued that will block suspend while it is pending
>> > or executing. To get the same functionality in the calling code often
>> > requires a separate suspend_blocker for pending and executing work, or
>> > additional state and locking.
>>
>> Hmm... I think this can be implemented as pure wrapper around
>> workqueue instead of injecting a flag and code into workqueue core.
>> Adding @fn field to suspend_blocking_work struct and using a custom
>> work function to call it and then invoke suspend_unblock() should be
>> enough, right?  Oh, dedicated queue functions will be needed too.  I
>> don't think it's wise to meddle with workqueue core code for this.
>
> Completely agreed. The patch adds very "strange" hacks into workqueue
> code to solve the very specific problems.
>

I want the suspend blocker active when the work is pending or running.
I did not see a way to do this on top of the workqueue api without
adding additional locking.

>
> Besides, the patch doesn't look right. suspend_unblock() can be called
> twice if you use cancel_work(). Perhaps this is not a problem, I dunno.

Calling suspend_unblock() twice is not a problem as long as
"unblocked" is the expected final state.

> WORK_STRUCT_SUSPEND_BLOCKING needs to ensure that cpu_workqueue_struct
> has a proper alignment.

OK.

> The unblock code in run_workqueue() is racy,
> it can unblock after the work was queued on another CPU, cwq->lock can't
> help.

If the work is both queued and starts running on another workqueue
between "get_wq_data(work) == cwq" and "!work_pending(work)", then
suspend_unblock will be called when it shouldn't. It should work fine
if I change to it check pending first though, since it cannot move
back to the current workqueue without locking cwq->lock first.

Or are you talking about the race when the callback is running on
multiple (cpu) workqueues at the same time. In that case the suspend
blocker is released when the callback returns from the last workqueue
is was queued on, not when all the callbacks have returned. On that
note, is it ever safe to use flush_work and cancel_work_sync for work
queues on anything other than a single single threaded workqueue?

-- 
Arve Hjønnevåg
