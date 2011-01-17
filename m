Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab1AQV3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:29:32 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43941 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab1AQV3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:29:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=HOJjkTGpNWGQ9Ocml2ygY44mt0tgs9CXjWU7tMOm5VD8eJ2HZwqIxrcxtLnGmxMJrd
         q1fafyurNLh3tCQrJfYlBMHuYhAX6opwiebJWZa+uJMBqTwISVPtCjqIQGS9mP/BVENQ
         z8ZVs6zTQlcPx8vr5cgzn/xgWlrVrO9eGnDdA=
MIME-Version: 1.0
Date: Mon, 17 Jan 2011 16:29:29 -0500
Message-ID: <AANLkTik2r1P9dqyw+QoHg9G3PUvvPukY08TpS5Ud1ffG@mail.gmail.com>
Subject: 2.6.37-git16 -- INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
2.6.37-git16 #2
------------------------------------------------------
wnck-applet/2334 [HC0[0]:SC1[1]:HE0:SE0] is trying to acquire:
 (&(&list->lock)->rlock#3){+.-...}, at: [<ffffffff812c8ad1>]
skb_queue_tail+0x1f/0x48

and this task is already holding:
 (&(&priv->sta_lock)->rlock){..-...}, at: [<ffffffffa0234de6>]
iwlagn_rx_reply_tx+0x596/0x5ba [iwlagn]
which would create a new lock dependency:
 (&(&priv->sta_lock)->rlock){..-...} -> (&(&list->lock)->rlock#3){+.-...}

but this new dependency connects a HARDIRQ-irq-safe lock:
 (&(&priv->lock)->rlock){-.-...}
... which became HARDIRQ-irq-safe at:
  [<ffffffff8105c1a7>] __lock_acquire+0x2f5/0xdcd
  [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
  [<ffffffff8135c162>] _raw_spin_lock_irqsave+0x44/0x57
  [<ffffffffa023a4d0>] iwl_isr_ict+0x37/0x1df [iwlagn]
  [<ffffffff8107a582>] handle_IRQ_event+0x26/0xb4
  [<ffffffff8107c54d>] handle_edge_irq+0xde/0x12a
  [<ffffffff810045a7>] handle_irq+0x83/0x8b
  [<ffffffff81004276>] do_IRQ+0x48/0x9f
  [<ffffffff8135cd53>] ret_from_intr+0x0/0x13

to a HARDIRQ-irq-unsafe lock:
 (&(&list->lock)->rlock#3){+.-...}
... which became HARDIRQ-irq-unsafe at:
...  [<ffffffff8105c228>] __lock_acquire+0x376/0xdcd
  [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
  [<ffffffff8135c069>] _raw_spin_lock+0x36/0x45
  [<ffffffffa01f7ed0>] ieee80211_rx_handlers+0x36/0x1ae3 [mac80211]
  [<ffffffffa01fa14a>] ieee80211_prepare_and_rx_handle+0x7cd/0x80a [mac80211]
  [<ffffffffa01fa973>] ieee80211_rx+0x785/0x7af [mac80211]
  [<ffffffffa0234730>] iwlagn_rx_reply_rx+0x2d5/0x2f0 [iwlagn]
  [<ffffffffa022b821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
  [<ffffffffa022bf14>] iwl_irq_tasklet+0x266/0x342 [iwlagn]
  [<ffffffff81038c46>] tasklet_action+0x85/0xd8
  [<ffffffff8103925e>] __do_softirq+0x98/0x136
  [<ffffffff8100300c>] call_softirq+0x1c/0x28
  [<ffffffff810045e7>] do_softirq+0x38/0x81
  [<ffffffff810393a5>] irq_exit+0x44/0x92
  [<ffffffff810042b6>] do_IRQ+0x88/0x9f
  [<ffffffff8135cd53>] ret_from_intr+0x0/0x13

other info that might help us debug this:

2 locks held by wnck-applet/2334:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8135f4b7>]
do_page_fault+0x161/0x340
 #1:  (&(&priv->sta_lock)->rlock){..-...}, at: [<ffffffffa0234de6>]
iwlagn_rx_reply_tx+0x596/0x5ba [iwlagn]

the dependencies between HARDIRQ-irq-safe lock and the holding lock:
 -> (&(&priv->lock)->rlock){-.-...} ops: 1474 {
    IN-HARDIRQ-W at:
                          [<ffffffff8105c1a7>] __lock_acquire+0x2f5/0xdcd
                          [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
                          [<ffffffff8135c162>] _raw_spin_lock_irqsave+0x44/0x57
                          [<ffffffffa023a4d0>] iwl_isr_ict+0x37/0x1df [iwlagn]
                          [<ffffffff8107a582>] handle_IRQ_event+0x26/0xb4
                          [<ffffffff8107c54d>] handle_edge_irq+0xde/0x12a
                          [<ffffffff810045a7>] handle_irq+0x83/0x8b
                          [<ffffffff81004276>] do_IRQ+0x48/0x9f
                          [<ffffffff8135cd53>] ret_from_intr+0x0/0x13
    IN-SOFTIRQ-W at:
                          [<ffffffff8105c1cb>] __lock_acquire+0x319/0xdcd
                          [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
                          [<ffffffff8135c162>] _raw_spin_lock_irqsave+0x44/0x57
                          [<ffffffffa022bccb>]
iwl_irq_tasklet+0x1d/0x342 [iwlagn]
                          [<ffffffff81038c46>] tasklet_action+0x85/0xd8
                          [<ffffffff8103925e>] __do_softirq+0x98/0x136
                          [<ffffffff8100300c>] call_softirq+0x1c/0x28
                          [<ffffffff810045e7>] do_softirq+0x38/0x81
                          [<ffffffff810393a5>] irq_exit+0x44/0x92
                          [<ffffffff810042b6>] do_IRQ+0x88/0x9f
                          [<ffffffff8135cd53>] ret_from_intr+0x0/0x13
    INITIAL USE at:
                         [<ffffffff8105c2a9>] __lock_acquire+0x3f7/0xdcd
                         [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
                         [<ffffffff8135c162>] _raw_spin_lock_irqsave+0x44/0x57
                         [<ffffffffa022a97e>] iwl_pci_probe+0x706/0xe2c [iwlagn]
                         [<ffffffff811b72ee>] local_pci_probe+0x3f/0x70
                         [<ffffffff811b787a>] pci_device_probe+0x65/0x96
                         [<ffffffff81253c32>] driver_probe_device+0xbc/0x157
                         [<ffffffff81253d17>] __driver_attach+0x4a/0x6b
                         [<ffffffff81252e7a>] bus_for_each_dev+0x57/0x83
                         [<ffffffff8125391d>] driver_attach+0x19/0x1b
                         [<ffffffff81253560>] bus_add_driver+0xae/0x204
                         [<ffffffff81253f56>] driver_register+0x96/0x103
                         [<ffffffff811b7aac>] __pci_register_driver+0x61/0xcd
                         [<ffffffffa012305c>] snd_mask_min+0x7/0x2f
[snd_pcm_oss]
                         [<ffffffff81000336>] do_one_initcall+0x7a/0x130
                         [<ffffffff810667ff>] sys_init_module+0xa1/0x1e1
                         [<ffffffff8100213b>] system_call_fastpath+0x16/0x1b
  }
  ... key      at: [<ffffffffa0241e50>]
__key.39500+0x0/0xffffffffffff979a [iwlagn]
  ... acquired at:
   [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
   [<ffffffff8135c069>] _raw_spin_lock+0x36/0x45
   [<ffffffffa02318c9>] iwlagn_tx_skb+0x139/0x9e2 [iwlagn]
   [<ffffffffa0228479>] iwlagn_mac_tx+0x15/0x27 [iwlagn]
   [<ffffffffa01fb3ca>] __ieee80211_tx+0x140/0x1d5 [mac80211]
   [<ffffffffa01fc9f4>] ieee80211_tx+0xc4/0x208 [mac80211]
   [<ffffffffa01fccd7>] ieee80211_xmit+0x19f/0x1b3 [mac80211]
   [<ffffffffa01fde80>] ieee80211_tx_skb+0x4a/0x52 [mac80211]
   [<ffffffffa01ffcbf>] ieee80211_send_auth+0x17f/0x18e [mac80211]
   [<ffffffffa01f0f2e>] ieee80211_work_work+0x5a0/0xef3 [mac80211]
   [<ffffffff81046b55>] process_one_work+0x1b4/0x2f2
   [<ffffffff81047f62>] worker_thread+0xff/0x19f
   [<ffffffff8104b78b>] kthread+0x9d/0xa5
   [<ffffffff81002f14>] kernel_thread_helper+0x4/0x10

-> (&(&priv->sta_lock)->rlock){..-...} ops: 40 {
   IN-SOFTIRQ-W at:
                        [<ffffffff8105c1cb>] __lock_acquire+0x319/0xdcd
                        [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
                        [<ffffffff8135c162>] _raw_spin_lock_irqsave+0x44/0x57
                        [<ffffffffa0234de6>]
iwlagn_rx_reply_tx+0x596/0x5ba [iwlagn]
                        [<ffffffffa022b821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
                        [<ffffffffa022bf14>]
iwl_irq_tasklet+0x266/0x342 [iwlagn]
                        [<ffffffff81038c46>] tasklet_action+0x85/0xd8
                        [<ffffffff8103925e>] __do_softirq+0x98/0x136
                        [<ffffffff8100300c>] call_softirq+0x1c/0x28
                        [<ffffffff810045e7>] do_softirq+0x38/0x81
                        [<ffffffff810393a5>] irq_exit+0x44/0x92
                        [<ffffffff810042b6>] do_IRQ+0x88/0x9f
                        [<ffffffff8135cd53>] ret_from_intr+0x0/0x13
                        [<ffffffff81094487>] get_page_from_freelist+0x3a0/0x4aa
                        [<ffffffff8109484a>] __alloc_pages_nodemask+0x119/0x66b
                        [<ffffffff8102240b>] pte_alloc_one+0x1e/0x3a
                        [<ffffffff810a42e8>] __pte_alloc+0x1f/0xa5
                        [<ffffffff810a614f>] handle_mm_fault+0x8b/0xc7
                        [<ffffffff8135f674>] do_page_fault+0x31e/0x340
                        [<ffffffff8135d01f>] page_fault+0x1f/0x30
   INITIAL USE at:
                       [<ffffffff8105c2a9>] __lock_acquire+0x3f7/0xdcd
                       [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
                       [<ffffffff8135c162>] _raw_spin_lock_irqsave+0x44/0x57
                       [<ffffffffa02384f4>]
iwlagn_alloc_bcast_station+0x27/0xfa [iwlagn]
                       [<ffffffffa0229c15>] __iwl_up+0xa2/0x2e8 [iwlagn]
                       [<ffffffffa0229fd5>] iwlagn_mac_start+0x2e/0x159 [iwlagn]
                       [<ffffffffa01f35b5>]
ieee80211_do_open+0xd4/0x454 [mac80211]
                       [<ffffffffa01f3988>] ieee80211_open+0x53/0x58 [mac80211]
                       [<ffffffff812d5b44>] __dev_open+0x96/0xcd
                       [<ffffffff812d5d74>] __dev_change_flags+0xa8/0x12c
                       [<ffffffff812d5e6f>] dev_change_flags+0x1c/0x51
                       [<ffffffff812e0778>] do_setlink+0x2b0/0x676
                       [<ffffffff812e10c8>] rtnl_setlink+0xca/0xea
                       [<ffffffff812e13af>] rtnetlink_rcv_msg+0x1f0/0x206
                       [<ffffffff812efa28>] netlink_rcv_skb+0x40/0x8b
                       [<ffffffff812e0dc4>] rtnetlink_rcv+0x21/0x28
                       [<ffffffff812ef519>] netlink_unicast+0xe6/0x150
                       [<ffffffff812ef830>] netlink_sendmsg+0x2ad/0x2cb
                       [<ffffffff812c1ebd>] __sock_sendmsg+0x66/0x72
                       [<ffffffff812c25db>] sock_sendmsg+0x9c/0xb1
                       [<ffffffff812c3ef8>] sys_sendmsg+0x245/0x2c3
                       [<ffffffff8100213b>] system_call_fastpath+0x16/0x1b
 }
 ... key      at: [<ffffffffa0241e78>]
__key.39458+0x0/0xffffffffffff9772 [iwlagn]
 ... acquired at:
   [<ffffffff8105a76b>] check_irq_usage+0x42/0x89
   [<ffffffff8105c98d>] __lock_acquire+0xadb/0xdcd
   [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
   [<ffffffff8135c162>] _raw_spin_lock_irqsave+0x44/0x57
   [<ffffffff812c8ad1>] skb_queue_tail+0x1f/0x48
   [<ffffffffa01e5c96>] ieee80211_tx_status_irqsafe+0x37/0x8d [mac80211]
   [<ffffffffa0232c4f>] iwlagn_tx_queue_reclaim+0x13b/0x1d8 [iwlagn]
   [<ffffffffa0234d20>] iwlagn_rx_reply_tx+0x4d0/0x5ba [iwlagn]
   [<ffffffffa022b821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
   [<ffffffffa022bf14>] iwl_irq_tasklet+0x266/0x342 [iwlagn]
   [<ffffffff81038c46>] tasklet_action+0x85/0xd8
   [<ffffffff8103925e>] __do_softirq+0x98/0x136
   [<ffffffff8100300c>] call_softirq+0x1c/0x28
   [<ffffffff810045e7>] do_softirq+0x38/0x81
   [<ffffffff810393a5>] irq_exit+0x44/0x92
   [<ffffffff810042b6>] do_IRQ+0x88/0x9f
   [<ffffffff8135cd53>] ret_from_intr+0x0/0x13
   [<ffffffff81094487>] get_page_from_freelist+0x3a0/0x4aa
   [<ffffffff8109484a>] __alloc_pages_nodemask+0x119/0x66b
   [<ffffffff8102240b>] pte_alloc_one+0x1e/0x3a
   [<ffffffff810a42e8>] __pte_alloc+0x1f/0xa5
   [<ffffffff810a614f>] handle_mm_fault+0x8b/0xc7
   [<ffffffff8135f674>] do_page_fault+0x31e/0x340
   [<ffffffff8135d01f>] page_fault+0x1f/0x30


the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
-> (&(&list->lock)->rlock#3){+.-...} ops: 565 {
   HARDIRQ-ON-W at:
                        [<ffffffff8105c228>] __lock_acquire+0x376/0xdcd
                        [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
                        [<ffffffff8135c069>] _raw_spin_lock+0x36/0x45
                        [<ffffffffa01f7ed0>]
ieee80211_rx_handlers+0x36/0x1ae3 [mac80211]
                        [<ffffffffa01fa14a>]
ieee80211_prepare_and_rx_handle+0x7cd/0x80a [mac80211]
                        [<ffffffffa01fa973>] ieee80211_rx+0x785/0x7af [mac80211]
                        [<ffffffffa0234730>]
iwlagn_rx_reply_rx+0x2d5/0x2f0 [iwlagn]
                        [<ffffffffa022b821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
                        [<ffffffffa022bf14>]
iwl_irq_tasklet+0x266/0x342 [iwlagn]
                        [<ffffffff81038c46>] tasklet_action+0x85/0xd8
                        [<ffffffff8103925e>] __do_softirq+0x98/0x136
                        [<ffffffff8100300c>] call_softirq+0x1c/0x28
                        [<ffffffff810045e7>] do_softirq+0x38/0x81
                        [<ffffffff810393a5>] irq_exit+0x44/0x92
                        [<ffffffff810042b6>] do_IRQ+0x88/0x9f
                        [<ffffffff8135cd53>] ret_from_intr+0x0/0x13
   IN-SOFTIRQ-W at:
                        [<ffffffff8105c1cb>] __lock_acquire+0x319/0xdcd
                        [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
                        [<ffffffff8135c162>] _raw_spin_lock_irqsave+0x44/0x57
                        [<ffffffff812c8ad1>] skb_queue_tail+0x1f/0x48
                        [<ffffffffa01fa142>]
ieee80211_prepare_and_rx_handle+0x7c5/0x80a [mac80211]
                        [<ffffffffa01fa973>] ieee80211_rx+0x785/0x7af [mac80211]
                        [<ffffffffa0234730>]
iwlagn_rx_reply_rx+0x2d5/0x2f0 [iwlagn]
                        [<ffffffffa022b821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
                        [<ffffffffa022bf14>]
iwl_irq_tasklet+0x266/0x342 [iwlagn]
                        [<ffffffff81038c46>] tasklet_action+0x85/0xd8
                        [<ffffffff8103925e>] __do_softirq+0x98/0x136
                        [<ffffffff8100300c>] call_softirq+0x1c/0x28
                        [<ffffffff810045e7>] do_softirq+0x38/0x81
                        [<ffffffff810393a5>] irq_exit+0x44/0x92
                        [<ffffffff810042b6>] do_IRQ+0x88/0x9f
                        [<ffffffff8135cd53>] ret_from_intr+0x0/0x13
   INITIAL USE at:
                       [<ffffffff8105c2a9>] __lock_acquire+0x3f7/0xdcd
                       [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
                       [<ffffffff8135c162>] _raw_spin_lock_irqsave+0x44/0x57
                       [<ffffffff812c8ad1>] skb_queue_tail+0x1f/0x48
                       [<ffffffffa01fa142>]
ieee80211_prepare_and_rx_handle+0x7c5/0x80a [mac80211]
                       [<ffffffffa01fa973>] ieee80211_rx+0x785/0x7af [mac80211]
                       [<ffffffffa0234730>]
iwlagn_rx_reply_rx+0x2d5/0x2f0 [iwlagn]
                       [<ffffffffa022b821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
                       [<ffffffffa022bf14>] iwl_irq_tasklet+0x266/0x342 [iwlagn]
                       [<ffffffff81038c46>] tasklet_action+0x85/0xd8
                       [<ffffffff8103925e>] __do_softirq+0x98/0x136
                       [<ffffffff8100300c>] call_softirq+0x1c/0x28
                       [<ffffffff810045e7>] do_softirq+0x38/0x81
                       [<ffffffff810393a5>] irq_exit+0x44/0x92
                       [<ffffffff810042b6>] do_IRQ+0x88/0x9f
                       [<ffffffff8135cd53>] ret_from_intr+0x0/0x13
 }
 ... key      at: [<ffffffffa020ab50>]
__key.17747+0x0/0xffffffffffffc7e0 [mac80211]
 ... acquired at:
   [<ffffffff8105a76b>] check_irq_usage+0x42/0x89
   [<ffffffff8105c98d>] __lock_acquire+0xadb/0xdcd
   [<ffffffff8105d0fb>] lock_acquire+0x8a/0xa2
   [<ffffffff8135c162>] _raw_spin_lock_irqsave+0x44/0x57
   [<ffffffff812c8ad1>] skb_queue_tail+0x1f/0x48
   [<ffffffffa01e5c96>] ieee80211_tx_status_irqsafe+0x37/0x8d [mac80211]
   [<ffffffffa0232c4f>] iwlagn_tx_queue_reclaim+0x13b/0x1d8 [iwlagn]
   [<ffffffffa0234d20>] iwlagn_rx_reply_tx+0x4d0/0x5ba [iwlagn]
   [<ffffffffa022b821>] iwl_rx_handle+0x17e/0x2ed [iwlagn]
   [<ffffffffa022bf14>] iwl_irq_tasklet+0x266/0x342 [iwlagn]
   [<ffffffff81038c46>] tasklet_action+0x85/0xd8
   [<ffffffff8103925e>] __do_softirq+0x98/0x136
   [<ffffffff8100300c>] call_softirq+0x1c/0x28
   [<ffffffff810045e7>] do_softirq+0x38/0x81
   [<ffffffff810393a5>] irq_exit+0x44/0x92
   [<ffffffff810042b6>] do_IRQ+0x88/0x9f
   [<ffffffff8135cd53>] ret_from_intr+0x0/0x13
   [<ffffffff81094487>] get_page_from_freelist+0x3a0/0x4aa
   [<ffffffff8109484a>] __alloc_pages_nodemask+0x119/0x66b
   [<ffffffff8102240b>] pte_alloc_one+0x1e/0x3a
   [<ffffffff810a42e8>] __pte_alloc+0x1f/0xa5
   [<ffffffff810a614f>] handle_mm_fault+0x8b/0xc7
   [<ffffffff8135f674>] do_page_fault+0x31e/0x340
   [<ffffffff8135d01f>] page_fault+0x1f/0x30


stack backtrace:
Pid: 2334, comm: wnck-applet Not tainted 2.6.37-git16 #2
Call Trace:
 <IRQ>  [<ffffffff8105a715>] ? check_usage+0x33e/0x352
 [<ffffffff81063726>] ? __module_text_address+0x11/0x5f
 [<ffffffff8105a2ea>] ? check_usage_forwards+0x0/0x78
 [<ffffffff8105a76b>] ? check_irq_usage+0x42/0x89
 [<ffffffff8105c98d>] ? __lock_acquire+0xadb/0xdcd
 [<ffffffff8105cc70>] ? __lock_acquire+0xdbe/0xdcd
 [<ffffffff8105d0fb>] ? lock_acquire+0x8a/0xa2
 [<ffffffff812c8ad1>] ? skb_queue_tail+0x1f/0x48
 [<ffffffff8135c162>] ? _raw_spin_lock_irqsave+0x44/0x57
 [<ffffffff812c8ad1>] ? skb_queue_tail+0x1f/0x48
 [<ffffffff812c8ad1>] ? skb_queue_tail+0x1f/0x48
 [<ffffffffa01e5c96>] ? ieee80211_tx_status_irqsafe+0x37/0x8d [mac80211]
 [<ffffffffa0232c4f>] ? iwlagn_tx_queue_reclaim+0x13b/0x1d8 [iwlagn]
 [<ffffffffa0232bb4>] ? iwlagn_tx_queue_reclaim+0xa0/0x1d8 [iwlagn]
 [<ffffffffa0232d4c>] ? iwlagn_hwrate_to_tx_control+0x60/0x68 [iwlagn]
 [<ffffffffa0234d20>] ? iwlagn_rx_reply_tx+0x4d0/0x5ba [iwlagn]
 [<ffffffffa022b821>] ? iwl_rx_handle+0x17e/0x2ed [iwlagn]
 [<ffffffff8105ade2>] ? mark_held_locks+0x50/0x72
 [<ffffffffa022bf14>] ? iwl_irq_tasklet+0x266/0x342 [iwlagn]
 [<ffffffff81038c46>] ? tasklet_action+0x85/0xd8
 [<ffffffff8103925e>] ? __do_softirq+0x98/0x136
 [<ffffffff8100300c>] ? call_softirq+0x1c/0x28
 [<ffffffff810045e7>] ? do_softirq+0x38/0x81
 [<ffffffff810393a5>] ? irq_exit+0x44/0x92
 [<ffffffff810042b6>] ? do_IRQ+0x88/0x9f
 [<ffffffff8135cd53>] ? ret_from_intr+0x0/0x13
 <EOI>  [<ffffffff8135f760>] ? add_preempt_count+0x25/0xae
 [<ffffffff81094487>] ? get_page_from_freelist+0x3a0/0x4aa
 [<ffffffff8109484a>] ? __alloc_pages_nodemask+0x119/0x66b
 [<ffffffff8105cc70>] ? __lock_acquire+0xdbe/0xdcd
 [<ffffffff8102240b>] ? pte_alloc_one+0x1e/0x3a
 [<ffffffff810a42e8>] ? __pte_alloc+0x1f/0xa5
 [<ffffffff810a614f>] ? handle_mm_fault+0x8b/0xc7
 [<ffffffff8135f674>] ? do_page_fault+0x31e/0x340
 [<ffffffff810c3716>] ? fput+0x1d/0x1b5
 [<ffffffff8105987c>] ? trace_hardirqs_off_caller+0xa3/0x10b
 [<ffffffff8135bea3>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8135d01f>] ? page_fault+0x1f/0x30
