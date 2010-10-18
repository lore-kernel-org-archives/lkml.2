Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab0JRSek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:34:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36760 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab0JRSei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:34:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cOGEvknTUSRX+epr1d/LjpzokyYArr39IIEngZQDKA84XsYsk7PNWwSXGHZCgOr/We
         o29rI/DiBS5q0bvoXCcbFBs6l9AkYs8hGio9ME1moAkUpoXiATFmjLKb9qcn20r9YMrk
         5vSKU0G7UuIj2DjN+f+Cl35ianKyYhv4KrHdU=
MIME-Version: 1.0
In-Reply-To: <4CBC4F4E.5010305@pobox.com>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
	<17d8d27a2356640a4359f1a7dcbb3b42@localhost>
	<4CBC4F4E.5010305@pobox.com>
Date: Mon, 18 Oct 2010 11:34:37 -0700
Message-ID: <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com>
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
From: Kevin Cernekee <cernekee@gmail.com>
To: Shinya Kuribayashi <skuribay@pobox.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 6:44 AM, Shinya Kuribayashi <skuribay@pobox.com> wrote:
> I suspect that SYNC insn alone is still not enough, insn't it?  In
> such systems with that 'deep' write buffer and data incoherency is
> visibly observed, there sill may be data write transactions floating
> in the internal bus system.
>
> To make sure that all data (data inside processor's write buffer and
> data floating in the internal bus system), we need the following
> three steps:
>
> 1. Flush data cache
> 2. Uncached, dummy load operation from _DRAM_ (not somewhere else)
> 3. then SYNC instruction

Some systems do require additional steps along those lines, e.g.

# ifdef CONFIG_SGI_IP28
#  define fast_iob()				\
	__asm__ __volatile__(			\
		".set	push\n\t"		\
		".set	noreorder\n\t"		\
		"lw	$0,%0\n\t"		\
		"sync\n\t"			\
		"lw	$0,%0\n\t"		\
		".set	pop"			\
		: /* no output */		\
		: "m" (*(int *)CKSEG1ADDR(0x1fa00004)) \
		: "memory")

Maybe it would be better to use iob() instead of __sync() directly, so
that it is easy to add extra steps for the CPUs that need them.  DEC
and Loongson have custom __wbflush() implementations, and something
similar could be added for your processor to implement the uncached
dummy load.

What do you think?
