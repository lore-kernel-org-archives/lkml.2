Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1JMIki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:40:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43095 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab1JMIkg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:40:36 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyMXgzywjXCtS1a5F-BDu_XP4ecg3Tw7zLuawZs0QNYaw@mail.gmail.com>
References: <CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
 <CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
 <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
 <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com>
 <CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com>
 <CA+55aFyskjs9qPkoFom16veQXy5a-beWF95A7mCFexqanRiiKQ@mail.gmail.com>
 <CAObL_7HUhxsOVHYFovgxYu7r5YNju+n4Q45GZ9viCCW-GrxWhg@mail.gmail.com>
 <CAFLxGvx0QMrvG_ZsFE6C_xHn9JpWJ-aW-V=K9pm3OoXZc=NKxQ@mail.gmail.com>
 <20111010114840.GC17079@elte.hu> <CAObL_7EykEi0OkKMj=iZ=A=acyiOPqx-CbUJMu=rVrvyUN8seQ@mail.gmail.com>
 <20111011062253.GA3589@elte.hu> <4E947BC9.7040805@mit.edu> <CA+55aFyMXgzywjXCtS1a5F-BDu_XP4ecg3Tw7zLuawZs0QNYaw@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 13 Oct 2011 01:40:16 -0700
X-Google-Sender-Auth: XGcx6VPrn9NV4akQydb1pufIVgc
Message-ID: <CAObL_7HYnDVUyLA=FQ-qmuh=J=H=JOQTBMP_wt_zwzOfe9-7Hg@mail.gmail.com>
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

On Wed, Oct 12, 2011 at 11:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Oct 12, 2011 at 5:24 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>>
>> So here's a different approach.  It's not perfect: it always blames
>> SEGV_MAPERR instead of SEGV_ACCERR.  I implemented it for vgettimeofday
>> but not the other two vsyscalls.
>>
>> What do you think of this approach?  If it seems good, I'll finish the
>> patch and submit it.
>
> I think the approach is valid, but you should *not* do this as some
> kind of crazy byte-by-byte copy_to_user() emulation.
>
> Do the "copy tz to user mode" as individual "put_user()" calls for
> tv_sec/tv_usec/timezone. IOW, there are three words being written to
> user mode, not "two memcpy's".

How does that work?  The tricky case is when one of those three words
spans a page boundary if the access to the first page is valid, but
the access to the second page is not.  When that happens, if we report
the fault as coming from the first page, then UML is likely to get
think the fault was spurious and enter an infinite loop.

To handle that case, I'll need 4- and 8- byte versions of put_user_sig
(IIRC vgetcpu uses unsigneds) that check whether their destinations
span page boundaries and complain accordingly, which will end up as
more code than I have now.

--Andy

>
> Other than that, there doesn't seem to be anything wrong.
>
>            Linus
>
