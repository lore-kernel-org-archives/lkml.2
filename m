Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0JBIWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 04:22:20 -0400
Received: from web53706.mail.re2.yahoo.com ([206.190.37.27]:34219 "HELO
	web53706.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751538Ab0JBIWR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 04:22:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=jSIdU3UOKSkLOn6Du+uLRBKqU5CQMTTXOTUc2ZQiDP2w+4g8FCrmFeaUOQQMNsoA8rZQg93MXPeUzcHCkU2MCkKirxTcZXWUsdF0udKBrx+HPjTdAir43TnPAI2q8M7NS3hgXd2sjFh1+BBqRVCMNUoTizbf356AkVKBLNRr2TY=;
Message-ID: <667106.4951.qm@web53706.mail.re2.yahoo.com>
X-YMail-OSG: Dg0ijIYVM1kCN71aNVZNsvbNYE7bWV06CB6zV0ds1nH4q77
 zfMzdzxvw8Wz8sKCGTewpEh2z2_reNXzt8scYTmc5A3xERJjU_dthlDP8OEk
 Nrx7z.P1GaiPWaQSJhWlfoqZ7a3PeuCw9m8HT8AVLCmIhLbe1I4G.IRfSjsw
 5qEr4wZlmHfgxrzTyLxGvTQuCk8Ku.eyGpW9lk3ZkMQThKhw.7Fn3xCPmfRe
 NKoekGW_ktl_91Au2RMdtZYFFHTbazBHn4I6_Zmv1iAtt5dv.hDKCoDUXn_k
 ffr4DaKVMZ_Ozv00UrZmeftg8sShTJhZbizitZArDpRVfNqPekECvb7GIofu
 wl7EYISo-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sat, 2 Oct 2010 01:22:16 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2.6.35.7] net: Fix the condition passed to sk_wait_event()
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending ...


The condition (3rd arg) passed to sk_wait_event() in sk_stream_wait_memory() and sk_stream_wait_connect() are incorrect.
The incorrect check in sk_stream_wait_memory() causes the following soft lockup in tcp_sendmsg() when the global tcp memory pool has exhausted. The check in sk_stream_wait_connect() was found by code audit.
   

>>> snip <<<

localhost kernel: BUG: soft lockup - CPU#3 stuck for 11s! [sshd:6429]
localhost kernel: CPU 3:
localhost kernel: RIP: 0010:[sk_stream_wait_memory+0xcd/0x200]  [sk_stream_wait_memory+0xcd/0x200] sk_stream_wait_memory+0xcd/0x200
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
exhaustion. This is because both sk_stream_memory_free() and vm_wait are true which causes sk_wait_event() to *not* call schedule_timeout(). 
Hence sk_stream_wait_memory() returns immediately to the caller w/o sleeping.
This causes the caller to again try allocation, which again fails and again
calls sk_stream_wait_memory(), and so on.


Signed-off-by: Nagendra Singh Tomar <tomer_iisc@yahoo.com>
---
--- linux-2.6.35.7/net/core/stream.c.orig	2010-03-23 23:46:45.000000000 +0530
+++ linux-2.6.35.7/net/core/stream.c	2010-03-24 00:21:09.000000000 +0530
@@ -73,9 +73,8 @@ int sk_stream_wait_connect(struct sock *
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 		sk->sk_write_pending++;
 		done = sk_wait_event(sk, timeo_p,
-				     !sk->sk_err &&
-				     !((1 << sk->sk_state) &
-				       ~(TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)));
+				     ((1 << sk->sk_state) &
+				       (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)));
 		finish_wait(sk_sleep(sk), &wait);
 		sk->sk_write_pending--;
 	} while (!done);
@@ -144,10 +143,9 @@ int sk_stream_wait_memory(struct sock *s
 
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		sk->sk_write_pending++;
-		sk_wait_event(sk, &current_timeo, !sk->sk_err &&
-						  !(sk->sk_shutdown & SEND_SHUTDOWN) &&
-						  sk_stream_memory_free(sk) &&
-						  vm_wait);
+		sk_wait_event(sk, &current_timeo, sk->sk_err ||
+						  (sk->sk_shutdown & SEND_SHUTDOWN) ||
+						  (sk_stream_memory_free(sk) && !vm_wait));
 		sk->sk_write_pending--;
 
 		if (vm_wait) {




      
