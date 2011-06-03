Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1FCLwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:52:21 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:59306 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab1FCLwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:52:20 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/f7yb6+x1CF1B3oIP27v4=
X-RZG-CLASS-ID: mo00
Message-ID: <4DE8CAE6.7050002@die-jansens.de>
Date: Fri, 03 Jun 2011 13:52:06 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
References: <20110405152729.232781355@chello.nl>	 <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>	 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>	 <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop>	 <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de>	 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com>	 <1307092535.2353.2973.camel@twins>  <4DE8B13D.9020302@die-jansens.de> <1307097052.2353.3061.camel@twins>
In-Reply-To: <1307097052.2353.3061.camel@twins>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.06.2011 12:30, Peter Zijlstra wrote:
> On Fri, 2011-06-03 at 12:02 +0200, Arne Jansen wrote:
>> On 03.06.2011 11:15, Peter Zijlstra wrote:
> 
> Bummer.
> 
>>  but the hang is not as complete as I first
>> thought. A running iostat via ssh continues to give output for a while,
>> the serial console still reacts to return and prompts for login. But
>> after a while more and more locks up. The console locks as soon as I
>> sysrq-t.
> 
> OK, that seems to suggest one CPU is stuck, and once you try something
> that touches the CPU everything grinds to a halt. Does something like
> sysrq-l work? That would send NMIs to the other CPUs.
> 
> Anyway, good to know using serial doesn't make it go away, that means
> its not too timing sensitive.
> 
> 
>> Also the 10k-print gets triggered
>> several times (though I only see 10 lines of output). Maybe you can
>> send me your test-module and I'll try that, so we have more equal
>> conditions.
> 
> Sure, see below.
> 

Your module also triggers it. On first test directly on first try, on
second test only on the 3rd try. When it hangs sysrq-l doesn't give
any output. I double checked without a hang, and then it dumps
something.


>> What also might help: the maschine I'm testing with is a quad-core
>> X3450 with 8GB RAM.
> 
> /me & wikipedia, that's a nehalem box, ok I'm testing on a westmere
> (don't have a nehalem).


> 
> ---
>  kernel/Makefile |    1 +
>  kernel/test.c   |   23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 2d64cfc..65eff6c 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -80,6 +80,7 @@ obj-$(CONFIG_LOCKUP_DETECTOR) += watchdog.o
>  obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
>  obj-$(CONFIG_SECCOMP) += seccomp.o
>  obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
> +obj-m += test.o
>  obj-$(CONFIG_TREE_RCU) += rcutree.o
>  obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
>  obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
> diff --git a/kernel/test.c b/kernel/test.c
> index e69de29..8005395 100644
> --- a/kernel/test.c
> +++ b/kernel/test.c
> @@ -0,0 +1,23 @@
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +MODULE_LICENSE("GPL");
> +
> +static void
> +test_cleanup(void)
> +{
> +}
> +
> +static int __init
> +test_init(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < 10000; i++)
> +		printk("test %d\n", i);
> +
> +	return 0;
> +}
> +
> +module_init(test_init);
> +module_exit(test_cleanup);
> 

