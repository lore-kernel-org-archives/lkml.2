Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab2BVQSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:18:13 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46290 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042Ab2BVQSM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:18:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eranian@google.com designates 10.112.85.233 as permitted sender) smtp.mail=eranian@google.com; dkim=pass header.i=eranian@google.com
MIME-Version: 1.0
In-Reply-To: <20120222111501.GA23068@elte.hu>
References: <1328826068-11713-1-git-send-email-eranian@google.com>
	<1328826068-11713-14-git-send-email-eranian@google.com>
	<20120222111501.GA23068@elte.hu>
Date: Wed, 22 Feb 2012 17:18:10 +0100
Message-ID: <CABPqkBQz0G6DQfAfzD2=1mCDvmVsaZhFjW0qEh4y+rNxtbLC4Q@mail.gmail.com>
Subject: Re: [PATCH v6 13/18] perf: add support for taken branch sampling to
 perf report
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roberto Agostino Vitillo <ravitillo@lbl.gov>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, acme@redhat.com, robert.richter@amd.com,
        ming.m.lin@intel.com, andi@firstfloor.org, asharma@fb.com,
        vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com, dsahern@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 12:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> From: Roberto Agostino Vitillo <ravitillo@lbl.gov>
>>
>> This patch adds support for taken branch sampling, i.e, the
>> PERF_SAMPLE_BRANCH_STACK feature to perf report. In other
>> words, to display histograms based on taken branches rather
>> than executed instructions addresses.
>>
>> The new option is called -b and it takes no argument. To
>> generate meaningful output, the perf.data must have been
>> obtained using perf record -b xxx ... where xxx is a branch
>> filter option.
>>
>> The output shows symbols, modules, sorted by 'who branches
>> where' the most often. The percentages reported in the first
>> column refer to the total number of branches captured and
>> not the usual number of samples.
>>
>> Here is a quick example.
>> Here branchy is simple test program which looks as follows:
>>
>> void f2(void)
>> {}
>> void f3(void)
>> {}
>> void f1(unsigned long n)
>> {
>>   if (n & 1UL)
>>     f2();
>>   else
>>     f3();
>> }
>> int main(void)
>> {
>>   unsigned long i;
>>
>>   for (i=0; i < N; i++)
>>    f1(i);
>>   return 0;
>> }
>>
>> Here is the output captured on Nehalem, if we are
>> only interested in user level function calls.
>>
>> $ perf record -b any_call,u -e cycles:u branchy
>>
>> $ perf report -b --sort=symbol
>>     52.34%  [.] main                   [.] f1
>>     24.04%  [.] f1                     [.] f3
>>     23.60%  [.] f1                     [.] f2
>>      0.01%  [k] _IO_new_file_xsputn    [k] _IO_file_overflow
>>      0.01%  [k] _IO_vfprintf_internal  [k] _IO_new_file_xsputn
>>      0.01%  [k] _IO_vfprintf_internal  [k] strchrnul
>>      0.01%  [k] __printf               [k] _IO_vfprintf_internal
>>      0.01%  [k] main                   [k] __printf
>
> Ok, nice feature.
>
> One detail needs to be fixed though, if someone does:
>
>  perf record -b ...
>
> then 'perf report' should *default* to the above branch stack
> output style, without having to specify -b again.
>
Fair enough.

I'll check how we could do that. It's not so obvious as the code
stands. I think we may need to add a new feature bit for that.
It would avoid having to sniff either the cmdline, the event desc
or worst the samples themselves.

> Having --branch/--no-branch present in perf report is fine if
> someone wants to force either direction, but the default
> absolutely must be picked up from the perf.data and should be
> the obvious behavior.
>
> Other than that it looks good to me, so if this detail is fixed
> (can be a delta patch on top of the existing series) and there's
> no problems with it I can pick it up for v3.4.
>
It'll be a delta patch.
