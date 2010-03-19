Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab0CSA25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:28:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58009 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab0CSA24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=aCsdp3bjSCxsxp1fqtMWaxDDu9evxCKhxmG3rTVFpNXoF6hA97cENW9a2pNKc2w25U
         PE//ZSCQUmRbDuQrnwSeBtCnzXryCXHrBHWzApXv0FTXEUWSrYb0FGI+eGcdR7deK35+
         YKFsmeeB/iPDm2cIzisw2ar1LosAlasfSuHXk=
MIME-Version: 1.0
In-Reply-To: <49f90a801003181710v5e08ccc8jdd26ec899e75bdb9@mail.gmail.com>
References: <21512362.post@talk.nabble.com> <3e8340490901162016y268e3936k4b2d3fcb2afcf216@mail.gmail.com> 
	<21512985.post@talk.nabble.com> <3e8340490901162126u109da9cbu7292fddf6d832723@mail.gmail.com> 
	<49f90a801003181710v5e08ccc8jdd26ec899e75bdb9@mail.gmail.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 18 Mar 2010 20:28:34 -0400
Message-ID: <3e8340491003181728r766245edo91ecc1db75f3a6df@mail.gmail.com>
Subject: Re: Kernel vs user memory
To: Siddhartha Chhabra <siddhartha.chhabra@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 20:10, Siddhartha Chhabra
<siddhartha.chhabra@gmail.com> wrote:
> When the kernel tries to access user space pages, for example, for copying
> on a copy on write, in order to do so, does it need to get the page mapped
> to its address space, that is, will a page fault happen for the kernel when
> it first tries to access the user space page that it needs to copy ?
>
> I read a paper that provides security to the OS based on the assumption that
> every time, the OS tries to access the user space, it will page fault and by
> intercepting this page fault, they can check whether the kernel should be
> accessing the page or not ? But based on the discussion below, I guess, the
> kernel is free to access all the pages in memory (or atleast the first 700MB
> on a 32-bit system) without causing a page fault in the kernel space ?
>
> Am I right on this? I greatly appreciate you taking time to answer this
> question

It depends.

If the kernel's doing a copy_from_user or copy_to_user family of calls
(ie, the calls used in system call handlers when accessing user space
buffers referenced in the arguments), this will trigger a page fault
exactly like the userspace process would, and the PF handler will then
deal with any copy on write or whatever may be needed. Of course, if a
userspace access wouldn't trigger a PF, the kernel access won't
either.

For the actual copy-on-write process itself, it would be a Bad Thing
to trigger a recursive page fault, so instead the kernel will directly
access the page via the direct mapped section of the address space -
this will never cause a PF (on x86, this may require creating a
temporary mapping for memory at a high physical address, but this
still won't be a PF as it will be set up before the first access).
Additionally, memory mapped IO involves direct DMA to/from pages that
are simultaneously in use by userspace - this won't cause a PF in
kernel mode either. Same with swap.

In short, some kernel accesses to user space do go through normal
channels which may or may not PF; other accesses will never PF. So
it's a bad idea to rely on all kernel accesses triggering a page
fault.

Hope this helps,

Bryan
