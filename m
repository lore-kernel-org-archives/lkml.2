Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758371Ab0GVBjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:39:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab0GVBjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:39:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: Question about binfmt_elf.c
In-Reply-To: Andrew Morton's message of  Wednesday, 21 July 2010 16:30:59 -0700 <20100721163059.ffc5e70d.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <201007161512.40388.rob@landley.net>
	<20100721163059.ffc5e70d.akpm@linux-foundation.org>
X-Zippy-Says: ..  the MYSTERIANS are in here with my CORDUROY SOAP DISH!!
Message-Id: <20100722013858.14C1A400B8@magilla.sf.frob.com>
Date: Wed, 21 Jul 2010 18:38:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 16 Jul 2010 15:12:39 -0500
> Rob Landley <rob@landley.net> wrote:
> 
> > Could somebody please update this comment to explain why fiddling with 
> > strangely protected bss is _not_ an easy way to leak arbitrary amounts of 
> > uninitalized kernel memory (with whatever previous contents they have) to 
> > userspace?

I can't tell why you would ever think that was possible.  There is no
kernel memory involved, uninitialized or otherwise.  All the memory in
the user address space is "initialized", being either zero pages or
file-mapped pages.  The only thing that happens when bogus ELF headers
prevent us from clearing some bss is that a partial page of file data
is visible in user memory rather than being all zero.

> In January 2005 davem added a check.  In Feb 2005 Pavel said "hey, my
> Kylix application broke".  So we took the check out again.
> 
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg60120.html
> http://www.mail-archive.com/bk-commits-head@vger.kernel.org/msg01390.html

Note there are other places that call padzero() and do check its
result.  So we're only ignoring the error for one particular kind of
bss, which is not even done in normal layouts at all (with the right
p_flags or not).  Usually, there is only bss in the last segment, which
is the path that uses padzero().  This code path without the error
check is only used for a segment that both has bss (p_memsz > p_filesz)
and is followed by some other PT_LOAD segment.

> I don't kow how one would craft such an elf file.  

  $ cat badbss.lds
  SECTIONS {
	  . = SIZEOF_HEADERS;
	  .text : { *(.text*) } :re
	  .bss : { *(.bss*) } :re
	  . = ALIGN(0x1000);
	  .data : { *(.data*) } :rw
  }

  PHDRS {
	  re PT_LOAD FLAGS(5) FILEHDR PHDRS;
	  rw PT_LOAD FLAGS(6);
  }
  $ gcc -m32 -static -nostdlib -nostartfiles -o badbss -xc <(echo 'char use_bss[0x234], use_data[0x345]={1,}; _start(){}') -Wl,badbss.lds
  $ eu-readelf -l badbss
  Program Headers:
    Type           Offset   VirtAddr   PhysAddr   FileSiz  MemSiz   Flg Align
    LOAD           0x000000 0x08048000 0x08048000 0x00009d 0x001634 R E 0x1000
    LOAD           0x0000a0 0x080490a0 0x080490a0 0x000345 0x000345 RW  0x1000

   Section to Segment mapping:
    Segment Sections...
     00      [RO: .note.gnu.build-id .text .data .bss]
     01      [RO: .data]

To the loader, "bss" means p_memsz > p_filesz, as you see there in the
first LOAD segment.  And it's not writable.


Thanks,
Roland
