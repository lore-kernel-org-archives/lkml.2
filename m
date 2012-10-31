Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2JaF7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:59:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:59434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab2JaF7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:59:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,685,1344236400"; 
   d="scan'208";a="213335411"
Date: Wed, 31 Oct 2012 13:59:16 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
Message-ID: <20121031055916.GC29509@yliu-dev.sh.intel.com>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20121029135935.bb8b0b2a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029135935.bb8b0b2a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 01:59:35PM -0700, Andrew Morton wrote:
> On Fri, 26 Oct 2012 15:56:57 +0800
> Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> 
> > Say, if we want to allocate a filo with size of 6 bytes, it would be safer
> > to allocate 8 bytes instead of 4 bytes.
> >
> > ...
> >
> > --- a/kernel/kfifo.c
> > +++ b/kernel/kfifo.c
> > @@ -39,11 +39,11 @@ int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
> >  		size_t esize, gfp_t gfp_mask)
> >  {
> >  	/*
> > -	 * round down to the next power of 2, since our 'let the indices
> > +	 * round up to the next power of 2, since our 'let the indices
> >  	 * wrap' technique works only in this case.
> >  	 */
> >  	if (!is_power_of_2(size))
> > -		size = rounddown_pow_of_two(size);
> > +		size = roundup_pow_of_two(size);
> >  
> >  	fifo->in = 0;
> >  	fifo->out = 0;
> > @@ -84,7 +84,7 @@ int __kfifo_init(struct __kfifo *fifo, void *buffer,
> >  	size /= esize;
> >  
> >  	if (!is_power_of_2(size))
> > -		size = rounddown_pow_of_two(size);
> > +		size = roundup_pow_of_two(size);
> >  
> >  	fifo->in = 0;
> >  	fifo->out = 0;
> 
> hm, well, if the user asked for a 100-element fifo then it is a bit
> strange and unexpected to give them a 128-element one.

Hi Andrew,

Yes, and I guess the same to give them a 64-element one.

> 
> If there's absolutely no prospect that the kfifo code will ever support
> 100-byte fifos then I guess we should rework the API so that the caller
> has to pass in log2 of the size, not the size itself.  That way there
> will be no surprises and no mistakes.
> 
> That being said, the power-of-2 limitation isn't at all intrinsic to a
> fifo, so we shouldn't do this.  Ideally, we'd change the kfifo
> implementation so it does what the caller asked it to do!

I'm fine with removing the power-of-2 limitation. Stefani, what's your
comment on that?

	--yliu
