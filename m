Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab0KLVpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:45:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab0KLVp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:45:28 -0500
To: "Sylvain GENEVES" <Sylvain.Geneves@inrialpes.fr>
Cc: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Oprofile bug ?
References: <c69374315a434a8bab96c55e4542bc81.squirrel@webmail.inrialpes.fr>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 12 Nov 2010 16:45:14 -0500
In-Reply-To: <c69374315a434a8bab96c55e4542bc81.squirrel@webmail.inrialpes.fr> (Sylvain GENEVES's message of "Fri, 12 Nov 2010 22:11:05 +0100")
Message-ID: <y0mlj4yw711.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Sylvain GENEVES" <Sylvain.Geneves@inrialpes.fr> writes:

> [...]
> I'm encountering unexpected behaviour with OProfile when the profiled
> system is under heavy load : "BUG: unable to handle kernel paging request
> at 0000000000004cc3" (full console message is attached).
> [...]
> Anyone has any idea on what is happening ?

Just glancing at that oops & my local random kernel build, it appears
as though this part of arch/x86/kernel/time.c:profile_pc is failing:

unsigned long profile_pc(struct pt_regs *regs)
{
        unsigned long pc = instruction_pointer(regs);

        if (!user_mode_vm(regs) && in_lock_functions(pc)) {
#ifdef CONFIG_FRAME_POINTER
                return *(unsigned long *)(regs->bp + sizeof(long));
#else
                       ^^^^^^^^^^^^^^^^^^
[...]

regs->bp must have been 0x4cbb, which this code turns into an
unchecked dereferences at 0x4cbb+8 = 0x4cc3.  I don't have a theory
as to why regs->bp should have that value in it, but the kernel
should probably use probe_kernel_read() or somesuch to validate the
value before dereferencing it.

- FChE
