Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2KLPZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 10:25:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40952 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2KLPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:25:04 -0500
Date: Mon, 12 Nov 2012 15:23:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] ARM: EXYNOS: use BUG_ON where possible
Message-ID: <20121112152349.GH28327@n2100.arm.linux.org.uk>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com> <1352406191-14303-5-git-send-email-sasha.levin@oracle.com> <50A111DD.6080504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A111DD.6080504@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 04:12:29PM +0100, Maarten Lankhorst wrote:
> Op 08-11-12 21:23, Sasha Levin schreef:
> > @@ -465,10 +465,8 @@ static void __init combiner_cascade_irq(unsigned int combiner_nr, unsigned int i
> >  	else
> >  		max_nr = EXYNOS4_MAX_COMBINER_NR;
> >  
> > -	if (combiner_nr >= max_nr)
> > -		BUG();
> > -	if (irq_set_handler_data(irq, &combiner_data[combiner_nr]) != 0)
> > -		BUG();
> > +	BUG_ON(combiner_nr >= max_nr);
> > +	BUG_ON(irq_set_handler_data(irq, &combiner_data[combiner_nr]) != 0);
>
> Is it really a good idea to put functions that perform work in a BUG_ON?
> I don't know, but for some reason it just feels wrong. I'd expect code to
> compile fine if BUG_ON was a noop, so doing verification calls only, not
> actual work..

Well, it is currently defined as:

include/asm-generic/bug.h:#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
include/asm-generic/bug.h:#define BUG_ON(condition) do { if (condition) ; } while(0)

but as these can be overridden, I don't think relying on those
implementations is a good idea; to do so would be fragile.  Eg, what if
the BUG_ON() implementation becomes just:

#define BUG_ON(x)

then the function call itself vanishes.  So, only put the actual bug test
inside a BUG_ON(), not the functional part which must always be executed.
