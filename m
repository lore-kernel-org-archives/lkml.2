Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2ASQNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:13:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47381 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2ASQNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:13:49 -0500
MIME-Version: 1.0
In-Reply-To: <20120119160113.GN7180@jl-vm1.vm.bytemark.co.uk>
References: <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <CAObL_7FsNQaPQg-3=AO9RuMNZZsRgDSJYPhPevDKERws9vQJWg@mail.gmail.com> <20120119160113.GN7180@jl-vm1.vm.bytemark.co.uk>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 19 Jan 2012 08:13:27 -0800
X-Google-Sender-Auth: dwzFG6iFOJL-uuzVWtVzu2pvF9U
Message-ID: <CAObL_7HwZDPeYe_T36zUMw+FA8x6DJX8Jzh59iuWXQLdktpR+Q@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Jamie Lokier <jamie@shareable.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 8:01 AM, Jamie Lokier <jamie@shareable.org> wrote:
> Andrew Lutomirski wrote:
>> It's reasonable, obvious, and even more wrong than it appears.  On
>> Xen, there's an extra 64-bit GDT entry, and it gets used by default.
>> (I got bitten by this in some iteration of the vsyscall emulation
>> patches -- see user_64bit_mode for the correct and
>> unusable-from-user-mode way to do this.)
>
> Here it is:
>
>        static inline bool user_64bit_mode(struct pt_regs *regs)
>        {
>        #ifndef CONFIG_PARAVIRT
>                /*
>                 * On non-paravirt systems, this is the only long mode CPL 3
>                 * selector.  We do not allow long mode selectors in the LDT.
>                 */
>                return regs->cs == __USER_CS;
>        #else
>                /* Headers are too twisted for this to go in paravirt.h. */
>                return regs->cs == __USER_CS || regs->cs == pv_info.extra_user_64bit_cs;
>        #endif
>        }
>
> Perhaps userspace can do that.
> Would it be right for a ptracer to say:
>
>   CS == 0x23 -> 32-bit
>   (CS & 4)   -> 32-bit (LDT, "we do not allow long mode selectors in the LDT")
>   else       -> 64-bit (__USER_CS or some other GDT entry which must be pv_info's)
>
> I.e. assume that no other *GDT* CS values are available to userspace?
> There are other 32-bit GDT entries, but are they not all for data or kernel use only?

I suspect not.  asm/xen/interface_64.h has:

#define FLAT_RING3_CS32 0xe023  /* GDT index 260 */
#define FLAT_RING3_CS64 0xe033  /* GDT index 261 */
#define FLAT_RING3_DS32 0xe02b  /* GDT index 262 */
#define FLAT_RING3_DS64 0x0000  /* NULL selector */
#define FLAT_RING3_SS32 0xe02b  /* GDT index 262 */
#define FLAT_RING3_SS64 0xe02b  /* GDT index 262 */

which sounds like there's an extra 32-bit selector as well.  I haven't
checked, though.

--Andy
