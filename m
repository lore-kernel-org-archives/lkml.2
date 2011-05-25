Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab1EYPt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:49:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39801 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975Ab1EYPt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:49:28 -0400
Message-ID: <4DDD24E2.4010602@zytor.com>
Date: Wed, 25 May 2011 08:48:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <20110524211644.GJ27634@elte.hu>	 <4DDC39F1.2060903@zytor.com> <1306332225.2211.9.camel@dan>
In-Reply-To: <1306332225.2211.9.camel@dan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 07:03 AM, Dan Rosenberg wrote:
> 
> My current idea is to use int 0x15, eax = 0xe801 (which seems to be
> nearly universally supported) and use bx/dx to determine the amount of
> contiguous, usable memory above 16 MB, which seems to be exactly what we
> want to know.  If the BIOS does not support this function I'll be sure
> to catch that and skip the randomization.  Likewise, if the amount of
> returned memory seems insufficient or otherwise confusing, I'll skip the
> randomization.
> 

No, sorry.  This has been wrong for over 10 years; there is no
substitute for the full (e820) memory map.  *Furthermore*, based on
where in the bootup sequence you are doing this, you also have to
consider any other memory structures that the kernel needs to be aware
of (initramfs, any chunks in the linked list, the command line, EFI
handover structures, etc.)  This is in fact an arbitrarily complex
operation... we have *finally* gotten the kernel to the point where (a)
the boot loader can actually do the right thing in all cases and (b) the
kernel will reserve or copy all the auxiliary memory chunks it needs at
a very early point.

Sorry, this cannot be short-circuited.

> Given this information, do you have a conservative guess for how close
> to the top of available memory we can put the kernel?  As in, let's say
> we have an XYZ MB chunk of contiguous, free memory, how should I
> calculate the highest, safe place to put the kernel in that region?
> 
> I'm going to continue to enforce the requirement that 16 MB is the
> lowest address we can safely load the kernel, and I'd still appreciate
> any information on why 2/4 MB default alignment might cause problems.

The problem with all of that was backwards compatibility with existing
relocating bootloaders.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

