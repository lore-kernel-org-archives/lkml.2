Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2EAKvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 06:51:23 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57135 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723Ab2EAKvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 06:51:21 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2012 06:51:21 EDT
X-Sasl-enc: B/YPkd4iG/lpBYRdEN3vyyCEO4Sou1id5D62Vu/z/jPr 1335868895
Message-ID: <4F9FBDD0.7050504@ladisch.de>
Date: Tue, 01 May 2012 12:41:20 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: deadlock in vt_kbd_con_stop
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pressing the Scroll Lock key in the console stops scrolling rather permanently.
(Ctrl+S/Q works fine.)

=============================================
[ INFO: possible recursive locking detected ]
3.4.0-rc5+ #354 Not tainted
---------------------------------------------
swapper/5/0 is trying to acquire lock:
 (kbd_event_lock){-.....}, at: [<ffffffff8127802c>] vt_kbd_con_stop+0x1a/0x57

but task is already holding lock:
 (kbd_event_lock){-.....}, at: [<ffffffff81277a84>] kbd_event+0x29/0x5b7

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(kbd_event_lock);
  lock(kbd_event_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by swapper/5/0:
 #0:  (&serio->lock){-.....}, at: [<ffffffff813abbd1>] serio_interrupt+0x24/0x7c
 #1:  (&(&dev->event_lock)->rlock#2){-.....}, at: [<ffffffff813b141a>] input_event+0x3a/0x7c
 #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff813afc20>] input_pass_event+0x0/0x128
 #3:  (kbd_event_lock){-.....}, at: [<ffffffff81277a84>] kbd_event+0x29/0x5b7

stack backtrace:
Pid: 0, comm: swapper/5 Not tainted 3.4.0-rc5+ #354
Call Trace:
 <IRQ>  [<ffffffff81029562>] ? vprintk+0x3ac/0x404
 [<ffffffff8106a3ed>] validate_chain+0x6ca/0xe6b
 [<ffffffff8106a9d5>] ? validate_chain+0xcb2/0xe6b
 [<ffffffff8106b417>] __lock_acquire+0x889/0x8fa
 [<ffffffff8106b417>] ? __lock_acquire+0x889/0x8fa
 [<ffffffff8106b4df>] lock_acquire+0x57/0x6d
 [<ffffffff8127802c>] ? vt_kbd_con_stop+0x1a/0x57
 [<ffffffff8148ddd8>] _raw_spin_lock_irqsave+0x46/0x58
 [<ffffffff8127802c>] ? vt_kbd_con_stop+0x1a/0x57
 [<ffffffff8127802c>] vt_kbd_con_stop+0x1a/0x57
 [<ffffffff8127c0f5>] con_stop+0x26/0x28
 [<ffffffff8126aad0>] stop_tty+0xa4/0xac
 [<ffffffff81277823>] fn_hold+0x2a/0x2c
 [<ffffffff812769d9>] k_spec+0x38/0x3a
 [<ffffffff81277f7b>] kbd_event+0x520/0x5b7
 [<ffffffff813afcde>] input_pass_event+0xbe/0x128
 [<ffffffff813afc20>] ? input_handler_for_each_handle+0xcd/0xcd
 [<ffffffff813b12e8>] input_handle_event+0x42a/0x439
 [<ffffffff813b143b>] input_event+0x5b/0x7c
 [<ffffffff813b7d8d>] atkbd_interrupt+0x50f/0x5de
 [<ffffffff813abbed>] serio_interrupt+0x40/0x7c
 [<ffffffff813ac992>] i8042_interrupt+0x289/0x2a3
 [<ffffffff8107e594>] handle_irq_event_percpu+0x34/0x133
 [<ffffffff8107e6cf>] handle_irq_event+0x3c/0x5c
 [<ffffffff81080c4b>] handle_edge_irq+0xc7/0xec
 [<ffffffff8100378e>] handle_irq+0x122/0x130
 [<ffffffff810459be>] ? atomic_notifier_call_chain+0xf/0x11
 [<ffffffff81002eb3>] do_IRQ+0x48/0xaf
 [<ffffffff8148e6ac>] common_interrupt+0x6c/0x6c
 <EOI>  [<ffffffff81008ff0>] ? default_idle+0x29/0x43
 [<ffffffff81008fee>] ? default_idle+0x27/0x43
 [<ffffffff81009155>] amd_e400_idle+0xcd/0xf4
 [<ffffffff81009289>] cpu_idle+0x73/0xb8
 [<ffffffff8148674c>] start_secondary+0x225/0x227
