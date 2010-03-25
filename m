Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab0CYJjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:39:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51362 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0CYJjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:39:16 -0400
Message-ID: <4BAB2EAF.2030804@cn.fujitsu.com>
Date: Thu, 25 Mar 2010 17:36:47 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: sched_wakeup_new and sched_kthread_stop events cause great overload
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have done sysbench test for ftrace's performance and it looks sched_wakeup_new
and sched_kthread_stop events can cause great overload.

When we only enable sched_wakeup_new and sched_kthread_stop events, sysbench.threads
shows the overload is 10%, sysbench.mutex shows the overload is 7.5%.

The more weird thing is that we found the sched_kthread_stop event is never called
in this test, the test steps as follow:

echo > debugfs/tracing/set_event
echo 1 > debugfs/tracing/events/sched/sched_wakeup_new/enable
echo 1 > debugfs/tracing/events/sched/sched_kthread_stop/enable

com_opt="--num-threads=5000 --max-requests=50000"
echo > debugfs/tracing/trace
sysbench $com_opt --test=threads --thread-yields=1000 --thread-locks=10000 run >& log
[or sysbench $com_opt --test=mutex --mutex-num=100 --mutex-locks=50000 --mutex-loops=10000 run for mutex]
echo > debugfs/tracing/set_event

For sysbench.threads:
cat debugfs/tracing/trace | grep "sched_wakeup_new" | wc -l
5001
cat debugfs/tracing/trace | grep "sched_kthread_stop" | wc -l
0

For sysbench.mutex:
cat debugfs/tracing/trace | grep "sched_wakeup_new" | wc -l
5001
cat debugfs/tracing/trace | grep "sched_kthread_stop" | wc -l
0

And, if only enable sched_kthread_stop event, the sysbench.threads's
overload is 5.90%, the sysbench.mutex's overload is 3.36%.

It hardly explain why sched_kthread_stop is never called but cause great overload.
