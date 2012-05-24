Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231Ab2EXPcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:32:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35892 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab2EXPcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:32:18 -0400
Message-ID: <4FBE547A.5020900@gmail.com>
Date: Thu, 24 May 2012 09:32:10 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] perf, tool: Fix endianity trick for adds_features
 bitmask
References: <1337151548-2396-1-git-send-email-jolsa@redhat.com> <1337151548-2396-7-git-send-email-jolsa@redhat.com> <4FBB1839.6000606@gmail.com> <20120522084153.GC2901@m.brq.redhat.com> <4FBBB539.5010805@gmail.com> <20120523175912.GA9213@m.brq.redhat.com>
In-Reply-To: <20120523175912.GA9213@m.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/12 11:59 AM, Jiri Olsa wrote:
> On Tue, May 22, 2012 at 09:48:09AM -0600, David Ahern wrote:
>> On 5/22/12 2:41 AM, Jiri Olsa wrote:
>>
>>> hm, any special details for the record? because I'm sure I tested this way..
>>>
>>> I'll retest, thanks
>>> jirka
>>
>>
>> The attached fixes it.
>
>> commit 1353676ca6551a0165df030784ada20ebea73f73
>> Author: David Ahern<dsahern@gmail.com>
>> Date:   Tue May 22 09:40:17 2012 -0600
>>
>>      perf, tool: Fix endianity swapping for adds_features bitmask
>>
>>      Based on Jiri's latest attempt:
>>      https://lkml.org/lkml/2012/5/16/61
>>
>>      Basically, adds_features should be byte swapped assuming unsigned
>>      longs are either 8-bytes (u64) or 4-bytes (u32).
>>
>>      Fixes 32-bit ppc dumping 64-bit x86 feature data:
>>       ========
>>       captured on: Sun May 20 19:23:23 2012
>>       hostname : nxos-vdc-dev3
>>       os release : 3.4.0-rc7+
>>       perf version : 3.4.rc4.137.g978da3
>>       arch : x86_64
>>       nrcpus online : 16
>>       nrcpus avail : 16
>>       cpudesc : Intel(R) Xeon(R) CPU E5540 @ 2.53GHz
>>       cpuid : GenuineIntel,6,26,5
>>       total memory : 24680324 kB
>>      ...
>>
>>      Verified 64-bit x86 can still dump feature data for 32-bit ppc.
>>
>>      Signed-off-by: David Ahern<dsahern@gmail.com>
>
> I got the header properly displayed with this patch, but I'm getting
> following diffs in the perf report output (ppc32 vs x86_64):
> (after moving origin perf archive build-id cache to target system)
>
> -     0.00%            perf  [ext4]               [k] 0x0005b318
> +     0.00%            perf  [ext4]               [k] .cleanup_module
>
> -     0.00%             yes  [kernel.kallsyms]    [k] .sys_write
> +     0.00%             yes  [kernel.kallsyms]    [k] .SyS_write
>
>   ^^^ this one is particularly disturbing ;)
>
> I guess it's unrelated to the header stuff which your patch fixes
> properly I think, but I got small conflict rebasing this to current tip
>
> Reviewed-by: Jiri Olsa<jolsa@redhat.com>

That is odd... and if you are getting that much you are ahead of me. 
When I analyze an x86_64 file on ppc32 all symbols show as 
kernel.kallsyms dso.

The patch applies cleanly for me on latest acme/core:
$ patch -p1 < perf-swap-features.patch
patching file tools/perf/util/header.c
patching file tools/perf/util/include/linux/bitops.h
patching file tools/perf/util/session.c
patching file tools/perf/util/session.h

David
