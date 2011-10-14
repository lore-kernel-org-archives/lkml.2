Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1JNGa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 02:30:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63015 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab1JNGaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 02:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzoDi-WP-2Uq-33FAGfMPZbrsvg6_QWEKm1zczET539PQ@mail.gmail.com>
References: <CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
 <CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
 <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
 <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com>
 <CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com>
 <CA+55aFyskjs9qPkoFom16veQXy5a-beWF95A7mCFexqanRiiKQ@mail.gmail.com>
 <CAObL_7HUhxsOVHYFovgxYu7r5YNju+n4Q45GZ9viCCW-GrxWhg@mail.gmail.com>
 <CAFLxGvx0QMrvG_ZsFE6C_xHn9JpWJ-aW-V=K9pm3OoXZc=NKxQ@mail.gmail.com>
 <20111010114840.GC17079@elte.hu> <CAObL_7EykEi0OkKMj=iZ=A=acyiOPqx-CbUJMu=rVrvyUN8seQ@mail.gmail.com>
 <20111011062253.GA3589@elte.hu> <4E947BC9.7040805@mit.edu>
 <CA+55aFyMXgzywjXCtS1a5F-BDu_XP4ecg3Tw7zLuawZs0QNYaw@mail.gmail.com>
 <CAObL_7HYnDVUyLA=FQ-qmuh=J=H=JOQTBMP_wt_zwzOfe9-7Hg@mail.gmail.com> <CA+55aFzoDi-WP-2Uq-33FAGfMPZbrsvg6_QWEKm1zczET539PQ@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 13 Oct 2011 23:30:00 -0700
X-Google-Sender-Auth: o9ViDaGwuNTh23ocJy7Pg7sLbVY
Message-ID: <CAObL_7ED+qwOgSH+WsLXvZqC83MX1Q-_1NtcgH-cPe9ghLveZg@mail.gmail.com>
Subject: Re: [RFC] fixing the UML failure root cause
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 9:46 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Oct 13, 2011 at 8:40 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>
>> How does that work?  The tricky case is when one of those three words
>> spans a page boundary if the access to the first page is valid, but
>> the access to the second page is not.  When that happens, if we report
>> the fault as coming from the first page, then UML is likely to get
>> think the fault was spurious and enter an infinite loop.
>
> Hmm. Gaah, I just find that memcpy loop disgusting.
>

Yeah, it's not pretty.

> We already have that ugly "uaccess_error" crap in handle_exception(),
> we might as well do something like the attached and just say "hey, now
> you can catch the page fault information for a get_user/put_user
> fault".
>
> Isn't that much nicer?

I actually tried this.  To really get it right, though, I also need to
either hook the access_ok failure paths (either every single one or
just the ones that matter for those three syscalls, which could be
fragile) or to check access_ok separately in the vsyscall emulation
code.  This also takes up 16 bytes of stack just to support a corner
case of a legacy code path.

Another idea is to have a flag that asks the fault handlers to call
force_sig_info for us.  That's just one bit of per-thread state.  Then
the vsyscall emulation code could check access_ok, force a signal if
access is not ok, then set the flag and do the syscall.  And maybe
some processes would want to opt in to that mode anyway -- arguably
EFAULT is a serious programmer error and should be dealt with more
harshly than other syscall misuses.

Admittedly, UML probably doesn't care about recovering vgettimeofday
pointed at kernel space...

--Andy
