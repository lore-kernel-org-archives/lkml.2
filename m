Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0HTPWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:22:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49932 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab0HTPWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:22:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QNTE4AhV8I7Lce7JNyfkv74DEbyvWBaj2kA94f9wNKxTJEGWOYDwUju9bxrSwIym5I
         un9v0yRcYcgMl3eGZqVXIjBz3kqG39p+/wWoLwV61Kcq74em5Ywfpw1fTGXvoDg3bxAc
         oA4HD2TqJcRWrmLmmAYO9JAuIh7YNfEsIWj/M=
MIME-Version: 1.0
In-Reply-To: <1282317016.2484.173.camel@edumazet-laptop>
References: <1282316003-2966-1-git-send-email-xiaosuo@gmail.com> <1282317016.2484.173.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 20 Aug 2010 23:22:23 +0800
Message-ID: <AANLkTimj=6HBdZK0WiPBxhm9YPG_8zRXEZyP--E7Shj8@mail.gmail.com>
Subject: Re: [PATCH v3] netfilter: save the hash of the tuple in the original
 direction for latter use
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        akpm@linux-foundation.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 11:10 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 20 août 2010 à 22:53 +0800, Changli Gao a écrit :
>> Since we don't change the tuple in the original direction, we can save it
>> in ct->tuplehash[IP_CT_DIR_REPLY].hnode.pprev for __nf_conntrack_confirm()
>> use.
>>
>> __hash_conntrack() is split into two steps: ____hash_conntrack() is used
>> to get the raw hash, and __hash_bucket() is used to get the bucket id.
>>
>> In SYN-flood case, early_drop() doesn't need to recompute the hash again.
>>
>> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>> ---
>
> Hmm... so to accept a few more SYN packets per second in SYNFLOOD
> attack, we slow a bit normal operations ?

SYN-flood case is just a side effect. What I want to do is eliminating
the second call to hash_conntrack() of the original tuple in
__nf_conntrack_confirm().

> (adding one test on each
> packet going through conntrack)

Do you mean the rnd test?

>
> If yes (I dont think we should, hackers are stronger than you anyway,
> just face it)
>
> v4:
>        __read_mostly on nf_conntrack_rnd
>
>
> What would happen if we let the initialization of nf_conntrack_rnd
> only in the insertion case (like currently done) ?
> Only the first packet received on the machine/conntrack might be hashed
> on a wrong slot. Is it a big deal ? If yes, maybe find a way to
> recompute the hash in this case, instead of reusing 'wrong' one ?
>

I should keep the old way, but fix a race.

        if (unlikely(!nf_conntrack_hash_rnd_initted)) {
                get_random_bytes(&nf_conntrack_hash_rnd,
                                sizeof(nf_conntrack_hash_rnd));
                nf_conntrack_hash_rnd_initted = 1;
        }

nf_conntrack_alloc() isn't called with in the nf_conntrack_lock. So
the above code maybe executed more than once on different CPUs. It is
easy to fix with the cmpxchg() trick.

Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
