Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1AGRIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:08:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38785 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1AGRIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:08:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wuOB4ROO9LzaFn3fE8GyYiYAaIPEhbnixB3XyoPxInd08Ff5P7tWfM/SLG3jnSDo3c
         /ren4fW1+4rHtSs3gVQIEpYvrxpBfyJouuAVWmQYLNuJMf6metPczrQFweEKrfWph5WA
         u5B5PUHLhzF6Mlbdw7VXvp9i8X+8IVKCj5KTA=
Date: Fri, 7 Jan 2011 18:07:52 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V8 12/13] ptp: Added a clock driver for the IXP46x.
Message-ID: <20110107170752.GB8666@riccoc20.at.omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
 <8151196c018776704df34748f333bdb159497d0b.1293820862.git.richard.cochran@omicron.at>
 <m3ei8plpa0.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3ei8plpa0.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof,

Thanks for your review. I have some responses, below.

But before that, I have a big favor to ask you. Can you please look at
the TODO in my patch and give me a hint? I don't know how to relate
the port instance (NPE A,B,C) to the two time stamping channels.

On Thu, Jan 06, 2011 at 10:01:59PM +0100, Krzysztof Halasa wrote:
> Richard Cochran <richardcochran@gmail.com> writes:
> > +	u32 SrcUUIDHi;  /* 0x5C Sequence Identifier/Source UUID0 High */
> 
> I don't like these XxxYyyZzz either :-(

Okay, I'll change that.

> > +static void do_tx_timestamp(struct port *port, struct sk_buff *skb)
> > +{
> > +#ifdef __ARMEB__
...
> > +#endif
> > +}
> 
> And what if we're little-endian?

It is a NOOP in that case.

> Why does it depend on BE?

The time stamp code clones the skb, but the LE version frees the skb
too early. Perhaps we can move that dev_kfree_skb(skb) in the LE case
to be the last statement in eth_xmit(). What do you think?

> 
> > @@ -1171,6 +1357,11 @@ static int __devinit eth_init_one(struct platform_device *pdev)
> >  	char phy_id[MII_BUS_ID_SIZE + 3];
> >  	int err;
> >  
> > +	if (ptp_filter_init(ptp_filter, ARRAY_SIZE(ptp_filter))) {
> > +		pr_err("ixp4xx_eth: bad ptp filter\n");
> > +		return -EINVAL;
> > +	}
> > +
> >  	if (!(dev = alloc_etherdev(sizeof(struct port))))
> >  		return -ENOMEM;
> 
> Shouldn't it depend on CPU type?

It won't hurt to init the BPF unconditionally. The important bits are
checked with cpu_is_ixp46x().

> BTW which CPU is required? IXP46x (455/460/465)? Does it work on 43x?

IIRC, it does not work on 43x.

I don't know about 455 and 460, but I can find out...

> > +	if (NO_IRQ == irq)
> > +		return NO_IRQ;
> 
> Don't like these either :-(

Do you mean, you don't like the constant on the left hand side?

Is that prohibited by CodingStyle or similar?

I got into the habit of writing it that way to prevent a typo like:

	if (irq = NO_IRQ)

> Not showstoppers but...
> 
> Also I don't like the ixp_read/ixp_write() trivial macros. Why not
> simply call __raw_readl() and __raw_writel()?

Well, I have had the experience back in 2.4 days of having my drivers
ruined by the changing IO macros in the kernel. The wrappers are
supposed to help if that ever happens again. Seeing *two* leading
underscores in the macro names certainly makes me nervous.

Thanks again,

Richard
