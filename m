Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab1HVBRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 21:17:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47519 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1HVBRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 21:17:04 -0400
Date: Mon, 22 Aug 2011 02:16:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
Message-ID: <20110822011645.GM2203@ZenIV.linux.org.uk>
References: <20110820201406.GF2203@ZenIV.linux.org.uk>
 <4E501F51.9060905@nod.at>
 <CAObL_7FoPHu6AKneswjEmiU4UBjUuKpYahakOaTNXM3=ZCpYaA@mail.gmail.com>
 <CAObL_7H8E1fde-d_Kfjrg2mQ5PdAp9X=fVRTqXJKzzYmQ1vAQQ@mail.gmail.com>
 <20110821063443.GH2203@ZenIV.linux.org.uk>
 <20110821084230.GI2203@ZenIV.linux.org.uk>
 <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com>
 <20110821144352.GJ2203@ZenIV.linux.org.uk>
 <20110821164124.GL2203@ZenIV.linux.org.uk>
 <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 08:44:12PM -0400, Andrew Lutomirski wrote:

> This is, IMO, gross -- if the values in pt_regs matched what they were
> when sysenter / syscall was issued, then we'd be fine -- we could
> restart the syscall and everything would work.  Apparently ptrace
> users have a problem with that, so we're stuck with the "lie" (i.e.
> reporting values as of __kernel_vsyscall, not as of the actual kernel
> entry).

Um, _no_.  If nothing else, pt_regs is seen by sys_....  And they don't
bloody know or care how the syscall had been entered.

> Which suggests an easy-ish fix: if sysenter is used or if syscall is
> entered from the EIP is is supposed to be entered from, then just
> change ip in the argument save to point to the int 0x80 instruction.
> This might also require tweaking the userspace stack.  That way,
> restart would hit int 0x80 instead of syscall/sysenter and the
> registers are exactly as expected.

Huh?  Actions after SYSENTER differ from those after int 0x80.  If nothing
else, you would need to tweak saved userland stack pointer as well.  It is
possible, but I seriously doubt that it's a better way to deal with that
mess.  And in any case, SYSEXIT buggers CX/DX, so we'd need two separate
post-syscall sequences in vdso.  Yucky...  I really don't like it.

The really ugly part for the SYSCALL variant is that right now we *can*
do things like this:
read_it:
	pushl %ebp
	movl $__NR_read, %eax
	movl $0, %ebx
	movl $array, %ebp
	movl $100, %edx
	syscall
        movl $__USER32_DS, %ecx
        movl %ecx, %ss
	popl %ebp
	ret
anywhere in your userland and have it act as an equivalent of
int read_it(void)
{
	return read(0, array, 100);
}

Is that ability a part of userland ABI or are we declaring that hopelessly
wrong and require to go through the function in vdso32?  Linus?

As it is, I don't see any cheap ways to deal with restarts if that thing
has to be preserved.  For sysenter it's flatly prohibited and that allows
us to play such games with adjusted return address.  Here, OTOH...
