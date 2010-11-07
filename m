Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0KGWEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:04:50 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:56964 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab0KGWEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:04:48 -0500
To: paulmck@linux.vnet.ibm.com
Cc: sergey.senozhatsky@gmail.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20101030093234.GK3932@swordfish.minsk.epam.com>
	<201010302214.DDF98906.MSFJOFtFHOLQVO@I-love.SAKURA.ne.jp>
	<20101030210244.GE2664@linux.vnet.ibm.com>
	<201010310833.CCE89052.FtQFHSOFLOOJMV@I-love.SAKURA.ne.jp>
	<20101107194330.GE15561@linux.vnet.ibm.com>
In-Reply-To: <20101107194330.GE15561@linux.vnet.ibm.com>
Message-Id: <201011080704.GIH17609.SFVQLtJOOHFFMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 8 Nov 2010 07:04:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Paul E. McKenney wrote:
> > Users missing rcu_read_lock() when calling find_task_by_vpid():
> > 
> >   check_clock() in kernel/posix-cpu-timers.c
> 
> 	This one has read_lock(&tasklist_lock).
> 
Excuse me. Holding tasklist_lock lock does not help.
We must call rcu_read_lock() explicitly.
That's why 9728e5d6 "kernel/pid.c: update comment on find_task_by_pid_ns" was made.

I think there are users who needlessly call read_lock(&tasklist_lock)
when they can use rcu_read_lock() instead.
But I don't know when to use read_lock(&tasklist_lock).

If read_lock(&tasklist_lock) is needed only when we want to access
the "struct task_struct" after rcu_read_unlock(), maybe it is cleaner to
use a helper like

struct task_struct *find_task_and_get(pid_t pid)
{
	struct task_struct *task;
	read_lock(&tasklist_lock);
	rcu_read_lock();
	task = find_task_by_vpid(pid);
	rcu_read_unlock();
	if (task)
		get_task_struct(task);
	read_unlock(&tasklist_lock);
	return task;
}

and hide tasklist_lock.

Regards.
