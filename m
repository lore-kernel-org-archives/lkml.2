Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab1CXQP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:15:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59464 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab1CXQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UqYk4q9stRwY2LHKErNdiMSlg3bBkvt86BF6H/a9iKftjkJ6hDnmUzkBgeCWyttHQC
         xV1h5OdMioAYsPFCvXUUTKFSm58028WUNuf61ilvaZp1bxjS+QFoh2J6Sq1LKnpGzBij
         5UNYK5/1z9kjXMXOtrLuOr9y53mTEmmlpWnUM=
Subject: Re: regression: ip r change mss doesn't work in 2.6.38-git14
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTikZhT5LaA-UEXniDvkneH8JScaVaCaCd4LT59cV@mail.gmail.com>
References: <AANLkTik6+TrjiC6ZF+KHhZ1iPzEe2jDayr363C0HgQN4@mail.gmail.com>
	 <1300980118.3747.42.camel@edumazet-laptop>
	 <AANLkTikZhT5LaA-UEXniDvkneH8JScaVaCaCd4LT59cV@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 17:15:40 +0100
Message-ID: <1300983340.3747.44.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 24 mars 2011 à 16:52 +0100, Alessandro Suardi a écrit :
> On Thu, Mar 24, 2011 at 4:21 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le jeudi 24 mars 2011 à 16:08 +0100, Alessandro Suardi a écrit :
> >> After fixing the display issue thanks to Chris Wilson, I now have
> >> another problem
> >>  (which didn't exist in 2.6.38-git2); most websites outside of my DSL link don't
> >>  work properly (connection packet goes through, but the page load times out
> >>  within Firefox) unless I do
> >>
> >> ip r change default via 192.168.1.1 dev eth1 advmss 1400
> >>
> >> This however doesn't change advmss anymore:
> >>
> >> [root@duff ~]# ip r
> >> default via 192.168.1.1 dev eth1
> >> 169.254.0.0/16 dev eth1  scope link  metric 1004
> >> 192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.8
> >> [root@duff ~]# ip r change default via 192.168.1.1 dev eth1 advmss 1400
> >> [root@duff ~]# ip r
> >> default via 192.168.1.1 dev eth1
> >> 169.254.0.0/16 dev eth1  scope link  metric 1004
> >> 192.168.1.0/24 dev eth1  proto kernel  scope link  src 192.168.1.8
> >
> > Indeed, we'll take a look, thanks for the report.
> >
> > In the time being you can do :
> >
> > ip ro change default via 192.168.1.1 dev eth1 advmss 1400 mtu 1500
> 
> Thanks - this one works for me.
> 
> I'm available to test patches if needed, though I have a feeling you
>  already have a handle on the issue and won't need that ;)

;)

I am testing following patch :

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 622ac4c..654ef5b 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -251,7 +251,7 @@ static struct fib_info *fib_find_info(const struct fib_info *nfi)
 		    nfi->fib_prefsrc == fi->fib_prefsrc &&
 		    nfi->fib_priority == fi->fib_priority &&
 		    memcmp(nfi->fib_metrics, fi->fib_metrics,
-			   sizeof(fi->fib_metrics)) == 0 &&
+			   sizeof(u32) * RTAX_MAX) == 0 &&
 		    ((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_F_DEAD) == 0 &&
 		    (nfi->fib_nhs == 0 || nh_comp(fi, nfi) == 0))
 			return fi;



