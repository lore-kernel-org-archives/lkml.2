Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab0E0TrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:47:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61089 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759186Ab0E0TrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oSmaVLpNx1PHHeGlfRSDKb6Z/WG37jEbmyPvrJ0C71kjVG+UivpytrZkTsT8JHNo70
         G+f5JQ4DdAxR8icQHCs7qj56xnrQbrINqE6w20muE7qeXYHfWGcQ8nCtEcRDYRxSzv6p
         aKDGR6mPCEj2qUNYzzJw+7yijw8dQ2hUh926Q=
Subject: Re: boot crash in arp_error_report() (Re: [GIT] Networking)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1005271213091.3689@i5.linux-foundation.org>
References: <20100525.165945.39198480.davem@davemloft.net>
	 <20100527190652.GA20303@elte.hu>
	 <alpine.LFD.2.00.1005271213091.3689@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 21:47:17 +0200
Message-ID: <1274989637.2446.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 27 mai 2010 à 12:27 -0700, Linus Torvalds a écrit :
> 
> On Thu, 27 May 2010, Ingo Molnar wrote:
> > 
> > FYI, this boot crash in arp_error_report() started triggering in -tip testing:
> > 
> > [  113.285384] BUG: unable to handle kernel paging request at 6b6b6b87
> 
> That's the POISON_FREE signature, with an offset of 28 (0x1c).
> 
> And it looks like the whole function got captured in the Code: sequence. 
> It looks like this:
> 
>    0:	55                   	push   %ebp
>    1:	89 e5                	mov    %esp,%ebp
>    3:	53                   	push   %ebx
>    4:	0f 1f 44 00 00       	nopl   0x0(%eax,%eax,1)
>    9:	89 d3                	mov    %edx,%ebx
>    b:	89 d0                	mov    %edx,%eax
>    d:	e8 fa fb ff ff       	call   0xfffffc0c		# skb_dst()
>   12:	85 c0                	test   %eax,%eax		# dst
>   14:	74 12                	je     0x28
>   16:	8b 40 40             	mov    0x40(%eax),%eax		# dst->ops
>   19:	85 c0                	test   %eax,%eax
>   1b:	74 0b                	je     0x28
>   1d:*	8b 50 1c             	mov    0x1c(%eax),%edx     <-- trapping instruction
>   20:	85 d2                	test   %edx,%edx
>   22:	74 04                	je     0x28
>   24:	89 d8                	mov    %ebx,%eax
>   26:	ff d2                	call   *%edx			# dst->ops->link_failure()
>   28:	89 d8                	mov    %ebx,%eax
>   2a:	e8 9b 50 fa ff       	call   0xfffa50ca		# skb_free()
>   2f:	5b                   	pop    %ebx
>   30:	5d                   	pop    %ebp
>   31:	c3                   	ret    
> 
> Where most of it is "dst_link_failure()" being inlined (that last "callq" 
> is the call to kfree_skb().
> 
> Looks like 'dst' points to free'd memory, so when we load a pointer from 
> it (the dst->ops) field, we get 0x6b6b6b6b, and then when we try to load
> dst->ops->link_failure it oopses.
> 
> tl;dr: that
> 
> 	struct dst_entry *dst = skb_dst(skb);
> 
> in dst_link_failure seems to result in a stale skb.
> 
> 		Linus
> --

I am looking at this bug report, as I am probably at fault, please give
me one or two hour ;)

Thanks


