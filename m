Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab0EZIBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:01:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50407 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0EZIBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=n4nVKh8mjFknO+aVILcMQVK7G84YJnM5p9kkkPAj5fbFTKXcTWubwggLU7lo5QXS5i
         tyu0p0mDbSbDe7jYlzR61rWETp4eg6Z1P3zmE/IBsKnRovQCWWnxp38TSNKA+FQ3mR/m
         1R1OGwB3WjyacHaVZn99FT5yJ/cDCCnaR/1PI=
MIME-Version: 1.0
In-Reply-To: <20100526074855.GE26696@linux-sh.org>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> 
	<20100525210755.GA8920@linux-sh.org> <AANLkTinTbJ3yu9ElO32rnavnGwCrsItdDCl58KoeEW3j@mail.gmail.com> 
	<20100526074855.GE26696@linux-sh.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 26 May 2010 04:01:24 -0400
Message-ID: <AANLkTikPvwpmIOWin-WH2UGqF-otT6OL4JhVo3UKKQZY@mail.gmail.com>
Subject: Re: [PATCH] FLAT: allow arches to declare a larger alignment than the 
	slab
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jie Zhang <jie@codesourcery.com>, uclinux-dev@uclinux.org,
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

On Wed, May 26, 2010 at 03:48, Paul Mundt wrote:
> On Tue, May 25, 2010 at 07:17:16PM -0400, Mike Frysinger wrote:
>> to be sure, we dont need 0x20 alignment in general.  i just figured
>> kill two birds with one patch here.  and Blackfin is already setting
>> ARCH_KMALLOC_MINALIGN to cacheline size, but that wouldnt make any
>> difference in these issues.
>
> I have no objections to adding a new alignment value for binfmt_flat, but
> given the confusion that exists around things like ARCH_SLAB_MINALIGN and
> ARCH_KMALLOC_MINALIGN already today it should be quite obvious what
> exactly the new value is for and what case it is specifically addressing.
> My guess is that the issues you are seeing with the gcc testsuite will
> also pop up on other nommu platforms, so it may be something we want to
> just deal with generically. At least I suspect you guys are running the
> gcc testsuite a lot more frequently than the rest of us!

looking at the linker scripts elf2flt uses, i'm wondering if perhaps
we shouldnt use 0x20 for the FLAT data chunk all the time.  it uses
ALIGN(0x20) when packing in the rodata/data/etc... sections, and
obviously this would only work if the starting alignment were 0x20+ to
begin with.

elf2flt.ld.in:
...
    . = ALIGN(0x20) ;
    *(.rodata)
    *(.rodata1)
    *(.rodata.*)
    *(.gnu.linkonce.r*)
    *(.data)
    *(.data1)
    *(.data.*)
    *(.gnu.linkonce.d*)
...

that would address our gcc test issues, but not the current initial
loading crash
-mike
