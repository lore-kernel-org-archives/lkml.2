Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2KWUZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:25:15 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38231 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab2KWUZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:25:12 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: andrew.cooper3@citrix.com, hpa@zytor.com, jbeulich@suse.com,
        konrad.wilk@oracle.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
	<1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
	<87lidwtego.fsf@xmission.com>
	<20121121105221.GA2925@host-192-168-1-59.local.net-space.pl>
	<87txshx28b.fsf@xmission.com>
	<20121123094516.GA2921@host-192-168-1-59.local.net-space.pl>
Date: Fri, 23 Nov 2012 12:24:51 -0800
In-Reply-To: <20121123094516.GA2921@host-192-168-1-59.local.net-space.pl>
	(Daniel Kiper's message of "Fri, 23 Nov 2012 10:47:38 +0100")
Message-ID: <877gpct6cs.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18YNNde0h/UaM0/CnIlTzmZ2dbqhCW57a8=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel Kiper <daniel.kiper@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 01/11] kexec: introduce kexec_ops struct
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kiper <daniel.kiper@oracle.com> writes:

> On Thu, Nov 22, 2012 at 04:15:48AM -0800, ebiederm@xmission.com wrote:
>>
>> Is this for when the hypervisor crashes and we want a crash dump of
>> that?
>
> dom0 at boot gets some info about kexec/kdump configuration from Xen hypervisor
> (e.g. placement of crash kernel area). Later if you call kexec syscall most
> things are done in the same way as on baremetal. However, after placing image
> in memory, HYPERVISOR_kexec_op() hypercall must be called to inform hypervisor
> that image is loaded (new hook machine_kexec_load is used for this;
> machine_kexec_unload is used for unload). Then Xen establishes fixmap for pages
> found in page_list[] and returns control to dom0. If dom0 crashes or "kexec execute"
> is used by user then dom0 calls HYPERVISOR_kexec_op() to instruct hypervisor that
> kexec/kdump image should be executed immediately. Xen calls relocate_kernel()
> and all things runs as usual.


Close

>> Successful code reuse depends upon not breaking the assumptions on which
>> the code relies, or modifying the code so that the new modified
>> assumptions are clear.  In this case you might as well define up as down
>> for all of the sense kexec_ops makes.
>
> Hmmm... Well, problem with above mentioned functions is that they work
> on physical addresses. In Xen PVOPS (currently dom0 is PVOPS) they
> are useless in kexec/kdump case. It means that physical addresses
> must be converted to/from machine addresses which has a real meaning
> in Xen PVOPS case. That is why those funtions were introduced.

Agreed operating on addresses that are relevant to the operation at hand
makes sense.

>> >> There may be a point to all of these but you are mixing and matching
>> >> things badly.
>> >
>> > Do you whish to split this kexec_ops struct to something which
>> > works with addresses and something which is reponsible for
>> > loading, unloading and executing kexec/kdump? I am able to change
>> > that but I would like to know a bit about your vision first.
>>
>> My vision is that we should have code that makes sense.
>>
>> My suspicion is that what you want is a cousin of the existing kexec
>> system call.  Perhaps what is needed is a flag to say use the firmware
>> kexec system call.
>>
>> I absolutely do not understand what Xen is trying to do.  kexec by
>> design should not require any firmware specific hooks.  kexec at this
>> level should only need to care about the processor architeture.  Clearly
>> what you are doing with Xen requires special hooks separate even from
>> the normal paravirt hooks.  So I do not understand you are trying to do.
>>
>> It needs to be clear from the code what is happening differently in the
>> Xen case.  Otherwise the code is unmaintainable as no one will be able
>> to understand it.
>
> I agree. I could remove all machine_* hooks from kexec_ops and call Xen
> specific functions from arch files. However, I need to add two new
> machine calls, machine_kexec_load and machine_kexec_unload, in the same
> manner as existing machine_* calls. In general they could be used to inform
> firmware (in this case Xen) that kexec/kdump image is loaded.
>
> kimage_alloc_pages, kimage_free_pages, page_to_pfn, pfn_to_page, virt_to_phys
> and phys_to_virt are worse. If we could not find good solution how to replace
> them then we end up with calling Xen specific version of kexec/kdump which
> would contain nearly full copy of exisiting kexec/kdump code. Not good.
>
> We could add some code to kernel/kexec.c which depends on CONFIG_XEN.
> It could contain above mentioned functions which later will be called
> by existing kexec code. This is not nice to be honest. However, I hope
> that we could find better solution for that problem.

Since in the Xen case you are not performing a normal kexec or kdump if
you are going to continue to use the kexec system call then another flag
(like the KEXEC_ON_CRASH flag) should be used.

The userspace flag should be something like KEXEC_HYPERVISOR.  From
there we can have a generic interface that feeds into whatever the Xen
infrastructure is.  And if any other hypervisors implement kexec like
functionality it could feed into them if we so choose.

When the choice is clearly between a linux-only kexec and for a hypervisor
level kexec using different functions to understand the target addresses
makes sense.

And of course /sbin/kexec can easity take an additional flag to say load
the kexec image to the hypervisor.

Eric
