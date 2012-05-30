Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab2E3Lzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:55:36 -0400
Received: from thoth.sbs.de ([192.35.17.2]:17558 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab2E3Lze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:55:34 -0400
Message-ID: <4FC60A71.5050804@siemens.com>
Date: Wed, 30 May 2012 13:54:25 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        X86 <x86@kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xen Devel <xen-devel@lists.xensource.com>, KVM <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Attilio Rao <attilio.rao@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH RFC V8 17/17] Documentation/kvm : Add documentation on
 Hypercalls and features used for PV spinlock
References: <20120502100610.13206.40.sendpatchset@codeblue.in.ibm.com> <20120502100947.13206.26518.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20120502100947.13206.26518.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-02 12:09, Raghavendra K T wrote:
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> 
> 
> KVM_HC_KICK_CPU  hypercall added to wakeup halted vcpu in paravirtual spinlock
> enabled guest.
> 
> KVM_FEATURE_PV_UNHALT enables guest to check whether pv spinlock can be enabled
> in guest.
> 
> Thanks Alex for KVM_HC_FEATURES inputs and Vatsa for rewriting KVM_HC_KICK_CPU

This contains valuable documentation for features that are already
supported. Can you break them out and post as separate patch already?
One comment on them below.

> 
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  Documentation/virtual/kvm/cpuid.txt      |    4 ++
>  Documentation/virtual/kvm/hypercalls.txt |   60 ++++++++++++++++++++++++++++++
>  2 files changed, 64 insertions(+), 0 deletions(-)
> diff --git a/Documentation/virtual/kvm/cpuid.txt b/Documentation/virtual/kvm/cpuid.txt
> index 8820685..062dff9 100644
> --- a/Documentation/virtual/kvm/cpuid.txt
> +++ b/Documentation/virtual/kvm/cpuid.txt
> @@ -39,6 +39,10 @@ KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
>  KVM_FEATURE_ASYNC_PF               ||     4 || async pf can be enabled by
>                                     ||       || writing to msr 0x4b564d02
>  ------------------------------------------------------------------------------
> +KVM_FEATURE_PV_UNHALT              ||     6 || guest checks this feature bit
> +                                   ||       || before enabling paravirtualized
> +                                   ||       || spinlock support.
> +------------------------------------------------------------------------------
>  KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
>                                     ||       || per-cpu warps are expected in
>                                     ||       || kvmclock.
> diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
> new file mode 100644
> index 0000000..bc3f14a
> --- /dev/null
> +++ b/Documentation/virtual/kvm/hypercalls.txt
> @@ -0,0 +1,60 @@
> +KVM Hypercalls Documentation
> +===========================
> +The template for each hypercall is:
> +1. Hypercall name, value.
> +2. Architecture(s)
> +3. Status (deprecated, obsolete, active)
> +4. Purpose
> +
> +1. KVM_HC_VAPIC_POLL_IRQ
> +------------------------
> +Value: 1
> +Architecture: x86
> +Purpose: None

Purpose: Trigger guest exit so that the host can check for pending
interrupts on reentry.

> +
> +2. KVM_HC_MMU_OP
> +------------------------
> +Value: 2
> +Architecture: x86
> +Status: deprecated.
> +Purpose: Support MMU operations such as writing to PTE,
> +flushing TLB, release PT.
> +
> +3. KVM_HC_FEATURES
> +------------------------
> +Value: 3
> +Architecture: PPC
> +Status: active
> +Purpose: Expose hypercall availability to the guest. On x86 platforms, cpuid
> +used to enumerate which hypercalls are available. On PPC, either device tree
> +based lookup ( which is also what EPAPR dictates) OR KVM specific enumeration
> +mechanism (which is this hypercall) can be used.
> +
> +4. KVM_HC_PPC_MAP_MAGIC_PAGE
> +------------------------
> +Value: 4
> +Architecture: PPC
> +Status: active
> +Purpose: To enable communication between the hypervisor and guest there is a
> +shared page that contains parts of supervisor visible register state.
> +The guest can map this shared page to access its supervisor register through
> +memory using this hypercall.
> +
> +5. KVM_HC_KICK_CPU
> +------------------------
> +Value: 5
> +Architecture: x86
> +Status: active
> +Purpose: Hypercall used to wakeup a vcpu from HLT state
> +
> +Usage example : A vcpu of a paravirtualized guest that is busywaiting in guest
> +kernel mode for an event to occur (ex: a spinlock to become available) can
> +execute HLT instruction once it has busy-waited for more than a threshold
> +time-interval. Execution of HLT instruction would cause the hypervisor to put
> +the vcpu to sleep until occurence of an appropriate event. Another vcpu of the
> +same guest can wakeup the sleeping vcpu by issuing KVM_HC_KICK_CPU hypercall,
> +specifying APIC ID of the vcpu to be wokenup.
> +
> +TODO:
> +1. more information on input and output needed?
> +2. Add more detail to purpose of hypercalls.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
