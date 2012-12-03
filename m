Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab2LCEs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 23:48:27 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58431 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2LCEsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 23:48:25 -0500
MIME-Version: 1.0
In-Reply-To: <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com>
References: <CALCETrVQxPDfU83-LUWrf330wOBbSsMvKdFXMR3CL4LmDvyfMw@mail.gmail.com>
 <CALQRfL67LX5owxo=SMuRNAm1Jds53zY-moLpXE=wCTF4Epu4_w@mail.gmail.com>
 <CALCETrXyX2aYjbLRCpzp-h_CXBb=K7OWkO1b+tVTRz9LQQOzdQ@mail.gmail.com>
 <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
 <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com> <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 2 Dec 2012 20:48:03 -0800
Message-ID: <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com>
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

On Sun, Dec 2, 2012 at 6:20 PM, Andrew G. Morgan <morgan@kernel.org> wrote:
> On Sun, Dec 2, 2012 at 3:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Sun, Dec 2, 2012 at 2:26 PM, Andrew G. Morgan <morgan@kernel.org> wrote:
>>> On Sun, Dec 2, 2012 at 10:35 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> On Sun, Dec 2, 2012 at 9:21 AM, Andrew G. Morgan <morgan@kernel.org> wrote:
>>>>> There is a fairly well written paper ;-) explaining how things are
>>>>> supposed to work:
>>>>>
>>>>>   http://ols.fedoraproject.org/OLS/Reprints-2008/hallyn-reprint.pdf
>>>>>
>>>>> The inheritable set is not intended to work the way you seem to want.
>>>>> Naive inheritance like that is quite explicitly the opposite of what
>>>>> was designed.
>>>>
>>>> I'm aware that the system was designed, or perhaps evolved, to prevent
>>>> users with uid != 0 from inheriting capabilities unless vfs
>>>> inheritable caps are granted on a per-file basis.  I want a way around
>>>> that -- I want to mix non-root, capabilities, and exec.  This is damn
>>>> near impossible right now if I don't have CAP_SETFCAP or root's
>>>> explicit, per-program cooperation.  CAP_SETFCAP is essentially
>>>> equivalent to "let me do anything".
>>>>
>>>> As it stands, using something like pam_cap to grant a user cap_net_raw
>>>> is useless -- that user can't use the privilege because (unless uid ==
>>>> 0) the privilege will never end up in the permitted set.
>>>
>>> Have you tried adding fI of cap_net_raw to the file to be executed?
>>
>> Yes, and it works.  I don't like this solution because:
>>
>> a) It doesn't scale in terms of sysadmin resources required.
>
> By doesn't scale, you mean it requires the admin to define which
> actual binaries on their system can wield privilege?

Yes.

>>
>> c) tcpdump isn't really special.  I trust this user account with
>> cap_net_raw, and that should be all the configuration I need.
>
> But this is a statement about access control, and not a statement
> about privilege. You trust the user to invoke something that can do
> tcpdump, you don't really trust the user to generate arbitrary packets
> on the network.

That *really* doesn't scale.  Suppose I trust one user to capture
packets and a second user to run portscans.  Setting tcpdump and nmap
as cap_net_raw+i and granting both users cap_net_raw (inheritable)
doesn't do it.  (Even ignoring the possibility of bugs in tcpdump and
nmap.)

In the immediate case that prompted this question, I only really trust
the user to run tcpdump, although I don't particularly care if they
generate arbitrary packets.  For simplicity, if I could use full
capability inheritance, I'd probably just grant cap_net_raw and be
done with it.  In this case, though, I have a helper that's ~50 lines
of code that has cap_net_raw=p.  It checks that it's happy about
what's going on, it does some apparmor twiddling (sigh), and it
execve's /usr/sbin/tcpdump.  And it only works because I set tcpdump
as cap_net_raw+i.

The ability to run helper programs is *useful*.  I find it rather
limiting that privileged programs that don't have uid=0 can't really
do it without administrative help.

>
>> d) If I really wanted, I could emulate execve without actually doing
>> execve, and capabilities would be inherited.
>
> If you could modify the executable properties of the binary that has
> the privilege to wield a privilege then you are either exploiting an
> app bug, or doing something the privileged binary has been trusted to
> do.

That's not what I mean.  I would:

fork()
munmap everything
mmap ld.so
set up a fake initial stack and the right fd or mapping or whatever
just to ld-linux.so

That's almost execve, and privilege inheritance works.

>
>> The issue with allowing real capability inheritance is that,
>> currently, it's safe for a program with fP != 0 to add an inheritable
>> capability and then execve something caller-controlled.  I don't know
>> whether anything actually does this, but it's hard to prove that
>> nothing does.  Hence my idea of requiring no_new_privs to make
>> capabilities inheritable.
>
> Assuming this is not another app bug, and that's what the executable
> with fP != 0 does, then that's why it was given fP != 0 - its what the
> program was designed to do. Why is this an issue?
>
>> An alternative, and considerably more intrusive, change would be to
>> add a fourth mask of genuinely inheritable capabilities.
>
> If you believe that you want to give a user the privilege to grant a
> privilege to an arbitrary binary to do things like this, why not write
> an app that adds file capabilities to target binaries owned by the
> user? You can make it execute-only by said user and let them do
> whatever they want. This requires no kernel changes.

Egads.  IMO that's way scarier.  I'd rather just mark ld.so as <everything>=i.

My point about no_new_privs is: if I trust a user or a program with a
capability, I probably also trust it to invoke helpers (via execve) as
it sees fit.  What I don't trust is everything else on the system that
has fP or set[ug]id bits set -- they probably weren't written to
anticipate inheritable capabilities and something like the sendmail
bug might happen again.  With no_new_privs set, though, that whole
vulnerability surface is gone -- the fP bits, setuid, and setgid are
inoperable.

--Andy
