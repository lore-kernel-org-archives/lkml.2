Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2DCKms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 06:42:48 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54875 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab2DCKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 06:42:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@kernel.org>
Cc: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20120402213440.49e9de74@neptune>
	<1333401898.2960.78.camel@laptop> <1333403193.2960.80.camel@laptop>
	<20120403060252.GA27084@gmail.com>
	<20120403081735.78ca3bb3@pluto.restena.lu>
	<m1d37pgugy.fsf@fess.ebiederm.org> <20120403071543.GA17502@gmail.com>
	<m1r4w5dzjq.fsf@fess.ebiederm.org> <20120403080410.GF26826@gmail.com>
	<m1sjgl9ozd.fsf@fess.ebiederm.org> <20120403101623.GA16889@gmail.com>
Date: Tue, 03 Apr 2012 03:46:28 -0700
In-Reply-To: <20120403101623.GA16889@gmail.com> (Ingo Molnar's message of
	"Tue, 3 Apr 2012 12:16:23 +0200")
Message-ID: <m18vid6qkb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19dSHjETmS9j7Zqrg35UNVUGJcaLoCUZdU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0009]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@kernel.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Ingo Molnar <mingo@kernel.org> writes:
>> 
>> > * Eric W. Biederman <ebiederm@xmission.com> wrote:
>> >
>> >> > Huh, so put repeated, duplicated, inconsistently applied sanity 
>> >> > checks into dozens of sysfs attribute using kernel subsystems?
>> >>
>> >> [...]
>> >>
>> >> No.  I was not talking about every usage site.
>> >
>> > Note, I'm not arguing that this isn't a bug in the P4 PMU driver 
>> > - it is clearly a bug and I've applied the fix for it. I'm 
>> > arguing about the escallation vector that this bug takes - that 
>> > is unnecessarily disruptive:
>> >
>> > You were talking about:
>> >
>> >> >> FIX perf to include sanity checks.
>> >
>> > and what the PMU drivers do here is not uncommon at all, and the 
>> > bug (for which I applied the fix and will push to Linus ASAP) is 
>> > not uncommon either:
>> 
>> > Bugs happen and indirections happen too. perf uses a generic 
>> > PMU driver layer where the lower level layers register 
>> > themselves. There's at least a dozen similar constructs in 
>> > the kernel and you suggest that the right solution is to put 
>> > checks in every one of them, while the nice patch from Bruno 
>> > could catch it too, in one central place?
>> 
>> What is uncommon is that perf_pmu_register is called from an 
>> early initcall, and then later a device_init call is used to 
>> register the pmu subsystem with sysfs.
>
> This has no relevance to the bug and crash pattern itself 
> whatsoever, so stop blathering about unrelated things.

Crashing or BUG_ON or WARN_ON has no relevance to how hard it is to
debug this.  They only have relevance on how hard it is to get
the information from a machine that experience this problem.

The call to perf_pmu_register was not in the stack backtrace,
because the call to perf_pmu_register happened long ago and
we put off registering with sysfs until later.

By the time we got to sysfs there was no information available
that would let us know which client of the perf events subsystem
it possibly could be.  Not enough information when we register
with sysfs to blame it on something makes it hard to debug.

> Not filling out a sysfs object attribute is an *easy* driver 
> level mistake, I've seen it happen on numerous occasions. Not 
> crashing on it in the sysfs layer is an *obvious* debugging 
> helper, and I don't understand why you are even arguing about 
> this.

I agree that not filling out some field of something that is
expected is an easy driver bug to make.  As such I would actually
like something to go on the next time someone makes that mistake.

Because the perf pmu subsystem is atypical and has asynchronous
registration with respect to sysfs.  These kinds of problems
are harder to find then they need to be.

The only tools to track this down that were realistically available
were git bisect and asking on the list of developers if this bug
looked familiar.  There was really not enough information at the point
of the crash to find which attribute was not properly initialized
without being intimately familiar with the perf pmu subsystem.

Having to resort to a git bisect when a few checks extra checks
could have caught the culprit red handed and we could have had
a the function name where the that started the registration
of the sysfs attribute to start debugging with.

Eric
