Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab0DHPOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:14:55 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:36623 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848Ab0DHPOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:14:53 -0400
X-Spam-Processed: digidescorp.com, Thu, 08 Apr 2010 10:14:52 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1714195e0c=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] increase pipe size/buffers/atomicity :D
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: brian <knotwurk@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <x2sb985fb501004071838z51a832dftdfaece15e5a0e154@mail.gmail.com>
References: <x2sb985fb501004071838z51a832dftdfaece15e5a0e154@mail.gmail.com>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Thu, 08 Apr 2010 10:14:47 -0500
Message-Id: <1270739687.3066.16.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian -

On Wed, 2010-04-07 at 19:38 -0600, brian wrote:
> (tested and working with 2.6.32.8 kernel, on a Athlon/686)

It would be good to know what issue this addresses. Gives people a way
to weigh any side-effects/drawbacks against the benefits, and an
opportunity to suggest alternate/better approaches.

> --- include/linux/pipe_fs_i.h.orig      2010-04-06 22:56:51.000000000 -0500
> +++ include/linux/pipe_fs_i.h   2010-04-06 22:56:58.000000000 -0500
> @@ -3,7 +3,7 @@
> 
>  #define PIPEFS_MAGIC 0x50495045
> 
> -#define PIPE_BUFFERS (16)
> +#define PIPE_BUFFERS (32)

This worries me. In several places there are functions with 2 or 3
pointer arrays of dimension [PIPE_BUFFERS] on the stack. So this adds
anywhere from 128 to 384 bytes to the stack in these functions depending
on sizeof(void*) and the number of arrays.

> 
>  #define PIPE_BUF_FLAG_LRU      0x01    /* page is on the LRU */
>  #define PIPE_BUF_FLAG_ATOMIC   0x02    /* was atomically mapped */
> --- include/asm-generic/page.h.orig     2010-04-06 22:57:08.000000000 -0500
> +++ include/asm-generic/page.h  2010-04-06 22:57:23.000000000 -0500
> @@ -12,7 +12,7 @@
> 
>  /* PAGE_SHIFT determines the page size */
> 
> -#define PAGE_SHIFT     12
> +#define PAGE_SHIFT     13

This has pretty wide-ranging implications, both within and across
arches. I don't think it's something that can be changed easily. Also I
don't believe this #define used in your configuration (Athlon/686)
unless you're running without a MMU.

>  #ifdef __ASSEMBLY__
>  #define PAGE_SIZE      (1 << PAGE_SHIFT)
>  #else
> --- include/linux/limits.h.orig 2010-04-06 22:54:15.000000000 -0500
> +++ include/linux/limits.h      2010-04-06 22:56:28.000000000 -0500
> @@ -10,7 +10,7 @@
>  #define MAX_INPUT        255   /* size of the type-ahead buffer */
>  #define NAME_MAX         255   /* # chars in a file name */
>  #define PATH_MAX        4096   /* # chars in a path name including nul */
> -#define PIPE_BUF        4096   /* # bytes in atomic write to a pipe */
> +#define PIPE_BUF        8192   /* # bytes in atomic write to a pipe */

I don't see this being used within the kernel, so I assume its a
userspace representation of PAGE_SIZE (ARM seems to associate these
explicitly). I would think you'd need to rebuild your glibc or
equivalent to notice any difference from a change.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



