Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab1IBImP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:42:15 -0400
Received: from mail.codesourcery.com ([38.113.113.100]:51513 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab1IBImM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:42:12 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFD: x32 ABI system call numbers
Date: Fri, 2 Sep 2011 09:42:06 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
References: <4E582577.2060805@zytor.com> <201109020149.10780.pedro@codesourcery.com> <4E6036A7.6090200@zytor.com>
In-Reply-To: <4E6036A7.6090200@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201109020942.07312.pedro@codesourcery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 September 2011 02:51:35, H. Peter Anvin wrote:
> On 09/01/2011 05:49 PM, Pedro Alves wrote:
> >>>
> >>>       struct iovec
> >>>       {
> >>>           void __user *iov_base;    /* BSD uses caddr_t (1003.1g requires
> >>> void *) */
> >>>           __kernel_size_t iov_len; /* Must be size_t (1003.1g) */
> >>>       } __attribute__((x32_abi_64));
> >>>
> >>>       typedef long time_t __attribute__((x32_abi_64));
> >>>
> >>> The x32_abi_64 attribute converts pointers and longs back to 64-bit and
> >>> adjusts the alignment accordingly.  If we tag all userspace visible
> >>> structures with this attribute, we can use the 64-bit ABI without changes.
> >
> > I would expect no new gcc extension to be needed for that -- there's the
> > mode attribute (you can read DI as 64-bit):
> >
> >   typedef void * __kernel_ptr64 __attribute ((mode(DI)));
> >
> >   struct iovec
> >   {
> >     __kernel_ptr64 iov_base;
> >     ...
> >   };
> >
> 
> Does that work for *writing*, too?  That might be a very useful little 
> escape hatch for some particularly tight corners.

With a gcc trunk from earlier this month (that supports -mx32):

typedef void * ptr64 __attribute ((mode(DI)));

struct foo
{
  ptr64 p64;
};

int
foofunc (void)
{
  struct foo foo;
  int i;
  void *p32;
  ptr64 p64;

  p32 = &i;
  p32 = &foofunc;

  p64 = p32;
  p64 = &i;
  p64 = foofunc;

  foo.p64 = p32;

  void **ptrp64 = &p64;  /* gives "warning: initialization from incompatible pointer type [enabled by default]". */

  return (int) (void*) ptrp64;
}

With:

./cc1 ~/mode.c -o mode.o -mx32 -fverbose-asm

gives me:

/home/pedro/mode.c: In function ‘foofunc’:
/home/pedro/mode.c:25:19: warning: initialization from incompatible pointer type [enabled by default]

and produced (note, -O0):

foofunc:
.LFB0:
        .cfi_startproc
        pushq   %rbp    #
        .cfi_def_cfa_offset 16
        .cfi_offset 6, -16
        movq    %rsp, %rbp      #,
        .cfi_def_cfa_register 6
        leaq    -20(%rbp), %rax #, tmp61
        movl    %eax, -4(%rbp)  # tmp61, p32
        movl    $foofunc, -4(%rbp)      #, p32
        mov     -4(%rbp), %eax  # p32,
        movq    %rax, -32(%rbp) #, p64
        leaq    -20(%rbp), %rax #, tmp62
        movq    %rax, -32(%rbp) # tmp62, p64
        movq    $foofunc, -32(%rbp)     #, p64
        mov     -4(%rbp), %eax  # p32, tmp63
        movq    %rax, -16(%rbp) # tmp63, foo.p64
        leaq    -32(%rbp), %rax #, tmp64
        movl    %eax, -8(%rbp)  # tmp64, ptrp64
        movl    -8(%rbp), %eax  # ptrp64, D.2693
        popq    %rbp    #
        .cfi_def_cfa 7, 8
        ret
        .cfi_endproc

-- 
Pedro Alves
