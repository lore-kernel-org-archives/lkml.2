Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab0EMSRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:17:19 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49965 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab0EMSRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:17:17 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Dilger <andreas.dilger@oracle.com>, Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Serge Hallyn <serue@us.ibm.com>,
       linux-fsdevel@vger.kernel.org, Steven French <sfrench@us.ibm.com>,
       Philippe Deniel <philippe.deniel@CEA.FR>,
       "linux-kernel\@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
In-Reply-To: <8739xvevbw.fsf@linux.vnet.ibm.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1273679444-14903-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com> <20100513084310.5212728b@notabene.brown> <871vdg2ulx.fsf@linux.vnet.ibm.com> <20100513171114.1629086b@notabene.brown> <51B2B398-99A7-43BF-A074-ACFBBA318DF7@oracle.com> <8739xvevbw.fsf@linux.vnet.ibm.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Thu, 13 May 2010 23:47:04 +0530
Message-ID: <878w7n1xb3.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 19:51:23 +0530, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Thu, 13 May 2010 02:30:46 -0600, Andreas Dilger <andreas.dilger@oracle.com> wrote:
> > On 2010-05-13, at 01:11, Neil Brown wrote:
> > > Here is my reason (well, one of my reasons) why UUID is clearly not an
> > > acceptable handle to use - you *must* use an fd or are worst a path name.
> > > 
> > > A filesystem can be mounted at multiple places in the namespace and each
> > > instance can have other filesystems mounted on different directories.
> > > Each of these is a 'vfsmnt'.
> > > You need a vfsmnt for most (all?) filesystem operations.
> > > A UUID does not uniquely identify a vfsmnt.  It might uniquely identify a
> > > filesystem, though that is debatable.  It definitely does not uniquely
> > > identify a vfsmnt.
> > > Therefore, given only a UUID the kernel would have to arbitrarily choose a
> > > vfsmnt that references to the right filesystem.  If a particular directory in
> > > the filesystem that you want to access was mounted-on in that vfsmnt, that
> > > directory would be completely inaccessible to you, even though it might be
> > > completely accessible in some other vfsmnt.
> > > So it is quite possible for a scheme based on kernel interpretation of uuids
> > > to fail.
> > 
> > I think this is exactly the wrong solution for this case.  The lookup from pathname to handle happened ALREADY (in the presence of the right namespace and vfsmnt information) and all that should be required for the handle lookup is to get the exact same inode back from disk.  It is irrelevant what vfsmnt is used to do this lookup, so long as it is in the same filesystem as before.
> > 
> > > This may be a corner case, but I think people are slowly getting more
> > > adventurous in terms of using the mount table to do interesting things.  It
> > > may be less of a corner case in 5 years.
> > 
> > I think the important feature for the handle is that _regardless_ of what shenanigans are done with the path, over-mounting of directories, etc, that the same inode is returned.  One would expect that if a real fd was opened by a process, that any later changes to the namespace would not suddenly result in another file with the same pathname to be accessible by that fd.
> > 
> > > So to tell the kernel which filesystem is of interest for filehandle
> > > lookup, you *must* give it a name, whether a textual path, or a filehandle
> > > obtained by opening a textual path.
> > 
> > No, that is done at the time of open() (or in this case name_to_handle()) and afterward the name/path/vfsmnt is completely irrelevant to the fd/handle.
> 
> 
> I guess we also have the problem with readonly bind mounts.  May be we
> should use the mountdir fd and leave the fsid to mountdir fd mapping to
> userspace. 
> 
> NOTE: With the current patchset a name_to_handle on the readonly mount
> point will fail because of the new checks i added in the syscall. But in
> general i guess we need to make sure that an open_by_handle should
> follow these vfsmount flags also. 
> 
> Christoph, Andreas,
> 
> Can we agree on the use of mountdir fd ? If so i can redo the patch
> using mountdirfd.
> 

Or

How about below interface

sys_open_by_handle_at(int mountdirfd, struct file_handle *handle, int
flags)

if mountdirfd == 0
   use UUID specified in the file handle to lookup vfsmount
else
   else use mountdirfd to get the vfsmount


-aneesh
