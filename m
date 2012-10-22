Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2JVE0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 00:26:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64878 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2JVE0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 00:26:53 -0400
MIME-Version: 1.0
In-Reply-To: <20121019160425.GA10175@dhcp22.suse.cz>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
	<20121019160425.GA10175@dhcp22.suse.cz>
Date: Mon, 22 Oct 2012 12:26:51 +0800
Message-ID: <CAKWKT+ZxC9H_03Kz48i+r2EAh3mtoobcdt1koiSp2KTpb=svHg@mail.gmail.com>
Subject: Re: process hangs on do_exit when oom happens
From: Qiang Gao <gaoqiangscut@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know whether  the process will exit finally, bug this stack
lasts for hours, which is obviously unnormal.
The situation:  we use a command calld "cglimit" to fork-and-exec the
worker process,and the "cglimit" will
set some limitation on the worker with cgroup. for now,we limit the
memory,and we also use cpu cgroup,but with
no limiation,so when the worker is running, the cgroup directory looks
like following:

/cgroup/memory/worker : this directory limit the memory
/cgroup/cpu/worker :with no limit,but worker process is in.

for some reason(some other process we didn't consider),  the worker
process invoke global oom-killer,
not cgroup-oom-killer.  then the worker process hangs there.

Actually, if we didn't set the worker process into the cpu cgroup,
this will never happens.

On Sat, Oct 20, 2012 at 12:04 AM, Michal Hocko <mhocko@suse.cz> wrote:
>
> On Wed 17-10-12 18:23:34, gaoqiang wrote:
> > I looked up nothing useful with google,so I'm here for help..
> >
> > when this happens:  I use memcg to limit the memory use of a
> > process,and when the memcg cgroup was out of memory,
> > the process was oom-killed   however,it cannot really complete the
> > exiting. here is the some information
>
> How many tasks are in the group and what kind of memory do they use?
> Is it possible that you were hit by the same issue as described in
> 79dfdacc memcg: make oom_lock 0 and 1 based rather than counter.
>
> > OS version:  centos6.2    2.6.32.220.7.1
>
> Your kernel is quite old and you should be probably asking your
> distribution to help you out. There were many fixes since 2.6.32.
> Are you able to reproduce the same issue with the current vanila kernel?
>
> > /proc/pid/stack
> > ---------------------------------------------------------------
> >
> > [<ffffffff810597ca>] __cond_resched+0x2a/0x40
> > [<ffffffff81121569>] unmap_vmas+0xb49/0xb70
> > [<ffffffff8112822e>] exit_mmap+0x7e/0x140
> > [<ffffffff8105b078>] mmput+0x58/0x110
> > [<ffffffff81061aad>] exit_mm+0x11d/0x160
> > [<ffffffff81061c9d>] do_exit+0x1ad/0x860
> > [<ffffffff81062391>] do_group_exit+0x41/0xb0
> > [<ffffffff81077cd8>] get_signal_to_deliver+0x1e8/0x430
> > [<ffffffff8100a4c4>] do_notify_resume+0xf4/0x8b0
> > [<ffffffff8100b281>] int_signal+0x12/0x17
> > [<ffffffffffffffff>] 0xffffffffffffffff
>
> This looks strange because this is just an exit part which shouldn't
> deadlock or anything. Is this stack stable? Have you tried to take check
> it more times?
>
> --
> Michal Hocko
> SUSE Labs
