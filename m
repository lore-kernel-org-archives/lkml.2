Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab2BUFji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 00:39:38 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:34671 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2BUFjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 00:39:37 -0500
X-AuditID: b753bd60-9785eba00000359c-95-4f432e16d613
X-AuditID: b753bd60-9785eba00000359c-95-4f432e16d613
Message-ID: <4F432E0B.5090608@hitachi.com>
Date: Tue, 21 Feb 2012 14:39:23 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v5 2/5] perf: set correct value to perf_event_header.misc
 for BTS
References: <20120130044242.2384.23076.stgit@linux3>  <20120130044303.2384.63515.stgit@linux3> <1327916138.2446.187.camel@twins>
In-Reply-To: <1327916138.2446.187.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/30 18:35), Peter Zijlstra wrote:
> On Mon, 2012-01-30 at 13:43 +0900, Akihiro Nagai wrote:
>> @@ -330,6 +342,14 @@ int intel_pmu_drain_bts_buffer(void)
>>                  return 1;
>>
>>          for (; at<  top; at++) {
>> +               /*
>> +                * To resolve user space symbols and DSOs correctly, set
>> +                * PERF_RECORD_MISC_USER if from_addr or to_addr is user space.
>> +                */
>> +               if (!kernel_ip(data.ip) || !kernel_ip(data.addr)) {
>> +                       header.misc&= ~PERF_RECORD_MISC_CPUMODE_MASK;
>> +                       header.misc |= PERF_RECORD_MISC_USER;
>> +               }
>>                  data.ip         = at->from;
>>                  data.addr       = at->to;
>
> Why not key off of the from? If its a jump from userspace its a user
> event, its a jump from kernel space its a kernel event?

Of course, originally, perf does that. And, in those cases,
BTS records the both addresses of kernel and user in one
perf_sample on branches from kernel to user. Current perf
sets PERF_RECORD_MISC_KERNEL to all BTS events, and
perf-script doesn't resolve symbols and DSOs about the
user-space address, because it is a kernel event. So, to
solve both kernel and user symbols on an event, I had to
add this change.

Thank you,
