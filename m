Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2ECSOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:14:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50924 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042Ab2ECSOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:14:04 -0400
Message-ID: <4FA2CAD9.6010808@zytor.com>
Date: Thu, 03 May 2012 11:13:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@gmail.com>,
        Jana Saout <jana@saout.de>, Joel Becker <jlbec@evilplan.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
References: <1335788867.29087.19.camel@localhost> <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com> <1335875321.26671.15.camel@localhost> <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com> <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com> <20120503064722.GN6871@ZenIV.linux.org.uk> <CA+55aFx0EUgXCE9CfUGz6zde-6iYgUKZRxB1=-VOEG0kSX2qEA@mail.gmail.com> <CA+55aFxeBHSB6iBpP55kV2bLQGg8ZC9Ve5mvCmZN0ARH9dVwKg@mail.gmail.com>
In-Reply-To: <CA+55aFxeBHSB6iBpP55kV2bLQGg8ZC9Ve5mvCmZN0ARH9dVwKg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 10:30 AM, Linus Torvalds wrote:
> On Thu, May 3, 2012 at 9:15 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> So I guess I need to do the exception handling that I was hoping I
>> wouldn't have to. Give me a jiffy.
> 
> Ok, that took longer than a jiffy, the asm was just nasty to get right
> with all the proper suffixes for 32-bit vs 64-bit, and the fact that
> gas apparently really needs %cl for the shift count, and doesn't like
> %rcx. Silly assembler.
> 

Yes, although it's a fixed register you can also just write as %%cl.

> Also, the asm would have been much simpler if I didn't care so much
> about the regular fast-path. I wanted the fast-path for the asm to be
> a single load, with no downside, and everything fixed up in the
> exception case.
> 
> And it's close. It's a single load, and the only downside is that
> register '%rcx' is marked as used, because *if* the exception happens,
> we want to use %rcx do the alignment fixup.
> 
> Peter, in particular, can you double (and triple-) check my asm, to
> see if I missed anything? It does that "lea" of the address into %rcx
> twice, because that way we don't need any other register temporaries.

Just from a cleanliness point of view, I don't think you need the
__WORDSUFFIX for any of these instructions (it is only required if it
would be ambiguous, but the register names should deal with it.)

>  - fast-path single-instruction unaligned load (with gcc free to pick
> registers and addressing modes):
> 
>       movl (%edi,%edx),%eax
> 
>  - with the exception fixup code becoming:
> 
>         leal (%edi,%edx),%ecx
>         andl $-4,%ecx
>         movl (%ecx),%eax
>         leal (%edi,%edx),%ecx
>         andl $3,%ecx
>         shll $3,%ecx
>         shll %cl,%eax
>         shrl %cl,%eax
>         jmp 2b

I think you want to drop the shl instruction.  You're loading what
should end up at the LSB end of the register into the MSB end of the
register, so shr is all you should need.

Let's say %edi+%edx points to 0xcccccffd with the values 66 77 88 99
starting at 0xcccccffc.  If the next page is present and zero, you'd end
up with %eax = 0x00998877, and so you would expect the same.

	lea (%edi,%edx),%ecx	-> %ecx = 0xcccccffd
	and $-4,%ecx		-> %ecx = 0xcccccffc
	mov (%ecx),%eax		-> %eax = 0x99887766
	lea (%edi,%edx),%ecx	-> %ecx = 0xcccccffd
	and $3,%ecx		-> %ecx = 1
	shl $3,%ecx		-> %ecx = 8
	shr %cl,%eax		-> %eax = 0x00998877

	-hpa



-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

