Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab2GGQlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 12:41:35 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:25254 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2GGQld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 12:41:33 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=ERiTfhtLjzXJcj3iJe/YJILk3eDG9UtWJfSbelKhppNrSQiB0AaJJAMQC4CE
	uqMfMuSuIv92o/r/R8hPmQzJpWPgrvLFa42X1a5WidWQmDsH9PsXSrGtT
	cqwXuqgrzu5MtDjH4iBXAKuSny0tRePntSExqLmr4pMVbTnfSRWQlM=;
X-Spam-Processed: mail.digidescorp.com, Sat, 07 Jul 2012 11:41:31 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.24.110
X-Return-Path: prvs=1535ec46b0=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341679286.2435.12.camel@iscandar>
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
 inodes/dentries
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 07 Jul 2012 11:41:26 -0500
In-Reply-To: <87wr2g9kh3.fsf@devron.myhome.or.jp>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	 <1341342576-15394-3-git-send-email-steve@digidescorp.com>
	 <87pq8bokcp.fsf@devron.myhome.or.jp>
	 <1341606824.2214.14.camel@iscandar.digidescorp.com>
	 <871ukobntl.fsf@devron.myhome.or.jp> <1341623782.2021.9.camel@iscandar>
	 <87wr2g9kh3.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-07 at 15:03 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> > On Sat, 2012-07-07 at 06:07 +0900, OGAWA Hirofumi wrote: 
> >> "Steven J. Magnani" <steve@digidescorp.com> writes:
> >> 
> >> > On Wed, 2012-07-04 at 20:07 +0900, OGAWA Hirofumi wrote: 
> >> >> Please don't add new lock_super() usage if it is not necessary. Almost
> >> >> all of lock_super() just replaced lock_kernel() usage. It rather should
> >> >> be removed in future.  Probably, this should use inode->i_mutex instead.
> >> >> 
> >> >> BTW, the above issue is same with all of directory read.
> >> >
> >> > I don't think there's really an alternative here. The cases addressed by
> >> > this patch all involve walking on-disk structures via
> >> > unofficial/temporary inodes created from information in the NFS handle
> >> > (i.e., outside the normal inode creation paths). When this process is
> >> > successful we end up with "official" connected inodes/dentries, but
> >> > getting there is really a "bottom up" strategy instead of the usual "top
> >> > down" approach.
> >> >
> >> > Because the "bottom up" method is lacking guarantees that "top down"
> >> > takes for granted - i.e., that a cluster on disk that's supposed to be a
> >> > directory actually *is* a directory -  I am adding some defensive code
> >> > in the next spin of the patch.
> >> 
> >> I'm not sure what you meant. Where is the problem? ->get_name()? If so,
> >> it has parent dentry parameter. What is the wrong if we take
> >> mutex_lock(parent->d_inode)?
> >
> > The temporary/"unofficial" inodes are unhashed and thus not visible
> > outside of the functions using them. They exist only to support access
> > to directory contents when we can't gain that access via other means
> > (because we only have "bottom up" information, about an object and
> > perhaps its parent, in a form that can't be used to look up hashed
> > inodes/dentries). Hashing them wouldn't help, because they don't have
> > the correct key (for instance, in the case of a ".." entry).
> >
> > Am I missing something?
> 
> You mean the unhashed inode is created by ->get_parent()? If so, the
> root cause sounds like ->get_parent() itself. If not, I'm not
> understanding the meaning of the temporary/unofficial inode here.

Maybe "private" is a better word than "unofficial". Private inodes are
created anywhere fat_new_inode (nee fat_build_unhashed_inode) is called
directly, instead of through fat_build_inode. So yes, this is on the
get_parent paths (via fat_lookup_dir), and also on the fh_to_dentry path
when inode reconstruction is necessary.

With private inodes, I don't see how anyone but the code that created
them could find them to lock them. The reason they're private is that
they're temporary aliases; at the time they're created, we don't have
enough information to register them in a way that others could find
them. A lookup, etc. operation will look for the inode of the "drivers"
directory, not the ".." of the "usb" directory. We do need these private
inodes in order to walk directory entries. I don't think they're a
problem that needs solving; if we didn't use private inodes, we'd still
need a way to walk directory entries in the context of these NFS
operations, and there would still be potential races between that and
other operations on the filesystem.

------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


