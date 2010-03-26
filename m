Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab0CZAzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 20:55:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34281 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0CZAzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 20:55:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sEn1AJ7utmGDi3Ntfm1ZUx+u3hWkQymt/JV4YD5aYnd4Pah1YUUmquXqWEOjNVSBvz
         lLEtNXg+y6BZ75nudJY+2xggYQtDzpzC/PjECuNmNTEYSiX8FZTwUJayjmyHlKP9hTDg
         8KWscZauUxCWRNwJ5Uz5tWWmiRyaFq/tP+KMg=
MIME-Version: 1.0
In-Reply-To: <1269542661.9188.38.camel@debian>
References: <1269542661.9188.38.camel@debian>
Date: Thu, 25 Mar 2010 17:55:11 -0700
X-Google-Sender-Auth: e00d3f124922661d
Message-ID: <e9c3a7c21003251755r251af427pf4f5ead9aca8a482@mail.gmail.com>
Subject: Re: [PATCH 1/2] dma: Add timb-dma
From: Dan Williams <dan.j.williams@intel.com>
To: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 11:44 AM, Richard Röjfors
<richard.rojfors@pelagicore.com> wrote:
> Adds the support for the DMA engine withing the timberdale FPGA.
>
> The DMA channels are strict device to host, or host to device
> and can not be used for generic memcpy.
>
> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
[..]
> +struct timb_dma_chan {
> +       struct dma_chan         chan;
> +       void __iomem            *membase;
> +       spinlock_t              lock; /* Used for mutual exclusion */

Please add some value to this comment.  I can assume it protects all
list manipulations, anything non-obvious worth noting?

[..]
> +
> +static int td_fill_desc(struct timb_dma_chan *td_chan, u8 *dma_desc,
> +       struct scatterlist *sg, bool last)
> +{
> +       if (sg_dma_len(sg) > USHORT_MAX) {
> +               dev_err(chan2dev(&td_chan->chan), "Too big sg element\n");
> +               return -EINVAL;
> +       }
> +
> +       /* length must be word aligned */
> +       if (sg_dma_len(sg) % sizeof(u32)) {
> +               dev_err(chan2dev(&td_chan->chan), "Incorrect length: %d\n",
> +                       sg_dma_len(sg));
> +               return -EINVAL;
> +       }
> +
> +       dev_dbg(chan2dev(&td_chan->chan), "desc: %p, addr: %p\n",
> +               dma_desc, (void *)(int)sg_dma_address(sg));

That (int) cast is not needed, causes a compiler warning, and can be dropped.

Nice simple driver.  You can just send a follow up patch to fix up
those minor issues.  I've pushed it out to my 'next' branch [1].

--
Dan

git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next
