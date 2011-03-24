Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab1CXIiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:38:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42427 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933723Ab1CXIiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bXWH76u70UqLPLJaND5oN3+cE8w99gFZMzDAvcsT7CGzDx79yFDXvDBcky/imzrCVz
         3SoCJEnk1qVKnkpNoGuMNCXzwDb2NYSZ0fnK3LXO8g4pJtFZ+g6rG5SkMd+uAQeBOSBq
         oKwC478IgbRMCQeQefuxrku4LCvxQW5M8aLmk=
Subject: Re: Hit BUG_ON in dma-mapping.c:425 (RFC)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        Hong XU <hong.xu@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-mtd <linux-mtd@lists.infradead.org>
In-Reply-To: <20110324082521.GB9844@n2100.arm.linux.org.uk>
References: <4D24A108.2080609@atmel.com> <4D8AFE45.8050609@atmel.com>
	 <20110324082521.GB9844@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 10:36:18 +0200
Message-ID: <1300955778.2735.68.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 08:25 +0000, Russell King - ARM Linux wrote:
> On Thu, Mar 24, 2011 at 04:18:13PM +0800, Nicolas Ferre wrote:
> > diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
> > --- a/drivers/spi/atmel_spi.c
> > +++ b/drivers/spi/atmel_spi.c
> > @@ -647,6 +647,22 @@ static void atmel_spi_next_message(struct spi_master *master)
> >  	atmel_spi_next_xfer(master, msg);
> >  }
> >  
> > +static void *adjust_buffer_location(struct device *dev, void *buf)
> > +{
> > +	if (likely(buf < high_memory)) {
> > +		return buf;
> > +	} else {
> > +		struct page *pg;
> > +
> > +		pg = vmalloc_to_page(buf);
> > +		if (pg == 0) {
> > +			dev_err(dev, "failed to vmalloc_to_page\n");
> > +			return NULL;
> > +		}
> > +		return page_address(pg) + ((size_t)buf & ~PAGE_MASK);
> > +	}
> > +}
> > +
> 
> This really doesn't fix the problem.  If the page is read or written via
> the vmalloc mapping, you'll have stale data.
> 
> DMA to vmalloc areas is dodgy at best.

This topics pops up often. So what is the right fix? And sorry for my
ignorance.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

