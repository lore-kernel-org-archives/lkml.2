Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032185Ab2COR7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:59:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38271 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1031199Ab2COR7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:59:03 -0400
Message-ID: <4F622DCE.4090608@fb.com>
Date: Thu, 15 Mar 2012 10:58:38 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH] perf: Add a new sort order: SORT_INCLUSIVE (v4)
References: <1331746607-6706-1-git-send-email-asharma@fb.com> <20120315141402.GA550@somewhere.redhat.com>
In-Reply-To: <20120315141402.GA550@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-15_04:2012-03-15,2012-03-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/12 7:14 AM, Frederic Weisbecker wrote:

> I still feel concerned about this.
>
> If I have only one event with a period of 1 and with that callchain:
>
> 	a ->  b ->  c
>
> Then I produce three hists
>
> 	1) a ->  b ->  c
> 	2) a ->  b
> 	3) a
>
> Each hist have a period of 1, but the total period is 1.
> So the end result should be (IIUC):
>
> 100%    foo     a
> 100%    foo     b
>                  |
>                  --- a
> 100%    foo     c
>                  |
>                  --- b
>                      |
>                      --- c
>

That is correct. The first column no longer adds up to 100%.
  		
> And the percentages on callchain branches will have the same kind
> of weird things.

I expect --sort inclusive to be used with -g graph,0.5,caller. I can
polish this in the next rev where a single top level flag will set this up.

The percentages on the branches should still be accurate (as a 
percentage of total_period). Please let me know if this is not the case.

>
> So I'm not sure this is a good direction. I'd rather advocate to create
> true hists for each callers, all having the same real period as the leaf.
>

Please see the v5 I just posted. The callers have a true histogram entry 
in every sense, except that period_self == 0.

If we don't do this, total_period will be inflated.

> Also this feature reminds me a lot the -b option in perf report.
> Branch sorting and callchain inclusive sorting are a bit different in
> the way they handle the things but the core idea is the same. Callchains
> are branches as well.
>

Yes - I kept asking why the branch stack stuff doesn't use the existing 
callchain logic.

> Branch sorting (-b) adds a hist for every branch taken, and the period
> is always 1. I wonder if this makes more sense than using the original
> period of the event for all branches of the event. Not sure.
>
> Anyway I wonder if both features can be better integrated. After all
> they are about the same thing. The difference is that the source of
> the branches is not the same and that callchains can be depicted into
> trees.
>
> So perhaps we can have -b specifying the desired source, in case both
> are present: -b callchain and -b branch. Both at the same time wouldn't
> make much sense I think.
>
> And the source could default to either if we don't have callchain and
> branch at the same time in the events.
>
> Just an idea...

I haven't played much with the branch stack logic. Will do so and get back.

In the meanwhile, my impression is that there are two high level use cases:

* Compiler optimizers, tracing JITs etc

Which try to focus on a single branch and try to understand what 
happened with that branch

* Programmers who're trying to understand the behavior of the code they 
wrote in production

I think the branch-stack stuff primarily caters to the former and 
inclusive callchain stuff to the latter. I was thinking that getting the 
branch-stack data into callchains will make the data more useful to more 
people.

  -Arun
