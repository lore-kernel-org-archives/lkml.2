Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2AIBhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 20:37:48 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:46292 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755005Ab2AIBhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 20:37:47 -0500
Message-ID: <4F0A5298.4060807@xenotime.net>
Date: Sun, 08 Jan 2012 18:36:08 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@suse.de,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: Is register_cpu() now obligatory?
References: <4F0A3C3B.5090700@nod.at>
In-Reply-To: <4F0A3C3B.5090700@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2012 05:00 PM, Richard Weinberger wrote:
> Hi!
> 
> In Linus' tree as of today UML is broken.
> It's crashing because get_cpu_device() in topology_add_dev()
> returns a device with an invalid kobj (address is 0x10).
> 
> The code seems to assume that each arch has to register their CPUs
> using register_cpu().
> 
> Is this a regression or was UML always faulty because it did not register it's CPU?

See Linus's comment yesterday:
  https://lkml.org/lkml/2012/1/7/114


> The below patch fixes the issue for UML.
> 
> Thanks,
> //richard
> 
> ---
> diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
> index bc49474..f3b43fe 100644
> --- a/arch/um/kernel/Makefile
> +++ b/arch/um/kernel/Makefile
> @@ -12,7 +12,7 @@ clean-files :=
>  obj-y = config.o exec.o exitcode.o init_task.o irq.o ksyms.o mem.o \
>  	physmem.o process.o ptrace.o reboot.o sigio.o \
>  	signal.o smp.o syscall.o sysrq.o time.o tlb.o trap.o \
> -	um_arch.o umid.o skas/
> +	um_arch.o umid.o cpu.o skas/
> 
>  obj-$(CONFIG_BLK_DEV_INITRD) += initrd.o
>  obj-$(CONFIG_GPROF)	+= gprof_syms.o
> diff --git a/arch/um/kernel/cpu.c b/arch/um/kernel/cpu.c
> new file mode 100644
> index 0000000..4914df2
> --- /dev/null
> +++ b/arch/um/kernel/cpu.c
> @@ -0,0 +1,19 @@
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/cpu.h>
> +#include <linux/percpu.h>
> +
> +static DEFINE_PER_CPU(struct cpu, cpu_devices);
> +
> +static int __init topology_init(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct cpu *c = &per_cpu(cpu_devices, cpu);
> +		register_cpu(c, cpu);
> +	}
> +
> +	return 0;
> +}
> +subsys_initcall(topology_init);
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
