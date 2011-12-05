Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab1LEMU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:20:58 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62965 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1LEMU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:20:57 -0500
MIME-Version: 1.0
In-Reply-To: <20110909153553.GA12448@gere.osrc.amd.com>
References: <20110812195220.GA29051@elte.hu>
	<20110814095910.GA18809@liondog.tnic>
	<6296.1313462075@turing-police.cc.vt.edu>
	<20110816121604.GA29251@aftab>
	<4E5FA18A.7010205@gmail.com>
	<CA+55aFz1RRY6KcqVVZ9tBH7PDXfBwkZ1AhJcSHPABLXMkNJCOA@mail.gmail.com>
	<20110908083551.GA5646@liondog.tnic>
	<4E689FC5.8010005@gmail.com>
	<20110909081407.GA29251@liondog.tnic>
	<CA+55aFy5QOwQXqHkOkoMU_Lg6DrhrwVpMx4R0kFTnKqmACGy6w@mail.gmail.com>
	<20110909153553.GA12448@gere.osrc.amd.com>
Date: Mon, 5 Dec 2011 17:50:49 +0530
Message-ID: <CAHSGOutdR8dvf+i0NfKCycpui6G3Du6qn0DXftHdtiHfmYCCRw@mail.gmail.com>
Subject: Re: x86 memcpy performance
From: melwyn lobo <linux.melwyn@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Borislav Petkov <bp@amd64.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver has a loop of memcpy the source and destination addresses
based on a runtime computed value and confuses the compiler on the
alignement.
So instead of generating neat 32 bit memcpy, gcc generates "rep movsb"
Example code snippet:
src = (char *)kmap(bo->pages[idx]);
src += offset;
memcpy(des, src, len);
Be replacing ssse3 only for memcpy of length larger than 1K bytes (for
my driver typical length are 2k metadata from SRAM to DDR) I think
overheads of FPU save and restore can be forgiven.
Will SSSE3 work for unlaigned pointers as well ? If it doesn't I am
lucky for past 6 months :)


On Fri, Sep 9, 2011 at 9:05 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Sep 09, 2011 at 07:39:18AM -0700, Linus Torvalds wrote:
>> Kernel memcpy's are basically almost always smaller than a page size,
>> because that tends to be the fundamental allocation size.
>
> Yeah, this is what my trace of a kernel build showed too:
>
> Bytes   Count
> =====   =====
>
> ...
>
> 224     3
> 225     3
> 227     3
> 244     1
> 254     5
> 255     13
> 256     21708
> 512     21746
> 848     12907
> 1920    36536
> 2048    21708
>
> OTOH, I keep thinking that copy_*_user might be doing bigger sizes, for
> example when shuffling network buffers to/from userspace. Converting
> those to SSE memcpy might not be as easy as memcpy itself, though.
>
>> Yes, there are exceptions that copy into big vmalloc'ed buffers, but
>> they don't tend to matter. Things like module loading etc.
>
> Too small a number of repetitions to matter, yes.
>
> --
> Regards/Gruss,
> Boris.
>
