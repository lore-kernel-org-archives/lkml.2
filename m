Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0HQIrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:47:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47483 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab0HQIrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=le/Rin+8i0jBQ5iGZMxFhmUc8K8HnUxgqnAJJi5YBr6539QDFIujV04lp1BU7iBzZx
         c8ZzxA2t2lKT3tqBeTM/99zgJU1zIsiHnRQxuVAgXpwsgrkFiEHzEVp1mQG3Iece7b+l
         2kXenfFa8KUtJMQ914bS23Cv4sujHeWh51F7Y=
MIME-Version: 1.0
In-Reply-To: <1282033817.2448.18.camel@edumazet-laptop>
References: <1282029386-2952-1-git-send-email-xiaosuo@gmail.com> <1282033817.2448.18.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Tue, 17 Aug 2010 16:46:46 +0800
Message-ID: <AANLkTinuUuZSqEzfQAF422x2gYsVLzFQtXZKNLhgw+9g@mail.gmail.com>
Subject: Re: [PATCH] netfilter: save the hash of the tuple in the original
 direction for latter use
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 4:30 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Three variables ?
>
> static atomic_t rnd __read_mostly;
>
> if (unlikely(!atomic_read(&rnd))) {
>        unsigned int val;
>
>        get_random_bytes(&val, sizeof(val));
>        if (!val)
>                val = 1;
>        atomic_cmpxchg(&rnd, 0, val);
> }
>


Good idea. However, atomic_t is a volatile variable, and it prevent
ILP. I think maybe it hurts the likely case. cmpxchg() is an atomic
operations, so is the bellow code better?

 static unsigned long rnd __read_mostly;

 if (unlikely(!rnd)) {
        unsigned long val;

        get_random_bytes(&val, sizeof(val));
        if (!val)
                val = 1;
        cmpxchg(&rnd, 0, val);
 }

Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
