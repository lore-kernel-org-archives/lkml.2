Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab2LJTz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:55:57 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61905 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab2LJTzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:55:54 -0500
MIME-Version: 1.0
In-Reply-To: <50C63D4C.9060703@schaufler-ca.com>
References: <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap> <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com> <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
 <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
 <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
 <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com>
 <20121210145950.GC8137@sergelap> <50C603F8.6070401@schaufler-ca.com>
 <CALCETrWNboHVRm_aZ-Fvqri6PW3C4FPfuLLe3-8q7+-vgEP2nw@mail.gmail.com>
 <50C6345C.8040804@schaufler-ca.com> <CALCETrUctrxm5Vy2WYXaQy3CyyJOGAQ78LYHbLzv+ua_rGxMDA@mail.gmail.com>
 <50C63D4C.9060703@schaufler-ca.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Dec 2012 11:55:33 -0800
Message-ID: <CALCETrXRuARVzBsdDufYUaJcp6Ta80WWb5nBuk_sATk52PgoTw@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:51 AM, Casey Schaufler
<casey@schaufler-ca.com> wrote:
> On 12/10/2012 11:31 AM, Andy Lutomirski wrote:
>> On Mon, Dec 10, 2012 at 11:13 AM, Casey Schaufler
>> <casey@schaufler-ca.com> wrote:
>>> On 12/10/2012 10:12 AM, Andy Lutomirski wrote:
>>>> I think that the Windows approach is worth looking at.  See here:
>>>>
>>>> http://msdn.microsoft.com/en-us/library/windows/desktop/aa375202%28v=vs.85%29.aspx
>>>>
>>>> In the Windows model, each capability ("privilege") can be in one of
>>>> three states: enabled (i.e working right now),
>>> Effective
>>>
>>>>  permitted (i.e.
>>>> available upon request but not currently enabled),
>>> Permitted
>>>
>>>> or removed
>>>> (disallowed to this process and all of its children).
>>> ~Inherited
>> No.  It's ~Inherited in a world where every binary has fI = everything.
>>
>>>> Permitted
>>>> privileges are always inherited when a child process is created.
>>>>
>>>> This is *way* simpler than Linux's model, and it works just fine*.
>>> I see a different set of complications, and Windows never had
>>> a setuid bit to contend with. God created the universe in seven
>>> days, but then, He didn't have an installed base.
>>>
>> What are those complications?
>
> I wish I had the time to go into the details, but I just can't.

Um.

I'd like to solve what appears to me to be a problem.  There's an
existing design that, from my perspective, is overcomplicated and
doesn't actually do what I want it to do.  I'd really like to know
what the current design *does* accomplish, since then I can make far
more informed proposals for how to fix it.

So far, I know of exactly nothing useful that's accomplished by the
current design.  It would be great if someone would enlighten me.

>
>> Also, I think we really could get rid of setuid without breaking
>> anything with a bit of extra (non-capability-related) plumbing work.
>
> If RedHat or Ubuntu wanted to take a year off from everything else
> they could create a setuid-root free system. It would probably be
> easier for Android or ChromiumOS, as they provide more limited
> environments.
>
> It's not "a bit of extra plumbing". I did it for a Unix system and
> you'll have to change bunches of existing programs to make it work.
> I'm not saying that the changes would be bad, but the sendmail
> fiasco arose from just such an effort. You'll also have to train
> the users that sudo no longer does them any good. In fact, you'll
> be barraged with one question:
>         "How do I get to be Real root"?
>

That's not what I'm talking about.

Write a daemon.  Rig up wrappers for each setuid program to instead
call into that daemon and have that daemon invoke the privileged
program on behalf of the caller, with a sanitized environment.  Be
annoyed by a few items on the "linux plumber's wish list" that make
this rather difficult right now.

sudo would give real root, just like it does today.  No setuid bit needed.

--Andy
