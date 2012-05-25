Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab2EYIU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 04:20:56 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63056 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753899Ab2EYIUw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 04:20:52 -0400
MIME-Version: 1.0
In-Reply-To: <4FBF185F.4060007@linux.vnet.ibm.com>
References: <4FBDFDA6.5010304@linux.vnet.ibm.com>
	<4FBF185F.4060007@linux.vnet.ibm.com>
Date: Fri, 25 May 2012 10:20:49 +0200
Message-ID: <CABPqkBQUDkW0qnf30Fv-dTgRCHr5D4tT43xuhHso88FC4M5Qiw@mail.gmail.com>
Subject: Re: perf record: why we used type casting of (uint64_t *) instead of int
From: Stephane Eranian <eranian@google.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 7:27 AM, Anshuman Khandual
<khandual@linux.vnet.ibm.com> wrote:
> This code is breaking in powerpc systems.
>
> (1) 'opt->value' gets updated inside the function parse_branch_stack via
>    dereferencing a (uint64_t *) type casted pointer.
>
> (2) But the value is not accessible when we again use opt->value via
>    dereferencing a (int *) type casted pointer.
>
> (3) As a result record.opts.branch_stack remains 0 and unchanged by parse_branch_stack
>
> This is caused by bit representation of 'uint64_t' and 'int' in powerpc systems. Bytes update
> for the data (when accessed trough (uint64_t *) casting) is no longer available to the
> data when accessed through (int *) type casting. Verified this from bit representation of
> the data (accessed through both type casting methods).
>
> However this problem does not seem to be present on an Intel box. Integer dereferencing of
> the opt->value still gives the value which was updated as (uint64_t).
>
> All this problem would not have been there if we had used (int *) instead of (uint64_t *) in
> the first place inside parse_branch_stack function.
>
The bug is that in struct record_opts, branch_stack is declared int
instead of u64.
I can post a patch to fix that. The value is eventually passed to struct
perf_event_attr.branch_sample_type  which is defined as u64.

I can post a patch to fix that.

Thanks for catching this.

> On Thursday 24 May 2012 02:51 PM, Anshuman Khandual wrote:
>
>> Hey Stephane,
>>
>> Just wondering why we used the type casting of (uint64_t *) on a data
>> which is defined as "int" in the structure of "perf_record_opts".
>>
>> struct perf_record_opts {
>>         struct perf_target target;
>>         bool         call_graph;
>>         bool         group;
>>         bool         inherit_stat;
>>         bool         no_delay;
>>         bool         no_inherit;
>>         bool         no_samples;
>>         bool         pipe_output;
>>         bool         raw_samples;
>>         bool         sample_address;
>>         bool         sample_time;
>>         bool         sample_id_all_missing;
>>         bool         exclude_guest_missing;
>>         bool         period;
>>         unsigned int freq;
>>         unsigned int mmap_pages;
>>         unsigned int user_freq;
>>         int          branch_stack;
>>         u64          default_interval;
>>         u64          user_interval;
>> };
>>
>> static int
>> parse_branch_stack(const struct option *opt, const char *str, int unset)
>> {
>> #define ONLY_PLM \
>>         (PERF_SAMPLE_BRANCH_USER        |\
>>          PERF_SAMPLE_BRANCH_KERNEL      |\
>>          PERF_SAMPLE_BRANCH_HV)
>>
>>         uint64_t *mode = (uint64_t *)opt->value;
>> --
>> Regards
>> Anshuman Khandual
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
