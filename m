Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0DNOfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:35:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430Ab0DNOfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:35:51 -0400
Date: Wed, 14 Apr 2010 07:32:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: Re: 2.6.34-rc4 : OOPS in unmap_vma
In-Reply-To: <20100414061746.GA23153@liondog.tnic>
Message-ID: <alpine.LFD.2.00.1004140712240.15116@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1004132147260.1881@parag-laptop> <20100414061746.GA23153@liondog.tnic>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Apr 2010, Borislav Petkov wrote:
> 
> hmm, it doesn't look like it. Your code translates to something like
> 
>    0:   b8 00 00 00 00          mov    $0x0,%eax
>    5:   80 ff ff                cmp    $0xff,%bh
>    8:   ff 48 21                decl   0x21(%rax)
>    b:   45 80 48 8b 45          rex.RB orb    $0x45,-0x75(%r8)
>   10:   80 48 ff c8             orb    $0xc8,-0x1(%rax)

There's a large constant (0xffffff8000000000) in there at the beginning, 
and the disassembly hasn't found the start of the next instruction very 
cleanly. The same is true at the end: another large constant is cut off in 
the middle. 

The byte just before the dumped instruction stream is almost certainly 
'48h', and the last byte of the last constant is 0xff, and the disassembly 
ends up being:

   0:	48 b8 00 00 00 00 80 	mov    $0xffffff8000000000,%rax
   7:	ff ff ff 
   a:	48 21 45 80          	and    %rax,-0x80(%rbp)
   e:	48 8b 45 80          	mov    -0x80(%rbp),%rax
  12:	48 ff c8             	dec    %rax
  15:	48 3b 85 40 ff ff ff 	cmp    -0xc0(%rbp),%rax
  1c:	48 8b 85 50 ff ff ff 	mov    -0xb0(%rbp),%rax
  23:	48 0f 42 7d 80       	cmovb  -0x80(%rbp),%rdi
  28:	48 89 7d 80          	mov    %rdi,-0x80(%rbp)
  2c:*	48 8b 38             	mov    (%rax),%rdi     <-- trapping instruction
  2f:	48 85 ff             	test   %rdi,%rdi
  32:	0f 84 f5 04 00 00    	je     0x52d
  38:	48 b8 fb 0f 00 00 00 	mov    $0xffffc00000000ffb,%rax
  3f:	c0 ff ff 

But yes, you found the right spot (that 0xffffff8000000000 constant is 
-549755813888 decimal):

> which I could correlate with what I get here (comments added):

Yup. Close enough. Btw, it's often good to look at both the *.s code _and_ 
the *.lst code. If you do "make mm/memory.lst", you'll find those big 
constants easily, and then you'll see the code this way:

	        do {
	                next = pgd_addr_end(addr, end);
	ffffffff81b2aa45:       48 b8 00 00 00 00 80    mov    $0x8000000000,%rax
	ffffffff81b2aa4c:       00 00 00
	ffffffff81b2aa4f:       49 8d 04 04             lea    (%r12,%rax,1),%rax
	ffffffff81b2aa53:       48 89 45 a8             mov    %rax,-0x58(%rbp)
	ffffffff81b2aa57:       48 b8 00 00 00 00 80    mov    $0xffffff8000000000,%rax
	ffffffff81b2aa5e:       ff ff ff
	ffffffff81b2aa61:       48 21 45 a8             and    %rax,-0x58(%rbp)
	ffffffff81b2aa65:       48 8b 45 b8             mov    -0x48(%rbp),%rax
	ffffffff81b2aa69:       48 8b 55 a8             mov    -0x58(%rbp),%rdx
	ffffffff81b2aa6d:       48 ff c8                dec    %rax
	ffffffff81b2aa70:       48 ff ca                dec    %rdx   
	ffffffff81b2aa73:       48 39 c2                cmp    %rax,%rdx
	ffffffff81b2aa76:       48 8b 45 b8             mov    -0x48(%rbp),%rax
	ffffffff81b2aa7a:       48 8b 55 90             mov    -0x70(%rbp),%rdx
	ffffffff81b2aa7e:       48 0f 42 45 a8          cmovb  -0x58(%rbp),%rax
	ffffffff81b2aa83:       48 89 45 a8             mov    %rax,-0x58(%rbp)
	ffffffff81b2aa87:       48 8b 02                mov    (%rdx),%rax
	void pud_clear_bad(pud_t *);
	void pmd_clear_bad(pmd_t *);
	
	static inline int pgd_none_or_clear_bad(pgd_t *pgd)
	{
	        if (pgd_none(*pgd))
	ffffffff81b2aa8a:       48 85 c0                test   %rax,%rax
	ffffffff81b2aa8d:       74 20                   je     ffffffff81b2aaaf <unmap_vmas+0x228>
	                return 1;
	        if (unlikely(pgd_bad(*pgd))) {
	ffffffff81b2aa8f:       48 ba fb 0f 00 00 00    mov    $0xffffc00000000ffb,%rdx
	ffffffff81b2aa96:       c0 ff ff
	ffffffff81b2aa99:       48 21 c2                and    %rax,%rdx
	ffffffff81b2aa9c:       48 83 fa 63             cmp    $0x63,%rdx
	ffffffff81b2aaa0:       0f 84 d9 04 00 00       je     ffffffff81b2af7f <unmap_vmas+0x6f8>

although Parag's compiler has generated much better code (possibly due to 
config differences, possibly due to compiler versions)

> So you oops when dereferencing that pgd value in %rax (%rdx in my case),
> *pgd in pgd_none_or_clear_bad(pgd) which is called in the below fragment
> of unmap_page_range().
> 
> 	pgd = pgd_offset(vma->vm_mm, addr);
> 	do {
> 		next = pgd_addr_end(addr, end);
> 		if (pgd_none_or_clear_bad(pgd)) {
> 			(*zap_work)--;
> 			continue;
> 		}
> 		next = zap_pud_range(tlb, vma, pgd, addr, next,
> 						zap_work, details);
> 	} while (pgd++, addr = next, (addr != end && *zap_work > 0));

Correct.

> so it looks like it tries to find a page table rooted at that address
> but the pointer value of 0000000000002203 is bogus.

Yes, it does look like some strange page table corruption, doesn't look 
anon_vma related at all. It's intriguing that it started happening now, 
though, so.. 

				Linus
