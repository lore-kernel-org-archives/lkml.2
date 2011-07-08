Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1GHRsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:48:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53065 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab1GHRsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:48:54 -0400
MIME-Version: 1.0
In-Reply-To: <20110708171926.GF2930@redhat.com>
References: <20110708171926.GF2930@redhat.com>
Date: Fri, 8 Jul 2011 10:48:53 -0700
X-Google-Sender-Auth: I_A2jwZ-gesh9FR-cIZeFzkwEOE
Message-ID: <CAE9FiQWOiEPFPBKp0ojC36stRpO21PYz7LOmXM54HTarNBw5LQ@mail.gmail.com>
Subject: Re: [PATCH] x86 boot: Wait for boot cpu to show up if nr_cpus limit
 is about to hit
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 8, 2011 at 10:19 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> nr_cpus allows one to specify number of possible cpus in the system.
> Current assumption seems to be that first cpu to show up is boot cpu
> and this assumption will be broken in kdump scenario where we can be
> booting on a non boot cpu with nr_cpus=1.
>
> It might happen that first cpu we parse is not the cpu we boot on and
> later we ignore boot cpu. Though code later seems to recognize this
> anomaly and forcibly sets boot cpu in physical cpu map with following
> warning.
>
> if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
>        printk(KERN_WARNING
>                "weird, boot CPU (#%d) not listed by the BIOS.\n",
>                hard_smp_processor_id());
>
>        physid_set(hard_smp_processor_id(), phys_cpu_present_map);
> }
>
> This patch waits for boot cpu to show up and starts ignoring the cpus
> once we have hit (nr_cpus - 1) number of cpus. So effectively we are
> reserving one slot out of nr_cpus for boot cpu explicitly.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Yinghai Lu <yinghai@kernel.org>

> ---
>  arch/x86/kernel/apic/apic.c |   22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> Index: linux-2.6/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/apic.c  2011-07-08 10:44:48.003709709 -0400
> +++ linux-2.6/arch/x86/kernel/apic/apic.c       2011-07-08 12:02:01.272223921 -0400
> @@ -1943,10 +1943,28 @@ void disconnect_bsp_APIC(int virt_wire_s
>
>  void __cpuinit generic_processor_info(int apicid, int version)
>  {
> -       int cpu;
> +       int cpu, max = nr_cpu_ids;
> +       bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
> +                               phys_cpu_present_map);
> +
> +       /*
> +        * If boot cpu has not been detected yet, then only allow upto
> +        * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
> +        */
> +       if (!boot_cpu_detected && num_processors >= nr_cpu_ids - 1 &&
> +           apicid != boot_cpu_physical_apicid) {
> +               int thiscpu = max + disabled_cpus - 1;
> +
> +               pr_warning(
> +                       "ACPI: NR_CPUS/possible_cpus limit of %i almost"
> +                       " reached. Keeping one slot for boot cpu."
> +                       "  Processor %d/0x%x ignored.\n", max, thiscpu, apicid);
> +
> +               disabled_cpus++;
> +               return;
> +       }
>
>        if (num_processors >= nr_cpu_ids) {
> -               int max = nr_cpu_ids;
>                int thiscpu = max + disabled_cpus;
>
>                pr_warning(
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
