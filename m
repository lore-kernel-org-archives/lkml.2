Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab2CTX2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:28:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37475 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756717Ab2CTX2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:28:44 -0400
Message-ID: <4F691289.7080505@fb.com>
Date: Tue, 20 Mar 2012 16:28:09 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, "Paul Mackerras" <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Stephane Eranian" <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Tom Zanussi" <tzanussi@gmail.com>, <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH] perf: Add a new sort order: SORT_INCLUSIVE (v4)
References: <1331746607-6706-1-git-send-email-asharma@fb.com> <20120315141402.GA550@somewhere.redhat.com> <4F622DCE.4090608@fb.com> <20120319155742.GF2660@somewhere>
In-Reply-To: <20120319155742.GF2660@somewhere>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-20_10:2012-03-20,2012-03-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/12 8:57 AM, Frederic Weisbecker wrote:

>>> Each hist have a period of 1, but the total period is 1.
>>> So the end result should be (IIUC):
>>>
>>> 100%    foo     a
>>> 100%    foo     b
>>>                  |
>>>                  --- a
>>> 100%    foo     c
>>>                  |
>>>                  --- b
>>>                      |
>>>                      --- c
>>>
>>
>> That is correct. The first column no longer adds up to 100%.
>
> So do we really want this?
>

I think so. It's a different way of presenting the data. Pie chart vs a 
bar chart of OS market share where people may be using more than one OS.

I'll post some documentation updates.

>> If we don't do this, total_period will be inflated.
>
> Yeah right I've just tried and callchains look right. I'm just puzzled
> by the percentages:
>

Thanks for testing this!

> +  98,99%  [k] execve
> +  98,99%  [k] stub_execve
> +  98,99%  [k] do_execve
> +  98,99%  [k] do_execve_common
> +  98,99%  [k] sys_execve
> +  53,12%  [k] __libc_start_main
> +  53,12%  [k] cmd_record

These look like they belong to the perf binary and are incorrectly 
classified as kernel samples. Problem is that callchain_get() is not 
populating the privilege level - it's simply propagating the privilege 
level of the sample:


+       for (i = 0; i < cursor->nr; i++) {
+               struct addr_location al_child = *al;
+
+               err = callchain_get(&iter, &al_child);

Not all fields of al_child are populated by callchain_get().

> +  53,12%  [k] T.101
> +  53,12%  [k] main
> +  53,12%  [k] run_builtin
> +  52,11%  [k] perf_evlist__prepare_workload
> +  52,09%  [k] T.1163

The rest of them look ok to me. If something doesn't make sense, please 
point me at the output of "perf script".

>
>>
>>> Also this feature reminds me a lot the -b option in perf report.
>>> Branch sorting and callchain inclusive sorting are a bit different in
>>> the way they handle the things but the core idea is the same. Callchains
>>> are branches as well.
>>>
>>
>> Yes - I kept asking why the branch stack stuff doesn't use the
>> existing callchain logic.
>
> Because I fear that loops branches could make the tree representation useless.
>

The loops could happen in callgraphs too right (eg: recursive programs)? 
The other problem in branch stacks/LBR is that they're sampled branches. 
Just because I got a sample with:

a -> b
b -> c

doesn't necessarily mean that the callchain was a -> b -> c.

I still don't have the branch stack setup working properly. But I'm now 
more sympathetic to the view that last branch sampling and callchains 
may have different representations in perf.

  -Arun
