Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab0E2Kbf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 06:31:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65335 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0E2Kbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 06:31:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=pwyCm+iluUNeKOEZP3F5pMX/Lxexguo0Rs2XZ1DDyoG66pa8q4JO6O3uSMO5wVkIkb
         99SsekGRc4VIVNHMmNXpi2U5qP4Einlr86xCYM6scudKyg7eKkInSPTtadyN0iutTPid
         L7/vkLj0yGxFmVMb1okTv0DvohP6mjY0MDmlg=
MIME-Version: 1.0
Date: Sat, 29 May 2010 06:31:32 -0400
Message-ID: <AANLkTimDfbJkAuoK1-asvk8Ub9C9QBkK5RkzLR3ilJUY@mail.gmail.com>
Subject: Re: [PATCH v21 011/100] eclone (11/11): Document sys_eclone
From: Albert Cahalan <acahalan@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, sukadev@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu writes:

> Randy Dunlap [randy.dunlap at oracle.com] wrote:
>>> base of the region allocated for stack. These architectures
>>> must pass in the size of the stack-region in ->child_stack_size.
>>
>>                               stack region
>>
>> Seems unfortunate that different architectures use
>> the fields differently.
>
> Yes and no. The field still has a single purpose, just that
> some architectures may not need it. We enforce that if unused
> on an architecture, the field must be 0. It looked like
> the easiest way to keep the API common across architectures.

Yuck. You're forcing userspace to have #ifdef messes or,
more likely, just not work on all architectures. There is
no reason to have field usage vary by architecture. The
original clone syscall was not designed with ia64 and hppa
in mind, and has been causing trouble ever since. Let's not
perpetuate the problem.

Given code like this:   stack_base = malloc(stack_size);
stack_base and stack_size are what the kernel needs.

I suspect that you chose the defective method for some reason
related to restarting processes that were created with the
older system calls. I can't say most of us even care, but in
that broken-already case your process restarter can make up
some numbers that will work. (for i386, the base could be the
lowest address in the vma in which %esp lies, or even address 0)

A related issue is that stack allocation and deallocation can
be quite painful: it is difficult (some assembly required) to
free one's own stack, and impossible if one is already dead.
We could use a flag to let the kernel handle allocation, with
the stack getting freed just after any ptracer gets a last look.
This issue is especially troublesome for me because the syscall
essentially requires per-thread memory to work; it is currently
extremely difficult to use the syscall in code which lacks that.
