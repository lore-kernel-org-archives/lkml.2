Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2ASWcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 17:32:00 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53630 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756887Ab2ASWbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 17:31:53 -0500
Message-ID: <4F18998D.30503@fb.com>
Date: Thu, 19 Jan 2012 14:30:37 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: <avagin@openvz.org>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing, sched: Add a new tracepoint for sleeptime
References: <1324404558-353-1-git-send-email-asharma@fb.com> <1324404558-353-3-git-send-email-asharma@fb.com> <4EF1B86D.9030809@openvz.org>
In-Reply-To: <4EF1B86D.9030809@openvz.org>
Content-Type: text/plain; charset="KOI8-R"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-19_09:2012-01-19,2012-01-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/11 2:43 AM, Andrey Vagin wrote:
>
>>
>> +#ifdef CREATE_TRACE_POINTS
>> +static inline u64 trace_get_sleeptime(struct task_struct *tsk)
>> +{
>> +#ifdef CONFIG_SCHEDSTATS
>> + u64 block, sleep;
>> +
>> + block = tsk->se.statistics.block_start;
>> + sleep = tsk->se.statistics.sleep_start;
> Arun, probably you have missed one of my comments.
> block_start and sleep_start should be zeroized here.
>
> tsk->se.statistics.block_start = 0;
> tsk->se.statistics.sleep_start = 0;

This still doesn't solve one minor problem: the first sample we get 
might be bad. Here's the sequence that could trigger it:

t1: task goes to sleep. sleep_start=t1
t2: task gets woken up. sleep_start is still t1
t3: context switch. trace_get_sleeptime() is not active. sleep_start is 
still t1
t4: trace_get_sleeptime() is activated
t5: task gets context switched out involuntarily.
t6: task gets context switched in. first sample from the task.

We compute sleeptime=t6-t1. The correct answer should be sleeptime=0.

We should set {sleep,block}_start to 0 regardless of whether the 
tracepoint is active or not.

I'll post a patch shortly.

  -Arun
