Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0JGUE0 convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Thu, 7 Oct 2010 16:04:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64402 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0JGUEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=P4uQ8FHy0C0saEdCPW5JytM9BpJ7nIJDegn74PBPSUhFE57KTansckkha8hrgfvCAj
         u0jQQbieyvv79lvci9mFhO6NnTdD/c6lrKo2QreZrRsu8LMBrxxBVIYbq3NIh2hZaXzE
         WwUMUwejzAllwUJciDyEpefSAo2oJGnGZKpLI=
Subject: Re: [PATCH] percpu_counter: change inaccurate comment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1010071440220.28032@router.home>
References: <1286469421.2912.240.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1010071440220.28032@router.home>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 07 Oct 2010 22:04:20 +0200
Message-ID: <1286481860.3745.30.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from QUOTED-PRINTABLE to 8bit by mail.home.local id o97K5h7O031981

Le jeudi 07 octobre 2010 à 14:42 -0500, Christoph Lameter a écrit :
> On Thu, 7 Oct 2010, Eric Dumazet wrote:
> 
> > percpu_counter used to be huge objects, they are not anymore,
> > thanks to fine alloc_percpu() granularity.
> >
> > We now consume 4 bytes per possible cpu.
> 
> Ahh I did not notice that they switched.... Then we may also want the
> following patch to improve performance. It would even be better if we
> could do a this_cpu_add(fbc->counters, amount) there but the 64 bit size
> fo count looks suspiciously like you are expecting overflows beyond ints
> max size.
> 

Yes, this 64bit interface is very strange.

> 
> Subject: percpu_counter: Use this_cpu_ptr instead of per_cpu_ptr
> 
> this_cpu_ptr avoids an array lookup and can use the percpu
> offset of the local cpu directly.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  lib/percpu_counter.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/lib/percpu_counter.c
> ===================================================================
> --- linux-2.6.orig/lib/percpu_counter.c	2010-10-07 14:36:39.000000000 -0500
> +++ linux-2.6/lib/percpu_counter.c	2010-10-07 14:38:43.000000000 -0500
> @@ -30,9 +30,9 @@ void __percpu_counter_add(struct percpu_
>  {
>  	s64 count;
>  	s32 *pcount;
> -	int cpu = get_cpu();
> 
> -	pcount = per_cpu_ptr(fbc->counters, cpu);
> +	preempt_disable();
> +	pcount = this_cpu_ptr(fbc->counters);
>  	count = *pcount + amount;
>  	if (count >= batch || count <= -batch) {
>  		spin_lock(&fbc->lock);
> @@ -42,7 +42,7 @@ void __percpu_counter_add(struct percpu_
>  	} else {
>  		*pcount = count;
>  	}
> -	put_cpu();
> +	preempt_enable();
>  }
>  EXPORT_SYMBOL(__percpu_counter_add);
> 

If enclosed by preempt_disable()/preempt_enable(), maybe we could use
__this_cpu_ptr() ?



