Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1G0P7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:59:22 -0400
Received: from mail.tpi.com ([70.99.223.143]:3696 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab1G0P7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:59:19 -0400
Message-ID: <4E3035BE.6090908@canonical.com>
Date: Wed, 27 Jul 2011 09:58:54 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: ebiederm@xmission.com, dan@aloni.org, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com, stable@vger.kernel.org
Subject: Re: [stable] [PATCH] [26/98] af_unix: Only allow recv on connected
 seqpacket sockets.
References: <20110726534.972201586@firstfloor.org> <20110727003518.6DA772403FF@tassilo.jf.intel.com>
In-Reply-To: <20110727003518.6DA772403FF@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 06:35 PM, Andi Kleen wrote:
> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
>
> ------------------
> From: Eric W. Biederman<ebiederm@xmission.com>
>
> commit a05d2ad1c1f391c7f514a1d1e09b5417968a7d07 upstream.
>
> This fixes the following oops discovered by Dan Aloni:
>> Anyway, the following is the output of the Oops that I got on the
>> Ubuntu kernel on which I first detected the problem
>> (2.6.37-12-generic). The Oops that followed will be more useful, I
>> guess.
>
>> [ 5594.669852] BUG: unable to handle kernel NULL pointer dereference
>> at Â  Â  Â  Â  Â  (null)
>> [ 5594.681606] IP: [<ffffffff81550b7b>] unix_dgram_recvmsg+0x1fb/0x420
>> [ 5594.687576] PGD 2a05d067 PUD 2b951067 PMD 0
>> [ 5594.693720] Oops: 0002 [#1] SMP
>> [ 5594.699888] last sysfs file:
>
> The bug was that unix domain sockets use a pseduo packet for
> connecting and accept uses that psudo packet to get the socket.
> In the buggy seqpacket case we were allowing unconnected
> sockets to call recvmsg and try to receive the pseudo packet.
>
> That is always wrong and as of commit 7361c36c5 the pseudo
> packet had become enough different from a normal packet
> that the kernel started oopsing.
>
> Do for seqpacket_recv what was done for seqpacket_send in 2.5
> and only allow it on connected seqpacket sockets.
>
> Tested-by: Dan Aloni<dan@aloni.org>
> Signed-off-by: Eric W. Biederman<ebiederm@xmission.com>
> Signed-off-by: David S. Miller<davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
> Signed-off-by: Andi Kleen<ak@linux.intel.com>
>
> ---
>   net/unix/af_unix.c |   16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.35.y/net/unix/af_unix.c
> ===================================================================
> --- linux-2.6.35.y.orig/net/unix/af_unix.c
> +++ linux-2.6.35.y/net/unix/af_unix.c
> @@ -504,6 +504,8 @@ static int unix_dgram_connect(struct soc
>   			      int, int);
>   static int unix_seqpacket_sendmsg(struct kiocb *, struct socket *,
>   				  struct msghdr *, size_t);
> +static int unix_seqpacket_recvmsg(struct kiocb *, struct socket *,
> +				  struct msghdr *, size_t, int);
>
>   static const struct proto_ops unix_stream_ops = {
>   	.family =	PF_UNIX,
> @@ -563,7 +565,7 @@ static const struct proto_ops unix_seqpa
>   	.setsockopt =	sock_no_setsockopt,
>   	.getsockopt =	sock_no_getsockopt,
>   	.sendmsg =	unix_seqpacket_sendmsg,
> -	.recvmsg =	unix_dgram_recvmsg,
> +	.recvmsg =	unix_seqpacket_recvmsg,
>   	.mmap =		sock_no_mmap,
>   	.sendpage =	sock_no_sendpage,
>   };
> @@ -1676,6 +1678,18 @@ static int unix_seqpacket_sendmsg(struct
>   	return unix_dgram_sendmsg(kiocb, sock, msg, len);
>   }
>
> +static int unix_seqpacket_recvmsg(struct kiocb *iocb, struct socket *sock,
> +			      struct msghdr *msg, size_t size,
> +			      int flags)
> +{
> +	struct sock *sk = sock->sk;
> +
> +	if (sk->sk_state != TCP_ESTABLISHED)
> +		return -ENOTCONN;
> +
> +	return unix_dgram_recvmsg(iocb, sock, msg, size, flags);
> +}
> +
>   static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
>   {
>   	struct unix_sock *u = unix_sk(sk);
>
>
>
>
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable

Andi - Ubuntu has reverted this patch for both Lucid (2.6.32) and Natty 
(2.6.38) as it appears to cause a networking regression, though we never 
really figured out root cause. Empirically, reverting the patch solved 
the issue. Eric Biederman theorized that it uncovered a user space issue 
(trying to read before listen), but the bug reporter seems to have lost 
interest in testing kernels so we couldn't ever pin it down.

http://bugs.launchpad.net/bugs/791512

We also decided that reverting this patch was likely OK because we 
couldn't find any Launchpad reports of the Ooops mentioned in the patch 
commit log, nor does a google search turn up any hits.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
