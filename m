Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab2HMR1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:27:46 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:34205 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2HMR1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:27:44 -0400
MIME-Version: 1.0
Date: Mon, 13 Aug 2012 10:27:43 -0700
Message-ID: <CA+HUmGhsOEgcAMjLRBHY9TRNJo6C25SghqQXFrHLXy4r3zZCgA@mail.gmail.com>
Subject: [PATCH 1/1]: leak of ctl_table_header structs in proc_sys_lookup
From: Francesco Ruggeri <fruggeri@aristanetworks.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 076c3eed2c31773200b082568957fd8852ae93d7 in 3.4 changed some of
the logic in proc_sys_lookup() by introducing lookup_entry().
On success lookup_entry() will return having invoked use_table() on
its first parameter. In case of a failure later on in proc_sys_lookup()
this reference has to be dropped.
This patch fixes one such case when sysctl_follow_link() fails.
When this happened the reference would never drop to 0, and would cause
dev_change_net_namespace() to hang while holding the rtnl lock with this
backtrace:

[<ffffffff814489d4>] schedule+0x5f/0x61
[<ffffffff8144784e>] schedule_timeout+0x22/0xbb
[<ffffffff8103153b>] ? vprintk+0x376/0x3b1
[<ffffffff8144834a>] wait_for_common+0x99/0x110
[<ffffffff81056e2d>] ? try_to_wake_up+0x1ae/0x1ae
[<ffffffff8144845b>] wait_for_completion+0x18/0x1a
[<ffffffff811438e0>] drop_sysctl_table+0x97/0x114
[<ffffffff811437e0>] put_links+0x10a/0x173
[<ffffffff81143872>] drop_sysctl_table+0x29/0x114
[<ffffffff81143952>] drop_sysctl_table+0x109/0x114
[<ffffffff81035f95>] ? local_bh_enable_ip+0x9/0xb
[<ffffffff811439c2>] unregister_sysctl_table+0x65/0x75
[<ffffffff8138a846>] neigh_sysctl_unregister+0x22/0x3a
[<ffffffff813d3b86>] inetdev_event+0x2c6/0x411
[<ffffffff8144c444>] notifier_call_chain+0x32/0x5e
[<ffffffff8104e8ee>] raw_notifier_call_chain+0xf/0x11
[<ffffffff813818b6>] call_netdevice_notifiers+0x45/0x4a
[<ffffffff81383a7f>] dev_change_net_namespace+0xc6/0x18e
[<ffffffff8138f270>] do_setlink+0x77/0x766
[<ffffffff812306de>] ? nla_parse+0x4f/0xc3
[<ffffffff813908cb>] rtnl_newlink+0x252/0x49f
[<ffffffff8139073d>] ? rtnl_newlink+0xc4/0x49f
[<ffffffff810cab4d>] ? pmd_offset+0x14/0x3b
[<ffffffff8139048c>] rtnetlink_rcv_msg+0x248/0x25e
[<ffffffff8100813a>] ? read_tsc+0x9/0x19
[<ffffffff810605de>] ? timekeeping_get_ns+0x15/0x34
[<ffffffff81390244>] ? __rtnl_unlock+0x33/0x33
[<ffffffff813a4b23>] netlink_rcv_skb+0x40/0x8c
[<ffffffff8138fb73>] rtnetlink_rcv+0x21/0x28
[<ffffffff813a46c0>] netlink_unicast+0xec/0x155
[<ffffffff813a492b>] netlink_sendmsg+0x202/0x220
[<ffffffff81371292>] __sock_sendmsg+0x6e/0x7a
[<ffffffff81371b71>] sock_sendmsg+0xa3/0xbc
[<ffffffff81371a74>] ? sock_recvmsg+0xa6/0xbf
[<ffffffff810b9b5e>] ? get_page+0x29/0x2e
[<ffffffff810b9faf>] ? __lru_cache_add+0x2f/0x56
[<ffffffff810ba16d>] ? lru_cache_add_lru+0x4e/0x55
[<ffffffff810d5147>] ? page_add_new_anon_rmap+0x5b/0x6d
[<ffffffff81372854>] ? move_addr_to_kernel+0x44/0x49
[<ffffffff81399080>] ? verify_compat_iovec+0x6d/0xb9
[<ffffffff81371e46>] __sys_sendmsg+0x21c/0x2c3
[<ffffffff810c6a48>] ? inc_zone_page_state+0x28/0x2a
[<ffffffff810cab4d>] ? pmd_offset+0x14/0x3b
[<ffffffff810cdb5e>] ? handle_mm_fault+0xeb/0x100
[<ffffffff8144c3a0>] ? do_page_fault+0x2da/0x34c
[<ffffffff81373432>] sys_sendmsg+0x3d/0x5b
[<ffffffff813998c7>] compat_sys_sendmsg+0xf/0x11
[<ffffffff81399af7>] compat_sys_socketcall+0x152/0x19b
[<ffffffff81450c56>] sysenter_dispatch+0x7/0x21

This patch slightly changes the logic in proc_sys_lookup in that
        d_set_d_op(dentry, &proc_sys_dentry_operations);
        d_add(dentry, inode);
will now execute before the ctl_table_header is freed.
This should not be a problem, and it makes the code cleaner than just
adding an extra call to sysctl_head_finish(h);

Tested in Linux 3.4.4.

Signed-off-by: Francesco Ruggeri <fruggeri@aristanetworks.com>

Index: linux-3.4.x86_64/fs/proc/proc_sysctl.c
===================================================================
--- linux-3.4.x86_64.orig/fs/proc/proc_sysctl.c
+++ linux-3.4.x86_64/fs/proc/proc_sysctl.c
@@ -462,9 +462,6 @@ static struct dentry *proc_sys_lookup(st

 	err = ERR_PTR(-ENOMEM);
 	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	if (h)
-		sysctl_head_finish(h);
-
 	if (!inode)
 		goto out;

@@ -473,6 +470,8 @@ static struct dentry *proc_sys_lookup(st
 	d_add(dentry, inode);

 out:
+	if (h)
+		sysctl_head_finish(h);
 	sysctl_head_finish(head);
 	return err;
 }
