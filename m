Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab0JCJpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 05:45:09 -0400
Received: from web53706.mail.re2.yahoo.com ([206.190.37.27]:43651 "HELO
	web53706.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751239Ab0JCJpH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 05:45:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=OUyAGCeEYEqz+NsIt7iZotBAO0DZE8JbtWdTCaWqIvI6PBnSl7OH40LNenwLb/abL7XzlQxNGZGnnKWKCWUrWja5qVujvNUiqfwprjRvgVVXFVcHgF6dHYEy4WtMbctda0lXgexQ5yqAjrUpDVMYRM89yuACDhHRryXspO57ctQ=;
Message-ID: <316201.7438.qm@web53706.mail.re2.yahoo.com>
X-YMail-OSG: lllW8NQVM1lIsf.qvy.amezmvfCaAWDcQfQ7YjtfIPh5UI0
 t9wP.hhB6Ex3MsmCPBObXw04FNNfQyG5QqLIzBLd0QnVl.Rm.fUVQN5DVXCB
 ZRuw4mbwJeSMp5hvlwm7VZnGTGlVLMk6UnT9lwHmTh3ho6chg3iaKsoXe9OE
 xstTC4w4e.iY8B5WdBTBcm0BaWB2uH7td4YeSY_m8R766k7pNQZ42d3jCyBF
 bbVT6.gVWbhpBxthevePIwq9CFhtCuhpceypw9LVHAlu7vK3aCz56J1LCqLR
 BfofvMz8i9X6EqltDPAQ2DUvk5rLxB_6r1nh3W4tdzh1K6H6_.ZB_WzF8V3W
 eipTABjE-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sun, 3 Oct 2010 02:45:06 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: [PATCH] net: Fix the condition passed to sk_wait_event()
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending, since this is the only patch now. Thanks.

---
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


Signed-off-by: Nagendra Singh Tomar <tomer_iisc@yahoo.com>
---
--- linux-2.6.35.7/net/core/stream.c.orig	2010-03-25 07:37:58.000000000 +0530
+++ linux-2.6.35.7/net/core/stream.c	2010-03-25 07:42:16.000000000 +0530
@@ -144,10 +144,10 @@ int sk_stream_wait_memory(struct sock *s
 
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
---








      
