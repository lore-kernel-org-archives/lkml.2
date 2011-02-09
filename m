Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab1BIRHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:07:07 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56618 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab1BIRHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:07:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "hpa\@zytor.com" <hpa@zytor.com>,
        "andi\@firstfloor.org" <andi@firstfloor.org>,
        "bp\@alien8.de" <bp@alien8.de>,
        "seto.hidetoshi\@jp.fujitsu.com" <seto.hidetoshi@jp.fujitsu.com>,
        "gregkh\@suse.de" <gregkh@suse.de>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "dle-develop\@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "amwang\@redhat.com" <amwang@redhat.com>,
        Satoru Moriya <satoru.moriya@hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C1494DBE0@USINDEVS01.corp.hds.com>
Date: Wed, 09 Feb 2011 09:06:50 -0800
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C1494DBE0@USINDEVS01.corp.hds.com>
	(Seiji Aguchi's message of "Wed, 9 Feb 2011 11:35:43 -0500")
Message-ID: <m1d3n12l3p.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18VzDaTYIy2SkXP3IMKt6J9gdPpbl55ino=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Seiji Aguchi <seiji.aguchi@hds.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH v2] Controlling kexec behaviour when hardware error happened.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seiji Aguchi <seiji.aguchi@hds.com> writes:

> Hi,
>
> I submitted a quite similar patch last December.
>
> http://www.spinics.net/lists/linux-mm/msg13157.html
>
> I retry it with different description of the purpose.
>
> [Changelog]
> from v1:
>     - Change name of sysctl parameter ,kexec_on_mce, to kexec_on_hwerr. 
>     - Move variable declaration from <asm/mce.h> to <kernel/panic.h>.
>     - Remove CONFIG_X86_MCE in *.c files.
>     - Modify [Purpose]/[Patch Description].
>
> [Purpose]
> There are some logging features of firmware/hardware, SEL,BMC, etc, in enterprise servers.
> We investigate the firmware/hardware logs first when MCE occurred and replace the broken hardware.
> So, memory dump is not necessary for detecting root cause of machine check.
> Also, we can reduce down-time by skipping kdump.
>
> Of course, there are a lot of servers which don't have logging features of firmware/hardware.
> So, I proposed a option controlling kexec behaviour when hardware error occurred. 

Mostly this seems reasonable.  If we can get the logic simple enough it
is fool proof I am for it.

> [Patch Description]
> This patch adds a sysctl option ,kernel.kexec_on_hwerr, controlling kexec behaviour when hardware error occurred.
>
>  - Permission
> 　　- 0644
>  - Value(default is "1")
>    - non-zero: Kexec is enabled regardless of hardware error.
>    - 0: Kexec is disabled when MCE occurred.
>    
>
> Matrix of kernel.kexec_on_hwerr value ,hardware error and kexec

If we do a version that is potentially arch agnostic but x86 for now,
and we call it kexec_on_logged_hwerr.  Because it is important that we
expect that the hardware will log the error.

Is there any reason we can't put logic to decided if we should write
a crashdump in the crashdump userspace?

Eric


