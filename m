Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab0H3Orn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:47:43 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:41951 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754556Ab0H3Orl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:47:41 -0400
Date: Mon, 30 Aug 2010 10:47:26 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, linux-next@vger.kernel.org,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <331762715.1536681283179646594.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C7BBE4E.8080901@kernel.org>
Subject: Re: kdump regression compared to v2.6.35
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Tejun Heo" <tj@kernel.org> wrote:

> Hello,
> 
> On 08/30/2010 04:02 PM, CAI Qian wrote:
> >> Hmm, odd.  So, here's the said debug patch.  It will periodically
> >> check all works and report if any work is being delayed for too
> long.
> >> If the max wait goes over 30secs, it will dump all task states and
> >> disable itself.  Can you please apply the patch on top of rc2 +
> >> wq#for-linus and report the output?  It should tell us who's stuck
> >> where.
> >
> > Nothing new was printed after around 10 minutes.
> 
> Eh... that's interesting.  That means no work is stalled on
> workqueues, so it at least is not a workqueue stall.  Can you please
> try the following then?  Or if sysrq wasn't working because your
...
SMP alternatives: switching to UP code
ACPI: Core revision 20100702
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 18488 entries in 73 pages
XXX show_state_timer registered
Not enabling x2apic, Intr-remapping init failed.
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           X7550  @ 2.00GHz stepping 06
Brought up 1 CPUs
Total of 1 processors activated (3990.10 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0

> keyboard wasn't initialized at that point, you can setup serial
> console and trigger sysrq that way.
Yes, it was triggered from a serial console.
> Thanks.
> 
> diff --git a/init/main.c b/init/main.c
> index 94ab488..e156b8f 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -423,11 +423,19 @@ static void __init setup_command_line(char
> *command_line)
> 
>  static __initdata DECLARE_COMPLETION(kthreadd_done);
> 
> +static void show_state_timer_fn(unsigned long data)
> +{
> +	show_state();
> +}
> +static DEFINE_TIMER(show_state_timer, show_state_timer_fn, 0, 0);
> +
>  static noinline void __init_refok rest_init(void)
>  	__releases(kernel_lock)
>  {
>  	int pid;
> 
> +	printk("XXX show_state_timer registered\n");
> +	mod_timer(&show_state_timer, jiffies + 180 * HZ);
>  	rcu_scheduler_starting();
>  	/*
>  	 * We need to spawn init first so that it obtains pid 1, however
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
