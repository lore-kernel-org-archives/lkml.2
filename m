Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1KDAJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 20:09:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43849 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751829Ab1KDAJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 20:09:43 -0400
Message-ID: <4EB32D1B.8060305@fb.com>
Date: Thu, 3 Nov 2011 17:08:59 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Andrew Vagin <avagin@openvz.org>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, <devel@openvz.org>
Subject: Re: [PATCH 3/4] perf: teach perf inject to merge sched_stat_* and
 sched_switch events
References: <1320274784-2463901-1-git-send-email-avagin@openvz.org> <1320274784-2463901-4-git-send-email-avagin@openvz.org>
In-Reply-To: <1320274784-2463901-4-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-11-03_08:2011-11-03,2011-11-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/11 3:59 PM, Andrew Vagin wrote:

> +		event_sw = (union perf_event *)&ent->header;

This causes problems with -Wstrict-aliasing=3.

I noticed that the suggested cmdline is:

perf script record sched-stat -- -e sched:sched_stat_sleep

I'd much prefer something along the lines of:

perf script record sched-stat -e <events> -- sleep 1

Also, the perf inject command is a bit unforgiving when the user makes 
some mistakes (eg: didn't specify -e sched:sched_stat_sleep). The 
failure mode is hard to understand (perf report -i perf.data.d fails 
with "no samples").

Doing it directly:

# perf record -ag -e sched:sched_switch --filter "prev_state == 1 || 
prev_state == 2" -e 
sched:sched_process_exit,sched:sched_stat_sleep,sched:sched_stat_iowait 
-- sleep 1
# perf inject -v -s -i perf.data -o perf.data.d

results in a whole bunch of:

Could not find sched_switch for pid 16188
Could not find sched_switch for pid 16212
Could not find sched_switch for pid 1500
Could not find sched_switch for pid 16195
Could not find sched_switch for pid 16179

I think this is the same issue you referenced in "Known issues".

Although I'm able to get some profiling info out of perf.data.d, the 
process I really wanted to trace got zero samples.

  -Arun

