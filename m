Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab2DZAJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:09:46 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:51254 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab2DZAJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:09:44 -0400
Date: Thu, 26 Apr 2012 00:11:01 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 27/43] userns: Use uid_eq gid_eq helpers when comparing
 kuids and kgids in the vfs
Message-ID: <20120426001101.GA10308@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-27-git-send-email-ebiederm@xmission.com>
 <20120418190337.GE5186@mail.hallyn.com>
 <m1sjfx2950.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sjfx2950.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting Eric W. Beiderman (ebiederm@xmission.com):
> >> From: Eric W. Biederman <ebiederm@xmission.com>
> >> 
> >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> >> ---
> >>  fs/attr.c                |    8 ++++----
> >>  fs/exec.c                |   10 +++++-----
> >>  fs/fcntl.c               |    6 +++---
> >>  fs/ioprio.c              |    4 ++--
> >>  fs/locks.c               |    2 +-
> >>  fs/namei.c               |    8 ++++----
> >>  include/linux/quotaops.h |    4 ++--
> >>  7 files changed, 21 insertions(+), 21 deletions(-)
> >> 
> 
> >> @@ -2120,7 +2120,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >>  	if (__get_dumpable(cprm.mm_flags) == 2) {
> >>  		/* Setuid core dump mode */
> >>  		flag = O_EXCL;		/* Stop rewrite attacks */
> >> -		cred->fsuid = 0;	/* Dump root private */
> >> +		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
> >
> > Sorry, one more - can this be the per-ns root uid?  The coredumps should
> > be ok to belong to privileged users in the namespace right?
> 
> I'm not certain it was clear when you were looking at this that
> this is about dumping core from suid applications, not normal
> applications. 
> 
>  Looking at the code in commoncap and commit_creds it looks like it is a
> bug that we don't call set_dumpable(new, suid_dumpable) in common cap
> when we use file capabilities.  I might be wrong but I think we escape

We do, check kernel/cred.c:commit_creds().  So long as the new permitted
set is not a subset of the old one.

Tested it to make absolutely sure.  When I add file capabilities to a
program that otherwise dumps core (int *x = 0; *x = 0;), core dumps are
no longer generated.

-serge
