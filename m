Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2KRSMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 13:12:10 -0500
Received: from londo.lunn.ch ([80.238.139.98]:40153 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab2KRSMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 13:12:08 -0500
Date: Sun, 18 Nov 2012 19:11:40 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Josh Coombs <josh.coombs@gmail.com>
Cc: linux ARM <linux-arm-kernel@lists.infradead.org>, wlanfae@realtek.com,
        Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [Patch v1 1/1] RTL8712 alignment bug in 3.6.5 on ARM
Message-ID: <20121118181140.GC14643@lunn.ch>
References: <CAMW5UfYUi-Zz2r5K9GeVzShSub2rDJVuoWR56+89+ytaqo_uxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMW5UfYUi-Zz2r5K9GeVzShSub2rDJVuoWR56+89+ytaqo_uxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 12:06:40PM -0500, Josh Coombs wrote:
> Starting with 3.6.5 on a Marvell Kirkwood based GoFlex Net I began
> observing scheduler bugs when using a USB based RTL8712 WiFi NIC.
> These would eventually overwhelm systemd's logger under moderate
> network activity and crash the box.
> 
> [   64.312377] BUG: scheduling while atomic: crond/151/0x40000300
> [   79.771862] BUG: scheduling while atomic: swapper/0/0x40000500
> [   81.826267] BUG: scheduling while atomic: swapper/0/0x40000500
> [   90.330911] BUG: scheduling while atomic: swapper/0/0x40000500
> 
> Working with Andrew Lunn we dug in further with full stack traces:
> 
> [   53.173973] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   54.191655] BUG: scheduling while atomic: crond/144/0x40000300
> [   54.197537] Modules linked in: rmd160 sha1_generic hmac
> blowfish_generic blowfish_common sr_mod cdrom fbcon bitblit softcursor
> font udlfb syscopyarea sysfillrect sysimgblt fb_sys_fops fb
> hid_generic snd_usb_audio snd_usbmidi_lib snd_hwdep mct_u232
> snd_rawmidi snd_seq_device snd_pcm snd_page_alloc usbhid usbserial
> snd_timer snd hid soundcore mv_cesa cryptodev(O) ipv6 autofs4
> [   54.231214] [<c000d020>] (unwind_backtrace+0x0/0xe0) from
> [<c03fd1d0>] (__schedule_bug+0x48/0x60)
> [   54.240171] [<c03fd1d0>] (__schedule_bug+0x48/0x60) from
> [<c0401258>] (__schedule+0x4c/0x4bc)
> [   54.248773] [<c0401258>] (__schedule+0x4c/0x4bc) from [<c003b470>]
> (__cond_resched+0x24/0x34)
> [   54.257365] [<c003b470>] (__cond_resched+0x24/0x34) from
> [<c040175c>] (_cond_resched+0x3c/0x44)
> [   54.266134] [<c040175c>] (_cond_resched+0x3c/0x44) from
> [<c0010288>] (do_alignment+0x29c/0x784)
> [   54.274895] [<c0010288>] (do_alignment+0x29c/0x784) from
> [<c00083d8>] (do_DataAbort+0x34/0x98)
> [   54.283571] [<c00083d8>] (do_DataAbort+0x34/0x98) from [<c04022d8>]
> (__dabt_svc+0x38/0x60)
> [   54.291891] Exception stack(0xc4575ac8 to 0xc4575b10)
> [   54.296976] 5ac0:                   00000138 00000000 00000000
> 00000000 c781c200 00000000
> [   54.305209] 5ae0: c7020338 c7000440 c70806e4 0000090e c781c238
> c781c220 00000002 c4575b10
> [   54.313438] 5b00: c035f994 c035f4bc 60000013 ffffffff
> [   54.318536] [<c04022d8>] (__dabt_svc+0x38/0x60) from [<c035f4bc>]
> (r8712_xmitframe_coalesce+0x388/0x8a0)
> [   54.328092] [<c035f4bc>] (r8712_xmitframe_coalesce+0x388/0x8a0)
> from [<c0360648>] (r8712_xmit_direct+0x18/0x40)
> [   54.338256] [<c0360648>] (r8712_xmit_direct+0x18/0x40) from
> [<c035feb4>] (r8712_pre_xmit+0xac/0xb4)
> [   54.347373] [<c035feb4>] (r8712_pre_xmit+0xac/0xb4) from
> [<c035a930>] (r8712_xmit_entry+0x70/0xf0)
> [   54.356410] [<c035a930>] (r8712_xmit_entry+0x70/0xf0) from
> [<c03771cc>] (dev_hard_start_xmit+0x440/0x67c)
> [   54.366056] [<c03771cc>] (dev_hard_start_xmit+0x440/0x67c) from
> [<c038cac4>] (sch_direct_xmit+0x50/0x1a4)
> [   54.375694] [<c038cac4>] (sch_direct_xmit+0x50/0x1a4) from
> [<c03776f4>] (dev_queue_xmit+0x2ec/0x4d8)
> [   54.384993] [<c03776f4>] (dev_queue_xmit+0x2ec/0x4d8) from
> [<bf00c5bc>] (ip6_finish_output2+0x294/0x344 [ipv6])
> [   54.395288] [<bf00c5bc>] (ip6_finish_output2+0x294/0x344 [ipv6])
> from [<bf01ea38>] (ndisc_send_skb+0x110/0x1f4 [ipv6])
> [   54.406202] [<bf01ea38>] (ndisc_send_skb+0x110/0x1f4 [ipv6]) from
> [<bf01f6f8>] (ndisc_send_rs+0x3c/0x44 [ipv6])
> [   54.416493] [<bf01f6f8>] (ndisc_send_rs+0x3c/0x44 [ipv6]) from
> [<bf013470>] (addrconf_dad_completed+0x80/0xc0 [ipv6])
> [   54.427289] [<bf013470>] (addrconf_dad_completed+0x80/0xc0 [ipv6])
> from [<bf013520>] (addrconf_dad_timer+0x70/0x10c [ipv6])
> [   54.438563] [<bf013520>] (addrconf_dad_timer+0x70/0x10c [ipv6])
> from [<c002211c>] (run_timer_softirq+0x1b0/0x2fc)
> [   54.448904] [<c002211c>] (run_timer_softirq+0x1b0/0x2fc) from
> [<c001be6c>] (__do_softirq+0xa0/0x1f8)
> [   54.458103] [<c001be6c>] (__do_softirq+0xa0/0x1f8) from
> [<c001c340>] (irq_exit+0x40/0x8c)
> [   54.466345] [<c001c340>] (irq_exit+0x40/0x8c) from [<c00094d8>]
> (handle_IRQ+0x64/0x84)
> [   54.474322] [<c00094d8>] (handle_IRQ+0x64/0x84) from [<c0402334>]
> (__irq_svc+0x34/0x78)
> [   54.482389] [<c0402334>] (__irq_svc+0x34/0x78) from [<c00be630>]
> (lookup_fast+0x74/0x258)
> [   54.490615] [<c00be630>] (lookup_fast+0x74/0x258) from [<c00c0274>]
> (path_lookupat+0xfc/0x71c)
> [   54.499286] [<c00c0274>] (path_lookupat+0xfc/0x71c) from
> [<c00c08b0>] (do_path_lookup+0x1c/0x5c)
> [   54.508138] [<c00c08b0>] (do_path_lookup+0x1c/0x5c) from
> [<c00c26ec>] (user_path_at_empty+0x54/0x8c)
> [   54.517338] [<c00c26ec>] (user_path_at_empty+0x54/0x8c) from
> [<c00c2734>] (user_path_at+0x10/0x14)
> [   54.526368] [<c00c2734>] (user_path_at+0x10/0x14) from [<c00b95d4>]
> (vfs_fstatat+0x2c/0x5c)
> [   54.534789] [<c00b95d4>] (vfs_fstatat+0x2c/0x5c) from [<c00b97f8>]
> (sys_stat64+0x14/0x30)
> [   54.543027] [<c00b97f8>] (sys_stat64+0x14/0x30) from [<c0008c60>]
> (ret_fast_syscall+0x0/0x2c)
> [   54.831585] BUG: scheduling while atomic: crond/144/0x40000300
> [   54.837464] Modules linked in: rmd160 sha1_generic hmac
> blowfish_generic blowfish_common sr_mod cdrom fbcon bitblit softcursor
> font udlfb syscopyarea sysfillrect sysimgblt fb_sys_fops fb
> hid_generic snd_usb_audio snd_usbmidi_lib snd_hwdep mct_u232
> snd_rawmidi snd_seq_device snd_pcm snd_page_alloc usbhid usbserial
> snd_timer snd hid soundcore mv_cesa cryptodev(O) ipv6 autofs4
> [   54.871168] [<c000d020>] (unwind_backtrace+0x0/0xe0) from
> [<c03fd1d0>] (__schedule_bug+0x48/0x60)
> [   54.880117] [<c03fd1d0>] (__schedule_bug+0x48/0x60) from
> [<c0401258>] (__schedule+0x4c/0x4bc)
> [   54.888714] [<c0401258>] (__schedule+0x4c/0x4bc) from [<c003b470>]
> (__cond_resched+0x24/0x34)
> [   54.897309] [<c003b470>] (__cond_resched+0x24/0x34) from
> [<c040175c>] (_cond_resched+0x3c/0x44)
> [   54.906079] [<c040175c>] (_cond_resched+0x3c/0x44) from
> [<c0010288>] (do_alignment+0x29c/0x784)
> [   54.914839] [<c0010288>] (do_alignment+0x29c/0x784) from
> [<c00083d8>] (do_DataAbort+0x34/0x98)
> [   54.923515] [<c00083d8>] (do_DataAbort+0x34/0x98) from [<c04022d8>]
> (__dabt_svc+0x38/0x60)
> [   54.931832] Exception stack(0xc4575b28 to 0xc4575b70)
> [   54.936917] 5b20:                   00000138 00000000 00000000
> 00000000 c781a200 00000000
> [   54.945153] 5b40: c70203dc c7000440 c70806e4 0000090e c781a238
> c781a220 00000016 c4575b70
> [   54.953381] 5b60: c035f994 c035f4bc 60000013 ffffffff
> [   54.958490] [<c04022d8>] (__dabt_svc+0x38/0x60) from [<c035f4bc>]
> (r8712_xmitframe_coalesce+0x388/0x8a0)
> [   54.968045] [<c035f4bc>] (r8712_xmitframe_coalesce+0x388/0x8a0)
> from [<c0360648>] (r8712_xmit_direct+0x18/0x40)
> [   54.978209] [<c0360648>] (r8712_xmit_direct+0x18/0x40) from
> [<c035feb4>] (r8712_pre_xmit+0xac/0xb4)
> [   54.987320] [<c035feb4>] (r8712_pre_xmit+0xac/0xb4) from
> [<c035a930>] (r8712_xmit_entry+0x70/0xf0)
> [   54.996354] [<c035a930>] (r8712_xmit_entry+0x70/0xf0) from
> [<c03771cc>] (dev_hard_start_xmit+0x440/0x67c)
> [   55.005998] [<c03771cc>] (dev_hard_start_xmit+0x440/0x67c) from
> [<c038cac4>] (sch_direct_xmit+0x50/0x1a4)
> [   55.015636] [<c038cac4>] (sch_direct_xmit+0x50/0x1a4) from
> [<c03776f4>] (dev_queue_xmit+0x2ec/0x4d8)
> [   55.024971] [<c03776f4>] (dev_queue_xmit+0x2ec/0x4d8) from
> [<bf027c34>] (mld_sendpack+0x184/0x300 [ipv6])
> [   55.034774] [<bf027c34>] (mld_sendpack+0x184/0x300 [ipv6]) from
> [<bf028380>] (mld_ifc_timer_expire+0x1e8/0x234 [ipv6])
> [   55.045636] [<bf028380>] (mld_ifc_timer_expire+0x1e8/0x234 [ipv6])
> from [<c002211c>] (run_timer_softirq+0x1b0/0x2fc)
> [   55.056238] [<c002211c>] (run_timer_softirq+0x1b0/0x2fc) from
> [<c001be6c>] (__do_softirq+0xa0/0x1f8)
> [   55.065448] [<c001be6c>] (__do_softirq+0xa0/0x1f8) from
> [<c001c340>] (irq_exit+0x40/0x8c)
> [   55.073691] [<c001c340>] (irq_exit+0x40/0x8c) from [<c00094d8>]
> (handle_IRQ+0x64/0x84)
> [   55.081668] [<c00094d8>] (handle_IRQ+0x64/0x84) from [<c0402334>]
> (__irq_svc+0x34/0x78)
> [   55.089725] [<c0402334>] (__irq_svc+0x34/0x78) from [<c00bfe6c>]
> (path_init+0x4/0x310)
> [   55.097707] [<c00bfe6c>] (path_init+0x4/0x310) from [<c00c01a4>]
> (path_lookupat+0x2c/0x71c)
> [   55.106120] [<c00c01a4>] (path_lookupat+0x2c/0x71c) from
> [<c00c08b0>] (do_path_lookup+0x1c/0x5c)
> [   55.114970] [<c00c08b0>] (do_path_lookup+0x1c/0x5c) from
> [<c00c26ec>] (user_path_at_empty+0x54/0x8c)
> [   55.124170] [<c00c26ec>] (user_path_at_empty+0x54/0x8c) from
> [<c00c2734>] (user_path_at+0x10/0x14)
> [   55.133202] [<c00c2734>] (user_path_at+0x10/0x14) from [<c00b95d4>]
> (vfs_fstatat+0x2c/0x5c)
> [   55.141622] [<c00b95d4>] (vfs_fstatat+0x2c/0x5c) from [<c00b97f8>]
> (sys_stat64+0x14/0x30)
> [   55.149846] [<c00b97f8>] (sys_stat64+0x14/0x30) from [<c0008c60>]
> (ret_fast_syscall+0x0/0x2c)
> 
> This pointed to a non-aligned access, which my patch below corrects.
> I've verified 3.6.4 does not show these symptoms, 3.6.5 and 3.6.6 do,
> with the patch below the bug goes away on my system.
> 
> Tested-by: Joshua Coombs <josh.coombs@gmail.com>

