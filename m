Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1AJUHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:07:41 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:45674 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1AJUHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:07:39 -0500
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAP/0Kk2rR7Ht/2dsb2JhbACkS3Oie5hJhUwEhGeGI4Mg
Message-ID: <4D2B6707.3070908@cisco.com>
Date: Mon, 10 Jan 2011 13:07:35 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, tzanussi@gmail.com,
        Paul Mackerras <paulus@samba.org>, imunsie@au1.ibm.com,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: perf: commit 55b4462 causes perf record to hang
References: <4D2B544F.1050803@cisco.com> <20110110200032.GA19703@ghostprotocols.net>
In-Reply-To: <20110110200032.GA19703@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/10/11 13:00, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 10, 2011 at 11:47:43AM -0700, David Ahern escreveu:
>> With latest version of perf-core branch, a variant of perf record hangs:
>> # /tmp/build-perf/perf record -v -e cs -fo /tmp/perf.data  -- sleep 1
>> [ perf record: Captured and wrote 0.003 MB /tmp/perf.data (~120 samples) ]
>>
>> It sits there forever. Back trace is:
>>
>> (gdb) bt
>> #0  0x0000000000447658 in __perf_session__process_events (session=0xab9500, data_offset=208, data_size=2896, file_size=3104, ops=0x685580) at util/session.c:1006
>> #1  0x00000000004107dd in process_buildids () at builtin-record.c:466
>> #2  0x000000000041084d in atexit_header () at builtin-record.c:477
>  
>> git bisect traced the hang to
>>
>> commit 55b44629f599a2305265ae9c77f9d9bcfd6ddc17
>> Author: Thomas Gleixner <tglx@linutronix.de>
>> Date:   Tue Nov 30 17:49:46 2010 +0000
> 
> Can you try with this patch, not reverting tglx's patch?
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 6fb4694..313dac2 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1007,7 +1007,7 @@ more:
>  	if (size == 0)
>  		size = 8;
>  
> -	if (head + event->header.size >= mmap_size) {
> +	if (head + event->header.size > mmap_size) {
>  		if (mmaps[map_idx]) {
>  			munmap(mmaps[map_idx], mmap_size);
>  			mmaps[map_idx] = NULL;


That does the trick -- perf-record exits fine.

David


> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
