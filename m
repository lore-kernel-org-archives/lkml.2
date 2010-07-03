Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0GCQGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:06:25 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:33071 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab0GCQEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:11 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Neil Brown <neilb@suse.de>, Andreas Dilger <andreas.dilger@oracle.com>
Cc: hch@infradead.org, "viro\@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "adilger\@sun.com" <adilger@sun.com>,
       "corbet\@lwn.net" <corbet@lwn.net>,
       "serue\@us.ibm.com" <serue@us.ibm.com>,
       "hooanon05\@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
       "bfields\@fieldses.org" <bfields@fieldses.org>,
       "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "sfrench\@us.ibm.com" <sfrench@us.ibm.com>,
       "philippe.deniel\@CEA.FR" <philippe.deniel@CEA.FR>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
In-Reply-To: <20100703080904.78e4e7e1@notabene.brown>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <871vbn2mk9.fsf@linux.vnet.ibm.com> <20100702064108.64034561@notabene.brown> <A44260DA-245D-47DD-820E-2F4F1F50BB9D@oracle.com> <20100702070548.GA6959@infradead.org> <BEEA47B4-4C9E-4086-96D2-FA6B8F68DA68@oracle.com> <20100703080904.78e4e7e1@notabene.brown>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sat, 03 Jul 2010 21:34:00 +0530
Message-ID: <87630w1rin.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Jul 2010 08:09:04 +1000, Neil Brown <neilb@suse.de> wrote:
> On Fri, 2 Jul 2010 10:12:47 -0600
> Andreas Dilger <andreas.dilger@oracle.com> wrote:
> 
> > On 2010-07-02, at 01:05, hch@infradead.org wrote:
> > > On Thu, Jul 01, 2010 at 10:02:29PM -0600, Andreas Dilger wrote:
> > >> I'd like to be able to use this interface to implement the distributed open call proposed by the POSIX HECWG. This allows one client to do the path traversal, broadcast the file handle to the (maybe) 1M processes in the job via MPI, and then the other clients can open the file by handle without doing 1M times the full path traversal (which might be 10's of RPCs per process). 
> > > 
> > > The proposal is doomed anyway.  If we allow any sort of open by handle
> > > system call for unprivilegued users we need to do reconnect the dentry
> > > to the dcache path anyway (reconnect_path), which is more expensive than
> > > a normal path lookup.
> > 
> > I haven't looked at this part of the VFS in a while, but it looks like an implementation issue specific to knfsd, and shouldn't be needed for regular files.  i.e. if exportfs_encode_fh() is never used on a disconnected file, then this overhead is not incurred.
> > 
> > The above use of open_by_handle() is not for userspace NFS/Samba re-export, but to allow applications to open regular files for IO.  
> > 
> 
>  From my recollection of implementing dentry reconnection there are two
>  needs for it.
> 
>  Firstly it is needed for directories so that the VFS can effectively lock
>  against directory rename races which could otherwise create disconnected
>  subtrees (where the first parent is a member only of one of its
>  descendants).  So if you get a filehandle for a directory it *must* be
>  properly connected to the root for rename to be safe.  This operation is
>  faster than a full path lookup if the dentry is already is cache, and slower
>  if it and any of the path is not in cache.
>  You could possibly delay the full-connection of the dentry until the first
>  attempt to rename beneath it.   I'm not sure how much VFS surgery that would
>  require.
> 
>  Secondly it is needed if you want to enforce the rule that the contents of a
>  directory are only accessible if the 'x' bit on the directory is set.
>  kNFSd does not enforce this (unless subtree_check is specified), partly
>  because it is hard to do correctly and partly because we have to trust the
>  client any, so trusting it to check the 'x' bit is very little extra trust.
> 
>  Note that it is not possible to reliably perform filehandle lookup for
>  non-directories if you need a fully reconnected dentry, as
>  cross-directory-renames can confuse the situation beyond recovery.
> 
>  Maybe open-by-handle should require DAC_OVERRIDE, or maybe a new
>  DAC_X_OVERRIDE. And if those aren't provided it only works for directories. 
>  ???
> 

Currently I have the below in open_by_handle

	/*
	 * With handle we don't look at the execute bit on the
	 * the directory. Ideally we would like CAP_DAC_SEARCH.
	 * But we don't have that
	 */
	if (!capable(CAP_DAC_READ_SEARCH)) {
		retval = -EPERM;
		goto out_err;
	}

-aneesh
