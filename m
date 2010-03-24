Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab0CXS4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:56:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44207 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab0CXS4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:56:06 -0400
Date: Wed, 24 Mar 2010 18:56:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Doug Nazar <nazard.lkml@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
Message-ID: <20100324185604.GT30031@ZenIV.linux.org.uk>
References: <4BAA3828.2070506@panasas.com>
 <20100324160754.GQ30031@ZenIV.linux.org.uk>
 <4BAA398C.5050901@panasas.com>
 <20100324163948.GR30031@ZenIV.linux.org.uk>
 <4BAA48A3.1030801@panasas.com>
 <4BAA4CAC.6060104@panasas.com>
 <4BAA5035.1060906@panasas.com>
 <4BAA52A8.2080304@panasas.com>
 <20100324180622.GS30031@ZenIV.linux.org.uk>
 <4BAA5955.4000001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAA5955.4000001@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 02:26:29PM -0400, Doug Nazar wrote:
> I also see it....didn't bisect it yet since I was in a rush and had
> a simple work around. I was doing a git pull between two
> repositories on a NFS 4 w/krb5 security. Got the error about
> .git/objects/pack (error: unable to open object pack directory:
> .git/objects/pack: Is a directory). If I then run 'ls
> .git/objects/pack', and then the 'git pull' again it works.

Very interesting...  The damn thing *is* a directory, which should have
made NFS skip all lookup_instantiate_filp() tricks completely.  IOW, it's
not hitting anything intent-related at that case.

I really wonder where the hell does EISDIR come from; no matter how screwed
the cached attributes are, there's not a lot of places where we can return
that sucker.  It either comes from something in NFS itself, or it's
may_open() getting MAY_WRITE on that object or it has to see O_CREAT in
open_flag.  And acc_mode is not modified after it's set in do_filp_open().
If that calculation (acc_mode by open_flag) would be buggered for O_RDONLY,
we'd be seeing a lot more breakage, starting with ls(1) ;-)

One possibility is that shit hits the fan a bit earlier and git really passes
something odd to that open() as the result of bogus stat(), etc.

Folks, could you try the following: in do_last() move case LAST_DOT:
to immediately after follow_dotdot(nd); and see if that changes anything?
It shouldn't, but if nfs is playing odd tricks with ->d_revalidate() for
directories acting differently depending on LOOKUP_PARENT in flags...

IOW, replace
        case LAST_DOTDOT:  
                follow_dotdot(nd);
                dir = nd->path.dentry;
                if (nd->path.mnt->mnt_sb->s_type->fs_flags & FS_REVAL_DOT) {
                        if (!dir->d_op->d_revalidate(dir, nd)) {
                                error = -ESTALE;
                                goto exit;
                        }
                }
                /* fallthrough */
        case LAST_DOT:
        case LAST_ROOT:
with
        case LAST_DOTDOT:  
                follow_dotdot(nd);
                /* fallthrough */
        case LAST_DOT:
                dir = nd->path.dentry;
                if (nd->path.mnt->mnt_sb->s_type->fs_flags & FS_REVAL_DOT) {
                        if (!dir->d_op->d_revalidate(dir, nd)) {
                                error = -ESTALE;
                                goto exit;
                        }
                }
                /* fallthrough */
        case LAST_ROOT:
and see what'll change.
