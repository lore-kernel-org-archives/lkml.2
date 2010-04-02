Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab0DBS0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:26:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577Ab0DBS0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:26:37 -0400
Date: Fri, 2 Apr 2010 11:24:28 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
Message-Id: <20100402112428.f46ddc44.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	<20100402175937.GA19690@liondog.tnic>
	<alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010 11:09:14 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> I think this is likely due to the new scalable anon_vma linking by Rik. 

Similar to https://bugzilla.kernel.org/show_bug.cgi?id=15680

> Nothing else I can imagine should have introduced anything like it.
> 
> Rik: the picures have the information, but you need to look at several to 
> see both the oops and the backtrace. Here's a condensed version:
> 
>  shrink_all_memory ->
>    do_try_to_free_pages ->
>      shrink_zone ->
>        shrink_inactive_list ->
>          shrink_page_list ->
>            page_referenced
> 
> where page_referenced() oopses due page_referenced_anon() as per 
> Borislav's description below.
> 
> Added all the usual suspects to the Cc list. Left the full report appended 
> so that the new people don't have to search for it on lkml.
> 
> 		Linus
> 
> On Fri, 2 Apr 2010, Borislav Petkov wrote:
> > 
> > I've got the following oopsie two times now when hibernating - this
> > means, I don't get it everytime I hibernate but only sometimes, say once
> > in a blue moon.
> > 
> > And yeah, I couldn't catch it over serial console so I had to make ugly
> > pictures. By the way, the numbers in the filenames increment as I scroll
> > down the whole oops (yep, it hadn't completely frozen and I still could
> > do Shift->PgUp or Shift->PgDn on the console):
> > 
> > http://www.kernel.org/pub/linux/kernel/people/bp/
> > 
> > So, here's what I could decipher from the oopsie, someone else who's
> > more knowledgeable in mm, rmap and anon_vma's list traversal should be
> > able to tell what goes wrong there.
> > 
> > EIP is at page_referenced+0xee
> > 
> > which is
> > 
> > <disasm>
> >     10c4:	41 01 c4             	add    %eax,%r12d
> >     10c7:	83 7d cc 00          	cmpl   $0x0,-0x34(%rbp)
> >     10cb:	74 19                	je     10e6 <page_referenced+0xff>
> >     10cd:	4d 8b 6d 20          	mov    0x20(%r13),%r13
> >     10d1:	49 83 ed 20          	sub    $0x20,%r13
> > 
> >     10d5:	49 8b 45 20          	mov    0x20(%r13),%rax		    <--------------
> > 
> >     10d9:	0f 18 08             	prefetcht0 (%rax)
> >     10dc:	49 8d 45 20          	lea    0x20(%r13),%rax
> >     10e0:	48 39 45 80          	cmp    %rax,-0x80(%rbp)
> > </disasm>
> > 
> > 
> > Corresponding asm:
> > 
> > <asm>
> > 	.loc 1 496 0
> > 	movq	32(%r13), %r13	# <variable>.same_anon_vma.next, __mptr.451
> > .LVL295:
> > 	subq	$32, %r13	#, avc
> > .LVL296:
> > .L184:
> > .LBE1278:
> > 	movq	32(%r13), %rax	# <variable>.same_anon_vma.next, <variable>.same_anon_vma.next			<----------------
> > 	prefetcht0	(%rax)	# <variable>.same_anon_vma.next
> > 	leaq	32(%r13), %rax	#, tmp97
> > 	cmpq	%rax, -128(%rbp)	# tmp97, %sfp
> > 	jne	.L187	#,
> > .L186:
> > 	.loc 1 514 0
> > 	movq	%r14, %rdi	# anon_vma,
> > 	call	page_unlock_anon_vma	#
> > </asm>
> > 
> > 
> > and the NULL pointer in question is being written into %r13 and then 32
> > is subtracted from it (I'm guessing container_of()). This is consistent
> > with the register snapshot - %r13 contains 0xffffffffffffffe0 which is
> > -32 and with the code dump in the oops, in CIMG1640.JPG code points to
> > opcode 49 8b 45 20.
> > 
> > Which is the following piece of code in <mm/rmap.c:page_referenced_anon()>.
> > 
> > <source>
> > 
> > 	mapcount = page_mapcount(page);
> > 	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
> > 		struct vm_area_struct *vma = avc->vma;
> > 		unsigned long address = vma_address(page, vma);
> > 		if (address == -EFAULT)
> > 			continue;
> > 
> > </source>
> > 
> > which tells us that same_anon_vma.next is NULL. Hmm...
> > 
> > -- 
> > Regards/Gruss,
> >     Boris.
> > 
