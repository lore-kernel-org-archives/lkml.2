Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1LUKKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 05:10:34 -0500
Received: from thoth.sbs.de ([192.35.17.2]:31511 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab1LUKKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 05:10:31 -0500
Message-ID: <4EF1B081.3010109@siemens.com>
Date: Wed, 21 Dec 2011 11:10:09 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Zaytsev <alexey.zaytsev@gmail.com>,
        "Liu, Jinsong" <jinsong.liu@intel.com>, Avi Kivity <avi@redhat.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>
Subject: [PATCH] KVM: x86: Prevent exposing TSC deadline timer feature in
 the absence of in-kernel APIC
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com> <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com> <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com> <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com> <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com> <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com> <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com> <4EF1146D.208@siemens.com>
In-Reply-To: <4EF1146D.208@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-21 00:04, Jan Kiszka wrote:
> On 2011-12-20 19:58, Linus Torvalds wrote:
>> On Tue, Dec 20, 2011 at 1:51 AM, Alexey Zaytsev
>> <alexey.zaytsev@gmail.com> wrote:
>>>
>>> Let me clarify the situation.
>>>
>>> Before this commit, the tsc was advertised in cpuid, and it was
>>> handled, if I understand things correctly, by qemu.
>>> After this commit, the tsc is advertised in cpuid, and is handled in
>>> the kernel, but only after qemu issues KVM_CREATE_IRQCHIP. If it does
>>> not issue the ioctl, the kernel just discards any wrmsrs done to the
>>> tsc. This does not look like an Illumos problem to me. Linux guests
>>> kind of work here, because they are  prepared to work on utterly
>>> broken hardware. Good for you, but please don't break less-prepared
>>> guests.
>>
>> Yes. This is a regression, and needs to be fixed.
>>
>> Liu, if you don't have time to debug it, we'll just revert the commit.
>> It's that easy. Regressions are not allowed. There are no excuses.
>>
>> In particular, saying "just wait for qemu-kvm" is not an acceptable
>> answer, because the point is that things *used* to work, and they
>> broke. No "change it to work with the new kernel" allowed, except for
>> some *very* rare critical circumstances (usually "major security-bug
>> that we had to fix, and people who relied on it are thus out of
>> luck").
>>
>> Commit a3e06bbe8445 still seems to revert cleanly, so that is the easy option.
>>
>> That said, it sounds like maybe another solution is to start with the
>> TSC_DEADLINE timer bit in cpuid cleared, and only setting it after the
>> KVM_CREATE_IRQCHIP ioctl.
> 
> KVM cpuid discovery can (and is) unfortunately be done before user space
> decides about creating an in-kernel irqchip or not. But the patch in
> question suggests to user space that it's optimal and perfectly fine to
> expose TSC_DEADLINE_TIMER to the guest - obviously a wrong suggestion in
> case user space does not use the in-kernel irqchip and does not
> implement the deadline timer in its own APIC model.
> 
> So the only proper solution I see is to drop that feature flag exposure
> from kvm_update_cpuid. Instead, KVM should indicate to *well informed*
> (i.e. updated) user space differently that there is now deadline timer
> support in the in-kernel APIC model. That different channel should be a
> KVM_CAP flag that user space can easily check and then merge the
> necessary flag on its own.
> 
>>
>> In fact, the patch is clearly buggy, in that it apparently doesn't
>> emulate TSC_DEADLINE correctly and natively on its own.
>>
>> Jan, Marcelo, Avi - is there a quick fix, or should I just revert?
> 
> Maybe fixing can be done quickly. In any case, the current ABI should
> not be exposed to user space, even at the price of postponing it's
> introduction. Just my 2 cents, though.

Was obviously too late for me. Here is a more accurate code analysis and
fix proposal:

kvm_update_cpuid is not involved in KVM_GET_SUPPORTED_CPUID as I
thought, thus there is no ABI issue. It should just be trivial bug in
setting the feature flag. Does this help? Untested!

Jan

-------8<-------

We must not report the TSC deadline timer feature on our own when user
space provides the APIC as we have no clue about its features.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 arch/x86/kvm/cpuid.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 230f713..28615f2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -40,7 +40,7 @@ void kvm_update_cpuid(struct kvm_vcpu *vcpu)
 			best->ecx |= bit(X86_FEATURE_OSXSAVE);
 	}
 
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+	if (apic && boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
 		best->function == 0x1) {
 		best->ecx |= bit(X86_FEATURE_TSC_DEADLINE_TIMER);
 		timer_mode_mask = 3 << 17;
-- 
1.7.3.4
