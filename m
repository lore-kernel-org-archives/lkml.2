Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab0FQMaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 08:30:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50635 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0FQMaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 08:30:06 -0400
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-doc@vger.kernel.org
References: <20100616221833.GM24749@outflux.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 17 Jun 2010 05:29:53 -0700
In-Reply-To: <20100616221833.GM24749@outflux.net> (Kees Cook's message of "Wed\, 16 Jun 2010 15\:18\:33 -0700")
Message-ID: <m1hbl1eta6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: kees.cook@canonical.com, linux-doc@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu, dhowells@redhat.com, hpa@zytor.com, oleg@redhat.com, roland@redhat.com, schwidefsky@de.ibm.com, hidave.darkstar@gmail.com, jkosina@suse.cz, akpm@linux-foundation.org, rdunlap@xenotime.net, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <kees.cook@canonical.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.3 XMBlogspot URI: Link to something.blogspot.com
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:

> As Linux grows in popularity, it will become a larger target for
> malware. One particularly troubling weakness of the Linux process
> interfaces is that a single user is able to examine the memory and
> running state of any of their processes. For example, if one application
> (e.g. Pidgin) was compromised, it would be possible for an attacker to
> attach to other running processes (e.g. Firefox, SSH sessions, GPG agent,
> etc) to extract additional credentials and continue to expand the scope
> of their attack without resorting to user-assisted phishing.
>
> This is not a theoretical problem. SSH session hijacking
> (http://www.storm.net.nz/projects/7) and arbitrary code injection
> (http://c-skills.blogspot.com/2007/05/injectso.html) attacks already
> exist and remain possible if PTRACE is allowed to operate as before.
> PTRACE is not commonly used by non-developers and non-admins, so system
> builders should be allowed the option to disable this debugging system.
>
> For a solution, some applications use prctl(PR_SET_DUMPABLE, ...) to
> specifically disallow such PTRACE attachment (e.g. ssh-agent), but many
> do not. A more general solution is to only allow PTRACE directly from a
> parent to a child process (i.e. direct "gdb EXE" and "strace EXE" still
> work), or with CAP_SYS_PTRACE (i.e. "gdb --pid=PID", and "strace -p PID"
> still work as root).
>
> This patch is based on the patch in grsecurity. It includes a sysctl
> to enable the behavior via /proc/sys/kernel/ptrace_scope.  This could
> be expanded in the future to further restrict PTRACE to, for example,
> only CAP_SYS_PTRACE (scope 2) or only init (scope 3).

This is ineffective.  As an attacker after I gain access to a users
system on ubuntu I can wait around until a package gets an update,
and then run sudo and gain the power to do whatever I want.

Either that or I can inject something nasty into the suid pulse-audio.

I tell you what.  If you really want something effective, help Serge
and I finish getting the cross namespace issues fixed for the user
namespace.  When complete, it will possible for an unprivileged process
to create a new one, and since kernel capabilities along with everything
else will be local to it, running pidgin, or firefox, or another network
facing potentially buggy application in such a namespace will ensure that
even if the process is compromised it won't have privileges to ptrace another
process or do much else on the system.

Eric
