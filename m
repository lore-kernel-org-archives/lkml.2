Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2AaPoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:44:39 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41803 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2AaPoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:44:38 -0500
Message-ID: <4F280C5C.9050104@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 21:14:28 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, dsahern@gmail.com
Subject: Re: [PATCH v4 12/18] perf: add support for sampling taken branch
 to perf record
References: <1327697778-18515-1-git-send-email-eranian@google.com> <1327697778-18515-13-git-send-email-eranian@google.com> <4F27B8CE.3010507@linux.vnet.ibm.com> <CABPqkBRrjz2wPkb8U_2eSb0hZdm_fbcqkNqvPPQSQPkYHZUeHQ@mail.gmail.com>
In-Reply-To: <CABPqkBRrjz2wPkb8U_2eSb0hZdm_fbcqkNqvPPQSQPkYHZUeHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12013115-9574-0000-0000-0000012E1C4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 January 2012 04:01 PM, Stephane Eranian wrote:
>>> +};
>>> +
>>> +static int
>>> +parse_branch_stack(const struct option *opt, const char *str, int unset __used)
>>> +{
>>> +#define ONLY_PLM \
>>> +     (PERF_SAMPLE_BRANCH_USER        |\
>>> +      PERF_SAMPLE_BRANCH_KERNEL      |\
>>> +      PERF_SAMPLE_BRANCH_KERNEL)
>>
>> I guess this would be PERF_SAMPLE_BRANCH_HV instead of the second
>> PERF_SAMPLE_BRANCH_KERNEL.
>>
> Oops, yes you're right.
> 
> There is also something else I realized after the fact that needs to
> be tweaked about
> BRANCH_HV.
> 
> The thing is the X86 code is setup to ignore priv levels it does not
> know about, it seems.
> Perf does not set exclude_hv by default. Thus in my patch, if the user
> does not specify
> any branch priv level, it will default to the level used for the
> event. That is fine but in the
> x86 code, I added a sanity check to reject BRANCH_HV because the HW
> does not support
> it. 

Right. So either we 

(1) Set 'exclude_hv' on a X86 system without hypervisor mode (and required HW support) and do the sanity check for BRANCH_HV

or 

(2) Do not set 'exclude_hv' (which is happening right now by default) and remove the sanity check
>I think it should just ignore it. That way, one can do:
> 
>     $ perf record -b any_call -e cycles ls
> 
> without getting an error (because hv is not supported on branch sampling).
> Currently, the workaround is to set the priv level on branches:
> 
>     $ perf record -b any_call,u,k -e cycles ls 
--------------------------------
./perf record -b any_call -e cycles ls
./perf record -b any_call,hv -e cycles ls

  Error: sys_perf_event_open() syscall returned with 95 (Operation not supported).  /bin/dmesg may provide additional information.

  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?

ls: Terminated
--------------------------------

However these works absolutely fine

perf record -b any_call,k -e cycles ls
perf record -b any_call,u -e cycles ls
perf record -b any_call,u,k -e cycles ls
-- 
Anshuman Khandual
Linux Technology Centre
IBM Systems and Technology Group

