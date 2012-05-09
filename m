Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843Ab2EIPY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:24:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56674 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759780Ab2EIPYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:24:04 -0400
Message-ID: <1336577114.3638.23.camel@lappy>
Subject: vfs: INFO: possible circular locking dependency detected
From: Sasha Levin <levinsasha928@gmail.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 09 May 2012 17:25:14 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've started seeing the following warning while fuzzing inside a KVM guest with the latest -next:

[   91.892449] ======================================================
[   91.894167] [ INFO: possible circular locking dependency detected ]
[   91.894167] 3.4.0-rc6-next-20120508-sasha-00003-g9f34dd7-dirty #120 Tainted: G        W   
[   91.894167] -------------------------------------------------------
[   91.894167] trinity/21513 is trying to acquire lock:
[   91.894167]  (&p->lock){+.+.+.}, at: [<ffffffff811fe53a>] seq_read+0x3a/0x420
[   91.894167] 
[   91.894167] but task is already holding lock:
[   91.894167]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811e2cb2>] prepare_bprm_creds+0x32/0x80
[   91.894167] 
[   91.894167] which lock already depends on the new lock.
[   91.894167] 
[   91.894167] 
[   91.894167] the existing dependency chain (in reverse order) is:
[   91.894167] 
[   91.894167] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
[   91.894167]        [<ffffffff81115e3e>] validate_chain.clone.26+0x70e/0x8c0
[   91.894167]        [<ffffffff8111910d>] __lock_acquire+0xa3d/0xb00
[   91.894167]        [<ffffffff81119881>] lock_acquire+0xd1/0x110
[   91.894167]        [<ffffffff82d89515>] __mutex_lock_common+0x65/0x570
[   91.894167]        [<ffffffff82d89b00>] mutex_lock_killable_nested+0x40/0x50
[   91.894167]        [<ffffffff810b1a7f>] mm_access+0x2f/0xb0
[   91.894167]        [<ffffffff8123f0c4>] m_start+0x74/0x1c0
[   91.894167]        [<ffffffff811fe687>] seq_read+0x187/0x420
[   91.894167]        [<ffffffff811dac8d>] vfs_read+0xbd/0x190
[   91.894167]        [<ffffffff811db04f>] sys_read+0x4f/0x90
[   91.894167]        [<ffffffff82d8dbbd>] system_call_fastpath+0x1a/0x1f
[   91.894167] 
[   91.894167] -> #0 (&p->lock){+.+.+.}:
[   91.894167]        [<ffffffff8111523e>] check_prev_add+0x11e/0x610
[   91.894167]        [<ffffffff81115e3e>] validate_chain.clone.26+0x70e/0x8c0
[   91.894167]        [<ffffffff8111910d>] __lock_acquire+0xa3d/0xb00
[   91.894167]        [<ffffffff81119881>] lock_acquire+0xd1/0x110
[   91.894167]        [<ffffffff82d89515>] __mutex_lock_common+0x65/0x570
[   91.894167]        [<ffffffff82d89a60>] mutex_lock_nested+0x40/0x50
[   91.894167]        [<ffffffff811fe53a>] seq_read+0x3a/0x420
[   91.894167]        [<ffffffff81241769>] proc_reg_read+0xa9/0xe0
[   91.894167]        [<ffffffff811dac8d>] vfs_read+0xbd/0x190
[   91.894167]        [<ffffffff811e2a51>] kernel_read+0x41/0x60
[   91.894167]        [<ffffffff811e2ed3>] prepare_binprm+0x123/0x140
[   91.894167]        [<ffffffff811e3487>] do_execve_common.clone.32+0x197/0x320
[   91.894167]        [<ffffffff811e3626>] do_execve+0x16/0x20
[   91.894167]        [<ffffffff81056571>] sys_execve+0x51/0x80
[   91.894167]        [<ffffffff82d8e08c>] stub_execve+0x6c/0xc0
[   91.894167] 
[   91.894167] other info that might help us debug this:
[   91.894167] 
[   91.894167]  Possible unsafe locking scenario:
[   91.894167] 
[   91.894167]        CPU0                    CPU1
[   91.894167]        ----                    ----
[   91.894167]   lock(&sig->cred_guard_mutex);
[   91.894167]                                lock(&p->lock);
[   91.894167]                                lock(&sig->cred_guard_mutex);
[   91.894167]   lock(&p->lock);
[   91.894167] 
[   91.894167]  *** DEADLOCK ***
[   91.894167] 
[   91.894167] 1 lock held by trinity/21513:
[   91.894167]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811e2cb2>] prepare_bprm_creds+0x32/0x80
[   91.894167] 
[   91.894167] stack backtrace:
[   91.894167] Pid: 21513, comm: trinity Tainted: G        W    3.4.0-rc6-next-20120508-sasha-00003-g9f34dd7-dirty #120
[   91.894167] Call Trace:
[   91.894167]  [<ffffffff811144d7>] print_circular_bug+0x107/0x130
[   91.894167]  [<ffffffff8111523e>] check_prev_add+0x11e/0x610
[   91.894167]  [<ffffffff81115e3e>] validate_chain.clone.26+0x70e/0x8c0
[   91.894167]  [<ffffffff8111910d>] __lock_acquire+0xa3d/0xb00
[   91.894167]  [<ffffffff81116c06>] ? mark_held_locks+0xe6/0x120
[   91.894167]  [<ffffffff81119881>] lock_acquire+0xd1/0x110
[   91.894167]  [<ffffffff811fe53a>] ? seq_read+0x3a/0x420
[   91.894167]  [<ffffffff82d8d426>] ? retint_kernel+0x26/0x30
[   91.894167]  [<ffffffff82d89515>] __mutex_lock_common+0x65/0x570
[   91.894167]  [<ffffffff811fe53a>] ? seq_read+0x3a/0x420
[   91.894167]  [<ffffffff810b4879>] ? vprintk+0x3f9/0x480
[   91.894167]  [<ffffffff811fe53a>] ? seq_read+0x3a/0x420
[   91.894167]  [<ffffffff811fe500>] ? seq_open+0xb0/0xb0
[   91.894167]  [<ffffffff82d89a60>] mutex_lock_nested+0x40/0x50
[   91.894167]  [<ffffffff811fe53a>] seq_read+0x3a/0x420
[   91.894167]  [<ffffffff810e891e>] ? sub_preempt_count+0xae/0xe0
[   91.894167]  [<ffffffff811fe500>] ? seq_open+0xb0/0xb0
[   91.894167]  [<ffffffff81241769>] proc_reg_read+0xa9/0xe0
[   91.894167]  [<ffffffff811dac8d>] vfs_read+0xbd/0x190
[   91.894167]  [<ffffffff811e2a51>] kernel_read+0x41/0x60
[   91.894167]  [<ffffffff811e2ed3>] prepare_binprm+0x123/0x140
[   91.894167]  [<ffffffff811e3487>] do_execve_common.clone.32+0x197/0x320
[   91.894167]  [<ffffffff811e3626>] do_execve+0x16/0x20
[   91.894167]  [<ffffffff81056571>] sys_execve+0x51/0x80
[   91.894167]  [<ffffffff82d8e08c>] stub_execve+0x6c/0xc0