> --------------------------------------------------
> kernel.kexec_on_hwerr| hardware error | kexec
> --------------------------------------------------
> non-zero             | occurred       | enabled
>                      -----------------------------
>                      | not occurred   | enabled
> --------------------------------------------------
> 0                    | occurred       | disabled
>                      |----------------------------
>                      | not occurred   | enabled
> --------------------------------------------------
>
>
> Any comments and suggestions are welcome.
>
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
>
> ---
>  Documentation/sysctl/kernel.txt  |   11 +++++++++++
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 ++
>  include/linux/kernel.h           |    2 ++
>  include/linux/sysctl.h           |    1 +
>  kernel/panic.c                   |   15 ++++++++++++++-
>  kernel/sysctl.c                  |    8 ++++++++
>  kernel/sysctl_binary.c           |    1 +
>  mm/memory-failure.c              |    2 ++
>  8 files changed, 41 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt index 11d5ced..3159111 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -34,6 +34,7 @@ show up in /proc/sys/kernel:
>  - hotplug
>  - java-appletviewer           [ binfmt_java, obsolete ]
>  - java-interpreter            [ binfmt_java, obsolete ]
> +- kexec_on_hwerr              [ x86 only ]
>  - kptr_restrict
>  - kstack_depth_to_print       [ X86 only ]
>  - l2cr                        [ PPC only ]
> @@ -261,6 +262,16 @@ This flag controls the L2 cache of G3 processor boards. If  0, the cache is disabled. Enabled if nonzero.
>  
>  ==============================================================
> +kexec_on_hwerr: (X86 only)
> +
> +Controls the behaviour of kexec when panic occurred due to hardware 
> +error.
> +Default value is 1.
> +
> +0: Kexec is disabled.
> +non-zero: Kexec is enabled.
> +
> +==============================================================
>  
>  kptr_restrict:
>  
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index d916183..e76b47b 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -944,6 +944,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  
>  	percpu_inc(mce_exception_count);
>  
> +	hwerr_flag = 1;
> +
>  	if (notify_die(DIE_NMI, "machine check", regs, error_code,
>  			   18, SIGKILL) == NOTIFY_STOP)
>  		goto out;
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h index 2fe6e84..c2fba7c 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -242,6 +242,8 @@ extern void add_taint(unsigned flag);  extern int test_taint(unsigned flag);  extern unsigned long get_taint(void);  extern int root_mountflags;
> +extern int kexec_on_hwerr;
> +extern int hwerr_flag;
>  
>  extern bool early_boot_irqs_disabled;
>  
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h index 7bb5cb6..8ae5bfe 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -153,6 +153,7 @@ enum
>  	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
> +	KERN_KEXEC_ON_HWERR=77, /* int: bevaviour of kexec for hardware error 
> +*/
Don't change this file.  You don't need a binary number.
>  };
>  
>  
> diff --git a/kernel/panic.c b/kernel/panic.c index 991bb87..84c1d2e 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -28,6 +28,8 @@
>  #define PANIC_BLINK_SPD 18
>  
>  int panic_on_oops;
> +int kexec_on_hwerr = 1;
> +int hwerr_flag;
>  static unsigned long tainted_mask;
>  static int pause_on_oops;
>  static int pause_on_oops_flag;
> @@ -45,6 +47,16 @@ static long no_blink(int state)
>  	return 0;
>  }
>  
> +static int kexec_should_skip(void)
> +{
> +	if (!kexec_on_hwerr && hwerr_flag) {
> +		printk(KERN_WARNING "Kexec is skipped because hardware error "
> +		       "occurred.\n");
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>  /* Returns how long it waited in ms */
>  long (*panic_blink)(int state);
>  EXPORT_SYMBOL(panic_blink);
> @@ -86,7 +98,8 @@ NORET_TYPE void panic(const char * fmt, ...)
>  	 * everything else.
>  	 * Do we want to call this before we try to display a message?
>  	 */
> -	crash_kexec(NULL);
> +	if (!kexec_should_skip())
> +		crash_kexec(NULL);
>  
>  	kmsg_dump(KMSG_DUMP_PANIC);
>  
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c index 0f1bd83..f78edd8 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -811,6 +811,14 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +		.procname	= "kexec_on_hwerr",
> +		.data		= &kexec_on_hwerr,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
> +
>  #endif
>  #if defined(CONFIG_MMU)
>  	{
> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c index b875bed..8d572ca 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -137,6 +137,7 @@ static const struct bin_table bin_kern_table[] = {
>  	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
>  	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
>  	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
> +	{ CTL_INT,	KERN_KEXEC_ON_HWERR,		"kexec_on_hwerr" },
>  	{}
Don't change this file.  No one uses the binary interface.
>  };
>  
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c index 0207c2f..0178f47 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -994,6 +994,8 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
>  	int res;
>  	unsigned int nr_pages;
>  
> +	hwerr_flag = 1;
> +
>  	if (!sysctl_memory_failure_recovery)
>  		panic("Memory failure from trap %d on page %lx", trapno,
> pfn);

I get the feeling that we should either call a function besides panic or
do something different so that we aren't controlling this trough an
implicit parameter set in a global variable.  That just seems scary racy
and hard to understand by reading the code.

Eric
