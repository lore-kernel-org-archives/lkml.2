Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab0EZF3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 01:29:13 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41332 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0EZF3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 01:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qHqroS8DEHPuDbdh0mCN9cW4FMBGLcR94XC+WfNksoS0pB0Yz3i39mQw4aIZrpGnwV
         DfuN3F4hbIaGv6vuVzIS6vVUzxmy2FwCEul5t/ow5OOyCSFzRvjsnqMqDn7rTtpbWTmx
         0JHLCm0SfnND70dHxyWxczimvolzk/o6Iw5UU=
Subject: RE: NULL Pointer Deference: NFS & Telnet
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Arce, Abraham" <x0066660@ti.com>
Cc: David Miller <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
In-Reply-To: <27F9C60D11D683428E133F85D2BB4A53043E3EDFF1@dlee03.ent.ti.com>
References: <27F9C60D11D683428E133F85D2BB4A53043E33A997@dlee03.ent.ti.com>
	 <27F9C60D11D683428E133F85D2BB4A53043E3EDFE6@dlee03.ent.ti.com>
	 <20100525.185236.193707791.davem@davemloft.net>
	 <27F9C60D11D683428E133F85D2BB4A53043E3EDFF1@dlee03.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 07:29:01 +0200
Message-ID: <1274851741.25136.16.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 25 mai 2010 à 21:02 -0500, Arce, Abraham a écrit :
> Thanks David,
> 
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index f8abf68..eb81f76 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -334,7 +334,7 @@ static void skb_release_data(struct sk_buff *skb)
> > >  	if (!skb->cloned ||
> > >  	    !atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
> > >  			       &skb_shinfo(skb)->dataref)) {
> > > -		if (skb_shinfo(skb)->nr_frags) {
> > > +		if (skb_shinfo(skb)->nr_frags && skb_has_frags(skb)) {
> > >  			int i;
> > >  			for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
> > >  				put_page(skb_shinfo(skb)->frags[i].page);
> > 
> > skb_shinfo(skb)->nr_frags counts the number of entries contained
> > in the skb_shinfo(skb)->frags[] array.
> > 
> > This has nothing to do with the frag list pointer,
> > skb_shinfo(skb)->frag_list, which is what skb_has_frags()
> > tests.
> > 
> > You've got some kind of memory corruption going on and it
> > appears to have nothing to do with the code paths you're
> > playing with here.
> 
> Do you have any recommendation on debugging technique/tool for this memory corruption issue?
> 
> Best Regards
> Abraham
> --

It seems quite strange. You have a skb->nr_frags > 0 value, but a
frags[i].page = 0 value

You might add following function :

shinfo_check(struct sk_buff *skb)
{
	struct skb_shared_info *shinfo = skb_shinfo(skb);
	int i;

	WARN_ON(shinfo->nr_frags >= MAX_SKB_FRAGS);
	for (i = 0; i < shinfo->nr_frags; i++)
		WARN_ON(!shinfo->frags[i].page);
}

And call it from various points, to check who corrupts your skb.



