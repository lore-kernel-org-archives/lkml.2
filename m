Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761655Ab0HFRyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:54:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55183 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0HFRyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EjKpfEEqAZwle/ZM9BcfOGW4XmXq+iE3z1uNdBdQZoNUjhEEu5jLWzc40aY3mt7cD+
         BvHFRIHjMerH+8oHjJLpDAWhd6eATVejBIAY29VgDaXlTnZ7wJ52u3TLBRqeZjbAgegk
         TX/hifcKJnSqpE2oDhLwhXMxPEgLIgqGkLFhM=
MIME-Version: 1.0
In-Reply-To: <AANLkTinAuZ5GAauKHfUVV_K_9gQOpFY35m7SLsH6rvD1@mail.gmail.com>
References: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTi=jStVGbJC7jUyhOG3og14F58rw+LEN2UqnP-X0@mail.gmail.com>
	<AANLkTi=bkp+JJYQ7dF36Up3gcjJR8LypgfKBWZHLfPH-@mail.gmail.com>
	<AANLkTimPAeupEKwksBKOyWX8K+wHgmgc5vEJ8cXBsQtD@mail.gmail.com>
	<AANLkTi=yJjHDh08muCg7Z97xRGDcTQrv=VimHSNCqn2U@mail.gmail.com>
	<20100805071235.GA436@morgana.i.gnudd.com>
	<AANLkTinAuZ5GAauKHfUVV_K_9gQOpFY35m7SLsH6rvD1@mail.gmail.com>
Date: Fri, 6 Aug 2010 10:54:50 -0700
X-Google-Sender-Auth: EYM9AqplYDYqwQPcN9I1CwOK37Y
Message-ID: <AANLkTi=OLP+NwGP7v0O0=ZqBNp_Ag9mm+LEUnCw5OX7L@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Alessandro Rubini <rubini@unipv.it>, peter.pearse@arm.com,
        viresh.kumar@st.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, yuanyabin1978@sina.com,
        ben-linux@fluff.org, kgene.kim@samsung.com, rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 12:30 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/8/5 Alessandro Rubini <rubini@unipv.it>:
>
>>> Peter, Alessandro and Viresh especially: you will hopefully use this
>>> driver for ARM refboards, Nomadik and SPEAr, can you provide
>>> an Acked-by:?
>>
>> I'm sorry I can't test it these times, I must delay stuff to
>> the last week of August.
>
> That's be a Tested-by: tag, Acked-by: was more about whether you
> think it looks sane I believe, see Documentation/SubmittingPatches.

We have the Acked-by from Viresh, Alessandro looks like he is
interested in trying it out, the driver is self contained, marked
experimental, and you have a track-record of fixing things up, so I'll
include it with the idea it will be easier to fixup in-tree.  One
thing that should be on the todo list is to review the usage of memory
barriers.  I don't think they are serving the purpose that you think
they are.  For example in  pl08x_irq() there is:

+       /*
+        * Clear only the terminal interrupts on channels we processed
+        */
+       writel(mask, pl08x->base + PL080_TC_CLEAR);
+       mb();
+
+       return mask ? IRQ_HANDLED : IRQ_NONE;

Which seems to imply you want to ensure the interrupt bits are cleared
before the handler returns.  But the only way you can guarantee that
the write has actually taken effect is to read back the register.
Does the amba bus interface make this guarantee with a barrier?  If so
then we need a comment about why we need a full barrier versus just a
wmb()?

+static void pl08x_pause_phy_chan(struct pl08x_phy_chan *ch)
+{
+       u32 val;
+
+       /* Set the HALT bit and wait for the FIFO to drain */
+       val = readl(ch->base + PL080_CH_CONFIG);
+       val |= PL080_CONFIG_HALT;
+       writel(val, ch->base + PL080_CH_CONFIG);
+
+       /* Wait for channel inactive */
+       while (pl08x_phy_channel_busy(ch))
+               ;
+       mb();
+}

Doesn't the while loop guarantee that the write has taken effect?

+static void pl08x_ensure_on(struct pl08x_driver_data *pl08x)
+{
+       u32 val;
+
+       val = readl(pl08x->base + PL080_CONFIG);
+       val &= ~(PL080_CONFIG_M2_BE | PL080_CONFIG_M1_BE | PL080_CONFIG_ENABLE);
+       /* We implictly clear bit 1 and that means little-endian mode */
+       val |= PL080_CONFIG_ENABLE;
+       mb();
+       writel(val, pl08x->base + PL080_CONFIG);
+       mb();
+}

This almost looks like you are using mb() as a compiler barrier, but
that is taken care of by readl / writel.  Speaking of which is amba
always little-endian, should we instead be using __raw_{read|write}l
in this driver?

--
Dan
