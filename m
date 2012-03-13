Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab2CMBLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:11:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64287 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab2CMBLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 21:11:23 -0400
X-AuditID: 9c93016f-b7c68ae000000b77-b3-4f5e9eb83912
Message-ID: <4F5E9EB6.6050302@lge.com>
Date: Tue, 13 Mar 2012 10:11:18 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.perf.user,gmane.linux.kernel
To: Arun Sharma <asharma@fb.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <20120308072901.GC20784@elte.hu> <20120308153130.GC7976@somewhere.redhat.com> <4F58FF47.6090504@fb.com> <4F5DA294.6070700@lge.com> <4F5E3ADC.5090200@fb.com>
In-Reply-To: <4F5E3ADC.5090200@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-03-13 3:05 AM, Arun Sharma wrote:
> On 3/12/12 12:15 AM, Namhyung Kim wrote:
>> I think it's because of the shared hist_entry. If a callchain is a
>> subset of another, it will be marked as inclusive so that it cannot be
>> contributed to total period. Say, there're two chains - X (a -> b -> c)
>> and Y (a -> b), once __hists__add_entry_inclusive() was called on X, we
>> have:
>>
>> a -> b -> c
>> a -> b (inclusive)
>> a (inclusive)
>>
>> And then, calling the function on Y should make:
>>
>> a -> b
>> a (inclusive)
>>
>> However, since both callchains are in tree already they'll be shared and
>> marked *inclusive*. Thus the total period will not increased at all for
>> Y. Also I guess the reverse case - add Y first, and then X - will have
>> the same result.
>
> Thanks for figuring this out. Looks like using a single bit (he->inclusive) is
> insufficient. How about:
>
> struct hist_entry {
> 	u64 	period;
> 	u64 	period_self;
> 	..
> };
>
> Normal mode: period_self == period.
> Inclusive mode: period_self will be zero for inclusive hist_entries.
> Shared entries: we sum up both period and period_self.
>
> We can then compute total_period by summing up period_self.
>

Yeah, I agree that we need that kind of code to handle total_period properly. 
Looking forward to your v3 :).

Thanks,
Namhyung

