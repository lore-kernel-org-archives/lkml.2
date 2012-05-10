Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab2EJGWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:22:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48560 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab2EJGWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:22:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxjq_zEVWVQ9dTm6gjozVZXTYbnciUiPdBsr7g3RSBWwg@mail.gmail.com>
References: <CAHo-OoxRj-sP1Tcy3oJ7DE3BOGSTnsWHZ5Q3hdmnK8A5jfjFcQ@mail.gmail.com>
	<CA+55aFzY+W3ECUnyvqU_Su8_2TFqYj-K7U40KZaoe61oDUGdxw@mail.gmail.com>
	<CAHo-OoxwSNFVCvdBxnMruKMebMW37NLX7eOKkLx=R7cSkhknGw@mail.gmail.com>
	<CA+55aFyrSNTh3B7L=Lq1L_Hz=0NEPC95TWmo2-W9odKi+80XJg@mail.gmail.com>
	<CAHo-OowjvXat8dZOpp50GO_KSTYBy_Wa96wvFUfTXmua3oBrUw@mail.gmail.com>
	<CA+55aFyXP8PRusYYrpAnFfV=eL69ktfQfiGxAH1B-Ds8HH+bJQ@mail.gmail.com>
	<CAHo-Ooyr=ugLDv6gSVTn_N0tb79BtgWGU87MrtVY9UF-ch9YCw@mail.gmail.com>
	<CA+55aFxN9QoJ_NTzeU+tPa-gJvHBQ5Oa5O0Ko95-iaNh5XCUGw@mail.gmail.com>
	<CA+55aFxjq_zEVWVQ9dTm6gjozVZXTYbnciUiPdBsr7g3RSBWwg@mail.gmail.com>
Date: Wed, 9 May 2012 23:22:39 -0700
Message-ID: <CAHo-OoxhKfyG_DVZnCMg=GZ47-qre5DVjSHMDza1UG0EjL41pg@mail.gmail.com>
Subject: Re: setuid and RLIMIT_NPROC and 3.1+
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 6:13 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Oh christ, I also cannot be bothered to continue arguing with you
> since you seemingly randomly drop other people from the discussion.

Sorry, that was a mail client misconfiguration, I was used to 'reply
all' instead of 'reply' being the default - something must have
changed recently.
I noticed and fixed it, but I had failed to notice that this email
also went out only to you.
Once again very sorry.

>>> If you return EAGAIN from setuid, because we've run into the hard
>>> limit, and userspace doesn't check it, then the exec will still
>>> succeed, and we'll end up running the exec'ed code as root.
>>
>> But how would that happen in practice, and why would we care?
>>
>> If the application is buggy, it won't check the setuid() error return,
>> but if it does the exec, it will fail.
>>
>> Only a buggy *and*malicious* application that *first* does non-exec
>> cases up until it hits the hard limit and *then* tries to do a buggy
>> setuid() - without testing the error value - and exec() would care.

There is no guarantee that the soft and hard walls aren't identical
(indeed setting them both to 1 or some other small number seems very
normal) - perhaps the soft limit check in your proposed patch should
be first.
They may also simply be very close to each other [multiple "fork,
setuid, execve" happening in parallel], or that the processes get used
up by someone else using that uid (whose rlimit nproc is higher, this
is a per-process not system-wide setting after all), or that an app
has cases were it setuid's without execing, and other places where it
setuid's with execing.

I agree that with the exception of hard==soft nproc rlimit, the rest
are probably relatively unlikely.
Userspace can increase soft limit to hard, so soft isn't really a
limit, as such anyone that wants to truly limit, will set
soft==hard==minimum value that works.

>> But we don't care about applications that *try* to be actively buggy.
>>
>> That simply isn't the interesting case. The point of the whole "return
>> error at execve()" was not to discourage the actively buggy usage
>> case, but the *accidentally* buggy case. And there's no sane way the
>> accidentally buggy case can trigger what you describe.

It doesn't discourage, because the setuid can no longer fail, so there
is no longer a point to checking it.
It almost actively encourages you to not check the setuid return code
(if you are root), since there's now even less of a point to checking
it.

>> So the whole point wasn't that it "fixes" buggy applications (they
>> are, after all, buggy), but that it makes it less likely to have
>> accidental problems. It's a "softer" edge to some bugs.

Yes, I agree with the sentiment.  It would be nice to both be correct
and somehow work-around/fix buggy apps.

Other possible approaches:
(a) fail the setuid system call, but set a magic flag (which clears on
a successful setuid), flag causes exec to fail.  This fixes the
fork/setuid/exec case, while not breaking those that expect setuid to
return the failure, while still being potentially insecure (for buggy
apps) in the fork/setuid/no-exec case.

This would basically be:
        if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
                        new_user != INIT_USER) {
                current->flags |= PF_NPROC_EXCEEDED;
                free_uid(new_user);
                return -EAGAIN;
        } else {
                current->flags &= ~PF_NPROC_EXCEEDED;
        }

(and exec would *NOT* recheck the rlimit, since the uid wasn't
changed, and rechecking the limit would now be outright wrong)

(b) have the setuid call change uid, set a a magic flag, but still
return failure, flag causes exec to fail

This also fixes buggy setuid/no-exec apps, but has funky syntax, and
could result in apps that do check setuid to be broken (since setuid
could now change the uid while appearing to fail and thus you could
lose privileges when not expecting to)

>> That said, I don't really care that much about the original patch
>> either. For all I care, we could revert it. I just simply don't
>> understand the point of your objections.

Would you accept a patch to do (a) from above?
