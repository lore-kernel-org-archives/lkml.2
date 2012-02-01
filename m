Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2BAETX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 23:19:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61770 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2BAETW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 23:19:22 -0500
Date: Wed, 1 Feb 2012 08:19:17 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, San Mehat <san@google.com>,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        kernel-team@android.com, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 1/3] procfs: Export next_tgid(), move it to kernel/pid.c
Message-ID: <20120201041917.GA22369@oksana.dev.rtsoft.ru>
References: <20120130011323.GA30274@oksana.dev.rtsoft.ru>
 <20120130134312.GA14110@redhat.com>
 <20120130204920.GA27812@oksana.dev.rtsoft.ru>
 <m1r4ygfxlz.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m1r4ygfxlz.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 05:51:20PM -0800, Eric W. Biederman wrote:
[...]
> > Yes, in LMK driver we don't need to be accurate. I probably could use
> > rcu_read_lock, but the plan was in not holding any global locks (in
> > this case the rcu) at all, instead I'd like to hold just a reference
> > of the task, which the driver is analyzing at this time. Once we decide
> > (to kill or not to kill the task), we either send a signal (and drop
> > the reference) or just drop the reference.
> 
> rcu_read_lock unless it is implemented wrong is free from a lock
> perspective.  rcu_read_lock only touches local state.
> 
> >From the look of your loop it already does a walk through the entire
> process list so it looks to me like playing games with get_task_struct
> and put_task_struct are going to be much more expensive.
> 
> proc grabs task references because we can't hold the rcu_read_lock
> over a copy_to_user because that is a sleeping function.
> 
> You don't call anything that sleeps so rcu_read_lock should be
> sufficient.

I'll just repeat what I told to Paul E. McKenney:

[...] the locking part wasn't my concern at all. As I said before,
LMK (low memory killer) itself is not important, and we don't care
about its overhead, unless it blocks another kernel activity --
which is my main concern.

So, reader part is not interesting in sense of overhead or
efficiency.

The interesting questions are:

1. Can the kernel create processes while LMK traverses the list?
2. Can the kernel free processes while LMK traverses the list?

Looking into kernel/fork.c:copy_process(), it does this:

- Takes a write lock on tasklist_lock;
- Uses list_add_tail_rcu() to add a task.

So, with current LMK driver (it grabs the tasklist_lock), it seems
that the kernel won't able to create processes while LMK traverse the
tasks.

Looking into kernel/exit.c:release_task(), it does this:

- Takes a write lock on tasklist_lock;
- Deletes the task from the list using list_del_rcu()
- Releases tasklist_lock;
- Issues call_rcu(&p->rcu, delayed_put_task_struct), which
  then actually completely frees the task;

So, with the current LMK driver, kernel won't able to release
processes while LMK traverse the processes, because LMK takes
the tasklist_lock.

By using rcu_read_lock() we would solve "1.", i.e. kernel will able
to create processes, but we still won't able to free processes (well,
for the most part we will, except that we'll only free memory after
LMK finishes its traverse).

(I still may be wrong in my findings, please correct me if so.)


Note the these aren't huge or catastrophic issues or something alike.
It is just that during LMK review people pointed out that grabbing
the tasklist lock for LMK is 'too much', and we'd better find a
better way.

rcu_read_lock() might be a good compromise.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
