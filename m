Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab0EYXRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:17:40 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:44041 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab0EYXRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rgGrWhu265lJwfVlqpKwhEnyn6upS5wbh5F1ZSP8lcyeCJ1sFMGSoh1I8oUFCYzvzC
         TjCfN7kaeh88bw2+RXm08dihS5Gi4cSpNJ1HEhuUc7MbkGRXY5hIwKTnOCKeJBCJqj4n
         7PVCoUEi1ZvlZpUwI1scFGlaAEXh6cA57ng0Y=
MIME-Version: 1.0
In-Reply-To: <20100525210755.GA8920@linux-sh.org>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> 
	<20100525210755.GA8920@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 25 May 2010 19:17:16 -0400
Message-ID: <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than the 
	slab
To: Paul Mundt <lethal@linux-sh.org>, Jie Zhang <jie@codesourcery.com>
Cc: Mike Frysinger <vapier@gentoo.org>, uclinux-dev@uclinux.org,
       David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       linux-kernel@vger.kernel.org,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 17:07, Paul Mundt wrote:
> On Tue, May 25, 2010 at 03:24:27PM -0400, Mike Frysinger wrote:
>> This stems from the alignment usage in the FLAT loader.  The behavior
>> before was that FLAT would default to ARCH_SLAB_MINALIGN only if it was
>> defined, and this was only defined by arches when they wanted a larger
>> alignment value.  Otherwise it'd default to pointer alignment.  Arguably,
>> this is kind of hokey that the FLAT is semi-abusing defines it shouldn't.
>
> This needs some explaining. What exactly do you find problematic with
> ARCH_SLAB_MINALIGN in this case? For the case that was introduced leading
> up to the wrapping of the minalign value it was absolutely the proper
> thing to use. If blackfin has special alignment requirements on top of
> that, then that's certainly fine, but it doesn't negate the validity of
> the minalign wrapping for the other platforms.

the Blackfin processor only requires alignment according to the
natural type sizes for 8, 16, and 32 bits.  so "char" needs no
alignment, "short" needs 2 byte alignment, and "int" & "void*" need 4
byte alignment.  these translate directly into a minimum aligned size
for .data sections as 4 bytes, and similarly for the stack.

FLAT is using ARCH_SLAB_MINALIGN to align the stack and align the data
section.  as such, Blackfin needs 4 byte alignment here.  the previous
FLAT behavior was "use arch slab sizes if defined, otherwise use
sizeof(void*)".  this worked fine for us size sizeof(void*) == 4.

now with ARCH_SLAB_MINALIGN being in global space, this defaults to 0
for us and the manual stack & data alignment no longer work.

i'm a schlub when it comes to these allocators, so i know as much as
the documentation states.  slab_def.h says:
 * Enforce a minimum alignment for all caches.
 * Intended for archs that get misalignment faults even for BYTES_PER_WORD
 * aligned buffers.

this comment does not seem to apply to Blackfin as BYTES_PER_WORD is 4
and we can work with anything aligned to 4 bytes.

>>  /*
>> - * User data (stack, data section and bss) needs to be aligned
>> - * for the same reasons as SLAB memory is, and to the same amount.
>> + * User data (stack, data section and bss) needs to be aligned.
>> + * If ARCH_FLAT_DATA_ALIGN is defined, use it.
>> + */
>
> If you're going to update the comment, the update should at least serve
> some purpose. This not only obscures the reason for the slab minalign
> wrapping, it also fails to suggest why anyone would deviate from that.
>
> If the intention is that ARCH_FLAT_DATA_ALIGN provides cacheline
> alignment on blackfin, then use ARCH_KMALLOC_MINALIGN like everyone else.

i do not believe that is the reason for this, but unfortunately Jie is
about the only one atm who knows the inner details as for why shared
FLAT libraries requires 0x20 rather than just 0x4 alignment.  i do
know that there are some gcc fortran tests that fail otherwise.
hopefully he can remember details ;).

to be sure, we dont need 0x20 alignment in general.  i just figured
kill two birds with one patch here.  and Blackfin is already setting
ARCH_KMALLOC_MINALIGN to cacheline size, but that wouldnt make any
difference in these issues.
-mike
