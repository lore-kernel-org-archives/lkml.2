Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2DCIs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:48:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53261 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2DCIsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:48:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@kernel.org>
Cc: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20120402165036.2bc987ad@pluto.restena.lu>
	<m17gxyklfm.fsf@fess.ebiederm.org> <20120402213440.49e9de74@neptune>
	<1333401898.2960.78.camel@laptop> <1333403193.2960.80.camel@laptop>
	<20120403060252.GA27084@gmail.com>
	<20120403081735.78ca3bb3@pluto.restena.lu>
	<m1d37pgugy.fsf@fess.ebiederm.org> <20120403071543.GA17502@gmail.com>
	<m1r4w5dzjq.fsf@fess.ebiederm.org> <20120403080410.GF26826@gmail.com>
Date: Tue, 03 Apr 2012 01:52:22 -0700
In-Reply-To: <20120403080410.GF26826@gmail.com> (Ingo Molnar's message of
	"Tue, 3 Apr 2012 10:04:11 +0200")
Message-ID: <m1sjgl9ozd.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX180fs4CiubX1+Rf/F4jLPjX6YoXzPdM62o=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@kernel.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> > Huh, so put repeated, duplicated, inconsistently applied sanity 
>> > checks into dozens of sysfs attribute using kernel subsystems?
>>
>> [...]
>>
>> No.  I was not talking about every usage site.
>
> Note, I'm not arguing that this isn't a bug in the P4 PMU driver 
> - it is clearly a bug and I've applied the fix for it. I'm 
> arguing about the escallation vector that this bug takes - that 
> is unnecessarily disruptive:
>
> You were talking about:
>
>> >> FIX perf to include sanity checks.
>
> and what the PMU drivers do here is not uncommon at all, and the 
> bug (for which I applied the fix and will push to Linus ASAP) is 
> not uncommon either:

> Bugs happen and indirections happen too. perf uses a generic PMU 
> driver layer where the lower level layers register themselves. 
> There's at least a dozen similar constructs in the kernel and 
> you suggest that the right solution is to put checks in every 
> one of them, while the nice patch from Bruno could catch it too, 
> in one central place?

What is uncommon is that perf_pmu_register is called from
an early initcall, and then later a device_init call
is used to register the pmu subsystem with sysfs.

That extra delay step is weird.  That registering extra early
is weird.

How we get from x86_pmu to the variable simply named pmu
that is registered I am still in the dark about.  There is a lot
of weird magic going on in that registration path before
these things get to sysfs.

And those extra steps are what make Bruno's patch largely
useless for this case.  

> If the PMU code used those attributes directly and could 
> crash/misbehave then you'd have a point. But the first thing 
> that makes real use of these objects is sysfs - so it's 
> trivially useful to at minimum have a sanity check there...

If the pmu subsystem is doing odd and peculiar things it should strive
to not impose debugging burden on others.

>> [...]  I was talking about the sites that are don't have a 
>> direct call chain to the sysfs methods and instead do 
>> something clever that makes backtraces worthless.
>> 
>> In the normal case sysfs registration problems are simple to 
>> trace back to their source because the backtrace points a 
>> finger at the piece of code that when registering had a 
>> problem.
>
> You mean the crash backtrace?

I mean a backtrace when people try and abuse sysfs by accident.
Typically they are backtraces from WARN_ON that I look at.  It is common
enough and I look a reasonable number of them.  Usually they point back
to the subsystem and the borked piece of code.  In this case the
backtrace barely hit the broad side of the barn.

It really irritates me that a stack backtrace is useless for figuring
out that this was something in under arch/x86 let alone for figuring
out that this was p4 related.

So since the perf pmu event subsystem is extremely atypical I am asking
that it be looked at to see if it's structure or sanity checks can
be improved so it is more debuggable when people make stupid mistakes.

Eric
