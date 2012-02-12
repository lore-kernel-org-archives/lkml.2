Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab2BLUuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 15:50:24 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2BLUuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 15:50:22 -0500
Date: Sun, 12 Feb 2012 12:50:16 -0800
From: Steven Noonan <steven@uplinklabs.net>
To: Ben Guthro <ben@guthro.net>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
Message-ID: <20120212205016.GA2794@asmodeus>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
 <1328894901.25989.20.camel@laptop>
 <20120210190412.GB12975@phenom.dumpdata.com>
 <CAOvdn6WcdrLHOPJc0Hv53+0trEFnU=RQJL5+xUMhAO3C3HWqbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOvdn6WcdrLHOPJc0Hv53+0trEFnU=RQJL5+xUMhAO3C3HWqbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 09:34:05PM -0500, Ben Guthro wrote:
> Re-send, with patch pasted in-line, rather than attached...
> 
> 
> Hmm - sorry I neglected this - it got filtered into my LKML folder,
> which I usually ignore, unless I'm looking for something.
> I'll have to adjust that filter for when I'm in the To: line.
> 
> I've attached a work-in-progress patch, that allows for kdb to work
> with the hvc console.
> 
> It assigns some IPI functions that may be applicable here...
> 
> That said - I'm not convinced it "rounds up" the cpus
> properly...though I haven't been able to prove otherwise. It seems to
> work generally...
> 

(I just set up Mutt as my mailer because GMail is stomping long lines on
me, and I don't like it one bit. I apologize if this mail isn't sent
correctly; I'm still tweaking my muttrc to work for LKML.)

So your patch does something interesting. Instead of getting a lengthy
hang with 'perf test', I now get a NULL pointer BUG instantly:

[   66.107165] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[   66.107298] IP: [<ffffffff813f49de>] evtchn_from_irq+0x36/0x3c
[   66.107383] PGD 69a88067 PUD 6c09d067 PMD 0 
[   66.107489] Oops: 0000 [#1] SMP 
[   66.107574] CPU 0 
[   66.107597] Modules linked in: xen_netback xen_blkback xen_evtchn xenfs fuse snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm iwlwifi thinkpad_acpi snd_seq_oss snd_seq_midi i2400m_usb mac80211 i2400m snd_rawmidi nfsd wimax nfs snd_seq_midi_event lockd uvcvideo videodev fscache snd_seq v4l2_compat_ioctl32 cfg80211 auth_rpcgss nfs_acl sunrpc psmouse snd_timer binfmt_misc snd_seq_device serio_raw intel_ips snd snd_page_alloc mei(C) soundcore wmi i915 drm_kms_helper drm e1000e ahci libahci i2c_algo_bit video
[   66.108928] 
[   66.108976] Pid: 3369, comm: perf Tainted: G         C   3.2.5-dirty #1 LENOVO 3680D79/3680D79
[   66.109118] RIP: e030:[<ffffffff813f49de>]  [<ffffffff813f49de>] evtchn_from_irq+0x36/0x3c
[   66.109228] RSP: e02b:ffff88006a7b7cc8  EFLAGS: 00010286
[   66.109284] RAX: 0000000000000000 RBX: ffff880069fd5001 RCX: 00000000fffffffa
[   66.109349] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   66.109413] RBP: ffff88006a7b7cc8 R08: ffff880072406400 R09: 0000000000000002
[   66.109479] R10: 00007ffff56a5750 R11: 0000000000000206 R12: 0000000000000000
[   66.109544] R13: ffff88006a7b7e30 R14: ffff88006a7b7f58 R15: 0000000000000000
[   66.109612] FS:  00007fa4c0ed4720(0000) GS:ffff88007ff52000(0000) knlGS:0000000000000000
[   66.109703] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[   66.109764] CR2: 0000000000000018 CR3: 00000000698de000 CR4: 0000000000002660
[   66.109828] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   66.109893] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   66.109957] Process perf (pid: 3369, threadinfo ffff88006a7b6000, task ffff88006c2b4560)
[   66.110049] Stack:
[   66.110098]  ffff88006a7b7ce8 ffffffff813f4cde ffff880005820700 ffff88006bcf9020
[   66.110254]  ffff88006a7b7cf8 ffffffff813f5b27 ffff88006a7b7d08 ffffffff8100d07e
[   66.110414]  ffff88006a7b7d18 ffffffff81012631 ffff88006a7b7d38 ffffffff810e3a1f
[   66.110566] Call Trace:
[   66.110619]  [<ffffffff813f4cde>] notify_remote_via_irq+0x12/0x29
[   66.110680]  [<ffffffff813f5b27>] xen_send_IPI_one+0x2d/0x2f
[   66.110745]  [<ffffffff8100d07e>] xen_send_IPI_self+0x18/0x1a
[   66.110806]  [<ffffffff81012631>] arch_irq_work_raise+0x27/0x36
[   66.110874]  [<ffffffff810e3a1f>] irq_work_queue+0x47/0x6c
[   66.110932]  [<ffffffff810eaf17>] perf_output_put_handle+0x67/0x69
[   66.110993]  [<ffffffff810eb14b>] perf_output_end+0xe/0x10
[   66.111056]  [<ffffffff810e8d1b>] __perf_event_overflow+0x144/0x17f
[   66.111119]  [<ffffffff810e8de6>] perf_swevent_overflow+0x90/0xaa
[   66.111179]  [<ffffffff810e8e47>] perf_swevent_event+0x47/0x49
[   66.111242]  [<ffffffff810e94dd>] perf_tp_event+0x68/0x90
[   66.111305]  [<ffffffff815b3a50>] ? do_page_fault+0x32c/0x3b6
[   66.111370]  [<ffffffff810dd684>] perf_syscall_enter+0xee/0xfd
[   66.111431]  [<ffffffff810d51de>] ? trace_hardirqs_off_caller+0xe/0x22
[   66.111498]  [<ffffffff810196e1>] syscall_trace_enter+0xda/0x165
[   66.111559]  [<ffffffff815b714c>] tracesys+0x7a/0xde
[   66.111615] Code: b9 ae 63 00 72 20 89 f9 31 c0 48 c7 c2 51 9c 84 81 be d0 00 00 00 48 c7 c7 3c 9c 84 81 e8 ab e8 c6 ff 31 c0 eb 09 e8 81 fe ff ff <0f> b7 40 18 5d c3 55 48 89 e5 66 66 66 66 90 e8 b6 ff ff ff 85 
[   66.112831] RIP  [<ffffffff813f49de>] evtchn_from_irq+0x36/0x3c
[   66.112910]  RSP <ffff88006a7b7cc8>
[   66.112963] CR2: 0000000000000018
[   66.113018] ---[ end trace 0acf1969d39ea313 ]---

