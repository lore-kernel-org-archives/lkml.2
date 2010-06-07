Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0FGNdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 09:33:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47714 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab0FGNdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 09:33:46 -0400
Date: Mon, 7 Jun 2010 15:33:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>,
       Stuart Bennett <stuart@freedesktop.org>,
       Christoph Bumiller <e0425955@student.tuwien.ac.at>,
       Shinpei KATO <shinpei@il.is.s.u-tokyo.ac.jp>,
       nouveau@lists.freedesktop.org, x86@kernel.org
Subject: Re: [PATCH] kmmio/mmiotrace: fix double free of kmmio_fault_pages
Message-ID: <20100607133321.GA7562@elte.hu>
References: <20100605164919.GA2816@joi.lan>
 <20100605193301.GA2674@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100605193301.GA2674@joi.lan>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4301]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> On Sat, Jun 05, 2010 at 06:49:42PM +0200, Marcin Slusarz wrote:
> > After every iounmap mmiotrace has to free kmmio_fault_pages, but it
> > can't do it directly, so it defers freeing by RCU.
> > 
> > It usually works, but when mmiotraced code calls ioremap-iounmap
> > multiple times without sleeping between (so RCU won't kick in and
> > start freeing) it can be given the same virtual address, so at
> > every iounmap mmiotrace will schedule the same pages for release.
> > Obviously it will explode on second free.
> > 
> > Fix it by marking kmmio_fault_pages which are scheduled for release
> > and not adding them second time.
> > 
> 
> Attached patch for mmiotrace testing module allows to reliably reproduce
> the bug. It can be folded into the main patch.
> 
> ---
> diff --git a/arch/x86/mm/testmmiotrace.c b/arch/x86/mm/testmmiotrace.c
> index 8565d94..5f0937b 100644
> --- a/arch/x86/mm/testmmiotrace.c
> +++ b/arch/x86/mm/testmmiotrace.c
> @@ -90,6 +90,19 @@ static void do_test(unsigned long size)
>  	iounmap(p);
>  }
>  
> +static void do_test2(void)

Please add a comment about what the test function achieves.

> +{
> +	void __iomem *p;
> +	int i;
> +	
> +	for (i = 0; i < 10; ++i) {
> +		p = ioremap_nocache(mmio_address, 4096);

s/4096/PAGE_SIZE

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

Please name the new function in a bit more meaningful way (such as 
do_test_remap()).

Looks good, please send the full (folded back) patch anew, with Pekka's Ack in 
place as well.

Thanks,

	Ingo
