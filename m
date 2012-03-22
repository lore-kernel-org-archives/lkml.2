Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab2CVLgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:36:12 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61290 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755030Ab2CVLgI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:36:08 -0400
MIME-Version: 1.0
In-Reply-To: <1332409996.18960.511.camel@twins>
References: <CAEbykaXUy7HEyW7mBaTNmB94NwyjuJBbA1R-H49Jjk5M-iL_fw@mail.gmail.com>
	<1332409996.18960.511.camel@twins>
Date: Thu, 22 Mar 2012 13:36:06 +0200
Message-ID: <CAEbykaUbkgCEcufTx4ZBSdqwrifVbV384Ru4xTyF7BXYtJ85Zg@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix RCU dereference check in perf_event_comm
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22. maaliskuuta 2012 11.53 Peter Zijlstra <a.p.zijlstra@chello.nl> kirjoitti:
> On Thu, 2012-03-22 at 01:43 +0200, Ari Savolainen wrote:
>> The warning below is printed when executing a command like
>> sudo perf record su - user -c "echo hello"
>>
>> It's fixed by moving the call of perf_event_comm to be protected
>> by the task lock.
>
> That seems like a rather poor solution since it increases the lock hold
> time for no explained reason.
>
>> include/linux/cgroup.h:567 suspicious rcu_dereference_check() usage!
>
>>  [<ffffffff8109be55>] lockdep_rcu_suspicious+0xe5/0x100
>>  [<ffffffff811131fa>] perf_event_comm+0x37a/0x4d0
>
> So where exactly is this, perf_event_comm_event() takes rcu_read_lock()
> so I presume its before that.

I think the warning comes from this source-level call path:

perf_event_comm ->
  perf_event_enable_on_exec ->
    perf_cgroup_sched_out ->
      perf_cgroup_from_task ->
        task_subsys_state ->
          task_subsys_state_check

It seems there that path does not take rcu_read_lock(). Where should
rcu_read_lock/unlock be added? In perf_group_sched_out around the
calls of perf_cgroup_from_task? Like this:

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1b5c081..bbb4abc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -409,6 +409,8 @@ static inline void perf_cgroup_sched_out(struct
task_struct *task,
        struct perf_cgroup *cgrp1;
        struct perf_cgroup *cgrp2 = NULL;

+       rcu_read_lock();
+
        /*
         * we come here when we know perf_cgroup_events > 0
         */
@@ -421,6 +423,8 @@ static inline void perf_cgroup_sched_out(struct
task_struct *task,
        if (next)
                cgrp2 = perf_cgroup_from_task(next);

+       rcu_read_unlock();
+
        /*
         * only schedule out current cgroup events if we know
         * that we are switching to a different cgroup. Otherwise,
--


Ari
