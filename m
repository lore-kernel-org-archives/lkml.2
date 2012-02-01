Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2BAEeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 23:34:22 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:46483 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2BAEeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 23:34:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        kernel-team@android.com, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] procfs: Export next_tgid(), move it to kernel/pid.c
References: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
	<20120130134312.GA14110@redhat.com>
	<20120130204920.GA27812@oksana.dev.rtsoft.ru>
	<m1r4ygfxlz.fsf@fess.ebiederm.org>
	<20120201041917.GA22369@oksana.dev.rtsoft.ru>
Date: Tue, 31 Jan 2012 20:37:00 -0800
In-Reply-To: <20120201041917.GA22369@oksana.dev.rtsoft.ru> (Anton Vorontsov's
	message of "Wed, 1 Feb 2012 08:19:17 +0400")
Message-ID: <m1ipjr2mqb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+gG6Zzt8n3bZKcR0GpxeGgYsKs0qJ0/N4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov <anton.vorontsov@linaro.org> writes:

> On Mon, Jan 30, 2012 at 05:51:20PM -0800, Eric W. Biederman wrote:
> [...]
>> > Yes, in LMK driver we don't need to be accurate. I probably could use
>> > rcu_read_lock, but the plan was in not holding any global locks (in
>> > this case the rcu) at all, instead I'd like to hold just a reference
>> > of the task, which the driver is analyzing at this time. Once we decide
>> > (to kill or not to kill the task), we either send a signal (and drop
>> > the reference) or just drop the reference.
>> 
>> rcu_read_lock unless it is implemented wrong is free from a lock
>> perspective.  rcu_read_lock only touches local state.
>> 
>> >From the look of your loop it already does a walk through the entire
>> process list so it looks to me like playing games with get_task_struct
>> and put_task_struct are going to be much more expensive.
>> 
>> proc grabs task references because we can't hold the rcu_read_lock
>> over a copy_to_user because that is a sleeping function.
>> 
>> You don't call anything that sleeps so rcu_read_lock should be
>> sufficient.
>
> I'll just repeat what I told to Paul E. McKenney:
>
> [...] the locking part wasn't my concern at all. As I said before,
> LMK (low memory killer) itself is not important, and we don't care
> about its overhead, unless it blocks another kernel activity --
> which is my main concern.
>
> So, reader part is not interesting in sense of overhead or
> efficiency.
>
> The interesting questions are:
>
> 1. Can the kernel create processes while LMK traverses the list?
> 2. Can the kernel free processes while LMK traverses the list?
>
> Looking into kernel/fork.c:copy_process(), it does this:
>
> - Takes a write lock on tasklist_lock;
> - Uses list_add_tail_rcu() to add a task.
>
> So, with current LMK driver (it grabs the tasklist_lock), it seems
> that the kernel won't able to create processes while LMK traverse the
> tasks.
>
> Looking into kernel/exit.c:release_task(), it does this:
>
> - Takes a write lock on tasklist_lock;
> - Deletes the task from the list using list_del_rcu()
> - Releases tasklist_lock;
> - Issues call_rcu(&p->rcu, delayed_put_task_struct), which
>   then actually completely frees the task;
>
> So, with the current LMK driver, kernel won't able to release
> processes while LMK traverse the processes, because LMK takes
> the tasklist_lock.
>
> By using rcu_read_lock() we would solve "1.", i.e. kernel will able
> to create processes, but we still won't able to free processes (well,
> for the most part we will, except that we'll only free memory after
> LMK finishes its traverse).


Correct. We will only free the task_struct after you release the
rcu_read_lock. Many of the other resources are freed before the
task_struct.  So most of the memory of a process should be freeable
even with the rcu_read_lock held.

Eric
