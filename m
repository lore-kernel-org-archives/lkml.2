Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2ASQBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:01:38 -0500
Received: from mail2.shareable.org ([80.68.89.115]:40521 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2ASQBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:01:37 -0500
Date: Thu, 19 Jan 2012 16:01:13 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
Message-ID: <20120119160113.GN7180@jl-vm1.vm.bytemark.co.uk>
References: <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org>
 <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org>
 <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <CAObL_7FsNQaPQg-3=AO9RuMNZZsRgDSJYPhPevDKERws9vQJWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7FsNQaPQg-3=AO9RuMNZZsRgDSJYPhPevDKERws9vQJWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Lutomirski wrote:
> It's reasonable, obvious, and even more wrong than it appears.  On
> Xen, there's an extra 64-bit GDT entry, and it gets used by default.
> (I got bitten by this in some iteration of the vsyscall emulation
> patches -- see user_64bit_mode for the correct and
> unusable-from-user-mode way to do this.)

Here it is:

	static inline bool user_64bit_mode(struct pt_regs *regs)
	{
	#ifndef CONFIG_PARAVIRT
		/*
		 * On non-paravirt systems, this is the only long mode CPL 3
		 * selector.  We do not allow long mode selectors in the LDT.
		 */
		return regs->cs == __USER_CS;
	#else
		/* Headers are too twisted for this to go in paravirt.h. */
		return regs->cs == __USER_CS || regs->cs == pv_info.extra_user_64bit_cs;
	#endif
	}

Perhaps userspace can do that.
Would it be right for a ptracer to say:

   CS == 0x23 -> 32-bit
   (CS & 4)   -> 32-bit (LDT, "we do not allow long mode selectors in the LDT")
   else       -> 64-bit (__USER_CS or some other GDT entry which must be pv_info's)

I.e. assume that no other *GDT* CS values are available to userspace?
There are other 32-bit GDT entries, but are they not all for data or kernel use only?

-- Jamie
