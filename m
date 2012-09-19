Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2ISS0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:26:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62262 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2ISS0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:26:35 -0400
MIME-Version: 1.0
In-Reply-To: <505A06BD.6000406@linaro.org>
References: <1347919501-64534-1-git-send-email-john.stultz@linaro.org>
 <CALCETrX5vXTZr_CNfCFDss7XG2PioxMqtpMTuYvoq7-ip2NNbA@mail.gmail.com>
 <5057BE59.3050903@linaro.org> <20120918180200.GA2281@netboy.at.omicron.at>
 <5058BD9E.30909@linaro.org> <20120919045038.GA2248@netboy.at.omicron.at>
 <5059F367.5020104@linaro.org> <20120919170347.GA2232@netboy.at.omicron.at> <505A06BD.6000406@linaro.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Sep 2012 11:26:11 -0700
Message-ID: <CALCETrUAiLXvxYMnNDvdUSFkno+v+P_XGirOYch-k8dUG05jpw@mail.gmail.com>
Subject: Re: [PATCH 0/6][RFC] Rework vsyscall to avoid truncation/rounding
 issue in timekeeping core
To: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Turner <pjt@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 10:54 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 09/19/2012 10:03 AM, Richard Cochran wrote:
>>
>> On Wed, Sep 19, 2012 at 09:31:35AM -0700, John Stultz wrote:
>>>
>>> With powerpc, there is no arch specific kernel code involved, its
>>> just a data structure the kernel exports that is accessible to
>>> userland. The execution logic lives in userland libraries, or
>>> sometimes application code itself.
>>
>> I took a brief look at arch/powerpc/kernel/vdso32/gettimeofday.S and
>> arch/powerpc/kernel/vdso64/gettimeofday.S, and I see what looks a lot
>> like functions
>
> Sorry, yes. My statement wasn't subtle enough (and I may be confusing my
> history).
>
> You are right, there is arch specific code involved, but the data structure
> that is exported is considered part of the abi since some applications
> access it directly.
>
> See the comments and structure in:
> arch/powerpc/include/asm/vdso_datapage.h
>
>
>
>> $ find arch/powerpc/kernel/vdso* -name gettimeofday.S|xargs grep
>> FUNCTION_BEGIN
>>
>>
>> arch/powerpc/kernel/vdso32/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_gettimeofday)
>>
>> arch/powerpc/kernel/vdso32/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_gettime)
>>
>> arch/powerpc/kernel/vdso32/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_getres)
>>
>> arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_gettimeofday)
>>
>> arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_gettime)
>>
>> arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__kernel_clock_getres)
>> arch/powerpc/kernel/vdso64/gettimeofday.S:V_FUNCTION_BEGIN(__do_get_tspec)
>>
>> and I wonder whether these could be done in C instead.
>
>
> Possibly, but I suspect they're in asm for performance reasons.
>
> Paul/Ben: Do you have any thoughts here?
>

Does anything except the vDSO actually use the vDSO data page?  It's
mapped as part of the vDSO image (i.e. at a non-constant address), and
it's not immediate obvious how userspace would locate that page.

FWIW, this is kind of cute and is not obviously worse than the way
that x86-64 does it, other than the possible ABI issue.
Pros:
 - vDSO code could use RIP-relative addressing instead of absolute
addressing, although I'm not sure whether there's actually a RIP +
16-bit offset encoding, so this might not be a win
 - Avoids a read-only page at a constant address
 - The mapping is per-process, so evil tricks could be used to shove,
say, pid in there.  This is almost certainly not worth it, especially
given the odd things that clone can do and that glibc already ought to
cache the pid.
Cons:
 - If ptrace or mprotect pokes that page, the clock stops for that process.
 - Lots of complexity for minimal gain.

In any case, it looks like #define VVAR(x) vdso_data->x would work on
ppc, although the vvar specification mechanism would not work.

--Andy
