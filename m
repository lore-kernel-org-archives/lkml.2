Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab2BCRDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:03:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43837 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab2BCRDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:03:04 -0500
Date: Fri, 3 Feb 2012 17:03:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andreas Dilger <adilger@dilger.ca>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
Message-ID: <20120203170300.GW23916@ZenIV.linux.org.uk>
References: <4F27C6EB.2070305@suse.cz>
 <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <20120202012258.GQ23916@ZenIV.linux.org.uk>
 <20120202212400.GR23916@ZenIV.linux.org.uk>
 <E950CD52-73DC-404C-A84A-6027CAF7F6E6@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E950CD52-73DC-404C-A84A-6027CAF7F6E6@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:25:26AM -0700, Andreas Dilger wrote:
> On 2012-02-02, at 2:24 PM, Al Viro wrote:
> > FWIW, there's something we really should've done a long time ago: putting
> > that limit into sb->s_max_links.  With 0 meaning "leave all checks to
> > ->link/->mkdir/->rename".  Something like the following would make a
> > reasonable start - just the conversion of obvious cases.  As the next
> > step I'd probably initialize it as ~0U instead of 0 and let the filesystems
> > that want something trickier (reiserfs, ext4, gfs2, ocfs2) explicitly set
> > it to 0 in their foo_fill_super().  That would take care of a bunch of cases
> > where we forgot to do those checks (ubifs, hfsplus, jffs2, ramfs, etc.) and
> > it's probably a saner default anyway.
> 
> This would also give userspace some hope of pathconf(path, _PC_LINK_MAX)
> returning the actual value from the filesystem, instead of hard-coding
> this into glibc itself based on the statfs-returned f_type magic value.

*snort*

Even skipping the standard flame about pathconf() as an API, this will
not work.
	* we have filesystems that do not allow link creation at all and
do keep track of subdirectories count in i_nlink of directories.  What
would you have them store?  As it is, ~0U works just fine, but pathconf()
users won't be happy with it.
	* we have filesystems that allow unlimited subdirectories, while
limiting the number of links to non-directories; ->s_max_links == 0 will
work just fine, but won't make pathconf() happy.
	* we have filesystems that have more complex rules re links to
non-directory (see mail from Chris in this thread).  What would you have
pathconf() do?
