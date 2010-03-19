Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0CSVhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:37:32 -0400
Received: from smtp.citrix.com ([66.165.176.89]:42982 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab0CSVhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:37:31 -0400
X-IronPort-AV: E=Sophos;i="4.51,276,1267419600"; 
   d="scan'208";a="7630941"
Subject: Re: [LKML] Re: Infinite loop on boot in free_early_partial due to
 start==end on tip/master
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4BA3E9CD.70203@kernel.org>
References: <1267801390.11737.38014.camel@zakaz.uk.xensource.com>
	 <20100319182807.GA14985@phenom.dumpdata.com> <4BA3CAB8.7000702@kernel.org>
	 <1269027289.23584.0.camel@localhost.localdomain>
	 <20100319200409.GE31908@phenom.dumpdata.com>  <4BA3E9CD.70203@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Fri, 19 Mar 2010 21:37:26 +0000
Message-ID: <1269034646.28761.29.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-19 at 21:17 +0000, Yinghai Lu wrote: 
> > index ef6370b..89a3205 100644
> > --- a/arch/x86/kernel/setup_percpu.c
> > +++ b/arch/x86/kernel/setup_percpu.c
> > @@ -140,7 +140,8 @@  static void __init pcpu_fc_free(void *ptr, size_t
> > size)
> >  #ifdef CONFIG_NO_BOOTMEM
> >  	u64 start = __pa(ptr);
> >  	u64 end = start + size;
> > -	free_early_partial(start, end);
> > +	if (start < end)
> > +		free_early_partial(start, end);
> 
> it seems we could remove this line

> Tejun, how this could happen? free zero range ?

I was seeing start==end although I never fully understood why. It
happened somewhere within pcpu_embed_first_chunk and/or
pcpu_build_alloc_info. My original posting (in
https://patchwork.kernel.org/patch/83756/) has some speculation.

Ian.

> 
> YH
> 
> >  #else
> >  	free_bootmem(__pa(ptr), size);
> >  #endif
> > diff --git a/kernel/early_res.c b/kernel/early_res.c
> > index 3cb2c66..f3a861b 100644
> > --- a/kernel/early_res.c
> > +++ b/kernel/early_res.c
> > @@ -333,6 +333,11 @@  void __init free_early_partial(u64 start, u64 end)
> >  	struct early_res *r;
> >  	int i;
> >  
> > +	if (WARN_ONCE(start >= end,
> > +		      "free_early_partial got wrong start/end
> > %#llx/%#llx\n",
> > +		      start, end))
> > +		return;
> > +
> >  try_next:
> >  	i = find_overlapped_early(start, end);
> >  	if (i >= max_early_res)
> > 


