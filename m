Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0EaDvc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 23:51:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36488 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab0EaDva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 23:51:30 -0400
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20100531030402.GQ6056@outflux.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 30 May 2010 20:50:53 -0700
In-Reply-To: <20100531030402.GQ6056@outflux.net> (Kees Cook's message of "Sun\, 30 May 2010 20\:04\:02 -0700")
Message-ID: <m17hmkg25e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: kees.cook@canonical.com, serue@us.ibm.com, tim.gardner@canonical.com, a.p.zijlstra@chello.nl, mingo@elte.hu, dhowells@redhat.com, eparis@redhat.com, jmorris@namei.org, schwidefsky@de.ibm.com, hidave.darkstar@gmail.com, jkosina@suse.cz, akpm@linux-foundation.org, rdunlap@xenotime.net, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
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
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:

> A long-standing class of security issues is the symlink-based
> time-of-check-time-of-use race, most commonly seen in world-writable
> directories like /tmp. The common method of exploitation of this flaw
> is to cross privilege boundaries when following a given symlink (i.e. a
> root process follows a symlink belonging to another user).  For a likely
> incomplete list of hundreds of examples across the years, please see:
> http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp
>
> The solution is to permit symlinks to only be followed when outside a sticky
> world-writable directory, or when the uid of the symlink and follower match,
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
> This patch is based on the patch in Openwall and grsecurity.  I have
> added a sysctl to toggle the behavior back to the old logic via
> /proc/sys/fs/weak-sticky-symlinks, documentation, and a ratelimited
> warning.

The name of the sysctl is horrible it is a double negative, which
makes thinking about it hard.

Why not simply put each user in a different mount namespace and have separate
/tmp directories per user?  That works today, with no kernel changes.

Placing this in cap_inode_follow_link is horrible naming.  There is nothing
capabilities about this.  Either this needs to go into one or several
of the security modules or this needs to go into the core vfs. 

I can't argue with taking action to close the too frequently security
issues in /tmp, but this changes appears to be unnecessary, difficult
to maintain, and difficult to understand.

Eric