So IRQ_WORK_VECTOR is being improperly handled by this patch, but at
least we get a message telling what's wrong.

> 
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index d5e0e0a..88815a1 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -65,6 +65,7 @@
> 
>  #include "xen-ops.h"
>  #include "mmu.h"
> +#include "smp.h"
>  #include "multicalls.h"
> 
>  EXPORT_SYMBOL_GPL(hypercall_page);
> @@ -768,6 +769,12 @@ static void set_xen_basic_apic_ops(void)
>  	apic->icr_write = xen_apic_icr_write;
>  	apic->wait_icr_idle = xen_apic_wait_icr_idle;
>  	apic->safe_wait_icr_idle = xen_safe_apic_wait_icr_idle;
> +
> +	apic->send_IPI_allbutself = xen_send_IPI_allbutself;
> +	apic->send_IPI_mask_allbutself = xen_send_IPI_mask_allbutself;
> +	apic->send_IPI_mask = xen_send_IPI_mask;
> +	apic->send_IPI_all = xen_send_IPI_all;
> +	apic->send_IPI_self = xen_send_IPI_self;
>  }
> 
>  #endif
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 3061244..d8928a1 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -436,8 +436,8 @@ static void xen_smp_send_reschedule(int cpu)
>  	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
>  }
> 
> -static void xen_send_IPI_mask(const struct cpumask *mask,
> -			      enum ipi_vector vector)
> +void xen_send_IPI_mask(const struct cpumask *mask,
> +			      int vector)
>  {
>  	unsigned cpu;
> 
> @@ -466,6 +466,39 @@ static void xen_smp_send_call_function_single_ipi(int cpu)
>  			  XEN_CALL_FUNCTION_SINGLE_VECTOR);
>  }
> 
> +void xen_send_IPI_all(int vector)
> +{
> +	xen_send_IPI_mask(cpu_online_mask, vector);
> +}
> +
> +void xen_send_IPI_self(int vector)
> +{
> +	xen_send_IPI_one(smp_processor_id(), vector);
> +}
> +
> +void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
> +				int vector)
> +{
> +	unsigned cpu;
> +	unsigned int this_cpu = smp_processor_id();
> +
> +	if (!(num_online_cpus() > 1))
> +		return;
> +
> +	for_each_cpu_and(cpu, mask, cpu_online_mask) {
> +		if (this_cpu == cpu)
> +			continue;
> +		
> +		xen_smp_send_call_function_single_ipi(cpu);
> +	}
> +}
> +
> +void xen_send_IPI_allbutself(int vector)
> +{
> +	xen_send_IPI_mask_allbutself(cpu_online_mask, vector);
> +}
> +
> +
>  static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
>  {
>  	irq_enter();
> diff --git a/arch/x86/xen/smp.h b/arch/x86/xen/smp.h
> new file mode 100644
> index 0000000..8981a76
> --- /dev/null
> +++ b/arch/x86/xen/smp.h
> @@ -0,0 +1,12 @@
> +#ifndef _XEN_SMP_H
> +
> +extern void xen_send_IPI_mask(const struct cpumask *mask,
> +			      int vector);
> +extern void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
> +				int vector);
> +extern void xen_send_IPI_allbutself(int vector);
> +extern void physflat_send_IPI_allbutself(int vector);
> +extern void xen_send_IPI_all(int vector);
> +extern void xen_send_IPI_self(int vector);
> +
> +#endif
> diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
> index 58ca7ce..4addc80 100644
> --- a/drivers/tty/hvc/hvc_console.c
> +++ b/drivers/tty/hvc/hvc_console.c
> @@ -754,13 +754,10 @@ int hvc_poll_init(struct tty_driver *driver, int
> line, char *options)
> 
>  static int hvc_poll_get_char(struct tty_driver *driver, int line)
>  {
> -	struct tty_struct *tty = driver->ttys[0];
> -	struct hvc_struct *hp = tty->driver_data;
>  	int n;
>  	char ch;
> 
> -	n = hp->ops->get_chars(hp->vtermno, &ch, 1);
> -
> +	n = cons_ops[last_hvc]->get_chars(vtermnos[last_hvc], &ch, 1);
>  	if (n == 0)
>  		return NO_POLL_CHAR;
> 
> @@ -769,12 +766,10 @@ static int hvc_poll_get_char(struct tty_driver
> *driver, int line)
> 
>  static void hvc_poll_put_char(struct tty_driver *driver, int line, char ch)
>  {
> -	struct tty_struct *tty = driver->ttys[0];
> -	struct hvc_struct *hp = tty->driver_data;
>  	int n;
> 
>  	do {
> -		n = hp->ops->put_chars(hp->vtermno, &ch, 1);
> +		n = cons_ops[last_hvc]->put_chars(vtermnos[last_hvc], &ch, 1);
>  	} while (n <= 0);
>  }
>  #endif
> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
> index cefd4a1..df904a5 100644
> --- a/kernel/debug/debug_core.c
> +++ b/kernel/debug/debug_core.c
> @@ -581,12 +581,14 @@ return_normal:
>  		kgdb_roundup_cpus(flags);
>  #endif
> 
> +#ifndef CONFIG_XEN
>  	/*
>  	 * Wait for the other CPUs to be notified and be waiting for us:
>  	 */
>  	while (kgdb_do_roundup && (atomic_read(&masters_in_kgdb) +
>  				atomic_read(&slaves_in_kgdb)) != online_cpus)
>  		cpu_relax();
> +#endif
> 
>  	/*
>  	 * At this point the primary processor is completely
> 
> 
> 
> On Fri, Feb 10, 2012 at 2:04 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >
> > On Fri, Feb 10, 2012 at 06:28:21PM +0100, Peter Zijlstra wrote:
> > > On Thu, 2012-02-09 at 18:32 -0800, Steven Noonan wrote:
> > > > [   88.517599]  [<ffffffff81085a86>] smp_call_function_single+0xec/0xfd
> > >
> > > This looks like its waiting for an IPI to complete..
> >
> > Hmm, Ben you tried some kdb debugging using Xen and ran in some IPI issues
> > didn't you? Do you remember what was the problem?
> >
> > >
> > > There's no actual BUGS or WARNs in the output, just the soft lockup
> > > thing saying things are taking a bit of time (clearly 15s waiting for an
> > > IPI isn't quite normal).
> > >
> > > I've no idea why this wouldn't work on Xen, nor do the trace have any
> > > Xen specific muck in them.
> >
