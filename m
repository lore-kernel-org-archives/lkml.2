Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0FWR3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 13:29:37 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:60964 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab0FWR3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 13:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YXXDOdU3f0G2icOiUmp27qkeV1eTmA/1JwpERccS6vi8pkh2GMUwtEeT3ntdc1/WL0
         cAWDRWHz04apITkGxWludh9++oONn0KQSMpUDdlkuvB+tzRq1JzE6BGeXn93Iu83akqp
         Io/ugreU7TGKNKQmrEDJpjOZ8mZv9L9TnCHcs=
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 00000000000000a0
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Justin P.Mattock" <justinmattock@gmail.com>
Cc: "John W.Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, timo.teras@iki.fi
In-Reply-To: <4C223DCA.5090704@gmail.com>
References: <AANLkTilf41JrFwN1veRDifNA78S2LQ6SO0g3YLOONd2W@mail.gmail.com>
	 <20100623141622.GC15205@tuxdriver.com>  <4C223DCA.5090704@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 19:29:27 +0200
Message-ID: <1277314167.2469.1144.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 23 juin 2010 à 10:00 -0700, Justin P. Mattock a écrit :
> o.k. the bisect is pointing to the below results..
> (I tried git revert xxx but this commit is too big
> so I'll(hopefully)manually revert it on the latest HEAD to
> see if this is the actual problem im experiencing)
> 
> 
> 
> 80c802f3073e84c956846e921e8a0b02dfa3755f is the first bad commit
> commit 80c802f3073e84c956846e921e8a0b02dfa3755f
> Author: Timo TerÃ¤s <timo.teras@iki.fi>
> Date:   Wed Apr 7 00:30:05 2010 +0000
> 
>      xfrm: cache bundles instead of policies for outgoing flows
> 
>      __xfrm_lookup() is called for each packet transmitted out of
>      system. The xfrm_find_bundle() does a linear search which can
>      kill system performance depending on how many bundles are
>      required per policy.
> 
>      This modifies __xfrm_lookup() to store bundles directly in
>      the flow cache. If we did not get a hit, we just create a new
>      bundle instead of doing slow search. This means that we can now
>      get multiple xfrm_dst's for same flow (on per-cpu basis).
> 
>      Signed-off-by: Timo Teras <timo.teras@iki.fi>
>      Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> :040000 040000 d8e60f5fa4c1329f450d9c7cdf98b34e6a177f22 
> 9f576e68e5bf4ce357d7f0305aee5f410250dfe2 M      include
> :040000 040000 f2876df688ee36907af7b4123eea96592faaed3e 
> a3f6f6f94f0309106856cd99b38ec90b024eb016 M      net
> 
> 

Thanks a lot for bisecting Jutin, this is really appreciated.

crash is in xfrm_bundle_ok()

if (xdst->policy_genid != atomic_read(&xdst->pols[0]->genid))
	return 0;

xdst->pols[0] contains a NULL pointer


