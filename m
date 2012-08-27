Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2H0HW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:22:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43567 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2H0HWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <20120825114746.GA28832@somewhere.redhat.com>
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
	<1344344165-369636-4-git-send-email-avagin@openvz.org>
	<20120825114746.GA28832@somewhere.redhat.com>
Date: Mon, 27 Aug 2012 11:22:18 +0400
Message-ID: <CANaxB-xF9s7kwq-LvXgFVgMi4=4i-qrX2hunvdJK1f9gnm-krQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] perf: teach perf inject to merge sched_stat_* and
 sched_switch events (v2)
From: Andrey Wagin <avagin@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/25 Frederic Weisbecker <fweisbec@gmail.com>:
>> +     if (!strcmp(evname, "sched_switch") ||  sched_process_exit) {
>> +             list_for_each_entry(ent, &samples, node)
>> +                     if (sample->pid == ent->pid)
>
> I suspect what you're rather interested in is the sample tid.

Yes, you are right.

>
>> +
>> +     } else if (!strncmp(evname, "sched_stat_", 11)) {
>> +             u32 pid;
>> +
>> +             pid = raw_field_value(evsel->tp_format,
>> +                                     "pid", sample->raw_data);
>
> There you parse the pid from the trace content. That's fine because
> it's actually the tid that is saved on the trace event. But this one
> is not pid-namespace safe (it saves current->pid directly) while
> sample->tid is pid-namespace safe (it uses task_pid_nr_ns).
>
> So I suggest you to use sample->tid instead, plus that's going to be
> consistant with what you did above.

Here is a problem, because a pid from the trace content and
sample->tid are not the same.
A kernel wakes up a task1 and do it from a context of another task2.
In this case a pid from the trace content is a pid of the task1 and a
sample->tid is a pid of the task2.

DECLARE_EVENT_CLASS(sched_stat_template,
TP_PROTO(struct task_struct *tsk, u64 delay),
...
                __entry->pid    = tsk->pid;
...


Here is a patch, which allow us to get "foreign" events.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e6dab5ffab59e910ec0e3355f4a6f29f7a7be474
