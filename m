Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab0EZHX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:23:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46056 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0EZHX0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:23:26 -0400
X-Greylist: delayed 33998 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 May 2010 03:23:26 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ufq6yVTd5Tq60day8uTzJH4rI5OJniaBvXai7a7TZNfbgSy03n9gkBlAtUMY/HywpX
         w5d3xgG40honMlZ/UiA7HSQ84uvZEd3BJ8JftAGXmoWf1bXx960LmMXe10n7bE/ewBwQ
         Piievzi3AARs4qn1HsOuOc+3BKKl3tS/ER3Yw=
MIME-Version: 1.0
In-Reply-To: <AANLkTilU133SjYfKGvUiQQ8v-CiecRYmKtH2tzAxL-3u@mail.gmail.com>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> 
	<20100525210755.GA8920@linux-sh.org> <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com> 
	<4BFC8617.9010501@codesourcery.com> <AANLkTilU133SjYfKGvUiQQ8v-CiecRYmKtH2tzAxL-3u@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 26 May 2010 03:23:02 -0400
Message-ID: <AANLkTimWuqtLtnrgA8SHa-XoN8YdHJhQ6F2BngmmKSrl@mail.gmail.com>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than the 
	slab
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jie Zhang <jie@codesourcery.com>, Paul Mundt <lethal@linux-sh.org>,
       uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
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

On Wed, May 26, 2010 at 02:59, Geert Uytterhoeven wrote:
> On Wed, May 26, 2010 at 04:23, Jie Zhang wrote:
>> On 05/26/2010 07:17 AM, Mike Frysinger wrote:
>>>
>>> i do not believe that is the reason for this, but unfortunately Jie is
>>> about the only one atm who knows the inner details as for why shared
>>> FLAT libraries requires 0x20 rather than just 0x4 alignment.  i do
>>> know that there are some gcc fortran tests that fail otherwise.
>>> hopefully he can remember details ;).
>>>
>> I encountered this issue when investigating some GCC test failures when
>> using FLAT. I don't remember if they were in GCC Fortran testsuite. Some
>> variables in those test cases were required to be aligned at a large
>> boundary, for example 16-byte. I found 0x20 was a reasonably large alignment
>> to fix all such failures in GCC testsuite.
>
> I'm no FLAT expert (except for the AmigaOS HUNK loader :-), but isn't
> the core of the
> issue that alignment requirements in the object file are no longer
> fulfilled after loading,
> as a FLAT segment in memory is just allocated using kmalloc(), which may now
> return 4-byte aligned blocks?

there are two issues.  first, the ARCH_SLAB_MINALIGN define is used to
align dynamically packed data on the stack.  the alignment of kmalloc
has no bearing here because things like the env get packed in and then
the ARCH_SLAB_MINALIGN value is manually used to re-align the stack.

second, the define is further used to manually set up alignment of the
data section after it has been mmapped in anonymously and made room
for shared library data.  this too has no kmalloc bearing because mmap
sucks things in by grabbing pages manually.

> From looking at <linux/flat.h>, it looks like the FLAT binary format
> doesn't contain any
> alignment information? So if I put __attribute__((aligned(4096))) in a
> file, there's still
> no guarantee it will actually be in memory at a 4Ki-aligned address?

i believe that is correct.  FLAT behavior today provides alignment of
either sizeof(unsigned long) or ARCH_SLAB_MINALIGN.

i imagine something like this would work today because everyone
defines it to a constant:
-#ifdef ARCH_SLAB_MINALIGN
+#if defined(ARCH_SLAB_MINALIGN) && ARCH_SLAB_MINALIGN != 0
but this would break if someone tried using gcc sizeof/alignof/etc...
-mike
