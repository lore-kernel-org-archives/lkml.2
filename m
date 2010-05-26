Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab0EZHtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:49:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53983 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376Ab0EZHtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:49:08 -0400
Date: Wed, 26 May 2010 16:48:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Jie Zhang <jie@codesourcery.com>, Mike Frysinger <vapier@gentoo.org>,
       uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than the slab
Message-ID: <20100526074855.GE26696@linux-sh.org>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> <20100525210755.GA8920@linux-sh.org> <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 07:17:16PM -0400, Mike Frysinger wrote:
> FLAT is using ARCH_SLAB_MINALIGN to align the stack and align the data
> section.  as such, Blackfin needs 4 byte alignment here.  the previous
> FLAT behavior was "use arch slab sizes if defined, otherwise use
> sizeof(void*)".  this worked fine for us size sizeof(void*) == 4.
> 
> now with ARCH_SLAB_MINALIGN being in global space, this defaults to 0
> for us and the manual stack & data alignment no longer work.
> 
> i'm a schlub when it comes to these allocators, so i know as much as
> the documentation states.  slab_def.h says:
>  * Enforce a minimum alignment for all caches.
>  * Intended for archs that get misalignment faults even for BYTES_PER_WORD
>  * aligned buffers.
> 
> this comment does not seem to apply to Blackfin as BYTES_PER_WORD is 4
> and we can work with anything aligned to 4 bytes.
> 
The comment here is a bit misleading, it's true that SLAB will happily
align to BYTES_PER_WORD as a default if nothing else is specified, but
it's also true that a growing number of structures contain 64-bit values
that need to be accessed on 64-bit boundaries on 32-bit platforms. If
this doesn't apply to blackfin then simply sticking with the default is
fine. SLAB/SLOB will align to 4 bytes while SLUB will presently align to
8.

> to be sure, we dont need 0x20 alignment in general.  i just figured
> kill two birds with one patch here.  and Blackfin is already setting
> ARCH_KMALLOC_MINALIGN to cacheline size, but that wouldnt make any
> difference in these issues.

I have no objections to adding a new alignment value for binfmt_flat, but
given the confusion that exists around things like ARCH_SLAB_MINALIGN and
ARCH_KMALLOC_MINALIGN already today it should be quite obvious what
exactly the new value is for and what case it is specifically addressing.
My guess is that the issues you are seeing with the gcc testsuite will
also pop up on other nommu platforms, so it may be something we want to
just deal with generically. At least I suspect you guys are running the
gcc testsuite a lot more frequently than the rest of us!
