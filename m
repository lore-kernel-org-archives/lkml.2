Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2CLVoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 17:44:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47438 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab2CLVo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 17:44:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>,
        Stephen Wilson <wilsons@start.ca>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
	<m1pqchocok.fsf@fess.ebiederm.org> <20120312204416.GG10787@dztty>
Date: Mon, 12 Mar 2012 14:47:43 -0700
In-Reply-To: <20120312204416.GG10787@dztty> (Djalal Harouni's message of "Mon,
	12 Mar 2012 21:44:16 +0100")
Message-ID: <m11uoxij9c.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/grxdwpk4dl9Pha3AvYlrCt2uKycbUunU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: lkml.org]
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Djalal Harouni <tixxdz@opendz.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 0/9] proc: protect /proc/<pid>/* files across execve
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Djalal Harouni <tixxdz@opendz.org> writes:

> On Mon, Mar 12, 2012 at 12:13:15PM -0700, Eric W. Biederman wrote:
>> Djalal Harouni <tixxdz@opendz.org> writes:
>> 
>> > Procfs files and other important objects may contain sensitive information
>> > which must not be seen, inherited or processed across execve.
>> 
>> So I am dense.  /proc/<pid>/mem was special in that it uses a different
>> set of checks than other files, and to do those access checks
>> /proc/<pid>/mem needed to look at exec_id.
> If you are referring to the old protection, yes it was against an ID, but
> not uniq IDs, so you can execve a suid do some tricks to have a match on IDs
> and bypass the protection, how: by opening your /proc/self/mem and pass
> the fd to the exec suid who at read/write time will process its own
> /proc/self/mem

Yes that case is silly and I don't care.  I care that you seem to be
stomping all over the non-silly cases using the excuse that there
was one silly case.

>> For all of the access checks that are not written in that silly way.
>> What is wrong with ptrace_may_access run at every read/write of a file?
> As it was noted, these files change during runtime, so even if you do the
> ptrace check at each syscall (which is of course a good thing), you must be
> sure that you are doing the check on the right target and the processed
> file belongs really to the appropriate process image of the target.

The right target is by definition the current value of the process in
question.

/proc/<pid>/<attr> files are supposed to work after an exec.

Adding an exec_id to additional files simply breaks existing
applications for no good reason.

What is needed is for safety is to guard against the race of exec
happening during a read or a write, so that we don't get access
to something we shouldn't have permissions to.

In general that means reference counting or locks.  All exec_id can
meaningfully be used for in the general case is a trigger to try again.

> This is not news. Alan's historical links:
> http://lkml.org/lkml/2012/1/29/35

Alan's case refers to how to handle /proc/<pid>/maps the right way.

> The previous discussion on kernel-hardening:
> (includes some variants described by Vasiliy and other problems which I'll
> try to discuss here)
> http://www.openwall.com/lists/kernel-hardening/2012/02/10/1

In your post on openwall I just see you arguing that the current
and deliberate semantics of the permission checks on the proc files are
wrong.  Because the permission checks happen at access time rather than
at open time.

Well I am sorry.  The permission checks have happened at access time for
ages and that is deliberate.

Furthermore one of your confused arguments seems to imply that there is
a such a thing as a /proc/self file distinct from a /proc/<pid> file.
There not.  /proc/self is just a symlink into /proc/<pid> and as such
does not open new security holes.

If you expect /proc/ not to let you find out things about yourself
if you are a suid executable that just seems silly.

So in short you seem to be arguing for changing the semantics of access
of every file under /proc/<pid> because there is cognitive dissonance
between your understanding of those files and what is implemented.  I
see no acknowledgement that you are arguing for a semantic change or
any arguments in favor of that change.  At best I see is an argument
that says you the files don't work the way you expect which is most
definitely not sufficient for a change.

Eric
