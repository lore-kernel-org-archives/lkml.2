Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493Ab2EJAtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:49:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53531 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab2EJAt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:49:29 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyXP8PRusYYrpAnFfV=eL69ktfQfiGxAH1B-Ds8HH+bJQ@mail.gmail.com>
References: <CAHo-OoxRj-sP1Tcy3oJ7DE3BOGSTnsWHZ5Q3hdmnK8A5jfjFcQ@mail.gmail.com>
	<CA+55aFzY+W3ECUnyvqU_Su8_2TFqYj-K7U40KZaoe61oDUGdxw@mail.gmail.com>
	<CAHo-OoxwSNFVCvdBxnMruKMebMW37NLX7eOKkLx=R7cSkhknGw@mail.gmail.com>
	<CA+55aFyrSNTh3B7L=Lq1L_Hz=0NEPC95TWmo2-W9odKi+80XJg@mail.gmail.com>
	<CAHo-OowjvXat8dZOpp50GO_KSTYBy_Wa96wvFUfTXmua3oBrUw@mail.gmail.com>
	<CA+55aFyXP8PRusYYrpAnFfV=eL69ktfQfiGxAH1B-Ds8HH+bJQ@mail.gmail.com>
Date: Wed, 9 May 2012 17:49:28 -0700
Message-ID: <CAHo-Ooxj1u3Qyjxrk4yWRG_65_sMB1f4L-bJGPPPS=2tzpNqRg@mail.gmail.com>
Subject: Re: setuid and RLIMIT_NPROC and 3.1+
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, those bggy apps have to be really *odd* buggy apps now. IOW,
> they need to do setuid(), and then not execve(). At that point, they
> really do have to check the error return, since there is no execve()
> for them to check.
>
> In the end, we can do only so much to counter buggy apps. I think my
> patch is a reasonable "we can try to give the error at execve() time,
> but if somebody does tons of setuid() without ever doing the execve(),
> at some point they do have to check the error return of setuid()
> itself".
>
> I suspect most users of setuid() are good and check the error return.

If you return EAGAIN from setuid, because we've run into the hard
limit, and userspace doesn't check it, then the exec will still
succeed, and we'll end up running the exec'ed code as root.
Which re-introduces the same bug this was trying to fix.  At that
point we might as well just revert the 3.1 commit.

(what if soft and hard nproc limits are the same? then it's always
EAGAIN, so the bug is always reintroduced)

In my opinion the buggy apps should be fixed and the 3.1 commit should
be reverted both in upcoming 3.4 and in stable 3.1/3.2/3.3.
