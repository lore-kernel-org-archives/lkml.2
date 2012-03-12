Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2CLSFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:05:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35523 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754720Ab2CLSFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:05:40 -0400
Message-ID: <4F5E3ADC.5090200@fb.com>
Date: Mon, 12 Mar 2012 11:05:16 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <20120308072901.GC20784@elte.hu> <20120308153130.GC7976@somewhere.redhat.com> <4F58FF47.6090504@fb.com> <4F5DA294.6070700@lge.com>
In-Reply-To: <4F5DA294.6070700@lge.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-12_05:2012-03-12,2012-03-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/12 12:15 AM, Namhyung Kim wrote:

>
> I think it's because of the shared hist_entry. If a callchain is a
> subset of another, it will be marked as inclusive so that it cannot be
> contributed to total period. Say, there're two chains - X (a -> b -> c)
> and Y (a -> b), once __hists__add_entry_inclusive() was called on X, we
> have:
>
> a -> b -> c
> a -> b (inclusive)
> a (inclusive)
>
> And then, calling the function on Y should make:
>
> a -> b
> a (inclusive)
>
> However, since both callchains are in tree already they'll be shared and
> marked *inclusive*. Thus the total period will not increased at all for
> Y. Also I guess the reverse case - add Y first, and then X - will have
> the same result.

Thanks for figuring this out. Looks like using a single bit 
(he->inclusive) is insufficient. How about:

struct hist_entry {
	u64                     period;
         u64                     period_self;
	..
};

Normal mode: period_self == period.
Inclusive mode: period_self will be zero for inclusive hist_entries.
Shared entries: we sum up both period and period_self.

We can then compute total_period by summing up period_self.

  -Arun

