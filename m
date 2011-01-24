Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab1AXJ0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 04:26:08 -0500
Received: from mailout00.t-online.de ([194.25.134.16]:41951 "EHLO
	mailout00.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1AXJ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 04:26:07 -0500
Message-ID: <4D3D45A3.7040809@t-online.de>
Date: Mon, 24 Jan 2011 10:25:55 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: paulus@samba.org, mostrows@earthlink.net, linux-ppp@vger.kernel.org
Subject: [BUG] 2.6.38-rc2: Circular Locking Dependency
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-ID: TcGUnOZBYhBjWWSnInwkitTrzrGSbkyxWqmay2ykq+uRrY2oo81xkwZwCkwHVt3wAC
X-TOI-MSGID: ed07c19b-5e37-48f1-8599-f5fa3d5e72bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I was hunting something different I found the following (potential)
problem on an openSuSE 11.3 system with kernel 2.6.38-rc2.
The message is triggerd by smpppd starting a dsl connection.

Knut


 NET: Registered protocol family 24

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.38-rc2-kape #7
 -------------------------------------------------------
 pppd/2529 is trying to acquire lock:
  (&(&pch->downl)->rlock){+.....}, at: [<f814a634>] ppp_push+0x59/0x4a8
[ppp_generic]

 but task is already holding lock:
  (&(&ppp->wlock)->rlock){+.-...}, at: [<f814ae1b>]
ppp_xmit_process+0x19/0x451 [ppp_generic]

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #2 (&(&ppp->wlock)->rlock){+.-...}:
        [<c01462b2>] lock_acquire+0x47/0x5e
        [<c0471de1>] _raw_spin_lock_bh+0x2a/0x39
        [<f814ae1b>] ppp_xmit_process+0x19/0x451 [ppp_generic]
        [<f814b39f>] ppp_start_xmit+0x14c/0x165 [ppp_generic]
        [<c04179ae>] dev_hard_start_xmit+0x3b1/0x489
        [<c0424a53>] sch_direct_xmit+0x55/0x1b1
        [<c0417cf9>] dev_queue_xmit+0x273/0x4dd
        [<c0434d31>] ip_finish_output+0x2b9/0x31f
        [<c043578c>] ip_output+0xe0/0xfb
        [<c0432c33>] ip_forward_finish+0x7b/0xa1
        [<c0432ede>] ip_forward+0x285/0x313
        [<c0431a30>] ip_rcv_finish+0x2b4/0x30f
        [<c0431ef6>] ip_rcv+0x21c/0x242
        [<c0415090>] __netif_receive_skb+0x34a/0x388
        [<c04151f7>] netif_receive_skb+0x32/0x35
        [<c0415218>] napi_skb_finish+0x1e/0x34
        [<c0415d72>] napi_gro_receive+0xbf/0xc7
        [<c035f25a>] sky2_poll+0x66e/0x92f
        [<c04153eb>] net_rx_action+0x3f/0xfe
        [<c0128563>] __do_softirq+0x76/0xfd

 -> #1 (_xmit_NETROM){+.-...}:
        [<c01462b2>] lock_acquire+0x47/0x5e
        [<c0471c9c>] _raw_spin_lock_irqsave+0x2e/0x3e
        [<c040ed60>] skb_dequeue+0x12/0x4a
        [<f814c237>] ppp_channel_push+0x2e/0x94 [ppp_generic]
        [<f814c33f>] ppp_write+0xa2/0xac [ppp_generic]
        [<c0188e50>] vfs_write+0x8c/0x120
        [<c018909d>] sys_write+0x3b/0x60
        [<c010274c>] sysenter_do_call+0x12/0x32

 -> #0 (&(&pch->downl)->rlock){+.....}:
        [<c014594c>] __lock_acquire+0xe23/0x13ad
        [<c01462b2>] lock_acquire+0x47/0x5e
        [<c0471de1>] _raw_spin_lock_bh+0x2a/0x39
        [<f814a634>] ppp_push+0x59/0x4a8 [ppp_generic]
        [<f814b1d9>] ppp_xmit_process+0x3d7/0x451 [ppp_generic]
        [<f814c336>] ppp_write+0x99/0xac [ppp_generic]
        [<c0188e50>] vfs_write+0x8c/0x120
        [<c018909d>] sys_write+0x3b/0x60
        [<c010274c>] sysenter_do_call+0x12/0x32

 other info that might help us debug this:

 1 lock held by pppd/2529:
  #0:  (&(&ppp->wlock)->rlock){+.-...}, at: [<f814ae1b>]
ppp_xmit_process+0x19/0x451 [ppp_generic]

 stack backtrace:
 Pid: 2529, comm: pppd Not tainted 2.6.38-rc2-kape #7
 Call Trace:
  [<c0143c54>] ? print_circular_bug+0x93/0x9f
  [<c014594c>] ? __lock_acquire+0xe23/0x13ad
  [<c014599a>] ? __lock_acquire+0xe71/0x13ad
  [<c01462b2>] ? lock_acquire+0x47/0x5e
  [<f814a634>] ? ppp_push+0x59/0x4a8 [ppp_generic]
  [<c0471de1>] ? _raw_spin_lock_bh+0x2a/0x39
  [<f814a634>] ? ppp_push+0x59/0x4a8 [ppp_generic]
  [<f814a634>] ? ppp_push+0x59/0x4a8 [ppp_generic]
  [<c014685c>] ? mark_held_locks+0x41/0x5d
  [<c0472236>] ? _raw_spin_unlock_irqrestore+0x36/0x59
  [<c0146958>] ? trace_hardirqs_on_caller+0xe0/0x11a
  [<c0472242>] ? _raw_spin_unlock_irqrestore+0x42/0x59
  [<c040ed91>] ? skb_dequeue+0x43/0x4a
  [<f814b1d9>] ? ppp_xmit_process+0x3d7/0x451 [ppp_generic]
  [<c0474723>] ? sub_preempt_count+0x81/0x8e
  [<c040ec5e>] ? skb_queue_tail+0x2d/0x32
  [<f814c336>] ? ppp_write+0x99/0xac [ppp_generic]
  [<c0188e50>] ? vfs_write+0x8c/0x120
  [<f814c29d>] ? ppp_write+0x0/0xac [ppp_generic]
  [<c018909d>] ? sys_write+0x3b/0x60
  [<c010274c>] ? sysenter_do_call+0x12/0x32

