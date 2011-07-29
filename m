Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab1G2R4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:56:24 -0400
Received: from relay3.sgi.com ([192.48.152.1]:58605 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752375Ab1G2R4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:56:21 -0400
Subject: Re: [PATCH] xfs: Fix build breakage in xfs_iops.c when
 CONFIG_FS_POSIX_ACL is not set
From: Alex Elder <aelder@sgi.com>
Reply-To: <aelder@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Liu <lingjiujianke@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
In-Reply-To: <20110726091520.GB1639@x4.trippels.de>
References: <20110725185649.GA22133@ZenIV.linux.org.uk>
	 <20110726033535.GA11939@x4.trippels.de>
	 <CA+55aFzaKHpVdLKac6rFN+YsAugz1aR3fv-reThJiD4HWDND8w@mail.gmail.com>
	 <20110726082146.GB11939@x4.trippels.de>
	 <CADxeRwnYxgxZPT3DN=SraZOvL_juWzV+MoY9+0vqZr29y6U6cA@mail.gmail.com>
	 <20110726085804.GA1639@x4.trippels.de>
	 <20110726091520.GB1639@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 12:56:13 -0500
Message-ID: <1311962173.2790.24.camel@doink>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.162.232.50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 11:15 +0200, Markus Trippelsdorf wrote:
> commit 4e34e719e45, that takes the ACL checks to common code,
> accidentely broke the build when CONFIG_FS_POSIX_ACL is not set:
> 
>   CC      fs/xfs/linux-2.6/xfs_iops.o
> fs/xfs/linux-2.6/xfs_iops.c:1025:14: error: ‘xfs_get_acl’ undeclared here (not in a function)
> 
> Fix this by declaring xfs_get_acl a static inline function.
> 
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> ---
>  fs/xfs/xfs_acl.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> index 2c656ef..39632d9 100644
> --- a/fs/xfs/xfs_acl.h
> +++ b/fs/xfs/xfs_acl.h
> @@ -51,7 +51,10 @@ extern int posix_acl_default_exists(struct inode *inode);
>  extern const struct xattr_handler xfs_xattr_acl_access_handler;
>  extern const struct xattr_handler xfs_xattr_acl_default_handler;
>  #else
> -# define xfs_get_acl(inode, type)			NULL
> +static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
> +{
> +	return NULL;
> +}
>  # define xfs_inherit_acl(inode, default_acl)		0
>  # define xfs_acl_chmod(inode)				0
>  # define posix_acl_access_exists(inode)			0

Linus, I have done basic testing of this patch (build,
boot, and some simple XFS tests that touch ACLs) using
your latest master branch (55f9c40).  I tested three
combinations:
  CONFIG_XFS_POSIX_ACL (and CONFIG_FS_POSIX_ACL) on
  CONFIG_XFS_POSIX_ACL off, CONFIG_FS_POSIX_ACL on
  CONFIG_XFS_POSIX_ACL and CONFIG_FS_POSIX_ACL both off

I confirmed the build problem in the last two configs
without this patch, and verified it went away with
the patch applied.

So all is well from my perspective.  Please either take
his original patch, or pull from here:

      git://oss.sgi.com/xfs/xfs for-linus

Thanks.

Signed-off-by: Alex Elder <aelder@sgi.com>



