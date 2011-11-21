Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1KUPTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:19:48 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:37292 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab1KUPTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:19:47 -0500
Date: Mon, 21 Nov 2011 10:19:31 -0500 (EST)
From: Dave Anderson <anderson@redhat.com>
To: prasad@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch 1/2][slimdump] Append CRASH_REASON to VMCOREINFO elf-note
Message-ID: <36c0c64c-9ccb-44a0-a81c-1071604cbdec@zmail15.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20111121101157.GA10194@in.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.16.19.41]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> Allow various crash paths to append the reason of crash into the
> VMCOREINFO elf-note through the field CRASH_REASON. We also make the
> fatal machine check exceptions append "PANIC_MCE" as the crash
> reason.  This string will be recognised by upstream tools like makedumpfile and
> crash to generate slimdump.

I don't understand -- how could "various paths" append a reason?
The patch below seems to return "PANIC_MCE" for every x86 crash.
What am I missing?

Dave
 
> With increased usage of the CRASH_REASON field, the crash strings can be
> encoded for better usage.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    8 ++++++++
>  kernel/kexec.c                   |    6 ++++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c
> b/arch/x86/kernel/cpu/mcheck/mce.c
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
> @@ -1080,6 +1080,11 @@ asmlinkage long compat_sys_kexec_load(unsigned
> long entry,
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
>  	update_vmcoreinfo_note();
>  }
>  
> 
> 
