Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2BCN1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:27:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62831 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab2BCN1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:27:22 -0500
Date: Fri, 3 Feb 2012 13:27:17 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] arm: vfp: Raising SIGFPE on invalid floating point
 operation
Message-ID: <20120203132717.GB2098@linaro.org>
References: <1328258184-23082-1-git-send-email-consul.kautuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328258184-23082-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 02:06:24PM +0530, Kautuk Consul wrote:
> There is a lot of ARM/VFP hardware which does not invoke the
> undefined instruction exception handler (i.e. __und_usr) at all
> even in case of an invalid floating point operation in usermode.
> For example, 100.0 divided by 0.0 will not lead to the undefined
> instruction exception being called by the processor although the
> hardware does reliably set the DZC bit in the FPSCR.

Which revision of the architecture are you referring to?

In VFPv2, I believe that exception trapping is architecturally required
to work: a CPU which doesn't trap when the corresponding exxception
enable bits in the FPSCR are set is a wrong implementation.

For VFPv3 and VFPv4 (on ARMv7+), there are two variants specified by the
architecture: "U" variants VFPv3U/VFPv4U where trapping must work (as in
VFPv2); and non-trapping variants VFPv3/VFPv4.

The non-trapping variants are common: Cortex-A8 and A9 for example have
non-trapping VFP implementations.

The architecture specified that writes to those FPSCR bits must be
ignored, and they must always read as 0, in non-trapping implementations.

> Currently, the usermode code will simply proceed to execute without
> the SIGFPE signal being raised on that process thus limiting the
> developer's knowledge of what really went wrong in his code logic.

ISO C specifies that this is exactly what is supposed to happen by
default.  This is very counterintiutive, but try:

double x = 1.0;
double y = 0.0;

int main(void)
{
        return x / y;
}

...on any x86 box or other machine, and you should get no SIGFPE.

You can request trapping exceptions by calling the standard function
feenableexcept(), but ISO C allows that some implementations may not
support trapping exceptions: feenableexcept() can return an error to
indicate this.

Due to a completely separate bug in libc though, we don't return the
error indication.  The code seems to assume the VFPv2 behaviour, and
doesn't consider the possibility that setting those exception enable
bits may fail.

> This patch enables the kernel to raise the SIGFPE signal when the
> faulting thread next calls schedule() in any of the following ways:
> - When the thread is interrupted by IRQ
> - When the thread calls a system call
> - When the thread encounters exception
> 
> Although the SIGFPE is not delivered at the exact faulting instruction,
> this patch at least allows the system to handle FPU exception scenarios
> in a more generic "Linux/Unix" manner.

Whether this is a practical/sensible at all seems questionable:

 a) This must not be unconditional, because userspace programs can
    legitimately ask not to receive SIGFPE on floating-point errors
    (indeed, this is the ISO C default behaviour at program startup,
    before feenableexcept() is called).

 b) There is currently no way for a userspace program to signal to the
    kernel that it wants the signals, except for setting the FPSCR
    exception enable bits (which aren't implemented, and always read as
    zero in non-trapping implementations) -- so without userspace
    explicitly telling the kernel this behaviour is wanted via a special
    non-standard syscall, there is no way to know whether the signal
    should be sent or not.  The default assumption will have to be that
    the signals should not be sent.

 c) Although I can find no exlpicit wording in C or POSIX to say so, I
    believe that most or all code relying on floating-point traps will
    expect the signal to be precise (i.e., triggered on the exact
    instruction which caused the exception).  If we can't guarantee this,
    it's probably better to fix libc and not pretend we can send the
    signals at all.

Checking the cumulative exception bits is potentially useful for
debugging, but you can do that from userspace by calling functions like
fetestexcept(); or a debugger can do it via ptrace().

If we synthesise fake trapping exceptions at all, it would probably have
to be a debugging feature which must explicitly be turned on per process,
via a special prctl() or something.  Most other arches don't seem to
have that, though.  Should we really be putting such functionality in
the kernel?

Cheers
---Dave

> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> Signed-off-by: Mohd. Faris <mohdfarisq2010@gmail.com>
> ---
>  arch/arm/include/asm/vfp.h |    2 ++
>  arch/arm/vfp/vfpmodule.c   |   15 ++++++++++++++-
>  2 files changed, 16 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/include/asm/vfp.h b/arch/arm/include/asm/vfp.h
> index f4ab34f..a37c265 100644
> --- a/arch/arm/include/asm/vfp.h
> +++ b/arch/arm/include/asm/vfp.h
> @@ -71,6 +71,8 @@
>  #define FPSCR_UFC		(1<<3)
>  #define FPSCR_IXC		(1<<4)
>  #define FPSCR_IDC		(1<<7)
> +#define FPSCR_CUMULATIVE_EXCEPTION_MASK	\
> +		(FPSCR_IOC|FPSCR_DZC|FPSCR_OFC|FPSCR_UFC|FPSCR_IXC|FPSCR_IDC)
>  
>  /* MVFR0 bits */
>  #define MVFR0_A_SIMD_BIT	(0)
> diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
> index 8f3ccdd..39824a1 100644
> --- a/arch/arm/vfp/vfpmodule.c
> +++ b/arch/arm/vfp/vfpmodule.c
> @@ -52,6 +52,8 @@ unsigned int VFP_arch;
>   */
>  union vfp_state *vfp_current_hw_state[NR_CPUS];
>  
> +static void vfp_raise_sigfpe(unsigned int, struct pt_regs *);
> +
>  /*
>   * Is 'thread's most up to date state stored in this CPUs hardware?
>   * Must be called from non-preemptible context.
> @@ -72,8 +74,13 @@ static bool vfp_state_in_hw(unsigned int cpu, struct thread_info *thread)
>   */
>  static void vfp_force_reload(unsigned int cpu, struct thread_info *thread)
>  {
> +	unsigned int fpexc = fmrx(FPEXC);
> +
>  	if (vfp_state_in_hw(cpu, thread)) {
> -		fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
> +		if ((fpexc & FPEXC_EN) &&
> +			(fmrx(FPSCR) & FPSCR_CUMULATIVE_EXCEPTION_MASK))
> +			vfp_raise_sigfpe(0, task_pt_regs(current));
> +		fmxr(FPEXC, fpexc & ~FPEXC_EN);
>  		vfp_current_hw_state[cpu] = NULL;
>  	}
>  #ifdef CONFIG_SMP
> @@ -100,6 +107,8 @@ static void vfp_thread_flush(struct thread_info *thread)
>  	cpu = get_cpu();
>  	if (vfp_current_hw_state[cpu] == vfp)
>  		vfp_current_hw_state[cpu] = NULL;
> +	if (fmrx(FPSCR) & FPSCR_CUMULATIVE_EXCEPTION_MASK)
> +		vfp_raise_sigfpe(0, task_pt_regs(current));
>  	fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
>  	put_cpu();
>  
> @@ -181,6 +190,10 @@ static int vfp_notifier(struct notifier_block *self, unsigned long cmd, void *v)
>  			vfp_save_state(vfp_current_hw_state[cpu], fpexc);
>  #endif
>  
> +		if ((fpexc & FPEXC_EN) &&
> +				(fmrx(FPSCR) & FPSCR_CUMULATIVE_EXCEPTION_MASK))
> +			vfp_raise_sigfpe(0, task_pt_regs(current));
> +
>  		/*
>  		 * Always disable VFP so we can lazily save/restore the
>  		 * old state.
> -- 
> 1.7.6
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
