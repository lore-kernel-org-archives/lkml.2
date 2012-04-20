Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab2DTXOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:14:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36154 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab2DTXOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:14:08 -0400
Message-ID: <4F91EDBD.4030700@gmail.com>
Date: Fri, 20 Apr 2012 16:14:05 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: David Daney <ddaney.cavm@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts: Make sortextable handle relocations.
References: <1334961679-14562-1-git-send-email-ddaney.cavm@gmail.com> <4F91EA5B.4000803@zytor.com>
In-Reply-To: <4F91EA5B.4000803@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 03:59 PM, H. Peter Anvin wrote:
> On 04/20/2012 03:41 PM, David Daney wrote:
>> From: David Daney<david.daney@cavium.com>
>>
>> If there are relocations on the __ex_table section, they must be fixed
>> up after the table is sorted.
>>
>> Also use the unaligned safe accessors from tools/{be,le}_byteshift.h
>>
>> Signed-off-by: David Daney<david.daney@cavium.com>
>> ---
>>
>> This should address HPA's concerns about the i386 relocations.  The
>> i386 kernel still boots after the sort, but I don't know how to test
>> the relocations, but they sure do look nice!  My MIPS64 kernels still
>> boot too, so that is also good.
>>
>
> Hi...
>
> This works for absolute relocations of the REL type, but not for
> relocations of the RELA type nor for non-absolute relocations (moving
> those changes the meaning.)

The program explicitly only handles MIPS and x86.

x86_64 and MIPS never have relocations, and x86_32 is always REL, so 
that is handled

Also x86_32 is only emitting R_386_32 and those are handled.

>
> I think Linus is right and the right thing to do is to switch to using
> relative entries in the exception table; I am currently testing a
> patchset to do exactly that (on x86).  It also has the benefit of making
> the table half the size on x86-64.  Then we can just zero out the
> .rel[a]__ex_table section and be done with it.

That's fine.

In any event we want to do build time sorting, this patch improves the 
original sortextable, so may be worthwhile as purely a cleanup.  I 
wanted to fix the relocation breakage, even if the eventual solution 
needs to be somewhat different.

>
> The trick, of course, is that sorting a relative table is slightly
> different than sorting an absolute table -- the way I'm doing it for the
> in-kernel sorter (still needed for modules) is to add the intra-section
> offset to each entry (both sides) before sorting, then doing a *signed*
> sort, then denormalize again.  Alpha does it differently, with custom
> compare and swap routines.
>
> 	-hpa
>

