Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1CMPH1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:07:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab1CMPHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:07:00 -0400
Date: Sun, 13 Mar 2011 17:06:47 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.osdl.org, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] vhost-net: use lock_sock_fast() in peek_head_len()
Message-ID: <20110313150646.GA30494@redhat.com>
References: <20110117081058.18900.67456.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
 <20110117081117.18900.48672.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110117081117.18900.48672.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 04:11:17PM +0800, Jason Wang wrote:
> We can use lock_sock_fast() instead of lock_sock() in order to get
> speedup in peek_head_len().
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/net.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index c32a2e4..50b622a 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -211,12 +211,12 @@ static int peek_head_len(struct sock *sk)
>  {
>  	struct sk_buff *head;
>  	int len = 0;
> +	bool slow = lock_sock_fast(sk);
>  
> -	lock_sock(sk);
>  	head = skb_peek(&sk->sk_receive_queue);
>  	if (head)
>  		len = head->len;
> -	release_sock(sk);
> +	unlock_sock_fast(sk, slow);
>  	return len;
>  }
>  

Wanted to apply this, but looking at the code I think the lock_sock here
is wrong. What we really need is to handle the case where the skb is
pulled from the receive queue after skb_peek.  However this is not the
right lock to use for that, sk_receive_queue.lock is.
So I expect the following is the right way to handle this.
Comments?

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 0329c41..5720301 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -213,12 +213,13 @@ static int peek_head_len(struct sock *sk)
 {
 	struct sk_buff *head;
 	int len = 0;
+	unsigned long flags;
 
-	lock_sock(sk);
+	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
 	head = skb_peek(&sk->sk_receive_queue);
-	if (head)
+	if (likely(head))
 		len = head->len;
-	release_sock(sk);
+	spin_unlock_irqrestore(&sk->sk_receive_queue.lock, flags);
 	return len;
 }
 
