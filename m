Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab0EaEN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 00:13:29 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51056 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab0EaEN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 00:13:27 -0400
Date: Sun, 30 May 2010 21:12:04 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
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
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100531041204.GR6056@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
 <m17hmkg25e.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17hmkg25e.fsf@fess.ebiederm.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Sun, May 30, 2010 at 08:50:53PM -0700, Eric W. Biederman wrote:
> The name of the sysctl is horrible it is a double negative, which
> makes thinking about it hard.

Hmm, I see your point, the "safe" value is "weak: not".  I was trying to
be descriptive without needing a "true" value, but I guess that's silly;
we already have things like randomize_va_space set to "2" by default, etc.
What would you suggest instead?  "protected_sticky_symlinks" (and reverse
the default and test logic)?

> Why not simply put each user in a different mount namespace and have separate
> /tmp directories per user?  That works today, with no kernel changes.

The key here is "no kernel changes" -- trying to isolate every user
and service from each other using different mount namespaces will not
work quickly in current distributions.  Even doing bind-mount tricks
to keep /tmp away from different users is overkill, especially when
you have situations like "screen" using a common /tmp directory tree
(in the setuid version), etc.  Things (correctly) expect to share /tmp
in some cases.  However, this one kernel change will allow everything
to continue without userspace overhead and without breaking anything
terribly.  Using containers will probably be the future, but I want to
solve this in the general case today.

> Placing this in cap_inode_follow_link is horrible naming.  There is nothing
> capabilities about this.  Either this needs to go into one or several
> of the security modules or this needs to go into the core vfs.

My thinking was that most of the LSMs call down to commoncaps first,
so it's a single place to put this.  When I was looking at this code
originally, I thought that if it doesn't go in security_inode_follow_link,
then a new function would be added to the VFS and both callers
of security_inode_follow_link would need to call it just before
security_inode_follow_link.  It seemed like putting it in there reduced
duplication of logic.

However, on closer examination, it seems that this code could live in
__do_follow_link instead.

fs/namei.c:
...
                error = security_inode_follow_link(path.dentry, &nd);
                if (error)
                        goto exit_dput;
                error = __do_follow_link(&path, &nd, &cookie);
...
        err = security_inode_follow_link(path->dentry, nd);
        if (err)
                goto loop;
        current->link_count++;
        current->total_link_count++;
        nd->depth++;
        err = __do_follow_link(path, nd, &cookie);
...

What would you suggest for the best approach here?

> I can't argue with taking action to close the too frequently security
> issues in /tmp, but this changes appears to be unnecessary, difficult
> to maintain, and difficult to understand.

Well, we disagree about "unnecessary".  :)  Finding an easy to maintain
solution is my goal here, and if it's difficult to understand, then I need
to fix that too.  What could use better clarification?

Thanks!

-Kees

-- 
Kees Cook
Ubuntu Security Team
