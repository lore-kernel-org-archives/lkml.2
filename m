Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0DUIWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:22:51 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:58778 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab0DUIWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:22:49 -0400
Subject: Re: mprotect() failed: Cannot allocate memory
From: Yann Droneaud <yann@droneaud.fr>
To: =?UTF-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>
Cc: libc-help@sourceware.org, Mike Frysinger <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <201004210144.18954.pluto@agmk.net>
References: <201004210105.20942.pluto@agmk.net>
	 <201004201917.23286.vapier@gentoo.org>  <201004210144.18954.pluto@agmk.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 21 Apr 2010 10:22:19 +0200
Message-Id: <1271838139.28592.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3-1.1mdv2009.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 21 avril 2010 à 01:44 +0200, Paweł Sikora a écrit :
> On Wednesday 21 April 2010 01:17:22 Mike Frysinger wrote:
> > On Tuesday 20 April 2010 19:05:20 Paweł Sikora wrote:
> > > i'm trying to debug an ugly application with ElectricFence.
> > 
> > electricfence does a lot of ugly memory tricks to do its thing, including,
> > but not limited to, overriding memory related symbols.  best to seek help
> > from the electricfence authors.
> 
> so, let's avoid EF and run following test:
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/mman.h>
> 
> void* my_alloc( size_t n )
> {
>         size_t ps = getpagesize();
>         printf( "request for %Zd bytes => ", n );
>         /* alloc PAGE_SIZE + n */
>         char* p = mmap( 0, ps + n, PROT_READ | PROT_WRITE, MAP_SHARED | 
> MAP_ANONYMOUS, -1, 0 );
>         if ( p == MAP_FAILED )
>                 __builtin_abort();
>         /* block guard page */
>         int rc = mprotect( p, ps, PROT_NONE );
>         if ( rc != 0 )
>                 __builtin_abort();
>         char* q = p + ps;
>         printf( "guard page @ %p, allocated region @ %p\n", p, q );
>         return q;
> }
> 
> int main()
> {
>         #define N 100  
>         size_t NN = 4*100*100;
>         size_t kmax = 100;
>         int i;
> 
>         double **bm = (double **)my_alloc( NN * sizeof( double* ) );
>         for( i = 0; i < NN; ++i )
>         {
>                 bm[ i ] = (double*)my_alloc( kmax * sizeof( double ) );
>         }
>         // leak...
>         return 0;
> }
> 
> and the result is...
> 
> (...)
> mmap(NULL, 4896, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0) = 
> 0x7f5fd97df000
> mprotect(0x7f5fd97df000, 4096, PROT_NONE) = -1 ENOMEM (Cannot allocate memory)

Have you checked available memory on your system ? Or user limit ?

You test program is going to allocate 
 79 + 1 pages for bm
 1 + 1 for each double arrays (x 40000)

So in the end your program is allocating 80080 pages, so about
312MBytes.

It not that big for a 64bits system.

Check limits such as 
-d	the maximum size of a process's data segment
-l	the maximum size a process may lock into memory
-m	the maximum resident set size

Regards.

-- 
Yann Droneaud


