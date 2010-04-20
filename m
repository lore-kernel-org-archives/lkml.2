Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0DTXoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:44:24 -0400
Received: from mail.agmk.net ([91.192.224.71]:48244 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829Ab0DTXoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:44:19 -0400
From: =?iso-8859-2?q?Pawe=B3_Sikora?= <pluto@agmk.net>
To: libc-help@sourceware.org
Subject: Re: mprotect() failed: Cannot allocate memory
Date: Wed, 21 Apr 2010 01:44:18 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33.2-1; KDE/4.4.2; x86_64; ; )
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
References: <201004210105.20942.pluto@agmk.net> <201004201917.23286.vapier@gentoo.org>
In-Reply-To: <201004201917.23286.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Message-Id: <201004210144.18954.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 April 2010 01:17:22 Mike Frysinger wrote:
> On Tuesday 20 April 2010 19:05:20 Pawe³ Sikora wrote:
> > i'm trying to debug an ugly application with ElectricFence.
> 
> electricfence does a lot of ugly memory tricks to do its thing, including,
> but not limited to, overriding memory related symbols.  best to seek help
> from the electricfence authors.

so, let's avoid EF and run following test:

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>

void* my_alloc( size_t n )
{
        size_t ps = getpagesize();
        printf( "request for %Zd bytes => ", n );
        /* alloc PAGE_SIZE + n */
        char* p = mmap( 0, ps + n, PROT_READ | PROT_WRITE, MAP_SHARED | 
MAP_ANONYMOUS, -1, 0 );
        if ( p == MAP_FAILED )
                __builtin_abort();
        /* block guard page */
        int rc = mprotect( p, ps, PROT_NONE );
        if ( rc != 0 )
                __builtin_abort();
        char* q = p + ps;
        printf( "guard page @ %p, allocated region @ %p\n", p, q );
        return q;
}

int main()
{
        #define N 100  
        size_t NN = 4*100*100;
        size_t kmax = 100;
        int i;

        double **bm = (double **)my_alloc( NN * sizeof( double* ) );
        for( i = 0; i < NN; ++i )
        {
                bm[ i ] = (double*)my_alloc( kmax * sizeof( double ) );
        }
        // leak...
        return 0;
}

and the result is...

(...)
mmap(NULL, 4896, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0) = 
0x7f5fd97df000
mprotect(0x7f5fd97df000, 4096, PROT_NONE) = -1 ENOMEM (Cannot allocate memory)
