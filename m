Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1FFMMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:12:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51207 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab1FFMMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:12:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=doLd+E0Jc3V8QPyd74kbEb97li5ymLmB9SlcDhdnVny+s5JV0d4i1BTu8w4dqeo3/3
         tSu8zv69BpOCFnJx3Jz+YrJJUjQ2lkocpj9jvbyyDFfCNL62q3QsfGkuDgNLdLq8vcX+
         +SjKDc4iyazvEaVaQRH5vZQbdqNo6eW5M1sAE=
Subject: Re: bridge/netfilter: regression in 2.6.39.1
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
In-Reply-To: <4DECBEA3.6070408@ahsoftware.de>
References: <4DE93422.3070000@ahsoftware.de>
	 <20110606111507.GA1000@hmsreliant.think-freely.org>
	 <4DECBEA3.6070408@ahsoftware.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 14:12:37 +0200
Message-ID: <1307362358.3098.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 13:48 +0200, Alexander Holler a écrit :
> Am 06.06.2011 13:15, schrieb Neil Horman:
> > On Fri, Jun 03, 2011 at 09:21:06PM +0200, Alexander Holler wrote:
> >> Hello,
> >>
> >> I'm getting a oops in the bridge code in br_change_mtu() with
> >> 2.6.39.1. The patch below seems to fix that.
> >>
> >> I'm not sure about the usage of dst_cow_metrics_generic() in
> >> fake_dst_ops, but after having a quick look at it seems to be ok to
> >> use that here.
> >>
> >> Regards,
> >>
> >> Alexander
> >>
> > How did the flags of the dst entry on which we're callnig dst_entry_write_ptr
> > wind up getting the  READ_ONLY flag set on it?  I don't see how we'er falling
> > into that clause in which we call cow_metrics when we call dst_metric_set.  It
> > seems like that flag is set erroneously.  perhaps we should just update
> > fake_rtable.dst to have the correct flags?
> > Neil
> 
> It is set by that change:
> 
> --------
> @@ -124,7 +128,7 @@ void br_netfilter_rtable_init(struct net_bridge *br)
>   	atomic_set(&rt->dst.__refcnt, 1);
>   	rt->dst.dev = br->dev;
>   	rt->dst.path = &rt->dst;
> -	dst_metric_set(&rt->dst, RTAX_MTU, 1500);
> +	dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
>   	rt->dst.flags	= DST_NOXFRM;
>   	rt->dst.ops = &fake_dst_ops;
>   }
> --------
> 
> The true in dst_init_metrics() is responsible for that flag.
> 

You are aware this change fixed an oops ?

read_only in this context means : In case this must be written, we make
a COW first
(allocate a piece of memory, copy the source in it before applying any
change)

It would be nice you send us the stack trace, so that we can have a clue
of whats going on.

Thanks


