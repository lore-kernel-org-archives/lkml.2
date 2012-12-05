Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab2LEKGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:06:30 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36629 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2LEKG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:06:27 -0500
Date: Wed, 5 Dec 2012 10:06:18 +0000
From: Cong Ding <dinggnu@gmail.com>
To: "Li, Zhen-Hua" <lizhenhua.dev@gmail.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memory: of_memory.c: remove unnecessary initialization
Message-ID: <20121205100617.GA12812@gmail.com>
References: <1354620448-14317-1-git-send-email-dinggnu@gmail.com>
 <50BDE224.8000301@ti.com>
 <CACxGe6viwuyfYm2RBfcj233U6-xmJJTQgu=DUu_11iPAckUzqg@mail.gmail.com>
 <50BE0CC3.7060800@ti.com>
 <CAEk7JKakQRPKEoi+vkF2KexB1d_G+BN-PZQT-QDNEeOrkVm0Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEk7JKakQRPKEoi+vkF2KexB1d_G+BN-PZQT-QDNEeOrkVm0Vg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 03:26:36PM +0800, Li, Zhen-Hua wrote:
> Infact, your patch does remove an orl operation, but add a new "move" operation.
> 
> You can test such two functions:
> int func1(int rm1, int rm2){
>         int i = 0;
>         i |= rm1;
>         i |= rm2;
> }
> 
> and
> 
> int func(int rm1, int rm2){
>         int i;
>         i = rm1;
>         i |= rm2;
> }
> 
> Use gcc to compile them to assemble with "-S" operation, and you will find it.
you are wrong. if we use O0 parameter in gcc, it really reduces an "OR"
operation; and you are correct if we use O2 in gcc, the assemble code is the
same. you can refer to the following screen snapshot.

But we should not rely on compilers, right? But in this situation, this simple
optimization should be done by any compiler, so it doesn't matter we patch it
or not. 

[ding@GNU ~]$ gcc --version
gcc (GCC) 4.6.2 20111027 (Red Hat 4.6.2-2)
Copyright (C) 2011 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

[ding@GNU ~]$ cat main1.c
#include<stdio.h>

int foo(int arg1, int arg2) {
        int ret = 0;
        ret |= arg1;
        ret |= arg2;
        return ret;
}

int main(int argc, char **argv) {
        int o = foo(57, 89);
        printf(value is %d.n, o);
}
[ding@GNU ~]$ cat main2.c
#include<stdio.h>

int foo(int arg1, int arg2) {
        int ret;
        ret = arg1;
        ret |= arg2;
        return ret;
}

int main(int argc, char **argv) {
        int o = foo(57, 89);
        printf(value is %d.n, o);
}
[ding@GNU ~]$ gcc -S main1.c -o main1.s
[ding@GNU ~]$ gcc -S main2.c -o main2.s
[ding@GNU ~]$ diff -up main1.s main2.s
--- main1.s     2012-12-05 09:23:18.487007457 +0000
+++ main2.s     2012-12-05 09:23:25.742997827 +0000
@@ -1,4 +1,4 @@
-       .file   main1.c
+       .file   main2.c
        .text
        .globl  foo
        .type   foo, @function
@@ -12,9 +12,8 @@ foo:
        .cfi_def_cfa_register 6
        movl    %edi, -20(%rbp)
        movl    %esi, -24(%rbp)
-       movl    -bash, -4(%rbp)
        movl    -20(%rbp), %eax
-       orl     %eax, -4(%rbp)
+       movl    %eax, -4(%rbp)
        movl    -24(%rbp), %eax
        orl     %eax, -4(%rbp)
        movl    -4(%rbp), %eax
[ding@GNU ~]$ gcc -S -O2 main1.c -o main1O2.s
[ding@GNU ~]$ gcc -S -O2 main2.c -o main2O2.s
[ding@GNU ~]$ diff -up main1O2.s main2O2.s
--- main1O2.s	2012-12-05 09:24:12.718928945 +0000
+++ main2O2.s	2012-12-05 09:24:22.590911258 +0000
@@ -1,4 +1,4 @@
-	.file	"main1.c"
+	.file	"main2.c"
 	.text
 	.p2align 4,,15
 	.globl	foo
[ding@GNU ~]$

> On Tue, Dec 4, 2012 at 10:46 PM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
> > On Tuesday 04 December 2012 07:25 PM, Grant Likely wrote:
> >>
> >> On Tue, Dec 4, 2012 at 11:44 AM, Santosh Shilimkar
> >> <santosh.shilimkar@ti.com> wrote:
> >>>
> >>> On Tuesday 04 December 2012 04:56 PM, Cong Ding wrote:
> >>>>
> >>>>
> >>>> the initialization of variable ret is unnecessary, we can remove it
> >>>> while
> >>>> save
> >>>> one time "or" operation.
> >>>>
> >>>> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> >>>> ---
> >>>
> >>>
> >>> Looks ok.
> >>> Acked-by: Santosh Shilimkar<santosh.shilimkar@ti.com>
> >>>
> >>
> >> Thanks for the patch, but I don't think it matters enough to apply it.
> >> The existing code isn't wrong.
> >>
> > The patch was removing an additional operation and hence i didn't
> > contest it. I agree with your comment though.
> >
> > Regards
> > Santosh
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
