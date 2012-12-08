Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2LHXh5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 18:37:57 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61858 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab2LHXh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 18:37:56 -0500
MIME-Version: 1.0
In-Reply-To: <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
References: <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
 <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com>
 <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com>
 <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com>
 <20121204135445.GA7420@mail.hallyn.com> <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap> <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com> <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
 <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com> <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 8 Dec 2012 15:37:35 -0800
Message-ID: <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 8, 2012 at 2:33 PM, Andrew G. Morgan <morgan@kernel.org> wrote:
> On Fri, Dec 7, 2012 at 10:39 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> It breaks down because, currently, users with nonzero pI have no
>> direct ability to wield the capabilities.  That means that every
>> single binary with fI bits set needs to be as careful as a setuid-root
>> binary to avoid leaking privilege to the caller.  (Obviously, binaries
>> with fP set need to be careful.  IMO binaries with only fI set should
>> not need to exercise any particular care to defend themselves from
>> their callers.)
>
> True. But what about protecting the system from privileges they didn't
> expect to have?

I don't really understand.  If I call rm -rf /, expect it to do
nothing, but I inadvertently had CAP_DAC_OVERRIDE and passed it on,
then I just shot myself in the foot.  I don't see what this has to do
with access control.

>
>> I'm obviously missing some fundamental (and probably historical) issue
>> here, so let me ask the following straw-man question.  Suppose
>> capabilities worked like this on exec:
>>
>> pP' = pI | (fP & pB)  (i.e. the current way, except that fI always has
>> all bits set for every binary on the system)
>> pI' = pI (unless !SECURE_NOROOT and uid == 0 or euid == 0, in which
>> case pI' = pP')
>>
>> with the added restriction that pI is always a subset of pP (i.e.
>> dropping a bit from pP (on exec or otherwise) drops that bit from pI).
>>
>> What would be wrong with this model?  (Let's pretend for now that
>> capabilities had always worked this way, so there's no change of
>> behavior to worry about.)
>>
>>  - The sendmail capability bug wouldn't happen: pI has no effect on
>> setuid-root binaries.
>
> Are you saying that setuid-root is required for a program like
> sendmail to work? Forever?

No.

If anyone writes a modern program like sendmail, it would be
capability-aware and it wouldn't have the same problem.  (And
presumably it wouldn't use setuid(2), which is terminally broken.)

>
>>  - There would be no difference between a user being trusted with a
>> capability and being inh-trusted with that capability, since the
>> latter concept wouldn't really exist.
>
> See below. It's key to see that it is not people, but programs that
> require privilege.

It may be key, but I am completely unconvinced that this is the right
model.  Windows has a capability system (called privileges, not
capabilities) with full inheritance and no per-binary anything.  It's
worked just fine for decades, and it is completely immune to
sendmail-like bugs because it *does not have* any concept of
privileged binaries.  It may have a classic MS-style overcomplicated
APIs, but the model is quite simple and easy to understand.

> I think you have correctly determined a key difference (a fundamental
> feature!) of the model.
>
> For an explanation, please search for "key insight" in the OLS paper:
>
>   http://ols.fedoraproject.org/OLS/Reprints-2008/hallyn-reprint.pdf
>
> Also, see p310+ of the first document linked to on the page Casey pointed to:
>
>   http://wt.tuxomania.net/publications/posix.1e/download.html
>
> which has quite an elaborate explanation of how this model was
> designed, and what the authors were trying to achieve.

I read the "key insight", although I admit that I gave up before I
found page 310 of the old POSIX draft.  (Why is the rationale nowhere
near the beginning?  I still can't figure out what the default value
of fI is.*)  I see no justification for *why* the authors were trying
to achieve that.

Again (any mainly because I feel like there's a giant mental
disconnect here in that I really don't understand wtf the current /
POSIX system is trying to accomplish): what would be wrong with a
model in which capabilities could be freely passed from parent to
child?  Why would it be insecure?  Why would it be error-prone?
There's got to be *some* reason why it's not in use right now.

I can speculate as to the reason the current scheme is barely used
except internally to a few daemons (and why AFAIK there is no one
making serious use of fI): it's basically incomprehensible.  Security
systems should be simple enough to understand and analyze.  "Here is
the set of things that I and my descendants can do" (the Windows
model) is simple.  "Here is the set of things I can do (pP).  Here is
a different set of things that a certain class of my descendants can
do (pI).  Here is the class of descendants that can do those things
(fI).  And here's a different class of descendants that can do things
no matter who invokes them (fP)." is really hard to understand.

It's especially bad because granting CAP_DAC_READ_SEARCH to user "foo"
doesn't mean anything.  Is he authorized to back things up to
encrypted storage?  Is he authorized to read any file for any purpose?
 Is he authorized to read things on behalf of properly authenticated
remote users?  No one knows because it depends entirely on what set of
binaries with CAP_DAC_READ_SEARCH=i he can find.

* I see "If pathconf() indicates that {_POSIX_CAP_PRESENT} is not in
effect for a file, then the capability state of that file shall be
implementation defined."  I think this means that the designers didn't
actually decide whether fI should default to all zeros or all ones.


--Andy
