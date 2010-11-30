Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab0K3T35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:29:57 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60285 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0K3T34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:29:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZnP/rnY9I7MyrO26Zuqq/mSI4lBDAnAYfELqxH/ul85U2AmlkuA0o87JdvgTp1FK9/
         JwCUAQM+Uf8OPNC/OvhghtDXAPfG/jSkfyWeUzZJkRjFPHx1X23kUss/xkxjFmiC6wAC
         gbiScCBAJt6XTmbEsK8OIF2S1IGaTjFoh0yAc=
Subject: Re: [thisops uV3 07/18] highmem: Use this_cpu_xx_return()
 operations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1011301325180.3134@router.home>
References: <20101130190707.457099608@linux.com>
	 <20101130190845.216537525@linux.com>
	 <1291144408.2904.232.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1011301325180.3134@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 20:29:51 +0100
Message-ID: <1291145391.2904.247.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 novembre 2010 à 13:26 -0600, Christoph Lameter a écrit :
> On Tue, 30 Nov 2010, Eric Dumazet wrote:
> 
> > >  {
> > > -	int idx = --__get_cpu_var(__kmap_atomic_idx);
> > > +	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
> >
> > __this_cpu_dec_return() is only needed if CONFIG_DEBUG_HIGHMEM
> >
> > >  #ifdef CONFIG_DEBUG_HIGHMEM
> > >  	BUG_ON(idx < 0);
> > >  #endif
> > >
> >
> > You could change kmap_atomic_idx_pop() to return void, and use
> > __this_cpu_dec(__kmap_atomic_idx)
> 
> The following would do?
> 
> 
> Subject: highmem: Use this_cpu_dec instead of __this_cpu_dec_return if !DEBUG_HIGHMEM
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  include/linux/highmem.h |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/include/linux/highmem.h
> ===================================================================
> --- linux-2.6.orig/include/linux/highmem.h	2010-11-30 13:23:44.000000000 -0600
> +++ linux-2.6/include/linux/highmem.h	2010-11-30 13:24:54.000000000 -0600
> @@ -95,14 +95,19 @@ static inline int kmap_atomic_idx(void)
>  	return __this_cpu_read(__kmap_atomic_idx) - 1;
>  }
> 
> +#ifdef CONFIG_DEBUG_HIGHMEM
>  static inline int kmap_atomic_idx_pop(void)
>  {
>  	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
> -#ifdef CONFIG_DEBUG_HIGHMEM
>  	BUG_ON(idx < 0);
> -#endif
>  	return idx;
>  }
> +#else
> +static inline void kmap_atomic_idx_pop(void)
> +{
> +	__this_cpu_dec(__kmap_atomic_idx);
> +}
> +#endif
> 
>  #endif
> 


well maybe a single prototype ;)

static inline void kmap_atomic_idx_pop(void)
{
#ifdef CONFIG_DEBUG_HIGHMEM
	int idx = __this_cpu_dec_return(__kmap_atomic_idx);
	BUG_ON(idx < 0);
#else
      __this_cpu_dec(__kmap_atomic_idx);
#endif
}


