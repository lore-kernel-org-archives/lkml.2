Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0LJK1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:27:51 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:48122 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0LJK1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:27:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HQ7BNNqU8XYWRpiadJ/WboHjZ+Om/cF7cZoTe/Ab/dR1WEDSE7i9QGjAH3ovuM1qES
         InQDq+gsaupH6fix4GRBbcOJSmL4eK3PMKMjt+JwSm10FiEGmCerBUpAVxiYJzWWUUXq
         4/9CZQA/9BeIC9SkrXMzuxsYlVY18CNj6LwlU=
Subject: Re: [RFC PATCH V2 5/5] Add TX zero copy in macvtap
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>, mst@redhat.com,
        xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1291976026.2167.49.camel@localhost.localdomain>
References: <1291976026.2167.49.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 11:27:44 +0100
Message-ID: <1291976864.3580.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 10 décembre 2010 à 02:13 -0800, Shirley Ma a écrit :

> +		while (len) {
> +			f = &skb_shinfo(skb)->frags[i];
> +			f->page = page[i];
> +			f->page_offset = base & ~PAGE_MASK;
> +			f->size = min_t(int, len, PAGE_SIZE - f->page_offset);
> +			skb->data_len += f->size;
> +			skb->len += f->size;
> +			skb->truesize += f->size;
> +			skb_shinfo(skb)->nr_frags++;
> +			/* increase sk_wmem_alloc */
> +			atomic_add(f->size, &skb->sk->sk_wmem_alloc);
> +			base += f->size;
> +			len -= f->size;
> +			i++;
> +		}

You could make one atomic_add() outside of the loop, and factorize many
things...

atomic_add(len, &skb->sk->sk_wmem_alloc);
skb->data_len += len;
skb->len += len;
skb->truesize += len;
while (len) {
	...
}


