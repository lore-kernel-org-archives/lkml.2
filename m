Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1KUN6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:58:48 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45081 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab1KUN6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:58:47 -0500
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 14:58:46 +0100
Message-ID: <CAJfGthSxanFbL2vKCpOQbP9K5oNAxeaYt7OMdmdoCb4eLQ_Fww@mail.gmail.com>
Subject: softirq oops from b44_poll
From: Xander Hover <lkml@hover.be>
To: peter.p.waskiewicz.jr@intel.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I noticed the small discussion about the b44_poll OOPS and
I also have a uni-processor PC with a broadcom network device (b44)
that causes similar kernel OOPSes.

Here is a (reproducible) trace that still shows up in kernel 3.1.1:

 ------------[ cut here ]------------
    WARNING: at kernel/softirq.c:159 local_bh_enable+0x32/0x79()
    Hardware name: Dimension 2400
    Modules linked in: snd_seq_midi snd_emu10k1_synth snd_emux_synth
snd_seq_virmidi snd_seq_midi_emul snd_seq_oss snd_seq_midi_event
snd_seq snd_pcm_oss snd_mixer_oss bnep rfcomm cryptd aes_i586
aes_generic ecb btusb bluetooth rfkill ppdev snd_emu10k1 snd_rawmidi
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer
snd_page_alloc dcdbas snd_util_mem parport_pc snd_hwdep snd parport
emu10k1_gp rtc_cmos gameport i2c_i801
    Pid: 0, comm: swapper Not tainted 3.1.1-gentoo #1
    Call Trace:
     [<c1022970>] warn_slowpath_common+0x65/0x7a
     [<c102699e>] ? local_bh_enable+0x32/0x79
     [<c1022994>] warn_slowpath_null+0xf/0x13
     [<c102699e>] local_bh_enable+0x32/0x79
     [<c134bfd8>] destroy_conntrack+0x7c/0x9b
     [<c134890b>] nf_conntrack_destroy+0x1f/0x26
     [<c132e3a6>] skb_release_head_state+0x74/0x83
     [<c132e286>] __kfree_skb+0xb/0x6b
     [<c132e30a>] consume_skb+0x24/0x26
     [<c127c925>] b44_poll+0xaa/0x449
     [<c1333ca1>] net_rx_action+0x3f/0xea
     [<c1026a44>] __do_softirq+0x5f/0xd5
     [<c10269e5>] ? local_bh_enable+0x79/0x79
     <IRQ>  [<c1026c32>] ? irq_exit+0x34/0x8d
     [<c1003628>] ? do_IRQ+0x74/0x87
     [<c13f5329>] ? common_interrupt+0x29/0x30
     [<c1006e18>] ? default_idle+0x29/0x3e
     [<c10015a7>] ? cpu_idle+0x2f/0x5d
     [<c13e91c5>] ? rest_init+0x79/0x7b
     [<c15c66a9>] ? start_kernel+0x297/0x29c
     [<c15c60b0>] ? i386_start_kernel+0xb0/0xb7
    ---[ end trace 583f33bb1aa207a9 ]---


However if I apply the following patch this error does not show up anymore:


diff --git a/drivers/net/ethernet/broadcom/b44.c
b/drivers/net/ethernet/broadcom/b44.c
index 4cf835d..3fb66d0 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -608,7 +608,7 @@ static void b44_tx(struct b44 *bp)
                                 skb->len,
                                 DMA_TO_DEVICE);
                rp->skb = NULL;
-               dev_kfree_skb(skb);
+               dev_kfree_skb_irq(skb);
        }

        bp->tx_cons = cons;
--
1.7.8.rc3


This is a "works for me..", however it may very well be that this only
suppresses the symptoms instead of solving the root cause.
I got this idea from a previous patch (see commit log below) which did
the exact opposite from this patch.

--------------
commit 4924f44b97a034dbf44c14b709b0b0907ee23f04
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Mon Jul 4 17:57:10 2011 -0700

    b44: use dev_kfree_skb() in b44_tx()

    b44_tx() is run from softirq handler, it can use dev_kfree_skb() instead
    of dev_kfree_skb_irq()
--------------

Any thoughts?

Kind regards,

Xander Hover
