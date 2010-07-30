Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab0G3KKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:10:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60748 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0G3KKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:10:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cihA+TWM8jkKUUwcc8GzXoT3KsXVuTKgf2g8RrWqw6eAnMncWdU5nDJ+GCZUu3WaM1
         D0do0Ox5btx0b8JZ2iFva5rV1KabCErhhRIUXnKkRAcZi3/k0XkqRkZ+lp+Z3AE49Q4+
         0lgDs70VqGg2vMKiqErqAhU7PD7Steev8BQ1o=
MIME-Version: 1.0
In-Reply-To: <20100730090922.GA7807@gondor.apana.org.au>
References: <1280448258-1893-1-git-send-email-xiaosuo@gmail.com> 
	<20100730090922.GA7807@gondor.apana.org.au>
From: Changli Gao <xiaosuo@gmail.com>
Date: Fri, 30 Jul 2010 18:10:19 +0800
Message-ID: <AANLkTi=YHvra6DuL7vX=DfQmR6bsw7rNMJ9mRhUzHvj2@mail.gmail.com>
Subject: Re: [PATCH] act_nat: the checksum of ICMP doesn't have pseudo header
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Jamal Hadi Salim <hadi@cyberus.ca>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 5:09 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Jul 30, 2010 at 08:04:18AM +0800, Changli Gao wrote:
>> after updating the value of the ICMP payload, inet_proto_csum_replace4() should
>> be called with zero pseudohdr.
>>
>> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>
> No, the code is correct as is.  We need to update the checksum
> even if the checksum is partial, which is what the 1 is for.
>

Is it really necessary, and I have noticed that netfilter doesn't call
inet_proto_csum_replace4 in this way.

static bool
icmp_manip_pkt(struct sk_buff *skb,
               unsigned int iphdroff,
               const struct nf_conntrack_tuple *tuple,
               enum nf_nat_manip_type maniptype)
{
        const struct iphdr *iph = (struct iphdr *)(skb->data + iphdroff);
        struct icmphdr *hdr;
        unsigned int hdroff = iphdroff + iph->ihl*4;

        if (!skb_make_writable(skb, hdroff + sizeof(*hdr)))
                return false;

        hdr = (struct icmphdr *)(skb->data + hdroff);
        inet_proto_csum_replace2(&hdr->checksum, skb,
                                 hdr->un.echo.id, tuple->src.u.icmp.id, 0);
        hdr->un.echo.id = tuple->src.u.icmp.id;
        return true;
}

Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
