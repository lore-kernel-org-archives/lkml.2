Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab1BNPXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:23:19 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47367 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab1BNPXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:23:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=HEFuktgSaIdkJZKRGMJfCReiJOOY/a0nPeD73G+KtVC+uZZNXkhEfjyJ8VoxOvE/IG
         gD9tFiW+cGuBatVutJDC4JZ+6Z+LtZ3PceHkIUuM9A6LASfrAoE2l36mqzD3ioCHYBsM
         jPbDozKYbN+9KfqVMK4icXh///WDTVA4+F+iI=
Date: Mon, 14 Feb 2011 18:23:10 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>, Changli Gao <xiaosuo@gmail.com>,
        Jesse Gross <jesse@nicira.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] core: dev: don't call BUG() on bad input
Message-ID: <20110214152310.GA24429@albatros>
References: <1297694579-23611-1-git-send-email-segoon@openwall.com>
 <AANLkTimidxVJxw-XKTWwCZh8k_vKHDeqxAwVbY6+aJ6x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimidxVJxw-XKTWwCZh8k_vKHDeqxAwVbY6+aJ6x@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey,

On Mon, Feb 14, 2011 at 17:16 +0200, Alexey Dobriyan wrote:
> On Mon, Feb 14, 2011 at 4:42 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > alloc_netdev() may be called with too long name (more that IFNAMSIZ bytes).
> > Currently this leads to BUG().  Other insane inputs (bad txqs, rxqs) and
> > even OOM don't lead to BUG().  Made alloc_netdev() return NULL, like on
> > other errors.
> 
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -5761,7 +5761,10 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
> >        size_t alloc_size;
> >        struct net_device *p;
> >
> > -       BUG_ON(strlen(name) >= sizeof(dev->name));
> > +       if (strnlen(name, sizeof(dev->name)) >= sizeof(dev->name)) {
> > +               pr_err("alloc_netdev: Too long device name\n");
> > +               return NULL;
> > +       }
> 
> Netdevice name isn't some random junk you get from userspace, so BUG is fine.

It IS for bluetooth, see net/bluetooth/bnep/core.c: bnep_add_connection() and
net/bluetooth/bnep/sock.c: bnep_sock_ioctl(). 

And txqs, txqs?  Then why do not BUG() on bad txqs too?  Why so
insonsistent?  BUG() should be called in some critical situation, net
device creation is probably not such a thing.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
