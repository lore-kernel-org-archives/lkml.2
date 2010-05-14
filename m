Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0ENBoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 21:44:23 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:33489 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755313Ab0ENBoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 21:44:21 -0400
Date: Fri, 14 May 2010 11:44:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 6/9] ext4: Add get_fsid callback
Message-ID: <20100514014404.GF8120@dastard>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1273679444-14903-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100513031133.GF13617@dastard>
 <87sk5w1fcb.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sk5w1fcb.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 12:02:52PM +0530, Aneesh Kumar K. V wrote:
> On Thu, 13 May 2010 13:11:33 +1000, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, May 12, 2010 at 09:20:41PM +0530, Aneesh Kumar K.V wrote:
> > > Acked-by: Serge Hallyn <serue@us.ibm.com>
> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > > ---
> > >  fs/ext4/super.c |   15 +++++++++++++++
> > >  1 files changed, 15 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > > index e14d22c..fc7d464 100644
> > > --- a/fs/ext4/super.c
> > > +++ b/fs/ext4/super.c
> > > @@ -1049,6 +1049,19 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
> > >  	return try_to_free_buffers(page);
> > >  }
> > >  
> > > +static int ext4_get_fsid(struct super_block *sb, struct uuid *fsid)
> > > +{
> > > +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> > > +	struct ext4_super_block *es = sbi->s_es;
> > > +
> > > +	memcpy(fsid->uuid, es->s_uuid, sizeof(fsid->uuid));
> > > +	/*
> > > +	 * We may want to make sure we return error if the s_uuid is not
> > > +	 * exactly unique
> > > +	 */
> > > +	return 0;
> > > +}
> > > +
> > >  #ifdef CONFIG_QUOTA
> > >  #define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
> > >  #define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
> > > @@ -1109,6 +1122,7 @@ static const struct super_operations ext4_sops = {
> > >  	.quota_write	= ext4_quota_write,
> > >  #endif
> > >  	.bdev_try_to_free_page = bdev_try_to_free_page,
> > > +	.get_fsid	= ext4_get_fsid,
> > >  };
> > >  
> > >  static const struct super_operations ext4_nojournal_sops = {
> > > @@ -1128,6 +1142,7 @@ static const struct super_operations ext4_nojournal_sops = {
> > >  	.quota_write	= ext4_quota_write,
> > >  #endif
> > >  	.bdev_try_to_free_page = bdev_try_to_free_page,
> > > +	.get_fsid	= ext4_get_fsid,
> > >  };
> > 
> > This all looks pretty simple - can you add XFS support to this
> > interface (uuid is in XFS_M(sb)->m_sb.sb_uuid) so that it can be
> > tested to work on multiple filesystems.
> > 
> > FWIW, I didn't get patch 0 of this series, so I'll comment on
> > one line of it right here because it is definitely relevant:
> > 
> > > I am also looking at getting xfsprogs libhandle.so on top of these
> > > syscalls.
> > 
> > If you plan to modify libhandle to use these syscalls, then you need
> > to guarantee:
> > 
> > 	1. XFS support for the syscalls
> > 	2. the handle format, lifecycle and protections for XFS
> > 	   handles are *exactly* the same as the current XFS
> > 	   handles.  i.e. there's a fixed userspace API that
> > 	   cannot be broken.
> > 	3. you don't break any of the other XFS specific handle
> > 	   interfaces that aren't implemented by the new syscalls
> > 	3. You don't break and existing XFS utilites - dump/restore,
> > 	   and fsr come to mind immediately.
> > 	4. that you'll fix the xfstests that may break because of the
> > 	   change
> > 	5. that you'll write new tests for xfstests that validates
> > 	   that the libhandle API works correctly and that handle
> > 	   formats and lifecycles do not get accidentally changed in
> > 	   future.
> > 
> > That's a lot of work and, IMO, is completely pointless. All we'd get
> > out of it is more complexity, bloat, scope for regressions and a
> > biger test matrix, and we wouldn't have any new functionality to
> > speak of.
> 
> getting libhandle.so to work with the syscall is something that is
> suggested on the list. The goal is to see if syscall achieve everything
> that XFS ioctl does

Ok, I didn't know that, but the question still stands. The XFS ioctl
cannot go away any time soon (we basically have to support it
forever), so why should we be writing a new, redundant
kernel API for this functionality that is going not generally going
to be directly accessed by userspace developers?

APIs are hard to get right - moving and modifying kernel code to be
generic is easy in comparison, and also somethign we can easily fix
if we get it wrong the first time. Make a mistake with a syscall
API, and we are stuck with it forever.

Might I suggest a slightly different approach, then? That is,
separate the two parts of making the XFS handle code generic and
providing a new API?  We don't lose anything by separating them - we
don't introduce any new APIs that have to be supported in the first
step, nor does the functionality get delayed by API discussions.
However, we still gain immediate widespread support for handles through
the libraries *already shipping* in every major distro, and that
doesn't get held up by discussions around what the API should look
like.

Then we can work on getting a new API right - we're going to be
stuck with it forever, so it's probably better to work out how the
interface will be used outside libhandle. A new application using it
would be a great example - it's rare that an API created with only
one user is going to be a good API when more developers try to make
use of it for new applications.

There is precedence here - the FIFREEZE ioctl for freezing/thawing
filesystems from userspace іs the API that XFS has been using for
years (XFS_IOC_FREEZE) to provide the functionality. It got promoted
to the VFS when other filesystems needed userspace freezing
capabilities, but only after new syscalls were proposed first.  The
result of using the existing interface was that freeze/thaw for any
capable filesystem was immediately availble using xfs_freeze or
xfs_io - there was no lag to userspace support in distro's, no
problems having to detect and support multiple interfaces depending
on what the kernel supported, etc. Overall it made things much
simpler and easier to manage and test....

Your thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
