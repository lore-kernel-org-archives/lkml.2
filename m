Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1EYQPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:15:55 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:52670 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab1EYQPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:15:53 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
In-Reply-To: <4DDD24E2.4010602@zytor.com>
References: <1306269105.21443.20.camel@dan> <20110524211644.GJ27634@elte.hu>
	 <4DDC39F1.2060903@zytor.com> <1306332225.2211.9.camel@dan>
	 <4DDD24E2.4010602@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 12:15:41 -0400
Message-ID: <1306340141.2211.32.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 08:48 -0700, H. Peter Anvin wrote:
> On 05/25/2011 07:03 AM, Dan Rosenberg wrote:
> > 
> > My current idea is to use int 0x15, eax = 0xe801 (which seems to be
> > nearly universally supported) and use bx/dx to determine the amount of
> > contiguous, usable memory above 16 MB, which seems to be exactly what we
> > want to know.  If the BIOS does not support this function I'll be sure
> > to catch that and skip the randomization.  Likewise, if the amount of
> > returned memory seems insufficient or otherwise confusing, I'll skip the
> > randomization.
> > 
> 
> No, sorry.  This has been wrong for over 10 years; there is no
> substitute for the full (e820) memory map.  *Furthermore*, based on
> where in the bootup sequence you are doing this, you also have to
> consider any other memory structures that the kernel needs to be aware
> of (initramfs, any chunks in the linked list, the command line, EFI
> handover structures, etc.)  This is in fact an arbitrarily complex
> operation... we have *finally* gotten the kernel to the point where (a)
> the boot loader can actually do the right thing in all cases and (b) the
> kernel will reserve or copy all the auxiliary memory chunks it needs at
> a very early point.
> 
> Sorry, this cannot be short-circuited.
> 

Ok, checking the e820 memory map seems like the way to go then.  As a
first attempt, I'd assume that if I find a contiguous free chunk that
begins before (or at) 16 MB and continues beyond 16 MB, then that
represents space where it's safe to load the kernel (up to a certain
point before the end of that chunk), assuming the chunk has enough space
and I do some degree of checking that I'm not decompressing on top of
something else (I'll start to gather a list of what to watch out for).
Is this a fair assumption?

> > Given this information, do you have a conservative guess for how close
> > to the top of available memory we can put the kernel?  As in, let's say
> > we have an XYZ MB chunk of contiguous, free memory, how should I
> > calculate the highest, safe place to put the kernel in that region?
> > 
> > I'm going to continue to enforce the requirement that 16 MB is the
> > lowest address we can safely load the kernel, and I'd still appreciate
> > any information on why 2/4 MB default alignment might cause problems.
> 
> The problem with all of that was backwards compatibility with existing
> relocating bootloaders.
> 

Do you have any alternatives that allow maintaining compatibility while
giving us finer-grained alignment?  It seems it should be possible,
since alignment was lower than 16 MB for years before this change was
introduced...

Thanks,
Dan

> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.