Hi Josh

I don't think Tested-by is sufficient for submitting a patch. It needs
a Signed-off-by: 

Take a look at Documentation/SubmittingPatches

Just to clarify the issue here:

union pn48 {
        u64 val;
#if defined(__BIG_ENDIAN)
        struct {
                u8 TSC7;
                u8 TSC6;

Any instance of pn48 needs to be 64 bit aligned when the val member of
the union is used. The structure sta_info contains two such pn48s, so
the code allocating the pool of these needs to ensure it allocated
them 64 bit aligned, not 32bit aligned as it currently is.

Please add a Acked-by Andrew Lunn <andrew@lunn.ch> to v2 of the patch.

     Andrew


> --
> 
> diff -ruN a/drivers/staging/rtl8712/rtl871x_sta_mgt.c
> b/drivers/staging/rtl8712/rtl871x_sta_mgt.c
> --- a/drivers/staging/rtl8712/rtl871x_sta_mgt.c 2012-11-05
> 03:57:06.000000000 -0500
> +++ b/drivers/staging/rtl8712/rtl871x_sta_mgt.c 2012-11-13
> 12:54:28.000000000 -0500
> @@ -55,8 +55,8 @@
>     NUM_STA + 4);
>   if (pstapriv->pallocated_stainfo_buf == NULL)
>   return _FAIL;
> - pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 4 -
> - ((addr_t)(pstapriv->pallocated_stainfo_buf) & 3);
> + pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 8 -
> + ((addr_t)(pstapriv->pallocated_stainfo_buf) & 7);
>   _init_queue(&pstapriv->free_sta_queue);
>   spin_lock_init(&pstapriv->sta_hash_lock);
>   pstapriv->asoc_sta_count = 0;
