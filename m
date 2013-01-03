Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3ACRwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:52:21 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54004 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab3ACRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:52:16 -0500
Date: Thu, 3 Jan 2013 12:44:57 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Yinghai Lu <yinghai@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v5 00/12] x86/microcode: Early load microcode
Message-ID: <20130103174455.GA7350@localhost.localdomain>
References: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356075872-3054-1-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 11:44:20PM -0800, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> The problem in current microcode loading method is that we load a microcode way,
> way too late; ideally we should load it before turning paging on.  This may only
> be practical on 32 bits since we can't get to 64-bit mode without paging on,
> but we should still do it as early as at all possible.
> 
> Similarly, we should load the microcode update as early as possible during AP
> bringup and when processors are brought back online after hotplug or S3/S4.
> 
> In order to do that, the microcode patch needs to be permanently present in
> kernel memory.  Each individual patch is fairly small, so that is OK, but the
> entire blob with support for each CPU is too big. Since only CPU's with same
> model can be in the same platform, we store microcode with the same model as
> BSP. Later on APs can upload microcode from the saved microcodep patches.
> 
> Note, however, that Linux users have gotten used to being able to install a
> microcode patch in the field without having a reboot; we support that model too.
> 
> In x86_64, this patchset needs early #PF handler set page table patchset. So
> this patchset is based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot
> 

A couple of questions - why the usage of native_[read|write]_msr? I get the
__native_cpuid variant, but I am not sure I understand why you are using
the native_* variants. Especially as this code ends up being called on
Xen and lguest (at least on 64-bit) and probably should go through the
paravirt interfaces.

Also the same question for the __native_flush_tlb_global_irq_disabled
- you take parts of it out (the ones dealing with CR4) and end up
calling those directly? Should they perhaps go through the paravirt
interface?

> v5: Call 64 bit load_ucode_bsp() after copy_bootdata() and remove its
> parameter.
> 
> v4: Change CPUID_IS macro. Call load_ucode_bsp after load_idt in x86_64. Flush
> tlb after applying microcode.
> 
> v3: Change .hex to .bin in 01/10 and 05/10 patches. Fix some compilation
> warnings. In x86_32 mode, access global varialbes by __pa_symobl() and fix
> static string issue in x86_vendor(). Call load_ucode_ap() in real mode as well.
> Add debug info.
> 
> v2: Detect vendor before loading microcode. Move some functions from
> microcode_intel_early.c to microcode_intel_lib.c. Change some early loading
> microcode dependencies in Kconfig. Reword doc.
> 
> Fenghua Yu (12):
>   Documentation/x86: Early load microcode
>   x86/microcode_intel.h: Define functions and macros for early loading
>     ucode
>   x86/common.c: Make have_cpuid_p() a global function
>   x86/common.c: load ucode in 64 bit or show loading ucode info in 32
>     bit on AP
>   x86/microcode_core_early.c: Define interfaces for early loading ucode
>   x86/microcode_intel_lib.c: Early update ucode on Intel's CPU
>   x86/tlbflush.h: Define __native_flush_tlb_global_irq_disabled()
>   x86/microcode_intel_early.c: Early update ucode on Intel's CPU
>   x86/head_32.S: Early update ucode in 32-bit
>   x86/head64.c: Early update ucode in 64-bit
>   x86/mm/init.c: Copy ucode from initrd image to kernel memory
>   x86/Kconfig: Configurations to enable/disable the feature
> 
>  Documentation/x86/early-microcode.txt   |  43 ++
>  arch/x86/Kconfig                        |  18 +
>  arch/x86/include/asm/microcode.h        |  14 +
>  arch/x86/include/asm/microcode_intel.h  |  85 ++++
>  arch/x86/include/asm/processor.h        |   8 +
>  arch/x86/include/asm/tlbflush.h         |  18 +-
>  arch/x86/kernel/Makefile                |   3 +
>  arch/x86/kernel/cpu/common.c            |  17 +-
>  arch/x86/kernel/head64.c                |   6 +
>  arch/x86/kernel/head_32.S               |  11 +
>  arch/x86/kernel/microcode_core.c        |   7 +-
>  arch/x86/kernel/microcode_core_early.c  |  76 +++
>  arch/x86/kernel/microcode_intel.c       | 198 ++------
>  arch/x86/kernel/microcode_intel_early.c | 796 ++++++++++++++++++++++++++++++++
>  arch/x86/kernel/microcode_intel_lib.c   | 174 +++++++
>  arch/x86/mm/init.c                      |  10 +
>  16 files changed, 1301 insertions(+), 183 deletions(-)
>  create mode 100644 Documentation/x86/early-microcode.txt
>  create mode 100644 arch/x86/include/asm/microcode_intel.h
>  create mode 100644 arch/x86/kernel/microcode_core_early.c
>  create mode 100644 arch/x86/kernel/microcode_intel_early.c
>  create mode 100644 arch/x86/kernel/microcode_intel_lib.c
> 
> -- 
> 1.8.0.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
