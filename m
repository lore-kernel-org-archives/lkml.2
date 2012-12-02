Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2LBRVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 12:21:44 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:54176 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2LBRVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 12:21:43 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrVQxPDfU83-LUWrf330wOBbSsMvKdFXMR3CL4LmDvyfMw@mail.gmail.com>
References: <CALCETrVQxPDfU83-LUWrf330wOBbSsMvKdFXMR3CL4LmDvyfMw@mail.gmail.com>
Date: Sun, 2 Dec 2012 09:21:41 -0800
X-Google-Sender-Auth: BSoEs7tOzvbdpbPSRDsz7jv6qDc
Message-ID: <CALQRfL67LX5owxo=SMuRNAm1Jds53zY-moLpXE=wCTF4Epu4_w@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a fairly well written paper ;-) explaining how things are
supposed to work:

  http://ols.fedoraproject.org/OLS/Reprints-2008/hallyn-reprint.pdf

The inheritable set is not intended to work the way you seem to want.
Naive inheritance like that is quite explicitly the opposite of what
was designed.

Cheers

Andrew

On Sat, Dec 1, 2012 at 7:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> I'd like to be able to run programs (like bash!) as nonroot but with
> some capabilities granted.  After all these years, it's almost, but
> not quite, possible.  This is because the transition rule (if root
> isn't involved or NOROOT is set) is pP' = (pB' & fP) | (pI' & fI),
> and, when execing a program without vfs caps set, fI = 0.  I want to
> set PR_SET_KEEPCAPS, setuid away from root, set some capability as
> inheritable, and exec something.  That capability stays inheritable,
> but it doesn't end up permitted.  Oops.
>
> (There's another alarming thing that happens -- programs end up with
> capability bits that are inheritable but not permitted.  I'd like to
> change cap_bprm_set_creds to clear all inheritable bits that don't end
> up in the final permitted set to minimize confusion.  Of course, this
> *could* (but seems unlikely to) trigger security bugs.)
>
> The obvious but scary fix is to make everything act like fI = <all
> caps> if vfs caps aren't set.  It's not immediately obvious why this
> would be bad: no task has any inheritable capabilities by default.
> Something like the sendmail bug is unlikely here -- this change would
> give *more* caps, not fewer, and it could be done in such a way that
> setuid binaries don't inherit caps.
>
> A less scary way would be to make it opt-in: set a securebit if you
> want default capability inheritance.  This requires CAP_SETPCAP, which
> seems to be shorthand for "allow me to shoot myself in the foot".
> Sensible programs might set no_new_privs when they set this securebit.
>
> An even less scary way would be to require a new securebit *and* no_new_privs.
>
> Any suggestions?  I'm happy to write patches, but I'd rather not cook
> up ten patches and have this get stuck in limbo for years.
>
> For some rationale: I want to write a program that has cap_net_raw
> permitted as a file capability.  That program will do some checks and
> then invoke tcpdump.  I can't do this: tcpdump can't inherit
> capabilities into its permitted set unless I set the cap_net_raw
> inheritable bit on it.
>
> --Andy
>
> P.S. The get_file_caps code is gross.  Whatever the outcome of this
> discussion, I'll submit a patch to clean it up, and I'll probably add
> a file to Documentation/security for good measure.
