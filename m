Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2CLSVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:21:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36156 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755197Ab2CLSVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:21:07 -0400
Message-ID: <4F5E3E8C.1020005@fb.com>
Date: Mon, 12 Mar 2012 11:21:00 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <4F5DA91F.7060908@lge.com>
In-Reply-To: <4F5DA91F.7060908@lge.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-12_05:2012-03-12,2012-03-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/12 12:43 AM, Namhyung Kim wrote:

>> Known bugs:
>>
>> total_period computation is broken for order=callee
>>
>
> I'd like to add two more :).
>
> * If perf record misses callchain info, perf report will get stuck.
> * If it's used with "symbol" sort order, it'll get stuck too.
>

Can you post the command lines you used to reproduce this? A backtrace 
on where perf report is getting stuck would be useful as well.

Since I didn't make any changes to the perf record or perf report code 
paths that don't involve "-s inclusive", I wonder if you see the same 
issues without my patch.

For missing callchain info cases, I'd expect cursor->nr to be zero. So 
loops such as:

+       for (i = 0; i < cursor->nr; i++) {

should terminate immediately.

>
> BTW, I don't like the name 'inclusive' as a sort key. If it cares about
> time, IMHO, the name should contain 'time' - something like 'itime' or
> 'inctime'?

The existing sort orders: pid, comm, dso, symbol, parent -- all care 
about time, but none of them have time in their name?

>
> Furthermore, I don't think it is a sort key. As it doesn't sort
> anything, and only affects the way calculating symbol's period value,
> wouldn't it be better making it a separate switch rather than a sort
> key? Plus, checking whether it has callchain data and symbol sort key
> might be added also.

Yes, we're still sorting by period, but a redefined meaning of period 
(please see my other mail about period vs period_self). Previous 
iterations of this code did use a top level flag, but that namespace is 
getting a bit crowded.

  -Arun
