Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1A3TO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 14:14:56 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:39499 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752814Ab1A3TOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 14:14:54 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19sBFNDxkxsKDH1sjIZTcvUkX2+Lx6Clz2g8zaFPb
	h5RY6Dld4ItnkZ
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH] char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered driver
Date: Sun, 30 Jan 2011 20:14:49 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, openipmi-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@kernel.org
References: <1294587680-1924-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1294587680-1924-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101302014.49507.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 09 Januar 2011, 16:41:20 schrieb Peter Huewe:
> This patch fixes an OOPS triggered when calling modprobe ipmi_si a
> second time after the first modprobe returned without finding any ipmi
> devices.
> 
> The OOPS is caused by calling pnp_unregister_driver on a (possibly)
> unregistered pnp driver. (Although I'm not sure why it works the first
> time)
> 
> IPMI System Interface driver.
> ipmi_si: Adding default-specified kcs state machine
> ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2,
> slave address 0x0, irq 0 ipmi_si: Interface detection failed
> ipmi_si: Adding default-specified smic state machine
> ipmi_si: Trying default-specified smic state machine at i/o address 0xca9,
> slave address 0x0, irq 0 ipmi_si: Interface detection failed
> ipmi_si: Adding default-specified bt state machine
> ipmi_si: Trying default-specified bt state machine at i/o address 0xe4,
> slave address 0x0, irq 0 ipmi_si: Interface detection failed
> ipmi_si: Unable to find any System Interface(s)
> 
> IPMI System Interface driver.
> BUG: unable to handle kernel paging request at c9ccb990
> IP: [<c1380c98>] put_driver+0x8/0x20
> *pde = 05e2f067 *pte = 00000000
> Oops: 0000 [#1]
> last sysfs file: /sys/module/ipmi_msghandler/initstate
> Modules linked in: ipmi_si(+) ipmi_msghandler snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss ipv6 pcmcia
> pcmcia_core lp fuse snd_ens1371 snd_via82xx gameport snd_ac97_codec
> ac97_bus snd_pcm ppdev snd_timer snd_mpu401_uart snd_rawmidi
> snd_seq_device snd via686a snd_page_alloc hwmon soundcore parport_pc
> shpchp rtc_cmos psmouse rtc_core parport rtc_lib button evdev serio_raw sg
> [last unloaded: pcmcia_core]
> 
> Pid: 1653, comm: insmod Not tainted 2.6.37 #1 8363-686A/VT8363
> EIP: 0060:[<c1380c98>] EFLAGS: 00010286 CPU: 0
> EIP is at put_driver+0x8/0x20
> EAX: c9ccb960 EBX: c12cc2e0 ECX: 00000000 EDX: c9ccb960
> ESI: c9ceb960 EDI: 00000000 EBP: c5e8fee0 ESP: c5e8fee0
>  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
> Process insmod (pid: 1653, ti=c5e8e000 task=c6e0a000 task.ti=c5e8e000)
> Stack:
>  c5e8ff04 c1380db5 c1118ba3 c9ceb8c0 c5e8fef8 c1380e99 00000000 00000004
>  00000000 c5e8ff0c c12cc49c c5e8ff58 c9ce9640 c9cea71c 000001a4 00000000
>  c9ceb65c c19fc3f8 fffffffc 00000000 c5e8ff38 c107b185 c5e8ff54 c105063c
> Call Trace:
>  [<c1380db5>] ? driver_register+0x105/0x130
>  [<c1118ba3>] ? sysfs_create_file+0x33/0x40
>  [<c1380e99>] ? driver_create_file+0x19/0x20
>  [<c12cc49c>] ? pnp_register_driver+0x1c/0x20
>  [<c9ce9640>] ? init_ipmi_si+0x294/0x88f [ipmi_si]
>  [<c107b185>] ? tracepoint_module_notify+0x25/0x30
>  [<c105063c>] ? notifier_call_chain+0x4c/0x70
>  [<c1001206>] ? do_one_initcall+0x116/0x160
>  [<c9ce93ac>] ? init_ipmi_si+0x0/0x88f [ipmi_si]
>  [<c1062f41>] ? sys_init_module+0x91/0x1d0
>  [<c17b7ebc>] ? syscall_call+0x7/0xb
> Code: 01 00 00 c7 04 24 c7 1c 91 c1 e8 64 14 cb ff 83 c4 0c 5b 5e c9 c3 8d
> b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 3e 8d 74 26 00 <8b> 40 30 e8
> 70 18 ee ff c9 c3 8d b4 26 00 00 00 00 8d bc 27 00 EIP: [<c1380c98>]
> put_driver+0x8/0x20 SS:ESP 0068:c5e8fee0
> CR2: 00000000c9ccb990
> ---[ end trace 9b4a0dc647b099c4 ]---
> 
> Since the OOPS occurs in the current 2.6.37 release, I added stable on
> CC.
> The code exists in this form since 27d0567ab6 (2009-12-17), but could
> not reproduce it in 2.6.33.
> 
> KernelVersion: 2.6.37
> Cc: <stable@kernel.org>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/char/ipmi/ipmi_si_intf.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c
> b/drivers/char/ipmi/ipmi_si_intf.c index 035da9e..26c46af 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -3440,6 +3440,11 @@ static int __devinit init_ipmi_si(void)
>  			pci_unregister_driver(&ipmi_pci_driver);
>  #endif
> 
> +#ifdef CONFIG_ACPI
> +		if (pnp_registered)
> +			pnp_unregister_driver(&ipmi_pnp_driver);
> +#endif
> +
>  #ifdef CONFIG_PPC_OF
>  		if (of_registered)
>  			of_unregister_platform_driver(&ipmi_of_platform_driver);


Ping? 
Any updates on this one?

Thanks,
Peter
