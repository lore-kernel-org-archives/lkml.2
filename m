Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2LBXEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 18:04:41 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37341 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2LBXEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 18:04:39 -0500
MIME-Version: 1.0
In-Reply-To: <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
References: <CALCETrVQxPDfU83-LUWrf330wOBbSsMvKdFXMR3CL4LmDvyfMw@mail.gmail.com>
 <CALQRfL67LX5owxo=SMuRNAm1Jds53zY-moLpXE=wCTF4Epu4_w@mail.gmail.com>
 <CALCETrXyX2aYjbLRCpzp-h_CXBb=K7OWkO1b+tVTRz9LQQOzdQ@mail.gmail.com> <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 2 Dec 2012 15:04:18 -0800
Message-ID: <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 2, 2012 at 2:26 PM, Andrew G. Morgan <morgan@kernel.org> wrote:
> On Sun, Dec 2, 2012 at 10:35 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Sun, Dec 2, 2012 at 9:21 AM, Andrew G. Morgan <morgan@kernel.org> wrote:
>>> There is a fairly well written paper ;-) explaining how things are
>>> supposed to work:
>>>
>>>   http://ols.fedoraproject.org/OLS/Reprints-2008/hallyn-reprint.pdf
>>>
>>> The inheritable set is not intended to work the way you seem to want.
>>> Naive inheritance like that is quite explicitly the opposite of what
>>> was designed.
>>
>> I'm aware that the system was designed, or perhaps evolved, to prevent
>> users with uid != 0 from inheriting capabilities unless vfs
>> inheritable caps are granted on a per-file basis.  I want a way around
>> that -- I want to mix non-root, capabilities, and exec.  This is damn
>> near impossible right now if I don't have CAP_SETFCAP or root's
>> explicit, per-program cooperation.  CAP_SETFCAP is essentially
>> equivalent to "let me do anything".
>>
>> As it stands, using something like pam_cap to grant a user cap_net_raw
>> is useless -- that user can't use the privilege because (unless uid ==
>> 0) the privilege will never end up in the permitted set.
>
> Have you tried adding fI of cap_net_raw to the file to be executed?

Yes, and it works.  I don't like this solution because:

a) It doesn't scale in terms of sysadmin resources required.

b) It adds no real security over real inheritable capabilities.  I'd
be rather surprised if tcpdump does not have any bugs that would allow
me to subvert it to recover its inherited capabilities.  For example,
it drops privileges like this:

                if (setgid(getgid()) != 0 || setuid(getuid()) != 0 )
                        fprintf(stderr, "Warning: setgid/setuid failed !\n");

This is buggy for at least two reasons: it doesn't abort on error and
setuid doesn't actually drop capabilities when uid 0 isn't involved.

c) tcpdump isn't really special.  I trust this user account with
cap_net_raw, and that should be all the configuration I need.

d) If I really wanted, I could emulate execve without actually doing
execve, and capabilities would be inherited.


The issue with allowing real capability inheritance is that,
currently, it's safe for a program with fP != 0 to add an inheritable
capability and then execve something caller-controlled.  I don't know
whether anything actually does this, but it's hard to prove that
nothing does.  Hence my idea of requiring no_new_privs to make
capabilities inheritable.

An alternative, and considerably more intrusive, change would be to
add a fourth mask of genuinely inheritable capabilities.

--Andy
