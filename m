Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1CTSmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 14:42:24 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36645 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073Ab1CTSmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 14:42:22 -0400
X-Sasl-enc: K56U8L3yGw6id7YJWXwdsrYIaAfASItpcdkroDoVCmit 1300646541
Message-ID: <4D864A82.4090104@fastmail.fm>
Date: Sun, 20 Mar 2011 18:42:10 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Mac <kmac@poczta.fm>
CC: linux-kernel@vger.kernel.org, linux-ppp@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 'scheduling while atomic' during ppp connection on 2.6.37.1 and
 2.6.38
References: <fuopaigyaypsqveewtjx@pwmq>
In-Reply-To: <fuopaigyaypsqveewtjx@pwmq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/19/2011 10:06 PM, Mac wrote:
>   dmesg returned:
>
>      [ 9229.131031] BUG: scheduling while atomic: firefox-bin/1992/0x10000800
>      [ 9229.131035] Modules linked in: ppp_async crc_ccitt ppp_generic slhc snd_hda_codec_realtek ath5k ath processor battery ac snd_hda_intel r8169 sdhci_pci sparse_keymap sdhci snd_hda_codec mmc_core nozomi container snd_hwdep
>      [ 9229.131076] Pid: 1992, comm: firefox-bin Not tainted 2.6.38 #1
>      [ 9229.131079] Call Trace:
>      [ 9229.131089]  [] ? schedule+0x67/0x3db
>      [ 9229.131095]  [] ? nf_conntrack_tuple_taken+0xa2/0xad
>      [ 9229.131102]  [] ? __cond_resched+0x1c/0x25
>      [ 9229.131105]  [] ? _cond_resched+0x16/0x20
>      [ 9229.131109]  [] ? mutex_lock+0xe/0x21
>      [ 9229.131116]  [] ? ntty_write+0x5d/0x192 [nozomi]
>      [ 9229.131121]  [] ? __mod_timer.clone.30+0xbe/0xcc
>      [ 9229.131126]  [] ? check_preempt_curr+0x60/0x6d
>      [ 9229.131130]  [] ? __nf_ct_refresh_acct+0x75/0xbe
>      [ 9229.131135]  [] ? ppp_async_push+0xa9/0x3bd [ppp_async]
>      [ 9229.131140]  [] ? ppp_async_send+0x34/0x40 [ppp_async]
>      [ 9229.131146]  [] ? ppp_push+0x6c/0x4f9 [ppp_generic]
>      [ 9229.131152]  [] ? selinux_ip_postroute+0x3d/0x210
>      [ 9229.131156]  [] ? ipt_do_table+0x300/0x328
>      [ 9229.131162]  [] ? _local_bh_enable_ip.clone.10+0x1f/0x88
>      [ 9229.131166]  [] ? ipt_do_table+0x300/0x328
>      [ 9229.131171]  [] ? ppp_xmit_process+0x3f5/0x472 [ppp_generic]
>      [ 9229.131176]  [] ? ppp_start_xmit+0x155/0x174 [ppp_generic]
>      [ 9229.131181]  [] ? dev_hard_start_xmit+0x3c7/0x4a0
>      [ 9229.131186]  [] ? sch_direct_xmit+0x3e/0xee
>      [ 9229.131190]  [] ? dev_queue_xmit+0x1cd/0x322
>      [ 9229.131194]  [] ? ip_queue_xmit+0x2d4/0x330
>      [ 9229.131200]  [] ? file_update_time+0x30/0x101
>      [ 9229.131204]  [] ? tcp_transmit_skb+0x6ee/0x721
>      [ 9229.131208]  [] ? tcp_write_xmit+0x765/0x851
>      [ 9229.131213]  [] ? __alloc_skb+0x81/0x121
>      [ 9229.131217]  [] ? __tcp_push_pending_frames+0x18/0x44
>      [ 9229.131221]  [] ? tcp_close+0x127/0x2f7
>      [ 9229.131226]  [] ? inet_release+0x53/0x5c
>      [ 9229.131231]  [] ? sock_release+0x19/0x6e
>      [ 9229.131234]  [] ? sock_close+0x22/0x29
>      [ 9229.131239]  [] ? fput+0xf8/0x19a
>      [ 9229.131243]  [] ? filp_close+0x5d/0x68
>      [ 9229.131246]  [] ? sys_close+0x6f/0x9e
>      [ 9229.131251]  [] ? system_call_fastpath+0x16/0x1b
Can you try the following patch?

[ Greg, I think this is the correct fix but you know more than me.]

Thanks,

Jack

diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index f4f1116..78a1ab3 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -364,8 +364,6 @@ struct port {
      u8 toggle_ul;
      u16 token_dl;

-    /* mutex to ensure one access patch to this port */
-    struct mutex tty_sem;
      wait_queue_head_t tty_wait;
      struct async_icount tty_icount;

@@ -1474,7 +1472,6 @@ static int __devinit nozomi_card_init(struct 
pci_dev *pdev,
          struct device *tty_dev;
          struct port *port = &dc->port[i];
          port->dc = dc;
-        mutex_init(&port->tty_sem);
          tty_port_init(&port->port);
          port->port.ops = &noz_tty_port_ops;
          tty_dev = tty_register_device(ntty_driver, dc->index_start + i,
@@ -1688,7 +1685,7 @@ static int ntty_write(struct tty_struct *tty, 
const unsigned char *buffer,
      if (!dc || !port)
          return -ENODEV;

-    mutex_lock(&port->tty_sem);
+    spin_lock_irqsave(&dc->spin_mutex, flags);

      if (unlikely(!port->port.count)) {
          DBG1(" ");
@@ -1703,7 +1700,6 @@ static int ntty_write(struct tty_struct *tty, 
const unsigned char *buffer,
          goto exit;
      }

-    spin_lock_irqsave(&dc->spin_mutex, flags);
      /* CTS is only valid on the modem channel */
      if (port == &(dc->port[PORT_MDM])) {
          if (port->ctrl_dl.CTS) {
@@ -1716,10 +1712,9 @@ static int ntty_write(struct tty_struct *tty, 
const unsigned char *buffer,
      } else {
          enable_transmit_ul(tty->index % MAX_PORT, dc);
      }
-    spin_unlock_irqrestore(&dc->spin_mutex, flags);

  exit:
-    mutex_unlock(&port->tty_sem);
+    spin_unlock_irqrestore(&dc->spin_mutex, flags);
      return rval;
  }

@@ -1736,13 +1731,14 @@ static int ntty_write_room(struct tty_struct *tty)
  {
      struct port *port = tty->driver_data;
      int room = 4096;
-    const struct nozomi *dc = get_dc_by_tty(tty);
+    struct nozomi *dc = get_dc_by_tty(tty);
+    unsigned long flags;

      if (dc) {
-        mutex_lock(&port->tty_sem);
+        spin_lock_irqsave(&dc->spin_mutex, flags);
          if (port->port.count)
              room = kfifo_avail(&port->fifo_ul);
-        mutex_unlock(&port->tty_sem);
+        spin_unlock_irqrestore(&dc->spin_mutex, flags);
      }
      return room;
  }

