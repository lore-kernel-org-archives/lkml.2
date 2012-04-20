Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab2DTXBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:01:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34537 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab2DTXBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:01:17 -0400
Message-ID: <4F91EA5B.4000803@zytor.com>
Date: Fri, 20 Apr 2012 15:59:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] scripts: Make sortextable handle relocations.
References: <1334961679-14562-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1334961679-14562-1-git-send-email-ddaney.cavm@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 03:41 PM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> If there are relocations on the __ex_table section, they must be fixed
> up after the table is sorted.
> 
> Also use the unaligned safe accessors from tools/{be,le}_byteshift.h
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
> 
> This should address HPA's concerns about the i386 relocations.  The
> i386 kernel still boots after the sort, but I don't know how to test
> the relocations, but they sure do look nice!  My MIPS64 kernels still
> boot too, so that is also good.
> 

Hi...

This works for absolute relocations of the REL type, but not for
relocations of the RELA type nor for non-absolute relocations (moving
those changes the meaning.)

I think Linus is right and the right thing to do is to switch to using
relative entries in the exception table; I am currently testing a
patchset to do exactly that (on x86).  It also has the benefit of making
the table half the size on x86-64.  Then we can just zero out the
.rel[a]__ex_table section and be done with it.

The trick, of course, is that sorting a relative table is slightly
different than sorting an absolute table -- the way I'm doing it for the
in-kernel sorter (still needed for modules) is to add the intra-section
offset to each entry (both sides) before sorting, then doing a *signed*
sort, then denormalize again.  Alpha does it differently, with custom
compare and swap routines.

	-hpa
