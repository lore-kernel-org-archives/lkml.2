Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab0JBI1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 04:27:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50319 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab0JBI1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 04:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oRoq41t3K1TAz4vpdxACp9iFH4PVB7jp9ajSVL+lYqEV6IZSNYoDdVIwwhy13KGKp8
         dfey+kJPeXpcTuL6At+Z4BPA0/47e+M4WfvP3M3QhyGk1Zcy8cp6BF2QOSXT6Oh5dkb5
         6uizswBpOWcqn5pBiP8AHz9ZCjvWiKjEWGOBM=
Subject: Re: [PATCH 2.6.35.7] net: Fix the condition passed to
 sk_wait_event()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nagendra Tomar <tomer_iisc@yahoo.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org
In-Reply-To: <667106.4951.qm@web53706.mail.re2.yahoo.com>
References: <667106.4951.qm@web53706.mail.re2.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 10:27:31 +0200
Message-ID: <1286008051.2582.846.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 02 octobre 2010 à 01:22 -0700, Nagendra Tomar a écrit :
> Resending ...
> 
> 
> The condition (3rd arg) passed to sk_wait_event() in sk_stream_wait_memory() and sk_stream_wait_connect() are incorrect.
> The incorrect check in sk_stream_wait_memory() causes the following soft lockup in tcp_sendmsg() when the global tcp memory pool has exhausted. The check in sk_stream_wait_connect() was found by code audit.
>    
> 
> >>> snip <<<
> 
> localhost kernel: BUG: soft lockup - CPU#3 stuck for 11s! [sshd:6429]
> localhost kernel: CPU 3:
> localhost kernel: RIP: 0010:[sk_stream_wait_memory+0xcd/0x200]  [sk_stream_wait_memory+0xcd/0x200] sk_stream_wait_memory+0xcd/0x200
> localhost kernel: Call Trace:
> localhost kernel:  [sk_stream_wait_memory+0x1b1/0x200] sk_stream_wait_memory+0x1b1/0x200
> localhost kernel:  [<ffffffff802557c0>] autoremove_wake_function+0x0/0x40
> localhost kernel:  [ipv6:tcp_sendmsg+0x6e6/0xe90] tcp_sendmsg+0x6e6/0xce0
> localhost kernel:  [sock_aio_write+0x126/0x140] sock_aio_write+0x126/0x140
> localhost kernel:  [xfs:do_sync_write+0xf1/0x130] do_sync_write+0xf1/0x130
> localhost kernel:  [<ffffffff802557c0>] autoremove_wake_function+0x0/0x40
> localhost kernel:  [hrtimer_start+0xe3/0x170] hrtimer_start+0xe3/0x170
> localhost kernel:  [vfs_write+0x185/0x190] vfs_write+0x185/0x190
> localhost kernel:  [sys_write+0x50/0x90] sys_write+0x50/0x90
> localhost kernel:  [system_call+0x7e/0x83] system_call+0x7e/0x83
> 
> >>> snip <<<
> 
> What is happening is, that the sk_wait_event() condition passed from
> sk_stream_wait_memory() evaluates to true for the case of tcp global memory
> exhaustion. This is because both sk_stream_memory_free() and vm_wait are true which causes sk_wait_event() to *not* call schedule_timeout(). 
> Hence sk_stream_wait_memory() returns immediately to the caller w/o sleeping.
> This causes the caller to again try allocation, which again fails and again
> calls sk_stream_wait_memory(), and so on.
> 
> 

Hi Nagendra


> Signed-off-by: Nagendra Singh Tomar <tomer_iisc@yahoo.com>
> ---
> --- linux-2.6.35.7/net/core/stream.c.orig	2010-03-23 23:46:45.000000000 +0530
> +++ linux-2.6.35.7/net/core/stream.c	2010-03-24 00:21:09.000000000 +0530
> @@ -73,9 +73,8 @@ int sk_stream_wait_connect(struct sock *
>  		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
>  		sk->sk_write_pending++;
>  		done = sk_wait_event(sk, timeo_p,
> -				     !sk->sk_err &&
> -				     !((1 << sk->sk_state) &
> -				       ~(TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)));
> +				     ((1 << sk->sk_state) &
> +				       (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)));

Just wondering why you remove the test on sk->err ?

We want to break the loop If sk->sk_err is set, or state is ESTABLISHED
or CLOSE_WAIT.

>  		finish_wait(sk_sleep(sk), &wait);
>  		sk->sk_write_pending--;
>  	} while (!done);
> @@ -144,10 +143,9 @@ int sk_stream_wait_memory(struct sock *s
>  
>  		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
>  		sk->sk_write_pending++;
> -		sk_wait_event(sk, &current_timeo, !sk->sk_err &&
> -						  !(sk->sk_shutdown & SEND_SHUTDOWN) &&
> -						  sk_stream_memory_free(sk) &&
> -						  vm_wait);
> +		sk_wait_event(sk, &current_timeo, sk->sk_err ||
> +						  (sk->sk_shutdown & SEND_SHUTDOWN) ||
> +						  (sk_stream_memory_free(sk) && !vm_wait));
>  		sk->sk_write_pending--;
>  
>  		if (vm_wait) {
> 
> 
> 

Thanks !



