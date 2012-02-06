Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab2BFRGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:06:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57951 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab2BFRGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:06:17 -0500
Message-ID: <4F3007AD.50307@zytor.com>
Date: Mon, 06 Feb 2012 09:02:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
References: <20120116183730.GB21112@redhat.com>    <CAObL_7E1gtDF8Bjb9vmFFkVFmxWbx4DrgGU0QPJEd6KXgS7U8A@mail.gmail.com>    <20120117170512.GB17070@redhat.com>    <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>    <20120118015013.GR11715@one.firstfloor.org>    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>    <20120118022217.GS11715@one.firstfloor.org>    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>    <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com> <dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>
In-Reply-To: <dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 12:32 AM, Indan Zupancic wrote:
> 
> It seems that just using eflags is a lot simpler than the alternatives,
> let's just go for it.
> 
> 
> I propose using bits somewhere in the middle of the upper half. If new
> flags are ever added by Intel or AMD, they will use the lower bits. If
> anyone else ever adds flags, they most likely add them to the top (VIA).
> So the middle seems the safest spot as far as long-term maintenance goes.
> 
> The below version does that, but instead of setting one of the two bits,
> it always sets bit 50 for newer kernels and sets bit 51 if it's a compat
> system call. I find this version more readable and after compilation it's
> also a couple of bytes smaller compared to Linus' original version.
> 
> Should we make sure that the top 32 bits are zero, in case any weird
> hardware does set our bits?
> 

[Adding H.J. Lu, since he has run into some of these requirements before]

NAK in the extreme.

We have not heard back from the architecture people on this, and I will
NAK this unless that happens.

Furthermore, you're picking bits that do not work for 32 bits, EVEN
THOUGH WE HAVE A SIMILAR PROBLEM ON 32 BITS; I outlined it for you and
you chose to ignore it.

Finally, I think we actually are going to need a fair number of bits in
the end.  All of this points to using a new regset designed for
extension in the first place.

As far as I can tell, we need at least the following information:

- If the CPU is currently in 32- or 64-bit mode.
- If we are currently inside a system call, and if so if it was entered
  via:
	- SYSCALL64
	- INT 80
	- SYSCALL32
	- SYSENTER

  The reason we need this information is because for the various 32-bit
  entry points we do some very ugly swizzling of registers, which
  matters to a ptrace client which wants to modify system call
  arguments.
- If the process was started as a 64-bit process, i386 process or x32
  process.

This adds up to a minimum of six bits already (and at least two bits on
i386), and that's just a start.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

