Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1FZJlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 05:41:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64837 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1FZJlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 05:41:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=k5rud/q/wK5HhvlpONWbInOyE3K8MNgSxyHg8e6izv2sZOnjhJ6eRaBXxEyPBq5mK6
         dfKDqNDY/3pBKmNTkA5+IUgJsP9UbkLZy33qH59yrQUWJf2ZZuVJyFYv1jy0MUFOZrBg
         YpKVwjawdzReyL87KbJogEw+qc0/rV04z6IqI=
Message-ID: <4E06FEB3.1010809@lwfinger.net>
Date: Sun, 26 Jun 2011 04:41:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
        Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Regression in 3.0-rc4 (actually 2.6.38) Bisected to commit 625dbc3
References: <4E0604BC.3060002@lwfinger.net>
In-Reply-To: <4E0604BC.3060002@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2011 10:54 AM, Larry Finger wrote:
> While running tests on 3.0-rc4 from the wireless-testing git tree, I tested an
> RTL8187B dongle that had not been used for some time. With it, I got the
> following WARNING:
>
> [291533.186383] ------------[ cut here ]------------
> [291533.186438] WARNING: at arch/x86/kernel/dumpstack_64.c:129
> dump_trace+0x292/0x3a0()
> [291533.186465] Hardware name: HP Pavilion dv2700 Notebook PC
> [291533.186487] Perf: bad frame pointer = 00000000000000cf in callchain
> [291533.186511] Modules linked in: loop aes_x86_64 aes_generic arc4 rtl8187
> mac80211 cfg80211 rfkill eeprom_93cx6 vboxnetadp vboxnetflt vboxdrv fuse
> af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd nfs lockd
> auth_rpcgss nfs_acl sunrpc ipv6 cpufreq_conservative cpufreq_userspace
> cpufreq_powersave powernow_k8 mperf ext4 jbd2 crc16 dm_mod ide_cd_mod cdrom
> snd_hda_codec_conexant ide_pci_generic snd_hda_intel snd_hda_codec snd_pcm
> amd74xx snd_timer snd ide_core forcedeth sg k8temp joydev serio_raw soundcore
> snd_page_alloc battery hwmon i2c_nforce2 ac i2c_core video button ext3 jbd
> mbcache sd_mod ohci_hcd ahci libahci libata ehci_hcd scsi_mod usbcore fan
> processor thermal [last unloaded: r8712u]
> [291533.186859] Pid: 0, comm: kworker/0:0 Tainted: G C 3.0.0-rc4-wl+ #22
> [291533.186885] Call Trace:
> [291533.186900] <IRQ> [<ffffffff81048f4a>] warn_slowpath_common+0x7a/0xb0
> [291533.186940] [<ffffffff81049021>] warn_slowpath_fmt+0x41/0x50
> [291533.186970] [<ffffffff8136e9a8>] ? bad_to_user+0x82/0x668
> [291533.186997] [<ffffffff81004be2>] dump_trace+0x292/0x3a0
> [291533.187028] [<ffffffff8100fd3a>] save_stack_trace+0x2a/0x50
> [291533.187054] [<ffffffff811e3a54>] dma_entry_alloc+0x54/0x90
> [291533.187080] [<ffffffff811e3d06>] debug_dma_map_page+0x86/0x160
> [291533.187142] [<ffffffffa00201ed>] usb_hcd_map_urb_for_dma+0x4ed/0x590 [usbcore]
> [291533.187195] [<ffffffffa0020536>] usb_hcd_submit_urb+0xe6/0x6a0 [usbcore]
> [291533.187229] [<ffffffff8107f87d>] ? trace_hardirqs_off+0xd/0x10
> [291533.187259] [<ffffffff8136a9b7>] ? _raw_spin_unlock_irqrestore+0x57/0x70
> [291533.187308] [<ffffffffa00216e9>] usb_submit_urb+0xe9/0x2c0 [usbcore]
> [291533.187339] [<ffffffffa0726315>] rtl8187b_status_cb+0x65/0x150 [rtl8187]
> [291533.187386] [<ffffffffa001f48f>] usb_hcd_giveback_urb+0x5f/0xe0 [usbcore]
> [291533.187426] [<ffffffffa012ff33>] ehci_urb_done+0x83/0xe0 [ehci_hcd]
> [291533.187460] [<ffffffffa0130325>] qh_completions+0x395/0x4c0 [ehci_hcd]
> [291533.187495] [<ffffffffa0132783>] ehci_work+0xe3/0xb40 [ehci_hcd]
> [291533.187530] [<ffffffffa01349cc>] ehci_irq+0x1cc/0x220 [ehci_hcd]
> [291533.187560] [<ffffffff811139cd>] ? dma_pool_alloc+0x1ed/0x330
> [291533.187603] [<ffffffffa001ed30>] usb_hcd_irq+0x40/0xb0 [usbcore]
> [291533.187635] [<ffffffff810afb4d>] handle_irq_event_percpu+0x5d/0x210
> [291533.187665] [<ffffffff810afd43>] handle_irq_event+0x43/0x70
> [291533.187693] [<ffffffff810b22f9>] ? handle_fasteoi_irq+0x19/0xd0
> [291533.187722] [<ffffffff810b2335>] handle_fasteoi_irq+0x55/0xd0
> [291533.187750] [<ffffffff81004834>] handle_irq+0x44/0xa0
> [291533.187776] [<ffffffff81004448>] do_IRQ+0x58/0xe0
> [291533.187802] [<ffffffff8136ac93>] common_interrupt+0x13/0x13
> [291533.187829] [<ffffffff8136a9b7>] _raw_spin_unlock_irqrestore+0x57/0x70
> [291533.187861] [<ffffffffa01af6c4>] ? enc128+0x34f/0x80b [aes_x86_64]
> [291533.187974] [<ffffffffa06bc5ae>] ? ieee80211_aes_ccm_decrypt+0xbe/0x170
> [mac80211]
> [291533.188031] [<ffffffffa06aaf65>] ? ieee80211_crypto_ccmp_decrypt+0x1a5/0x230
> [mac80211]
> [291533.188094] [<ffffffffa06c18b8>] ? ieee80211_rx_handlers+0x998/0x1fc0
> [mac80211]
> [291533.188128] [<ffffffff812b6036>] ? skb_queue_tail+0x26/0x60
> [291533.188156] [<ffffffff810856fd>] ? trace_hardirqs_on+0xd/0x10
> [291533.188211] [<ffffffffa06c312e>] ?
> ieee80211_prepare_and_rx_handle+0x24e/0x890 [mac80211]
> [291533.188274] [<ffffffffa06c3ad0>] ? ieee80211_rx+0x360/0xb70 [mac80211]
> [291533.188330] [<ffffffffa06c3815>] ? ieee80211_rx+0xa5/0xb70 [mac80211]
> [291533.188382] [<ffffffffa06a5e41>] ? ieee80211_tasklet_handler+0xc1/0xd0
> [mac80211]
> [291533.188418] [<ffffffff8104fb73>] ? tasklet_action+0x73/0x120
> [291533.188445] [<ffffffff810505bd>] ? __do_softirq+0xbd/0x210
> [291533.188472] [<ffffffff8136c6cc>] ? call_softirq+0x1c/0x30
> [291533.188499] [<ffffffff81004915>] ? do_softirq+0x85/0xc0
> [291533.188525] [<ffffffff810509a6>] ? irq_exit+0x96/0xb0
> [291533.188550] [<ffffffff81004451>] ? do_IRQ+0x61/0xe0
> [291533.188576] [<ffffffff8136ac93>] ? common_interrupt+0x13/0x13
> [291533.188602] ------------[ cut here ]------------
>
> This problem may be related to
> https://bugzilla.kernel.org/show_bug.cgi?id=31012 and its corresponding report
> at http://marc.info/?l=linux-kernel&m=129995721014931&w=2. AFAICT, this
> regression has not been resolved.
>
> As this dongle has not been used in some time, I do not know when the regression
> occurred, but I will do some tests to determine that, and then do a bisection.
> In the meantime, any suggestions regarding this problem would be appreciated.
>
> The problem does not occur for an RTL8187L, thus only part of rtl8187 is affected.

The regression happened between 2.6.37 and 2.6.38 and this problem is very 
likely the one mentioned in Bug 31012. I have now bisected the problem to commit 
625dbc3b8acbefefefe27e1d7bbc6e53eb4f3f2d entitled "x86: Save rbp in pt_regs on 
irq entry", thus this is an x86_64 problem. After reverting this patch, 3.0-rc4 
runs correctly.

I don't understand enough about the x86_64 instruction set to know why the frame 
pointer is not being set correctly is some instances.

Thanks,

Larry




