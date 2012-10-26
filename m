Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab2JZENp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 00:13:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37589 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2JZENo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 00:13:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: hpa@zytor.com, len.brown@intel.com, fenghua.yu@intel.com, x86@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca, tglx@linutronix.de,
        mingo@elte.hu, vgoyal@redhat.com
References: <5085B0D0.9020508@zytor.com> <87mwze8abu.fsf@xmission.com>
	<5085E663.6040307@zytor.com>
	<20121026.122406.13396329.d.hatayama@jp.fujitsu.com>
Date: Thu, 25 Oct 2012 21:13:25 -0700
In-Reply-To: <20121026.122406.13396329.d.hatayama@jp.fujitsu.com> (HATAYAMA
	Daisuke's message of "Fri, 26 Oct 2012 12:24:06 +0900 (JST)")
Message-ID: <87r4oloopm.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19zO37pogBdHqFyuBUzv0SzFLWdzNKy/hM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> From: "H. Peter Anvin" <hpa@zytor.com>
> Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
> Date: Mon, 22 Oct 2012 17:35:47 -0700
>
>> On 10/22/2012 02:29 PM, Eric W. Biederman wrote:
>>>>
>>>> As I said, I thought Fenghua tried that but it didn't work,
>>>> experimentally.
>>>
>>> Fair enough.  You described the problem with clearing bit 8 in a weird
>>> way.
>>>
>>> If the best we can muster are fuzzy memories it may be worth
>>> revisiting.
>>> Perhaps it works on enough cpu models to be interesting.
>>>
>> 
>> It isn't fuzzy memories... this was done as late as 1-2 months ago.  I
>> just don't know the details.
>> 
>> Fenghua, could you help fill us in?
>> 
>
> I overlooked completely the fact that BSP flag is rewritable.
>
> I tried Eric's suggestion using attached test programs and saw it
> worked fine at least on the three cpus around me below:
>
> - Intel(R) Xeon(R) CPU E7- 4820  @ 2.00GHz
> - Intel(R) Xeon(R) CPU E7- 8870  @ 2.40GHz
> - Intel(R) Xeon(TM) CPU 1.80GHz
>   - 32 bits CPU
>
> Next I found the description about this in 8.4.2, IASDM Vol.3:
>
>   The MP initialization protocol imposes the following requirements
>   and restrictions on the system:
>
>   * The MP protocol is executed only after a power-up or RESET. If the
>     MP protocol has completed and a BSP is chosen, subsequent INITs
>     (either to a specific processor or system wide) do not cause the
>     MP protocol to be repeated. Instead, each logical processor
>     examines its BSP flag (in the IA32_APIC_BASE MSR) to determine
>     whether it should execute the BIOS boot-strap code (if it is the
>     BSP) or enter a wait-for-SIPI state (if it is an AP).
>
> So this is no longer undocumented behaviour for recent cpus, I think.

The underdocumented bit is the ability to clear the flag.
And of course these are processor specific registers.

> Considering these, I'll make a patch to clear BSP flag at appropreate
> position in kernel boot-up code. OTOH, according to the discussion, it
> was reported that clearing BSP flag affected some BIOSes. To deal with
> this, I'll prepare a kernel option to decide whether to clear BSP flag
> or not.
>
> Does anyone have any comments now? Or please comment after I submit a
> new patch.

I think you are on right track with preparing some patches, and this
certainly looks like worth experimenting with.

At least for i386 the code need to verify you have a cpu new enough to
have an APIC_BASE_MSR, but I don't think that is going to be hard.

Eric
