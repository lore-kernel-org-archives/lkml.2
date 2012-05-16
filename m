Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab2EPHlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:41:50 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42042 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab2EPHls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:41:48 -0400
MIME-Version: 1.0
In-Reply-To: <4FB32032.3000509@gmail.com>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
	<1337081295-10303-5-git-send-email-eranian@google.com>
	<4FB32032.3000509@gmail.com>
Date: Wed, 16 May 2012 09:41:47 +0200
Message-ID: <CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 5:34 AM, David Ahern <dsahern@gmail.com> wrote:
> On 5/15/12 5:28 AM, Stephane Eranian wrote:
>>
>> This patch adds the meta-data header support for perf record
>> when used in pipe mode: perf record -o -
>>
>> Up until now, meta-data was only available when perf record
>> was used in "regular" mode, i.e., generating a perf.data file.
>> For users depending on pipe mode, no host, event header information
>> was gathered. This patch addresses this limitation.
>>
>> The difficulty in pipe mode is that information needs to be written
>> sequentially to the pipe. Meta data headers are usually generated
>> (and also expected) at the beginning of the file (or piped output).
>> To solve this problem, we introduce new synthetic record types,
>> one for each meta-data type. The approach is similar to what
>> is already used for BUILD_ID and TRACING_DATA.
>>
>> We have modified util/header.c such that the same routines are used
>> to generate and read the meta-data information regardless of pipe-mode
>> vs. regular mode. To make this work, we added a new struct called
>> feat_fd which encapsulates all the information necessary to read or
>> write meta-data information to a file/pipe or from a file/pipe.
>>
>> It should be noted that there is a limitation with the current
>> perf in terms of endianess in pipe mode. Perf assumes the records
>> are generated using the same endianess during collection and
>> analysis.  That is always the case with the example shown below.
>> However, one could also do:
>> $ perf record -o - noploop 2 | perf inject -b>perf.data
>> $ cat perf.data | perf report -i -
>>
>> With this patch, it is possible to get:
>>  $ perf record -o - noploop 2 | perf inject -b | perf report -i -
>>       # ========
>>       # captured on: Fri Jan 20 18:13:55 2012
>>       # ========
>>       #
>>       # hostname : quad
>>       # os release : 3.2.0-rc7-tip
>>       # perf version : 3.2.0
>>       # arch : x86_64
>>       # nrcpus online : 4
>>       # nrcpus avail : 4
>>       # cpudesc : Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz
>>       # cpuid : GenuineIntel,6,15,11
>>       # total memory : 8092884 kB
>>       ...
>>       # HEADER_CPU_TOPOLOGY info available, use -I to display
>>       noploop for 2 seconds
>>       [ perf record: Woken up 1 times to write data ]
>>       [ perf record: Captured and wrote 0.084 MB - (~3677 samples) ]
>>         99.80%  noploop  noploop            [.] noploop
>>          0.19%  noploop  [kernel.kallsyms]  [k] radix_tree_gang_lookup
>>
>> Signed-off-by: Stephane Eranian<eranian@google.com>
>
>
> I love the feature and it works nicely, but there has been push back on
> adding more synthesized events.  Also the size of the patch is a bit much to
> take in. If there is no objection to the synthesized can you break the patch
> up -- e.g., introduce the events in one, synthesis and processing functions
> in another, plug into the commands, ...
>
Without new synthesized events, you cannot make this work. This is by
construction
of the pipe mode. Meta-data has be be injected in the stream and
therefore it needs
PERF_RECORD_* types.

> David
