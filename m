Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2AaPsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:48:08 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45063 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804Ab2AaPsE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:48:04 -0500
MIME-Version: 1.0
In-Reply-To: <4F280C5C.9050104@linux.vnet.ibm.com>
References: <1327697778-18515-1-git-send-email-eranian@google.com>
	<1327697778-18515-13-git-send-email-eranian@google.com>
	<4F27B8CE.3010507@linux.vnet.ibm.com>
	<CABPqkBRrjz2wPkb8U_2eSb0hZdm_fbcqkNqvPPQSQPkYHZUeHQ@mail.gmail.com>
	<4F280C5C.9050104@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 16:48:02 +0100
Message-ID: <CABPqkBSa60pA3qQ=zT=NNP_VmW2DeFCzg-1fdHdr7tPZ-djBzA@mail.gmail.com>
Subject: Re: [PATCH v4 12/18] perf: add support for sampling taken branch to
 perf record
From: Stephane Eranian <eranian@google.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com, ravitillo@lbl.gov,
        vweaver1@eecs.utk.edu, dsahern@gmail.com
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 4:44 PM, Anshuman Khandual
<khandual@linux.vnet.ibm.com> wrote:
> On Tuesday 31 January 2012 04:01 PM, Stephane Eranian wrote:
>>>> +};
>>>> +
>>>> +static int
>>>> +parse_branch_stack(const struct option *opt, const char *str, int unset __used)
>>>> +{
>>>> +#define ONLY_PLM \
>>>> +     (PERF_SAMPLE_BRANCH_USER        |\
>>>> +      PERF_SAMPLE_BRANCH_KERNEL      |\
>>>> +      PERF_SAMPLE_BRANCH_KERNEL)
>>>
>>> I guess this would be PERF_SAMPLE_BRANCH_HV instead of the second
>>> PERF_SAMPLE_BRANCH_KERNEL.
>>>
>> Oops, yes you're right.
>>
>> There is also something else I realized after the fact that needs to
>> be tweaked about
>> BRANCH_HV.
>>
>> The thing is the X86 code is setup to ignore priv levels it does not
>> know about, it seems.
>> Perf does not set exclude_hv by default. Thus in my patch, if the user
>> does not specify
>> any branch priv level, it will default to the level used for the
>> event. That is fine but in the
>> x86 code, I added a sanity check to reject BRANCH_HV because the HW
>> does not support
>> it.
>
> Right. So either we
>
> (1) Set 'exclude_hv' on a X86 system without hypervisor mode (and required HW support) and do the sanity check for BRANCH_HV
>
> or
>
> (2) Do not set 'exclude_hv' (which is happening right now by default) and remove the sanity check
>>I think it should just ignore it. That way, one can do:
>>
>>     $ perf record -b any_call -e cycles ls
>>
>> without getting an error (because hv is not supported on branch sampling).
>> Currently, the workaround is to set the priv level on branches:
>>
>>     $ perf record -b any_call,u,k -e cycles ls
> --------------------------------
> ./perf record -b any_call -e cycles ls
> ./perf record -b any_call,hv -e cycles ls
>
>  Error: sys_perf_event_open() syscall returned with 95 (Operation not supported).  /bin/dmesg may provide additional information.
>
>  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
>
> ls: Terminated
> --------------------------------
>
> However these works absolutely fine
>
> perf record -b any_call,k -e cycles ls
> perf record -b any_call,u -e cycles ls
> perf record -b any_call,u,k -e cycles ls

Yes, because you only get the problem with the kernel has to figure out the
default priv level for the branches.

I want to make this simplest case work:
     /perf record -b any_call -e cycles ls

For now, I have reworked the patchset, to ignore hv in the x86 lbr code.
That's the simplest.

> --
> Anshuman Khandual
> Linux Technology Centre
> IBM Systems and Technology Group
>
