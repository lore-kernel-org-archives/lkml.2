Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab2CaE6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 00:58:51 -0400
Received: from relais.videotron.ca ([24.201.245.36]:45180 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2CaE6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 00:58:49 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Sat, 31 Mar 2012 00:58:47 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: error: 'SEGMENT_SIZE' undeclared with arm-eabi-gcc toolchain
In-reply-to: <4F7638C3.4060301@samsung.com>
Message-id: <alpine.LFD.2.02.1203310017440.24151@xanadu.home>
References: <4F7638C3.4060301@samsung.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, Kukjin Kim wrote:

> Hi all,
> 
> Occurs following error with arm-eabi-gcc toolchain (gcc version 4.4.3 -
> GCC). But there is no error with arm-none-linux-gnueabi-gcc toolchain
> (gcc version 4.4.1 - Sourcery G++ Lite 2009q3)...
> 
> fs/binfmt_aout.c: In function 'load_aout_binary':
> fs/binfmt_aout.c:255: error: 'SEGMENT_SIZE' undeclared (first use in
> this function)
> fs/binfmt_aout.c:255: error: (Each undeclared identifier is reported
> only once
> fs/binfmt_aout.c:255: error: for each function it appears in.)
> make[2]: *** [fs/binfmt_aout.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [fs] Error 2
> 
> Any idea?

Yes.  This comes from the N_DATADDR() macro, defined in 
include/linux/a.out.h as follows:

|#define N_DATADDR(x) \
|    (N_MAGIC(x)==OMAGIC? (_N_TXTENDADDR(x)) \
|     : (_N_SEGMENT_ROUND (_N_TXTENDADDR(x))))

Then, looking at _N_SEGMENT_ROUND() in the same file:

|#define _N_SEGMENT_ROUND(x) ALIGN(x, SEGMENT_SIZE)

Here it is.  Now, why isn't SEGMENT_SIZE defined?  Well that's where 
things get way more hairy than they are already (caution, barf bag 
recommended):

|/* Address of data segment in memory after it is loaded.
|   Note that it is up to you to define SEGMENT_SIZE
|   on machines not listed here.  */
|#if defined(vax) || defined(hp300) || defined(pyr)
|#define SEGMENT_SIZE page_size
|#endif
|#ifdef	sony
|#define	SEGMENT_SIZE	0x2000
|#endif	/* Sony.  */
|#ifdef is68k
|#define SEGMENT_SIZE 0x20000
|#endif
|#if defined(m68k) && defined(PORTAR)
|#define PAGE_SIZE 0x400
|#define SEGMENT_SIZE PAGE_SIZE
|#endif
|
|#ifdef linux
|#ifdef __KERNEL__
|#include <asm/page.h>
|#else
|#include <unistd.h>
|#endif
|#if defined(__i386__) || defined(__mc68000__)
|#define SEGMENT_SIZE	1024
|#else
|#ifndef SEGMENT_SIZE
|#ifdef __KERNEL__
|#define SEGMENT_SIZE	PAGE_SIZE
|#else
|#define SEGMENT_SIZE   getpagesize()
|#endif
|#endif
|#endif
|#endif

So the clue you're looking for is probably on the 18th line above.

BTW, no one is using a.out on ARM anymore.  You should really consider 
removing CONFIG_BINFMT_AOUT from your config.


Nicolas
