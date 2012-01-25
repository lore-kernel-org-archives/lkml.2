Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab2AYWax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 17:30:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60758 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750880Ab2AYWaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 17:30:52 -0500
Message-ID: <4F20823A.6010808@fb.com>
Date: Wed, 25 Jan 2012 14:29:14 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
References: <1327026020-32376-1-git-send-email-asharma@fb.com>  <1327318449.2446.5.camel@twins> <4F1DA9D0.6090208@fb.com>  <1327352631.2446.22.camel@twins> <4F1DE6FE.4000603@fb.com>  <1327415255.2614.33.camel@laptop> <4F1F26CC.4040109@fb.com>  <20120125092008.GB20878@somewhere> <4F205D1D.1020304@fb.com> <1327522558.22710.47.camel@gandalf.stny.rr.com>
In-Reply-To: <1327522558.22710.47.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-25_09:2012-01-25,2012-01-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/12 12:15 PM, Steven Rostedt wrote:

> trace-cmd record -e sched_switch -f 'prev_state == 1 || prev_state == 2' -e sched_stat_sleep sleep 3
>
> I'm not sure the filter is even needed, and it should still keep up
> fine.

Better - I didn't see any overruns with trace-cmd.

Even if we resolve the sampling rate related problems, there is the 
issue of: can we trust that a sampled sched_switch event and a sampled 
sched_stat_sleep event actually match each other?

There is consensus here that touching an extra cacheline in the context 
switch path is a good trade-off given the usefulness of sleep profiling 
in troubleshooting latency problems.

Since it may not be a good trade-off for everyone, we just need to 
figure out where to store some per-task state. To recap two potential 
paths to investigate:

* store sleep_start someplace else that no one other than 
sched_stat_sleeptime() knows about.

* store state in task struct that remembers whether the last context 
switch was a preemption or not.

  -Arun
