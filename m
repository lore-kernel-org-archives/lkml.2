Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab0FCUDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 16:03:13 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53628 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0FCUDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 16:03:09 -0400
To: Kees Cook <kees.cook@canonical.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Eric Paris <eparis@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20100603080158.GE4971@outflux.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 03 Jun 2010 13:02:48 -0700
In-Reply-To: <20100603080158.GE4971@outflux.net> (Kees Cook's message of "Thu\, 3 Jun 2010 01\:01\:58 -0700")
Message-ID: <m11vcnlw9j.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: kees.cook@canonical.com, alan@lxorguk.ukuu.org.uk, tytso@mit.edu, serue@us.ibm.com, tim.gardner@canonical.com, a.p.zijlstra@chello.nl, mingo@elte.hu, dhowells@redhat.com, schwidefsky@de.ibm.com, jkosina@suse.cz, akpm@linux-foundation.org, rdunlap@xenotime.net, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, jmorris@namei.org, hch@infradead.org, eparis@redhat.com, viro@zeniv.linux.org.uk, hidave.darkstar@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Kees Cook <kees.cook@canonical.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: lkml.org]
	* -1.0 XM_URI_RBL_RM URI removed in uri.bl.xmission.com
	*      [URIs: mitre.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:

> A long-standing class of security issues is the symlink-based
> time-of-check-time-of-use race, most commonly seen in world-writable
> directories like /tmp. The common method of exploitation of this flaw
> is to cross privilege boundaries when opening a file through a given
> symlink (i.e. a root process opens a symlink belonging to another user).
> For a likely incomplete list of hundreds of examples across the years,
> please see: http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp
>
> The solution is to permit symlinks to only be opened when outside a sticky
> world-writable directory, or when the uid of the symlink and opener match,
> or when the directory owner matches the symlink's owner.
>
> Some pointers to the history of earlier discussion that I could find:
>
>  1996 Aug, Zygo Blaxell
>   http://marc.info/?l=bugtraq&m=87602167419830&w=2
>  1996 Oct, Andrew Tridgell
>   http://lkml.indiana.edu/hypermail/linux/kernel/9610.2/0086.html
>  1997 Dec, Albert D Cahalan
>   http://lkml.org/lkml/1997/12/16/4
>  2005 Feb, Lorenzo Hernández García-Hierro
>   http://lkml.indiana.edu/hypermail/linux/kernel/0502.0/1896.html
>
> Past objections and rebuttals could be summarized as:
>
>  - Violates POSIX.
>    - POSIX didn't consider this situation and it's not useful to follow
>      a broken specification at the cost of security.
>  - Might break unknown applications that use this feature.
>    - Applications that break because of the change are easy to spot and
>      fix. Applications that are vulnerable to symlink ToCToU by not having
>      the change aren't.
>  - Applications should just use mkstemp() or O_CREATE|O_EXCL.
>    - True, but applications are not perfect, and new software is written
>      all the time that makes these mistakes; blocking this flaw at the
>      kernel is a single solution to the entire class of vulnerability.
>
> This patch is based on the patch in Openwall and grsecurity, but with the
> scope changed to be only "opening" a symlink.  I have added a sysctl to
> enable the protected behavior, documentation, and a ratelimited warning.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

This approach to fix the problem to of /tmp looks to me like it
will have the opposite effect.  I think this patch will encourage
more badly written applications.

This patch does not actually fix the problem of recurring security
issues in /tmp.  Fundamentally /tmp is a design flaw. You have
evidence that even the introduction of the sticky bit, and O_NOFOLLOW
did not fix this design flaw, I don't see how yet another kernel feature
will make finally make /tmp secure.  The design flaw in /tmp is that we
encourage storing files that we care little about (temporary files) in
a location that is shared between everyone.  From a security point of
view sharing of files needs to be done very carefully, and as such
should only be done for files that we really care about and intend to
share.

Furthermore the set of applications with security problems you are intending
to address are privileged applications.   There is no excuse not to audit
and fix those applications.  If you include this patch I see no reason why
audits won't get more lax and other related security issues won't crop up.

The real solution to this problem of inadvertently sharing things that are
not safe to be shared is not to have a shared /tmp at all.

Per user tmp can be as simple as:
export TMPDIR=$HOME/tmp/
chmod 0500 /tmp

So is your interest in actually fixing this problem, or do you just
want to encourage more bad applications to be written without worrying
about inadvertent sharing in /tmp?

Eric
