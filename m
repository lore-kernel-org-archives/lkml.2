Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2COVq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:46:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55240 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932421Ab2COVqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:46:55 -0400
Message-ID: <4F626321.3060001@fb.com>
Date: Thu, 15 Mar 2012 14:46:09 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <dsahern@gmail.com>, <ravitillo@lbl.gov>,
        <khandual@linux.vnet.ibm.com>, <robert.richter@amd.com>,
        <ming.m.lin@intel.com>, <vweaver1@eecs.utk.edu>, <andi@firstfloor.org>
Subject: Re: [RFC] perf report: Implement symbol filtering on TUI
References: <20120306062546.GA622@elte.hu> <1331085470-32594-1-git-send-email-namhyung.kim@lge.com> <20120314231154.GA15986@dev3310.snc6.facebook.com> <4F613B68.2040004@lge.com>
In-Reply-To: <4F613B68.2040004@lge.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-15_04:2012-03-15,2012-03-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/12 5:44 PM, Namhyung Kim wrote:

> Thanks for reviewing and sending the patch.
>
> However this was already fixed on my new patch set. Please see below:
>
> https://lkml.org/lkml/2012/3/13/73
>

I still get different behaviors with and without my two line patch.

Try:

perf record -g
perf report c -G -g graph,0.5,caller -s inclusive --stdio

I don't see where hists__filter_by_symbol() gets called when using --stdio.

But let's examine what I think is a more important general issue (not 
specific to your patch):

Here's the behavior my coworkers are requesting. With the test program I 
mailed earlier with this callgraph:

./perf report -G -g graph,0.5,caller -s pid --stdio

   100.00%            foo:30804
             |
             --- __libc_start_main
                |
                 --99.87%-- main
                           |
                           |--50.01%-- a
                           |          |
                           |           --42.71%-- c
                           |                     |
                           |                     |--14.36%-- e
                           |                     |          |
                           |                     |           --7.09%-- f
                           |                     |
                           |                      --14.33%-- d
                           |                                |
                           |                                 --6.81%-- f
                           |
                            --49.86%-- b
                                      |
                                       --42.72%-- c
                                                 |
                                                 |--14.43%-- d
                                                 |          |
                                                 |           --7.30%-- f
                                                 |
                                                  --14.13%-- e
                                                            |
                                                             --7.05%-- f

If the user filters by "d", we should:

a) Construct a callgraph that has only callchains containing "d"
b) Express percentages as a fraction of the unfiltered total_period
c) Allow users to expand callchains and see both the callers and callees 
of d.

Right now, I can do this in two steps:

# Get the callgraph leading to "d"
perf report -S d -G -g graph,0.5,callee

  100.00%      foo  foo
                 |
                 --- __libc_start_main
                     main
                    |
                    |--51.37%-- a
                    |          c
                    |          d
                    |
                     --48.63%-- b
                               c
                               d

# Get the callgraph below "d" (i.e. where d is the caller)

perf report d -G -g graph,0.5,caller -s inclusive

    95.56%  [.] d
             |
             --- d
                |
                 --46.88%-- f

and the percentages are not expressed as a percentages of the total_period.

I'll send out a RFC patch next.

  -Arun
