Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab0HQJCC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:02:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59841 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab0HQJCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fBdnpypvDHUPZclPlbcC3ZHbzFqABnqaQvuAWDY3L+R1NGxs/fLyePciSz93G1T1ed
         +l/9gfWeoGwcaL3vOunoueCew7t8wGIYCzH/4sJamZRIQmvd6FeHbZhsYw1RVHxYIuQS
         Ls4bMKU5H/0tfGW6CjL0DYaJU1diLceZX37NI=
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com>
	 <1282033817.2448.18.camel@edumazet-laptop>
	 <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 11:01:55 +0200
Message-ID: <1282035715.2448.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 août 2010 à 16:46 +0800, Changli Gao a écrit :
> On Tue, Aug 17, 2010 at 4:30 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > Three variables ?
> >
> > static atomic_t rnd __read_mostly;
> >
> > if (unlikely(!atomic_read(&rnd))) {
> >        unsigned int val;
> >
> >        get_random_bytes(&val, sizeof(val));
> >        if (!val)
> >                val = 1;
> >        atomic_cmpxchg(&rnd, 0, val);
> > }
> >
> 
> 
> Good idea. However, atomic_t is a volatile variable, and it prevent
> ILP. I think maybe it hurts the likely case. cmpxchg() is an atomic
> operations, so is the bellow code better?
> 

I am not sure what you mean by ILP.

On x86, reading twice same memory location is faster than
reading it and store in temp variable (on stack)
reading from stack

>  static unsigned long rnd __read_mostly;
> 
>  if (unlikely(!rnd)) {
>         unsigned long val;
> 
>         get_random_bytes(&val, sizeof(val));
>         if (!val)
>                 val = 1;
>         cmpxchg(&rnd, 0, val);
>  }
> 
> Thanks.
> 

I am not sure we must use a long (we really need 4 bytes only), and last
time I tried to use cmpxchg(), I was being told it was not available on
all arches.

But seeing it used in kernel/pid.c, maybe its not true anymore (that is,
__HAVE_ARCH_CMPXCHG is always defined to 1)

Since its a recent change (in kernel/pid.c), I would wait a bit and see
if an arch maintainer complains ;)


