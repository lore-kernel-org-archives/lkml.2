Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1HPOGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 10:06:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37671 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752532Ab1HPOGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 10:06:44 -0400
Date: Tue, 16 Aug 2011 10:06:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [Regression] GPF in usb_driver_release_interface during/after
 resume
In-Reply-To: <201108152252.49863.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1108160956170.2028-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011, Rafael J. Wysocki wrote:

> Hi,
> 
> I get the following general protection fault sometimes (but sufficiently
> often for it to be annoying) during resume from system suspend on Toshiba
> Portege R500:
> 
> [  330.839651] PM: Finishing wakeup.
> [  330.839656] Restarting tasks ... 
> [  330.839742] e1000e 0000:01:00.0: PME# enabled
> [  330.840121] usb 2-2: USB disconnect, device number 3
> [  330.841626] option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
> [  330.841835] option 2-2:1.0: device disconnected
> [  330.842626] option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
> [  330.842770] option 2-2:1.1: device disconnected
> [  330.843506] option1 ttyUSB2: GSM modem (1-port) converter now disconnected from ttyUSB2
> [  330.843648] option 2-2:1.2: device disconnected
> [  330.857550] done.
> [  330.857591] video LNXVIDEO:00: Restoring backlight state
> [  330.915075] option1 ttyUSB3: GSM modem (1-port) converter now disconnected from ttyUSB3
> [  330.924372] option 2-2:1.3: device disconnected
> [  330.964520] usb 5-2: USB disconnect, device number 4
> [  331.218859] general protection fault: 0000 [#1] PREEMPT SMP 
> [  331.218889] CPU 0 
> [  331.218894] Modules linked in: bnep cryptd aes_x86_64 aes_generic xt_tcpudp xt_pkttype af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq microcode freq_table mperf fuse dm_mod sr_mod cdrom arc4 joydev btusb bluetooth option usb_wwan iwl4965 pcmcia iwl_legacy mac80211 psmouse snd_hda_codec_realtek usbhid serio_raw sdhci_pci usb_storage hid usbserial sdhci firewire_ohci snd_hda_intel yenta_socket snd_hda_codec pcmcia_rsrc sg firewire_core mmc_core snd_hwdep pcmcia_core crc_itu_t cfg80211 snd_pcm iTCO_wdt iTCO_vendor_support snd_timer snd soundcore e1000e rfkill snd_page_alloc toshiba_bluetooth battery ac uhci_hcd sd_mod crc_t10dif ehci_hcd usbcore rtc_cmos ext3 jbd ahci libahci libata fan processor thermal
> [  331.219207] 
> [  331.219216] Pid: 906, comm: khubd Not tainted 2.6.39+ #388 TOSHIBA PORTEGE R500/Portable PC
> [  331.219237] RIP: 0010:[<ffffffffa00c5bd1>]  [<ffffffffa00c5bd1>] usb_driver_release_interface+0x32/0x9f [usbcore]
> [  331.219289] RSP: 0018:ffff880078899be0  EFLAGS: 00010282
> [  331.219301] RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6b RCX: 0000000000000006
> [  331.219314] RDX: 0000000000000006 RSI: 00000000000001e3 RDI: ffffffffa0011020
> [  331.219327] RBP: ffff880078899c00 R08: ffff880078899be0 R09: 09f911029d74e35b
> [  331.219341] R10: ffff880078899bb0 R11: 0000000000000000 R12: ffff88007a5e6548
> [  331.219354] R13: ffff880040a8d000 R14: ffffffffa0011020 R15: ffffffffa00110b8
> [  331.219368] FS:  0000000000000000(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
> [  331.219382] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  331.219394] CR2: 00007f4b2fd01080 CR3: 0000000079cf9000 CR4: 00000000000006f0
> [  331.219407] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  331.219420] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  331.219434] Process khubd (pid: 906, threadinfo ffff880078898000, task ffff88003798ee80)
> [  331.219448] Stack:
> [  331.219455]  ffff880078899c00 ffff880037070388 ffff88007a5e6548 ffff880040a8d000
> [  331.219477]  ffff880078899c30 ffffffffa000fdb4 ffff88007a5e6578 ffff88007a5e6578
> [  331.219497]  ffff88007a5e6548 ffff88007856c188 ffff880078899c70 ffffffffa00c5af0
> [  331.219518] Call Trace:
> [  331.219535]  [<ffffffffa000fdb4>] btusb_disconnect+0x9c/0xc2 [btusb]
> [  331.219566]  [<ffffffffa00c5af0>] usb_unbind_interface+0x5a/0x109 [usbcore]
> [  331.219590]  [<ffffffff812a3818>] __device_release_driver+0x81/0xca
> [  331.219606]  [<ffffffff812a387a>] device_release_driver+0x19/0x26
> [  331.219622]  [<ffffffff812a33e1>] bus_remove_device+0xc2/0xd3
> [  331.219637]  [<ffffffff812a0e96>] device_del+0x12b/0x17a
> [  331.219666]  [<ffffffffa00c477f>] usb_disable_device+0x8a/0x176 [usbcore]
> [  331.219695]  [<ffffffffa00bdac4>] usb_disconnect+0xcd/0x137 [usbcore]
> [  331.219724]  [<ffffffffa00bf1c2>] hub_thread+0x74b/0x113e [usbcore]
> [  331.219745]  [<ffffffff81033ab7>] ? get_parent_ip+0x11/0x41
> [  331.219760]  [<ffffffff8102c835>] ? need_resched+0x1e/0x28
> [  331.219777]  [<ffffffff81057f49>] ? wake_up_bit+0x25/0x25
> [  331.219804]  [<ffffffffa00bea77>] ? usb_new_device+0x1ca/0x1ca [usbcore]
> [  331.219821]  [<ffffffff81057aa9>] kthread+0x7d/0x85
> [  331.219838]  [<ffffffff8136af54>] kernel_thread_helper+0x4/0x10
> [  331.219854]  [<ffffffff81369a44>] ? retint_restore_args+0xe/0xe
> [  331.219870]  [<ffffffff81057a2c>] ? __init_kthread_worker+0x56/0x56
> [  331.219885]  [<ffffffff8136af50>] ? gs_change+0xb/0xb
> [  331.219896] Code: 54 53 48 89 f3 48 83 ec 08 be e3 01 00 00 48 85 db 74 0a 48 85 ff 75 13 be e6 01 00 00 48 c7 c7 9c 25 0d a0 e8 b6 6d f7 e0 eb 65 
> [  331.219983]  8b 83 20 01 00 00 48 85 c0 74 59 48 81 c7 98 00 00 00 48 39 
> [  331.220031] RIP  [<ffffffffa00c5bd1>] usb_driver_release_interface+0x32/0x9f [usbcore]
> [  331.220065]  RSP <ffff880078899be0>
> [  331.240771] ---[ end trace be6a0c945bcc56b9 ]---
> 
> This started to happen during the 3.0 development cycle, as far as I can say.
> 
> According to GDB, usb_driver_release_interface+0x32 is line 484 in
> drivers/usb/core/driver.c:
> 
> void usb_driver_release_interface(struct usb_driver *driver,
>                                         struct usb_interface *iface)
> {
>         struct device *dev = &iface->dev;
> 
>         /* this should never happen, don't release something that's not ours */
> --->    if (!dev->driver || dev->driver != &driver->drvwrap.driver)
> 
> so this looks like a use-after-free to me and since it doesn't occur every
> time, there seems to be a race condition in the USB stack.

That's what it looks like to me too.  But I don't see how iface could 
have been freed at this point, because the USB core still has a 
reference to it.

> I tried to figure it out myself, but apparently it's too tricky to me. :-)

Does the same thing happen if you simply unload the btusb driver, 
without suspending?

Also, can you add some debugging statements to
drivers/bluetooth/btusb.c?  in btusb_disconnect(), it would be good to
see the values of intf, data, data->intf, and data->isoc.  In addition
(with caution), data->intf->dev.driver and data->isoc->dev.driver.

Alan Stern

