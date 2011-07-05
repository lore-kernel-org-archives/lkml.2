Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1GESpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 14:45:44 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:38956 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab1GESpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 14:45:43 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Hank Janssen <hjanssen@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        stable <stable@kernel.org>
Subject: RE: [PATCH 5/5] staging: hv: fix a kernel warning in
 netvsc_linkstatus_callback()
Thread-Topic: [PATCH 5/5] staging: hv: fix a kernel warning in
 netvsc_linkstatus_callback()
Thread-Index: AQHMLPzdqi1EZ1AAa0iE5UK5LWgnTJTed2KA//+0e8A=
Date: Tue, 5 Jul 2011 18:45:41 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0964C6AB@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
 <1308322688-9796-5-git-send-email-haiyangz@microsoft.com>
 <20110705161007.GA24332@kroah.com>
In-Reply-To: <20110705161007.GA24332@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.34]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, July 05, 2011 12:10 PM
> To: Haiyang Zhang
> Cc: Hank Janssen; KY Srinivasan; Abhishek Kane (Mindtree Consulting PVT
> LTD); gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; stable
> Subject: Re: [PATCH 5/5] staging: hv: fix a kernel warning in
> netvsc_linkstatus_callback()
> 
> On Fri, Jun 17, 2011 at 07:58:08AM -0700, Haiyang Zhang wrote:
> > netif_notify_peers() is not allowed in netvsc_linkstatus_callback() on
> some
> > distros,
> 
> "distros"?  Huh?  You mean kernel versions right?
> 
> And this doesn't matter for the current kernel, right?  If not, then it
> doesn't need to be applied.  If so, then it should.  Which is it?

It should be applied to both current kernel and stable kernels 2.6.32 and later.

> > because netvsc_linkstatus_callback() is within IRQ context. So we
> > move the first call to netif_notify_peers() into queued work as well,
> but with
> > zero delay.
> 
> What happens if you don't have this patch applied?  What breaks?  Is it
> just a warning?  Something else?

Without the patch, it will have this warning:

[  232.102605] WARNING: at kernel/mutex.c:198 __mutex_lock_slowpath+0x28d/0x2c0(
)
[  232.102605] Hardware name: Virtual Machine
[  232.272436] Modules linked in: hv_netvsc(C) hv_vmbus(C) lockd sunrpc nf_connt
rack_netbios_ns nf_conntrack_broadcast ipt_REJECT nf_conntrack_ipv4 nf_defrag_ip
v4 xt_state nf_conntrack iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table
_filter ip6_tables x_tables ipv6 loop dm_mirror dm_multipath scsi_dh video therm
al sbs sbshc pci_slot hed fan container battery acpi_memhotplug ac power_supply
parport nvram sg sr_mod cdrom evdev processor button serio_raw floppy tpm_tis tp
m tpm_bios tulip i2c_piix4 i2c_core dm_region_hash dm_log dm_mod ide_gd_mod piix
 pata_acpi ide_pci_generic ide_core ata_piix ata_generic libata sd_mod scsi_mod
ext3 jbd mbcache [last unloaded: microcode]
[  232.935109] Pid: 0, comm: swapper Tainted: G         C  3.0.0-rc2-stable-0019
6-g06e8684 #4
[  232.939905] Call Trace:
[  232.942238]  [<c13008fd>] ? __mutex_lock_slowpath+0x28d/0x2c0
[  232.974990]  [<c1041a9c>] warn_slowpath_common+0x7c/0xa0
[  232.977701]  [<c13008fd>] ? __mutex_lock_slowpath+0x28d/0x2c0
[  232.980431]  [<c1041add>] warn_slowpath_null+0x1d/0x20
[  232.983403]  [<c13008fd>] __mutex_lock_slowpath+0x28d/0x2c0
[  232.995597]  [<c130093b>] mutex_lock+0xb/0x20
[  233.020191]  [<c127347d>] rtnl_lock+0xd/0x10
[  233.023275]  [<c127cf7b>] netif_notify_peers+0xb/0x20
[  233.026424]  [<e0e581d2>] netvsc_linkstatus_callback+0x142/0x230 [hv_netvsc]
[  233.051372]  [<e0e5c0df>] rndis_filter_receive+0x83f/0x8e0 [hv_netvsc]
[  233.062010]  [<e0e3c82e>] ? hv_ringbuffer_read+0x15e/0x200 [hv_vmbus]
[  233.065632]  [<e0e5a936>] netvsc_channel_cb+0x8e6/0xb10 [hv_netvsc]
[  233.069444]  [<e0e38743>] vmbus_onchannel_event+0x33/0x80 [hv_vmbus]
[  233.092295]  [<e0e37bb8>] vmbus_on_event+0xf8/0x180 [hv_vmbus]
[  233.104314]  [<c104850f>] tasklet_action+0x4f/0x100
[  233.106669]  [<c1047876>] __do_softirq+0x86/0x1e0
[  233.109376]  [<c10477f0>] ? local_bh_enable_ip+0xa0/0xa0
[  233.112031]  <IRQ>  [<c1047b6c>] ? irq_exit+0x8c/0xa0
[  233.133300]  [<c10040a5>] ? do_IRQ+0x45/0xb0
[  233.136307]  [<c1047b4e>] ? irq_exit+0x6e/0xa0
[  233.138901]  [<c101d149>] ? smp_apic_timer_interrupt+0x59/0x90
[  233.142796]  [<c1302db0>] ? common_interrupt+0x30/0x38
[  233.146401]  [<c1024be5>] ? native_safe_halt+0x5/0x10
[  233.149765]  [<c1009b00>] ? default_idle+0x70/0x130
[  233.154054]  [<c1001dda>] ? cpu_idle+0x8a/0xd0
[  233.157170]  [<c12eb4dd>] ? rest_init+0x7d/0x80
[  233.168628]  [<c14239e5>] ? start_kernel+0x315/0x3d0
[  233.171518]  [<c1423270>] ? parse_early_options+0x30/0x30
[  233.180398]  [<c1423078>] ? i386_start_kernel+0x78/0xc0
[  233.183514] ---[ end trace 3a5b5bc7486ad570 ]---
 
> Please resend this with more information.
Will do (after Ky's patch series are resubmitted and applied).

Thanks,

- Haiyang

