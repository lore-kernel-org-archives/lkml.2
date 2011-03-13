Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1CMPxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 11:53:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61347 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1CMPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 11:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=az4/4a/+ZSzuTTc47w+Xel3EHd7N6lkS57Nlei19Qo2/C8azhv+ttjnQr91c5dtkD7
         oUwW6SYnrzC190yxE5sclw4OGisjjCABKK0HgLcaeQGSNteuA1XcG7nkemrGPhuXceCL
         YjV+dmIYPyts97rkVP0NqB5hnMdugq/FSmATw=
Subject: Re: [PATCH 3/3] vhost-net: use lock_sock_fast() in peek_head_len()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, virtualization@lists.osdl.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110313150646.GA30494@redhat.com>
References: <20110117081058.18900.67456.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
	 <20110117081117.18900.48672.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
	 <20110313150646.GA30494@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Mar 2011 16:52:50 +0100
Message-ID: <1300031570.2761.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 13 mars 2011 à 17:06 +0200, Michael S. Tsirkin a écrit :
> On Mon, Jan 17, 2011 at 04:11:17PM +0800, Jason Wang wrote:
> > We can use lock_sock_fast() instead of lock_sock() in order to get
> > speedup in peek_head_len().
> > 
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > ---
> >  drivers/vhost/net.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index c32a2e4..50b622a 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -211,12 +211,12 @@ static int peek_head_len(struct sock *sk)
> >  {
> >  	struct sk_buff *head;
> >  	int len = 0;
> > +	bool slow = lock_sock_fast(sk);
> >  
> > -	lock_sock(sk);
> >  	head = skb_peek(&sk->sk_receive_queue);
> >  	if (head)
> >  		len = head->len;
> > -	release_sock(sk);
> > +	unlock_sock_fast(sk, slow);
> >  	return len;
> >  }
> >  
> 
> Wanted to apply this, but looking at the code I think the lock_sock here
> is wrong. What we really need is to handle the case where the skb is
> pulled from the receive queue after skb_peek.  However this is not the
> right lock to use for that, sk_receive_queue.lock is.
> So I expect the following is the right way to handle this.
> Comments?
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 0329c41..5720301 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -213,12 +213,13 @@ static int peek_head_len(struct sock *sk)
>  {
>  	struct sk_buff *head;
>  	int len = 0;
> +	unsigned long flags;
>  
> -	lock_sock(sk);
> +	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
>  	head = skb_peek(&sk->sk_receive_queue);
> -	if (head)
> +	if (likely(head))
>  		len = head->len;
> -	release_sock(sk);
> +	spin_unlock_irqrestore(&sk->sk_receive_queue.lock, flags);
>  	return len;
>  }
>  

You may be right, only way to be sure is to check the other side.

If it uses skb_queue_tail(), then yes, your patch is fine.

If other side did not lock socket, then your patch is a bug fix.



