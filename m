Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab1HVCel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 22:34:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58064 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1HVCej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 22:34:39 -0400
Message-ID: <4E51C026.7000702@zytor.com>
Date: Sun, 21 Aug 2011 19:34:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: SYSCALL, ptrace and syscall restart breakages (Re: [RFC] weird
 crap with vdso on uml/i386)
References: <20110821063443.GH2203@ZenIV.linux.org.uk> <20110821084230.GI2203@ZenIV.linux.org.uk> <CAObL_7GXyzAzNjBtgye9BwXLyHm337oBTdjRDjbSPqoKZGWyyA@mail.gmail.com> <20110821144352.GJ2203@ZenIV.linux.org.uk> <20110821164124.GL2203@ZenIV.linux.org.uk> <CAObL_7E1vU8+0UQST6Smf9j40TckTzB=QdY0AuAWo4AX6cs2xg@mail.gmail.com> <20110822011645.GM2203@ZenIV.linux.org.uk> <CA+55aFz1jCZGcQ-c6uGN=k8nKDuGoz5g8e+pxpYAg4X_p7=5Mw@mail.gmail.com> <4E51B56F.3080301@zytor.com> <CAObL_7HLDD=FVSN58W7a0g0R--8x7OVrQVCBxWD1DirVZxRn2w@mail.gmail.com> <20110822020737.GP2203@ZenIV.linux.org.uk> <CAObL_7HY7qFUoqtNju42=BHTR8WuuW-cL_cQh_uUfx_7gFfHRg@mail.gmail.com>
In-Reply-To: <CAObL_7HY7qFUoqtNju42=BHTR8WuuW-cL_cQh_uUfx_7gFfHRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2011 07:26 PM, Andrew Lutomirski wrote:
> 
> Which still leaves the question of how to fix it.  Restarting via an
> int 0x80-based helper might be the only option that leaves everything
> fully functional.
> 

The issue is that we don't represent the entire state ... we represent
only one metalevel of it, currently the "cooked" one.  The problem is
that we need the "raw" one as well, and in order to have *both* we need
to know the entry mechanism.

We need that IN EITHER CASE.

This is reasonably straightforward... we can carry the entry mechanism
forward inside the kernel, and fix it up in the IRET path.

The *really* big issue is what we drop as the sigcontext since this is
an ABI carried out to userspace.  We could just say "it's currently
totally broken for SYSCALL" and just change it to drop the raw state,
but which has the potential for breaking unknown programs, *or* we could
add a bit of state (presumably by reclaiming one of the padding fields
around cs and ss) ... which *also* has the potential for breaking programs.

Right now, SYSCALL -> signal -> restart *is broken*, however, so there
is also the option of just doing nothing in this case, I guess.
	
	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
