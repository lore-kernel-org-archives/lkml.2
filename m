Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760828Ab0J1SAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:00:55 -0400
Received: from claw.goop.org ([74.207.240.146]:59054 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab0J1SAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:00:50 -0400
Message-ID: <4CC9BA4E.2090903@goop.org>
Date: Thu, 28 Oct 2010 11:00:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] xen PV on HVM and initial domain
References: <alpine.DEB.2.00.1010261207180.1407@kaball-desktop> <alpine.DEB.2.00.1010271901350.1407@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1010271901350.1407@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Linus,

Did you see this pull request?  I approve of it, if that's what you're
looking for.

Thanks,
    J

On 10/27/2010 11:08 AM, Stefano Stabellini wrote:
> Linus,
> I added another commit at the end of the branch to fix MSI setup issues
> when Linux is running as initial domain on Xen.
> The shortlog and the diffstat are slightly different now:
>
> Jeremy Fitzhardinge (5):
>       acpi: use indirect call to register gsi in different modes
>       xen: add xen hvm acpi_register_gsi variant
>       xen: remap GSIs as pirqs when running as initial domain
>       xen: map a dummy page for local apic and ioapic in xen_set_fixmap
>       xen: make hvc_xen console work for dom0.
>
> Juan Quintela (2):
>       xen: Initialize xenbus for dom0.
>       xen: add the direct mapping area for ISA bus access
>
> Qing He (1):
>       xen: remap MSIs into pirqs when running as initial domain
>
> Stefano Stabellini (10):
>       xen: support pirq != irq
>       xen: get the maximum number of pirqs from xen
>       xen: implement xen_hvm_register_pirq
>       xen: support GSI -> pirq remapping in PV on HVM guests
>       xen: map MSIs into pirqs
>       xen: introduce XEN_DOM0 as a silent option
>       xen: use vcpu_ops to setup cpu masks
>       xen: mask the MTRR feature from the cpuid
>       xen: add a missing #include to arch/x86/pci/xen.c
>       xen: initialize cpu masks for pv guests in xen_smp_init
>
> Weidong Han (1):
>       xen: register xen pci notifier
>
>  arch/x86/include/asm/acpi.h       |    3 +
>  arch/x86/include/asm/xen/pci.h    |   12 ++
>  arch/x86/kernel/acpi/boot.c       |   60 +++++--
>  arch/x86/pci/xen.c                |  308 ++++++++++++++++++++++++++++++++++--
>  arch/x86/xen/Kconfig              |   10 ++
>  arch/x86/xen/enlighten.c          |    2 +
>  arch/x86/xen/mmu.c                |   47 ++++++-
>  arch/x86/xen/setup.c              |    3 +
>  arch/x86/xen/smp.c                |   26 +++
>  drivers/char/hvc_xen.c            |   98 ++++++++----
>  drivers/xen/Makefile              |    1 +
>  drivers/xen/events.c              |  195 +++++++++++++++++++++---
>  drivers/xen/pci.c                 |  117 ++++++++++++++
>  drivers/xen/xenbus/xenbus_probe.c |   29 ++++-
>  include/xen/events.h              |    8 +
>  include/xen/interface/features.h  |    3 +
>  include/xen/interface/physdev.h   |   67 ++++++++
>  17 files changed, 897 insertions(+), 92 deletions(-)
>
>
> The branch is still:
>
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git for-linus
>
> otherwise if you prefer the old branch, without this commit, pull this:
>
> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.36-rc8-initial-domain-v7
>
>
> Many thanks in advance,
>
> Stefano
>
> On Tue, 26 Oct 2010, Stefano Stabellini wrote:
>> Linus,
>> I have two patch series that I would like you to pull:
>>
>> PV on HVM: receive interrupts as xen events [1]
>> xen: initial domain support [2]
>>
>> Please pull from the following branch:
>>
>> git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git for-linus
>>
>> it contains both series rebased on Konrad's xen-pcifront series [3]
>> (they depend on it, unfortunately I cannot produce a working series
>> without it) on Linux 2.6.36 rc8; my two patch series start after git
>> commit 67ba37293e938208795d6a3562201bdb0cf43393.
>>
>> The first patch series introduces some performance improvements for Xen
>> PV on HVM guests: interacting with the emulated APIC is slow because it
>> causes traps in the hypervisor while receiving Xen events using the
>> vector callback mechanism allow us to skip all that. For this reason we
>> remap interrupts and MSIs into Xen pirqs so that from that point on we
>> can receive them as Xen events instead.
>>
>> The second patch series implements the basic support needed to boot
>> Linux as initial domain on Xen: the target is not to add full featured
>> dom0 support in the kernel but to be able to boot Linux on Xen on
>> native.
>>
>> I have just added a last minute fix at end to solve a vcpu
>> initialization problem for pv guests (they would see only a single vcpu
>> even though they are given more than one [4]).
>>
>>
>> All together the two series introduce the following changes:
>>
>> Jeremy Fitzhardinge (5):
>>       acpi: use indirect call to register gsi in different modes
>>       xen: add xen hvm acpi_register_gsi variant
>>       xen: remap GSIs as pirqs when running as initial domain
>>       xen: map a dummy page for local apic and ioapic in xen_set_fixmap
>>       xen: make hvc_xen console work for dom0.
>>
>> Juan Quintela (2):
>>       xen: Initialize xenbus for dom0.
>>       xen: add the direct mapping area for ISA bus access
>>
>> Qing He (1):
>>       xen: remap MSIs into pirqs when running as initial domain
>>
>> Stefano Stabellini (10):
>>       xen: support pirq != irq
>>       xen: get the maximum number of pirqs from xen
>>       xen: implement xen_hvm_register_pirq
>>       xen: support GSI -> pirq remapping in PV on HVM guests
>>       xen: map MSIs into pirqs
>>       xen: introduce XEN_DOM0 as a silent option
>>       xen: use vcpu_ops to setup cpu masks
>>       xen: mask the MTRR feature from the cpuid
>>       xen: add a missing #include to arch/x86/pci/xen.c
>>       xen: initialize cpu masks for pv guests in xen_smp_init
>>
>>  arch/x86/include/asm/acpi.h       |    3 +
>>  arch/x86/include/asm/xen/pci.h    |   12 ++
>>  arch/x86/kernel/acpi/boot.c       |   60 +++++--
>>  arch/x86/pci/xen.c                |  308 ++++++++++++++++++++++++++++++++++--
>>  arch/x86/xen/Kconfig              |   10 ++
>>  arch/x86/xen/enlighten.c          |    2 +
>>  arch/x86/xen/mmu.c                |   47 ++++++-
>>  arch/x86/xen/setup.c              |    3 +
>>  arch/x86/xen/smp.c                |   26 +++
>>  drivers/char/hvc_xen.c            |   98 ++++++++----
>>  drivers/xen/events.c              |  195 +++++++++++++++++++++---
>>  drivers/xen/xenbus/xenbus_probe.c |   29 ++++-
>>  include/xen/events.h              |    8 +
>>  include/xen/interface/features.h  |    3 +
>>  include/xen/interface/physdev.h   |   46 ++++++
>>  15 files changed, 758 insertions(+), 92 deletions(-)
>>
>> Cheers,
>>
>> Stefano
>>
>> ---
>> [1] http://lkml.org/lkml/2010/10/12/246 
>> [2] http://lkml.org/lkml/2010/10/19/199
>> [3] http://lkml.org/lkml/2010/10/26/231
>> [4] http://lkml.org/lkml/2010/10/26/369 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>

