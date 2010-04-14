Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0DNPWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:22:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44015 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab0DNPWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:22:35 -0400
Date: Wed, 14 Apr 2010 17:22:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: Re: 2.6.34-rc4 : OOPS in unmap_vma
Message-ID: <20100414152231.GA16779@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
	Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
	kexec@lists.infradead.org
References: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
 <20100414061746.GA23153@liondog.tnic>
 <alpine.LFD.2.00.1004140712240.15116@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004140712240.15116@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, Apr 14, 2010 at 07:32:08AM -0700

Hi Linus,

> On Wed, 14 Apr 2010, Borislav Petkov wrote:
> > 
> > hmm, it doesn't look like it. Your code translates to something like
> > 
> >    0:   b8 00 00 00 00          mov    $0x0,%eax
> >    5:   80 ff ff                cmp    $0xff,%bh
> >    8:   ff 48 21                decl   0x21(%rax)
> >    b:   45 80 48 8b 45          rex.RB orb    $0x45,-0x75(%r8)
> >   10:   80 48 ff c8             orb    $0xc8,-0x1(%rax)
> 
> There's a large constant (0xffffff8000000000) in there at the beginning, 
> and the disassembly hasn't found the start of the next instruction very 
> cleanly. The same is true at the end: another large constant is cut off in 
> the middle. 
> 
> The byte just before the dumped instruction stream is almost certainly 
> '48h', and the last byte of the last constant is 0xff, and the disassembly 
> ends up being:
> 
>    0:	48 b8 00 00 00 00 80 	mov    $0xffffff8000000000,%rax
>    7:	ff ff ff 
>    a:	48 21 45 80          	and    %rax,-0x80(%rbp)
>    e:	48 8b 45 80          	mov    -0x80(%rbp),%rax
>   12:	48 ff c8             	dec    %rax
>   15:	48 3b 85 40 ff ff ff 	cmp    -0xc0(%rbp),%rax
>   1c:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
>   23:	48 0f 42 7d 80       	cmovb  -0x80(%rbp),%rdi
>   28:	48 89 7d 80          	mov    %rdi,-0x80(%rbp)
>   2c:*	48 8b 38             	mov    (%rax),%rdi     <-- trapping instruction
>   2f:	48 85 ff             	test   %rdi,%rdi
>   32:	0f 84 f5 04 00 00    	je     0x52d
>   38:	48 b8 fb 0f 00 00 00 	mov    $0xffffc00000000ffb,%rax
>   3f:	c0 ff ff 
> 
> But yes, you found the right spot (that 0xffffff8000000000 constant is 
> -549755813888 decimal):

Right, the decodecode output looked kinda strange to me and I tried
to match the instruction order and find the location. But yeah, now
that I'm looking at show_registers(), we don't start dumping on precise
instruction boundary but simply 64 bytes in the default case. No time
for an instruction decoder along that path :).

> > which I could correlate with what I get here (comments added):
> 
> Yup. Close enough. Btw, it's often good to look at both the *.s code _and_ 
> the *.lst code. If you do "make mm/memory.lst", you'll find those big 
> constants easily, and then you'll see the code this way:

[..]

ok, I can't say that I'm a linux newbie but the .lst code is new to me.
Damn, and I thought I knew it all :)

> > so it looks like it tries to find a page table rooted at that address
> > but the pointer value of 0000000000002203 is bogus.
> 
> Yes, it does look like some strange page table corruption, doesn't look 
> anon_vma related at all. It's intriguing that it started happening now, 
> though, so..

Well, Parag said something about kexec kernel so it is definitely
interesting what he means there - a kexec-enabled kernel or is this the
"second" kernel his machine kexec'd into after a previous failure. I
think this could clarify the situation a bit.

Thanks for looking over the asm.

-- 
Regards/Gruss,
Boris.
