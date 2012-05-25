Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2EYF2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 01:28:21 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:45212 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2EYF2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 01:28:20 -0400
Message-ID: <4FBF185F.4060007@linux.vnet.ibm.com>
Date: Fri, 25 May 2012 10:57:59 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411 Thunderbird/11.0.1
MIME-Version: 1.0
To: eranian@google.com, Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: perf record: why we used type casting of (uint64_t *) instead
 of int
References: <4FBDFDA6.5010304@linux.vnet.ibm.com>
In-Reply-To: <4FBDFDA6.5010304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052419-1396-0000-0000-0000014ADABD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is breaking in powerpc systems.

(1) 'opt->value' gets updated inside the function parse_branch_stack via
    dereferencing a (uint64_t *) type casted pointer.

(2) But the value is not accessible when we again use opt->value via 
    dereferencing a (int *) type casted pointer.

(3) As a result record.opts.branch_stack remains 0 and unchanged by parse_branch_stack

This is caused by bit representation of 'uint64_t' and 'int' in powerpc systems. Bytes update
for the data (when accessed trough (uint64_t *) casting) is no longer available to the
data when accessed through (int *) type casting. Verified this from bit representation of
the data (accessed through both type casting methods).

However this problem does not seem to be present on an Intel box. Integer dereferencing of
the opt->value still gives the value which was updated as (uint64_t).

All this problem would not have been there if we had used (int *) instead of (uint64_t *) in
the first place inside parse_branch_stack function.

On Thursday 24 May 2012 02:51 PM, Anshuman Khandual wrote:

> Hey Stephane,
> 
> Just wondering why we used the type casting of (uint64_t *) on a data 
> which is defined as "int" in the structure of "perf_record_opts".
> 
> struct perf_record_opts {
>         struct perf_target target;
>         bool         call_graph;
>         bool         group;
>         bool         inherit_stat;
>         bool         no_delay;
>         bool         no_inherit;
>         bool         no_samples;
>         bool         pipe_output;
>         bool         raw_samples;
>         bool         sample_address;
>         bool         sample_time;
>         bool         sample_id_all_missing;
>         bool         exclude_guest_missing;
>         bool         period;
>         unsigned int freq;
>         unsigned int mmap_pages;
>         unsigned int user_freq;
>         int          branch_stack;
>         u64          default_interval;
>         u64          user_interval;
> };
> 
> static int
> parse_branch_stack(const struct option *opt, const char *str, int unset)
> {
> #define ONLY_PLM \
>         (PERF_SAMPLE_BRANCH_USER        |\
>          PERF_SAMPLE_BRANCH_KERNEL      |\
>          PERF_SAMPLE_BRANCH_HV)
> 
>         uint64_t *mode = (uint64_t *)opt->value;
> --
> Regards
> Anshuman Khandual
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


