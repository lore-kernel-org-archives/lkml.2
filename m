Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab0IUKsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 06:48:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47728 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab0IUKs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 06:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=RqaCSYjxHLWQyF2Whtl15oIi6NYD1v4q+sEX4QG0PV0HnjPuipLcEpyw5pjdABPZmS
         8hSxfkSMI7WdAm28AcPqGkyIRwvDL2J3VvQ5S3qRWFbMv3VbHKLyfgCykGgpgFHvCyTx
         Rnp12eRxIw/OzOZZRAETVvrcwN8RdsymXAaZw=
Date: Tue, 21 Sep 2010 10:48:21 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression, bisected: reference leak with IPSec since ~2.6.31
Message-ID: <20100921104821.GA8986@ff.dom.local>
References: <20100921091248.GA8424@ff.dom.local> <1285060860.2617.158.camel@edumazet-laptop> <20100921093853.GA8664@ff.dom.local> <1285062948.2617.204.camel@edumazet-laptop> <1285063657.2617.226.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1285063657.2617.226.camel@edumazet-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 12:07:37PM +0200, Eric Dumazet wrote:
> Le mardi 21 septembre 2010 ?? 11:55 +0200, Eric Dumazet a écrit :
> > Le mardi 21 septembre 2010 ?? 09:38 +0000, Jarek Poplawski a écrit :
> > > On Tue, Sep 21, 2010 at 11:21:00AM +0200, Eric Dumazet wrote:
> > 
> > > I hope you're right with this.
> > > 
> > > > 
> > > > I liked the :
> > > > 
> > > > <check everything without changing state>
> > > > if something wrong
> > > > 	goto slow_path
> > > > else
> > > > 	<OK, lets do destructive things>
> > > > 
> > > 
> > > But it's an optimization of the "unlikely" case btw. ;-)
> > > 
> > 
> > This is a bug fix, in a complex function.
> > 
> > in -next branch, we can try to be smart, adding more code in slow_path
> > to revert what was done in the hope fast path would be taken.
> > And pray we dont add another bug :)

But if you were honest about caches there is no reason to be smart
no more. ;-)

Below is your patch mostly as an example only that I didn't mean
nothing complex (ipv4 only, not compiled).

Jarek P.
---

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 04b6989..049d61f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -490,7 +490,6 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 	if (skb_has_frags(skb)) {
 		struct sk_buff *frag;
 		int first_len = skb_pagelen(skb);
-		int truesizes = 0;
 
 		if (first_len - hlen > mtu ||
 		    ((first_len - hlen) & 7) ||
@@ -503,18 +502,18 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 			if (frag->len > mtu ||
 			    ((frag->len & 7) && frag->next) ||
 			    skb_headroom(frag) < hlen)
-			    goto slow_path;
+			    goto slow_path_clean;
 
 			/* Partially cloned skb? */
 			if (skb_shared(frag))
-				goto slow_path;
+				goto slow_path_clean;
 
 			BUG_ON(frag->sk);
 			if (skb->sk) {
 				frag->sk = skb->sk;
 				frag->destructor = sock_wfree;
+				skb->truesize -= frag->truesize;
 			}
-			truesizes += frag->truesize;
 		}
 
 		/* Everything is OK. Generate! */
@@ -524,7 +523,6 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 		frag = skb_shinfo(skb)->frag_list;
 		skb_frag_list_init(skb);
 		skb->data_len = first_len - skb_headlen(skb);
-		skb->truesize -= truesizes;
 		skb->len = first_len;
 		iph->tot_len = htons(first_len);
 		iph->frag_off = htons(IP_MF);
@@ -576,6 +574,17 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
 		}
 		IP_INC_STATS(dev_net(dev), IPSTATS_MIB_FRAGFAILS);
 		return err;
+
+slow_path_clean:
+		if (skb->sk) {
+			skb_walk_frags(skb, frag) {
+				if (!frag->sk)
+					break;
+				frag->sk = NULL;
+				frag->destructor = NULL;
+				skb->truesize += frag->truesize;
+			}
+		}
 	}
 
 slow_path:
