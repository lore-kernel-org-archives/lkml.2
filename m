Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1ABHYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:36623 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1ABHYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:47 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Nagendra Tomar <tomer_iisc@yahoo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 194/260] net: Fix the condition passed to sk_wait_event()
Date: Sun,  2 Jan 2011 02:18:10 -0500
Message-Id: <1293952756-15010-195-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:43.0073 (UTC) FILETIME=[FC350D10:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nagendra Tomar <tomer_iisc@yahoo.com>

commit 482964e56e1320cb7952faa1932d8ecf59c4bf75 upstream.

This patch fixes the condition (3rd arg) passed to sk_wait_event() in
sk_stream_wait_memory(). The incorrect check in sk_stream_wait_memory()
causes the following soft lockup in tcp_sendmsg() when the global tcp
memory pool has exhausted.

>>> snip <<<

localhost kernel: BUG: soft lockup - CPU#3 stuck for 11s! [sshd:6429]
localhost kernel: CPU 3:
localhost kernel: RIP: 0010:[sk_stream_wait_memory+0xcd/0x200]  [sk_stream_wait_memory+0xcd/0x200] sk_stream_wait_memory+0xcd/0x200
localhost kernel:
localhost kernel: Call Trace:
localhost kernel:  [sk_stream_wait_memory+0x1b1/0x200] sk_stream_wait_memory+0x1b1/0x200
localhost kernel:  [<ffffffff802557c0>] autoremove_wake_function+0x0/0x40
localhost kernel:  [ipv6:tcp_sendmsg+0x6e6/0xe90] tcp_sendmsg+0x6e6/0xce0
localhost kernel:  [sock_aio_write+0x126/0x140] sock_aio_write+0x126/0x140
localhost kernel:  [xfs:do_sync_write+0xf1/0x130] do_sync_write+0xf1/0x130
localhost kernel:  [<ffffffff802557c0>] autoremove_wake_function+0x0/0x40
localhost kernel:  [hrtimer_start+0xe3/0x170] hrtimer_start+0xe3/0x170
localhost kernel:  [vfs_write+0x185/0x190] vfs_write+0x185/0x190
localhost kernel:  [sys_write+0x50/0x90] sys_write+0x50/0x90
localhost kernel:  [system_call+0x7e/0x83] system_call+0x7e/0x83

>>> snip <<<

What is happening is, that the sk_wait_event() condition passed from
sk_stream_wait_memory() evaluates to true for the case of tcp global memory
exhaustion. This is because both sk_stream_memory_free() and vm_wait are true
which causes sk_wait_event() to *not* call schedule_timeout().
Hence sk_stream_wait_memory() returns immediately to the caller w/o sleeping.
This causes the caller to again try allocation, which again fails and again
calls sk_stream_wait_memory(), and so on.

[ Bug introduced by commit c1cbe4b7ad0bc4b1d98ea708a3fecb7362aa4088
  ("[NET]: Avoid atomic xchg() for non-error case") -DaveM ]

Signed-off-by: Nagendra Singh Tomar <tomer_iisc@yahoo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/stream.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/stream.c b/net/core/stream.c
index a37debf..e48c85f 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -140,10 +140,10 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
 
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		sk->sk_write_pending++;
-		sk_wait_event(sk, &current_timeo, !sk->sk_err &&
-						  !(sk->sk_shutdown & SEND_SHUTDOWN) &&
-						  sk_stream_memory_free(sk) &&
-						  vm_wait);
+		sk_wait_event(sk, &current_timeo, sk->sk_err ||
+						  (sk->sk_shutdown & SEND_SHUTDOWN) ||
+						  (sk_stream_memory_free(sk) &&
+						  !vm_wait));
 		sk->sk_write_pending--;
 
 		if (vm_wait) {
-- 
1.7.3.3

