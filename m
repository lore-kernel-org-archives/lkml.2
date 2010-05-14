Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab0ENSSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:18:37 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55198 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab0ENSSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:18:36 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
       Andreas Dilger <andreas.dilger@oracle.com>
Cc: Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>,
       Jonathan Corbet <corbet@lwn.net>, Serge Hallyn <serue@us.ibm.com>,
       linux-fsdevel@vger.kernel.org, Steven French <sfrench@us.ibm.com>,
       Philippe Deniel <philippe.deniel@CEA.FR>,
       "linux-kernel\@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
In-Reply-To: <20100514172510.GU30031@ZenIV.linux.org.uk>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1273679444-14903-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com> <20100513084310.5212728b@notabene.brown> <871vdg2ulx.fsf@linux.vnet.ibm.com> <20100513171114.1629086b@notabene.brown> <51B2B398-99A7-43BF-A074-ACFBBA318DF7@oracle.com> <8739xvevbw.fsf@linux.vnet.ibm.com> <878w7n1xb3.fsf@linux.vnet.ibm.com> <B93EA6D0-4D21-46B2-988C-A7A307EBE0B7@oracle.com> <20100514172510.GU30031@ZenIV.linux.org.uk>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Fri, 14 May 2010 23:48:24 +0530
Message-ID: <87d3wye49b.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 18:25:10 +0100, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Thu, May 13, 2010 at 04:54:11PM -0600, Andreas Dilger wrote:
> 
> > fd = 0 is a valid descriptor, though -1 is not.  I'd be OK with this, because it still means we can use the UUID to positively identify the filesystem (it would also avoid the need to do a by-UUID lookup in most cases, since the dirfd would already point to a filesystem and we can just compare the handle UUID with the UUID for that superblock.
> > 
> > The question is what to do if the UUID in the file handle does not match the filesystem that is passed via vfsmount?  It would seem that vfsmount is needed for determining the namespace and possibly disambiguating multiple mounts of snapshots with the same UUID.  Independent of that if the UUID is not matching the underlying filesystem that the vfsmount is pointing to the open should fail with -ESTALE.
> > 
> > If the UUID is not the same, then the chance that the inode/generation stored in the file handle are still useful is slim.  If someone is cloning the filesystem down to the inode number, then they can clone the UUID as well.
> > 
> > In summary, I'm OK with this approach.
> 
> I am not.  First of all, it relies on order of vfsmounts in the list to
> decide which one gets picked; as far as I'm concerned, that alone is enough
> to declare it bogus.  "Let's pick the random answer" is wrong outside of
> /dev/random and it's got way too little entropy for that use ;-)
> 
> What's more, there's absolutely nothing to stop you from having fsid -> fd
> cache in userland and populating it on demand from whatever means you are
> using to determine the mapping from fsid to fs.
> 
> IOW, NAK.

How about
sys_open_by_handle(int mountdirfd,
                  struct file_handle __user *ufh, int open_flag)

and we validate the UUID present in the file_handle by using mountdirfd
vfsmount. In otherwords we drop the UUID based vfsmount lookup, But
still add UUID as a part of file handle ?

-aneesh

