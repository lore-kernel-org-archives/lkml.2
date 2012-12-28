Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2L1DGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 22:06:33 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42417 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2L1DGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 22:06:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: <kexec@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <tglx@linutronix.de>,
        <maxim.uvarov@oracle.com>, <andrew.cooper3@citrix.com>,
        <hpa@zytor.com>, <jbeulich@suse.com>, <mingo@redhat.com>,
        <x86@kernel.org>, <virtualization@lists.linux-foundation.org>,
        <vgoyal@redhat.com>, <linux-kernel@vger.kernel.org>
References: <2f3acfe3-c608-43d8-b76a-6ba69a872692@default>
Date: Thu, 27 Dec 2012 19:06:13 -0800
In-Reply-To: <2f3acfe3-c608-43d8-b76a-6ba69a872692@default> (Daniel Kiper's
	message of "Thu, 27 Dec 2012 16:18:56 -0800 (PST)")
Message-ID: <874nj6ooyi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/ucq/S2VajQy1XwEAoKK2rydGJt9Hy4IA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel Kiper <daniel.kiper@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 01/11] kexec: introduce kexec firmware support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kiper <daniel.kiper@oracle.com> writes:

>> Daniel Kiper <daniel.kiper@oracle.com> writes:
>>
>> > Some kexec/kdump implementations (e.g. Xen PVOPS) could not use default
>> > Linux infrastructure and require some support from firmware and/or hypervisor.
>> > To cope with that problem kexec firmware infrastructure was introduced.
>> > It allows a developer to use all kexec/kdump features of given firmware
>> > or hypervisor.
>>
>> As this stands this patch is wrong.
>>
>> You need to pass an additional flag from userspace through /sbin/kexec
>> that says load the kexec image in the firmware.  A global variable here
>> is not ok.
>>
>> As I understand it you are loading a kexec on xen panic image.  Which
>> is semantically different from a kexec on linux panic image.  It is not
>> ok to do have a silly global variable kexec_use_firmware.
>
> Earlier we agreed that /sbin/kexec should call kexec syscall with
> special flag. However, during work on Xen kexec/kdump v3 patch
> I stated that this is insufficient because e.g. crash_kexec()
> should execute different code in case of use of firmware support too.

That implies you have the wrong model of userspace.

Very simply there is:
linux kexec pass through to xen kexec.

And
linux kexec (ultimately pv kexec because the pv machine is a slightly
different architecture).

> Sadly syscall does not save this flag anywhere.

> Additionally, I stated
> that kernel itself has the best knowledge which code path should be
> used (firmware or plain Linux). If this decision will be left to userspace
> then simple kexec syscall could crash system at worst case (e.g. when
> plain Linux kexec will be used in case when firmware kaxec should be
> used).

And that path selection bit is strongly non-sense.  You are advocating
hardcoding unnecessary policy in the kernel.

If for dom0 you need crash_kexec to do something different from domU
you should be able to load a small piece of code via kexec that makes
the hypervisor calls you need.

> However, if you wish I could add this flag to syscall.

I do wish.  We need to distinguish between the kexec firmware pass
through, and normal kexec.

> Additionally, I could
> add function which enables firmware support and then kexec_use_firmware
> variable will be global only in kexec.c module.

No.  kexec_use_firmware is the wrong mental model.

Do not mix the kexec pass through and the normal kexec case.

We most definitely need to call different code in the kexec firmware
pass through case.

For normal kexec we just need to use a paravirt aware version of
machine_kexec and machine_kexec_shutdown.

>> Furthermore it is not ok to have a conditional
>> code outside of header files.
>
> I agree but how to dispatch execution e.g. in crash_kexec()
> if we would like (I suppose) compile kexec firmware
> support conditionally?

The classic pattern is to have the #ifdefs in the header and have an
noop function that is inlined when the functionality is compiled out.
This allows all of the logic to always be compiled.

Eric
