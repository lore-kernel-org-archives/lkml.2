Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2KZSSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:18:38 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53490 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab2KZSSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 13:18:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gleb Natapov <gleb@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
References: <50ADE0C2.1000106@cn.fujitsu.com> <50ADE11A.401@cn.fujitsu.com>
	<87ip8sxuyh.fsf@xmission.com> <20121126172054.GF12969@redhat.com>
	<87fw3wuuoh.fsf@xmission.com> <20121126175327.GG12969@redhat.com>
Date: Mon, 26 Nov 2012 12:18:27 -0600
In-Reply-To: <20121126175327.GG12969@redhat.com> (Gleb Natapov's message of
	"Mon, 26 Nov 2012 19:53:27 +0200")
Message-ID: <87mwy4teh8.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19qyUBn1HwjY8uvGhSBtTzHCBv3zA3/WFA=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gleb Natapov <gleb@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v8 1/2] x86/kexec: add a new atomic notifier list for kdump
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> writes:

> On Mon, Nov 26, 2012 at 11:43:10AM -0600, Eric W. Biederman wrote:
>> Gleb Natapov <gleb@redhat.com> writes:
>> 
>> > On Mon, Nov 26, 2012 at 09:08:54AM -0600, Eric W. Biederman wrote:
>> >> Zhang Yanfei <zhangyanfei@cn.fujitsu.com> writes:
>> >> 
>> >> > This patch adds an atomic notifier list named crash_notifier_list.
>> >> > Currently, when loading kvm-intel module, a notifier will be registered
>> >> > in the list to enable vmcss loaded on all cpus to be VMCLEAR'd if
>> >> > needed.
>> >> 
>> >> crash_notifier_list ick gag please no.  Effectively this makes the kexec
>> >> on panic code path undebuggable.
>> >> 
>> >> Instead we need to use direct function calls to whatever you are doing.
>> >> 
>> > The code walks linked list in kvm-intel module and calls vmclear on
>> > whatever it finds there. Since the function have to resides in kvm-intel
>> > module it cannot be called directly. Is callback pointer that is set
>> > by kvm-intel more acceptable?
>> 
>> Yes a specific callback function is more acceptable.  Looking a little
>> deeper vmclear_local_loaded_vmcss is not particularly acceptable. It is
>> doing a lot of work that is unnecessary to save the virtual registers
>> on the kexec on panic path.
>> 
> What work are you referring to in particular that may not be
> acceptable?

The unnecessary work that I was see is all of the software state
changing.  Unlinking things from linked lists flipping variables.
None of that appears related to the fundamental issue saving cpu
state.

Simply reusing a function that does more than what is strictly required
makes me nervous.  What is the chance that the function will grow
with maintenance and add constructs that are not safe in a kexec on
panic situtation.

>> In fact I wonder if it might not just be easier to call vmcs_clear to a
>> fixed per cpu buffer.
>> 
> There may be more than one vmcs loaded on a cpu, hence the list.
>
>> Performing list walking in interrupt context without locking in
>> vmclear_local_loaded vmcss looks a bit scary.  Not that locking would
>> make it any better, as locking would simply add one more way to deadlock
>> the system.  Only an rcu list walk is at all safe.  A list walk that
>> modifies the list as vmclear_local_loaded_vmcss does is definitely not safe.
>> 
> The list vmclear_local_loaded walks is per cpu. Zhang's kvm patch
> disables kexec callback while list is modified.

If the list is only modified on it's cpu and we are running on that cpu
that does look like it will give the necessary protections.  It isn't
particularly clear at first glance that is the case unfortunately.

Eric
