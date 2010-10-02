Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0JBMQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 08:16:49 -0400
Received: from web53705.mail.re2.yahoo.com ([206.190.37.26]:47282 "HELO
	web53705.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754111Ab0JBMQs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 08:16:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=RAllDjk4dRybT0ekpHxM+ly2W1gBtmS8xXoEWupeTqyILtcbg0oiGqo4CuT/do2yBkRFWOdztcUK1gB8NUJQwPsDgjtbPMU2ruCs9UjRwM45RmIyNCquV0uINNqsztwADHfba1s+o0zXAscta28fbrw16+fbfK6rgQevKU3RAlo=;
Message-ID: <605654.23716.qm@web53705.mail.re2.yahoo.com>
X-YMail-OSG: mS_GQngVM1knYAy5P36zIVxZL0Z7O2r55TZhmmcvNM3VHOx
 0zrS4FTNflwvR98ImI94KFUML9aEZBce.En_oBgedrCE_3cmKCBGjgrEprLT
 ht2jv8cqK9SYa8W4OVysPB5aSipG21jDoxP_3jqFGNJEMDcFU5SiJX6p7zpR
 FBXP.3ZUcNxaquz6vSsiwdH4JBo7q8GhmXwby3vVCqYSIB1z_3Js_JxSErMG
 ZC0j2tJ5._ntw6tRD0pFxMCqyeCJCMf2xFGWu9T.KtQls8gZPPRyjQRlLWMs
 rhu3rg9VPPlfXFCixRMh6xZEfrvty4098wchGjqjL1RZcmA4dxNa4Q8JH.1I
 YC.82F9EGYA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sat, 2 Oct 2010 05:16:47 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2/2] net: Fix the condition passed to sk_wait_event()
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second part of the split up patch submitted in http://www.spinics.net/lists/netdev/msg142617.html

This fixes the condition (3rd arg) passed to sk_wait_event() in sk_stream_wait_memory(). The incorrect check in sk_stream_wait_memory() causes the following soft lockup in tcp_sendmsg() when the global tcp memory pool has exhausted. 

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
--- linux-2.6.35.7/net/core/stream.c.orig	2010-03-24 09:31:00.000000000 +0530
+++ linux-2.6.35.7/net/core/stream.c	2010-03-24 09:31:08.000000000 +0530
@@ -143,10 +143,9 @@ int sk_stream_wait_memory(struct sock *s
 
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



      
