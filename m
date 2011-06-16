Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab1FPHLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:11:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49733 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932080Ab1FPHL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:27 -0400
X-Sasl-enc: i4sE2fZylYgPzTFxB0BDczOgMtidPwklOf34DBKxIsn3 1308208285
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:11 2011
Message-Id: <20110616002911.170830406@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:29:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>
Subject: [73/85] oprofile, dcookies: Fix possible circular locking dependency
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit fe47ae7f53e179d2ef6771024feb000cbb86640f upstream.

The lockdep warning below detects a possible A->B/B->A locking
dependency of mm->mmap_sem and dcookie_mutex. The order in
sync_buffer() is mm->mmap_sem/dcookie_mutex, while in
sys_lookup_dcookie() it is vice versa.

Fixing it in sys_lookup_dcookie() by unlocking dcookie_mutex before
copy_to_user().

oprofiled/4432 is trying to acquire lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff810b444b>] might_fault+0x53/0xa3

but task is already holding lock:
 (dcookie_mutex){+.+.+.}, at: [<ffffffff81124d28>] sys_lookup_dcookie+0x45/0x149

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (dcookie_mutex){+.+.+.}:
       [<ffffffff8106557f>] lock_acquire+0xf8/0x11e
       [<ffffffff814634f0>] mutex_lock_nested+0x63/0x309
       [<ffffffff81124e5c>] get_dcookie+0x30/0x144
       [<ffffffffa0000fba>] sync_buffer+0x196/0x3ec [oprofile]
       [<ffffffffa0001226>] task_exit_notify+0x16/0x1a [oprofile]
       [<ffffffff81467b96>] notifier_call_chain+0x37/0x63
       [<ffffffff8105803d>] __blocking_notifier_call_chain+0x50/0x67
       [<ffffffff81058068>] blocking_notifier_call_chain+0x14/0x16
       [<ffffffff8105a718>] profile_task_exit+0x1a/0x1c
       [<ffffffff81039e8f>] do_exit+0x2a/0x6fc
       [<ffffffff8103a5e4>] do_group_exit+0x83/0xae
       [<ffffffff8103a626>] sys_exit_group+0x17/0x1b
       [<ffffffff8146ad4b>] system_call_fastpath+0x16/0x1b

-> #0 (&mm->mmap_sem){++++++}:
       [<ffffffff81064dfb>] __lock_acquire+0x1085/0x1711
       [<ffffffff8106557f>] lock_acquire+0xf8/0x11e
       [<ffffffff810b4478>] might_fault+0x80/0xa3
       [<ffffffff81124de7>] sys_lookup_dcookie+0x104/0x149
       [<ffffffff8146ad4b>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by oprofiled/4432:
 #0:  (dcookie_mutex){+.+.+.}, at: [<ffffffff81124d28>] sys_lookup_dcookie+0x45/0x149

stack backtrace:
Pid: 4432, comm: oprofiled Not tainted 2.6.39-00008-ge5a450d #9
Call Trace:
 [<ffffffff81063193>] print_circular_bug+0xae/0xbc
 [<ffffffff81064dfb>] __lock_acquire+0x1085/0x1711
 [<ffffffff8102ef13>] ? get_parent_ip+0x11/0x42
 [<ffffffff810b444b>] ? might_fault+0x53/0xa3
 [<ffffffff8106557f>] lock_acquire+0xf8/0x11e
 [<ffffffff810b444b>] ? might_fault+0x53/0xa3
 [<ffffffff810d7d54>] ? path_put+0x22/0x27
 [<ffffffff810b4478>] might_fault+0x80/0xa3
 [<ffffffff810b444b>] ? might_fault+0x53/0xa3
 [<ffffffff81124de7>] sys_lookup_dcookie+0x104/0x149
 [<ffffffff8146ad4b>] system_call_fastpath+0x16/0x1b

References: https://bugzilla.kernel.org/show_bug.cgi?id=13809
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/dcookies.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -178,6 +178,8 @@ SYSCALL_DEFINE(lookup_dcookie)(u64 cooki
 	/* FIXME: (deleted) ? */
 	path = d_path(&dcs->path, kbuf, PAGE_SIZE);
 
+	mutex_unlock(&dcookie_mutex);
+
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
 		goto out_free;
@@ -194,6 +196,7 @@ SYSCALL_DEFINE(lookup_dcookie)(u64 cooki
 
 out_free:
 	kfree(kbuf);
+	return err;
 out:
 	mutex_unlock(&dcookie_mutex);
 	return err;


