Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab2JEMWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:22:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58934 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2JEMWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:22:17 -0400
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109
 __alloc_pages_nodemask+0x1d4/0x68c()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: mbizon@freebox.fr
Cc: David Madore <david+ml@madore.org>, Francois Romieu <romieu@fr.zoreil.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <1349434194.16710.44.camel@sakura.staff.proxad.net>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net>
	 <alpine.LSU.2.00.1208311900330.1936@eggly.anvils>
	 <1349366521.2532.12.camel@sakura.staff.proxad.net>
	 <1349368171.16011.79.camel@edumazet-glaptop>
	 <1349422868.21172.38.camel@edumazet-glaptop>
	 <1349434194.16710.44.camel@sakura.staff.proxad.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Oct 2012 14:22:12 +0200
Message-ID: <1349439732.21172.52.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 12:49 +0200, Maxime Bizon wrote:
> On Fri, 2012-10-05 at 09:41 +0200, Eric Dumazet wrote:
> 
> > By the way, the commit you pointed has no effect on the reallocation
> > performed by pskb_expand_head() :
> 
> The commit has a side effect, because the problem appeared after it was
> merged (and goes away if I revert it)
> 
> > int size = nhead + skb_end_offset(skb) + ntail;
> > 
> > So pskb_expand_head() always assumed the current head is fully used, and
> > because we have some kmalloc-power-of-two contraints, each time
> > pskb_expand_head() is called with a non zero (nhead + ntail) we double
> > the skb->head ksize.
> 
> That is true, but only after the commit I mentioned.
> 
> Before that commit, we indeed reallocate skb->head to twice the size,
> but skb->end is *not* positioned at the end of newly allocated data. So
> on the next pskb_expand_head(), if head and tail are not big values, the
> kmalloc() will be of the same size.
> 
> 
> The commit adds this after allocation:
> 
> size = SKB_WITH_OVERHEAD(ksize(data))
> [...]
> skb->end      = skb->head + size;
> 
> so on the next pskb_expand_head, we are going to allocate twice the size
> for sure.

Yes, but the idea of the patch was to _avoid_ next pskb_expand_head()
calls...

Its defeated because you have a too small NET_SKB_PAD, and skb_recycle()
inability to properly detect ans skb is oversized.

> 
> > So why are we using skb_end_offset(skb) here is the question.
> > 
> > I guess it could be (skb_tail_pointer(skb) - skb->head) on some uses.
> 
> I think your patch is wrong, ntail is not the new tailroom size, it's
> what missing to the current tailroom size, by adding ntail + nhead +
> tail_offset we are removing previous tailroom.
> 



> We cannot shrink the skb that way here I guess, a caller may check
> needed headroom & tailroom, calls with nhead=1/ntail=0 because only
> headroom is missing, but after the call tailroom would be less than
> before the call.
> 
> Why don't we juste reallocate to this size:
> 
> MAX(current_alloc_size, nhead + ntail + current_end - current_head)

Hmm, 

this changes nothing assuming current_end == skb_end_offset(skb)
and current_head = skb->head

Not sure what you mean.

I guess the right answer is to change API, because we have no clue if
the callers want some tailroom or not.

If they have 'enough' they currently pass 0, so we dont really now how
many bytes they really need..

In fact very few call sites need to increase the tailroom, so it's
probably very easy to do this change.

New convention would be : pass number of needed bytes after current
tail, not after current end.



