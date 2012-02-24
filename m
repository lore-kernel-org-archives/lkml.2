Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab2BXPkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:40:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64758 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2BXPkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:40:41 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.112.100.169 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
MIME-Version: 1.0
In-Reply-To: <4F47AD6A.6080609@gmail.com>
References: <20120224094048.GA7952@quad>
	<4F47ABAD.9080408@gmail.com>
	<CABPqkBT1R_SJiQkjujS4dN5yQZPakjOmmCLNR3DmNxTmVT_p9A@mail.gmail.com>
	<4F47AD6A.6080609@gmail.com>
Date: Fri, 24 Feb 2012 16:40:39 +0100
Message-ID: <CABPqkBQyBtxO3ytcZKHyGNAiwYzmqODy+C-EY5gQTENKtngBFw@mail.gmail.com>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        asharma@fb.com, robert.richter@amd.com, ming.m.lin@intel.com,
        vweaver1@eecs.utk.edu, andi@firstfloor.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 4:31 PM, David Ahern <dsahern@gmail.com> wrote:
> On 2/24/12 8:28 AM, Stephane Eranian wrote:
>>
>> On Fri, Feb 24, 2012 at 4:24 PM, David Ahern<dsahern@gmail.com>  wrote:
>>>
>>> On 2/24/12 2:40 AM, Stephane Eranian wrote:
>>>>
>>>>
>>>>
>>>> This patch adds auto-detection of samples with taken branch stacks.
>>>> The auto-detection avoids having to specify the -b or --branch-stack
>>>> option on the cmdline.
>>>>
>>>> The patch adds a new feature bit HEADER_BRANCH_STACK to mark the
>>>> presence of branch stacks in samples.
>>>>
>>>> You can now do:
>>>> $ perf record -b any noploop 2
>>>> $ perf report
>>>> # Events: 8K cycles
>>>> #
>>>> # Overhead  Command  Source Shared Object        Source Symbol  Target
>>>> Shared Object       Target Symbol
>>>> # ........  .......  ....................  ...................
>>>>  ....................  ..................
>>>> #
>>>>     91.56%  noploop  noploop               [.] noploop
>>>>   noploop  [.] noploop
>>>>      0.42%  noploop  [kernel.kallsyms]     [k] __lock_acquire
>>>>  [kernel.kallsyms]  [k] __lock_acquire
>>>>
>>>>
>>>> To force regular reporting based on the instruction address:
>>>> $ perf report --no-branch-stack
>>>> #
>>>> # Events: 2K cycles
>>>> #
>>>> # Overhead  Command      Shared Object                           Symbol
>>>> # ........  .......  .................  ...............................
>>>> #
>>>>     92.03%  noploop  noploop            [.] noploop
>>>>      1.00%  noploop  [kernel.kallsyms]  [k] lock_acquire
>>>>
>>>>
>>>> Signed-off-by: Stephane Eranian<eranian@google.com>
>>>> ---
>>>>
>>>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>>>> index 1c49d4e..5e833a2 100644
>>>> --- a/tools/perf/builtin-record.c
>>>> +++ b/tools/perf/builtin-record.c
>>>> @@ -473,6 +473,9 @@ static int __cmd_record(struct perf_record *rec, int
>>>> argc, const char **argv)
>>>>        if (!have_tracepoints(&evsel_list->entries))
>>>>                perf_header__clear_feat(&session->header,
>>>> HEADER_TRACE_INFO);
>>>>
>>>> +       if (!rec->opts.branch_stack)
>>>> +               perf_header__clear_feat(&session->header,
>>>> HEADER_BRANCH_STACK);
>>>
>>>
>>>
>>> branch tracing is user requested on, so shouldn't feature default off and
>>> only be enabled when requested?
>>>
>> Well, what Ingo was suggesting is that perf report auto-detects whether or
>> not branch mode is necessary by looking at the perf.data file. Most likely
>> if you've recorded with -b, you are interested in a branch mode view
>> rather
>> that the instruction view (default). So all this does is elimintate the
>> need
>> to pass -b to perf report to enable branch mode.
>
>
> Right. My point is that HEADER_BRANCH_STACK feature should be off by default
> and only enabled by builtin-record when branch stack is requested. You have
> the reverse -- enabled by default and off in record if not requested.
>
No, I don't. Read the code carefully. The for loop sets all known feature bits.
Then, the ones not necessary or unused are turned off individually.

> David
>
