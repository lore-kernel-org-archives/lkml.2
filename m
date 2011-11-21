Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1KUPM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:12:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab1KUPM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:12:26 -0500
Date: Mon, 21 Nov 2011 10:11:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [RFC Patch 1/2][slimdump] Append CRASH_REASON to VMCOREINFO
 elf-note
Message-ID: <20111121151157.GE313@redhat.com>
References: <20111121095405.GA2289@in.ibm.com>
 <20111121101157.GA10194@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121101157.GA10194@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 03:41:57PM +0530, K.Prasad wrote:
> Allow various crash paths to append the reason of crash into the
> VMCOREINFO elf-note through the field CRASH_REASON. We also make the
> fatal machine check exceptions append "PANIC_MCE" as the crash reason.
> This string will be recognised by upstream tools like makedumpfile and
> crash to generate slimdump.
> 
> With increased usage of the CRASH_REASON field, the crash strings can be
> encoded for better usage.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    8 ++++++++
>  kernel/kexec.c                   |    6 ++++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 362056a..5b2cb6a 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -38,6 +38,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/irq_work.h>
>  #include <linux/export.h>
> +#include <linux/kexec.h>
>  
>  #include <asm/processor.h>
>  #include <asm/mce.h>
> @@ -240,6 +241,13 @@ static atomic_t mce_paniced;
>  static int fake_panic;
>  static atomic_t mce_fake_paniced;
>  
> +char *arch_add_crash_reason(void)
> +{
> +	static char crash_reason[] = "PANIC_MCE";
> +
> +	return crash_reason;
> +}
> +
>  /* Panic in progress. Enable interrupts and wait for final IPI */
>  static void wait_for_panic(void)
>  {
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index dc7bc08..a731693 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1080,6 +1080,11 @@ asmlinkage long compat_sys_kexec_load(unsigned long entry,
>  }
>  #endif
>  
> +__weak char *arch_add_crash_reason(void)
> +{
> +	return (char *)NULL;
> +}
> +
>  void crash_kexec(struct pt_regs *regs)
>  {
>  	/* Take the kexec_mutex here to prevent sys_kexec_load
> @@ -1411,6 +1416,7 @@ static void update_vmcoreinfo_note(void)
>  void crash_save_vmcoreinfo(void)
>  {
>  	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
> +	vmcoreinfo_append_str("\nCRASH_REASON=%s\n", arch_add_crash_reason());

I think don't even create a CRASH_REASON= entry if arch returns a NULL
string.

Vivek
