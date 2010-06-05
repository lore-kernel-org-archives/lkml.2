Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab0FEUpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:45:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:38685 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab0FEUph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=c7SfpGP64McIkgzLidrzfpg28hz/887LmrTiM9yWBJS4APjA3yi49hYU8+sfo77LMI
         zL0lRrxlOqErjyAL/jiy4VKrigqqxxBIFezFfYmfmDldBxvKzdyrtLr1kwbAOUKTUBde
         5iweZSF9fvQVmSAcVET9Xpf5Sc2/L0rg7kNrw=
Date: Sat, 5 Jun 2010 23:45:27 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stuart Bennett <stuart@freedesktop.org>,
       Christoph Bumiller <e0425955@student.tuwien.ac.at>,
       Shinpei KATO <shinpei@il.is.s.u-tokyo.ac.jp>,
       nouveau@lists.freedesktop.org, x86@kernel.org
Subject: Re: [PATCH] kmmio/mmiotrace: fix double free of kmmio_fault_pages
Message-ID: <20100605234527.2e1a671d@daedalus.pq.iki.fi>
In-Reply-To: <20100605193301.GA2674@joi.lan>
References: <20100605164919.GA2816@joi.lan>
	<20100605193301.GA2674@joi.lan>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jun 2010 21:33:01 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> On Sat, Jun 05, 2010 at 06:49:42PM +0200, Marcin Slusarz wrote:
> > After every iounmap mmiotrace has to free kmmio_fault_pages,
> > but it can't do it directly, so it defers freeing by RCU.
> > 
> > It usually works, but when mmiotraced code calls ioremap-iounmap
> > multiple times without sleeping between (so RCU won't kick in
> > and start freeing) it can be given the same virtual address, so
> > at every iounmap mmiotrace will schedule the same pages for
> > release. Obviously it will explode on second free.
> > 
> > Fix it by marking kmmio_fault_pages which are scheduled for
> > release and not adding them second time.
> > 
> 
> Attached patch for mmiotrace testing module allows to reliably
> reproduce the bug. It can be folded into the main patch.
> 
> ---
> diff --git a/arch/x86/mm/testmmiotrace.c
> b/arch/x86/mm/testmmiotrace.c index 8565d94..5f0937b 100644
> --- a/arch/x86/mm/testmmiotrace.c
> +++ b/arch/x86/mm/testmmiotrace.c
> @@ -90,6 +90,19 @@ static void do_test(unsigned long size)
>  	iounmap(p);
>  }
>  
> +static void do_test2(void)
> +{
> +	void __iomem *p;
> +	int i;
> +	
> +	for (i = 0; i < 10; ++i) {
> +		p = ioremap_nocache(mmio_address, 4096);
> +		if (p)
> +			iounmap(p);
> +	}
> +	synchronize_rcu(); /* will freeing work? */
> +}
> +
>  static int __init init(void)
>  {
>  	unsigned long size = (read_far) ? (8 << 20) : (16 << 10);
> @@ -104,6 +117,7 @@ static int __init init(void)
>  		   "and writing 16 kB of rubbish in there.\n",
>  		   size >> 10, mmio_address);
>  	do_test(size);
> +	do_test2();
>  	pr_info("All done.\n");
>  	return 0;
>  }

Acked-by: Pekka Paalanen <pq@iki.fi>

-- 
Pekka Paalanen
http://www.iki.fi/pq/
