Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2GIMDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:03:47 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:2404 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab2GIMDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:03:44 -0400
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=message-id:from;
	b=bWQi6HPZQmKS2+LS+ap+/45fFCpLSe/XpqEpr7kFGVO4CFuEWXAFS1RBWX18
	wXdkEVpsj4yJjjdjBXd9DimUzHZuJYNo8YoLix37n80uTIDb1T3/L22Pj
	mZ0QM54LnWAd9PdEyhXvvOivzQC9JP2S4Zp23IXS3X2LwtkZ/ueC2Q=;
X-Spam-Processed: mail.digidescorp.com, Mon, 09 Jul 2012 07:03:42 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1537d3712a=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Message-ID: <1341835422.2215.6.camel@iscandar.digidescorp.com>
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
 inodes/dentries
From: "Steven J. Magnani" <steve@digidescorp.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 07:03:42 -0500
In-Reply-To: <87zk7bo6aq.fsf@devron.myhome.or.jp>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	 <1341342576-15394-3-git-send-email-steve@digidescorp.com>
	 <87pq8bokcp.fsf@devron.myhome.or.jp>
	 <1341606824.2214.14.camel@iscandar.digidescorp.com>
	 <871ukobntl.fsf@devron.myhome.or.jp> <1341623782.2021.9.camel@iscandar>
	 <87wr2g9kh3.fsf@devron.myhome.or.jp> <1341679286.2435.12.camel@iscandar>
	 <87zk7bo6aq.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 (3.4.3-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-08 at 02:00 +0900, OGAWA Hirofumi wrote: 
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> >> You mean the unhashed inode is created by ->get_parent()? If so, the
> >> root cause sounds like ->get_parent() itself. If not, I'm not
> >> understanding the meaning of the temporary/unofficial inode here.
> >
> > Maybe "private" is a better word than "unofficial". Private inodes are
> > created anywhere fat_new_inode (nee fat_build_unhashed_inode) is called
> > directly, instead of through fat_build_inode. So yes, this is on the
> > get_parent paths (via fat_lookup_dir), and also on the fh_to_dentry path
> > when inode reconstruction is necessary.
> >
> > With private inodes, I don't see how anyone but the code that created
> > them could find them to lock them. The reason they're private is that
> > they're temporary aliases; at the time they're created, we don't have
> > enough information to register them in a way that others could find
> > them. A lookup, etc. operation will look for the inode of the "drivers"
> > directory, not the ".." of the "usb" directory. We do need these private
> > inodes in order to walk directory entries. I don't think they're a
> > problem that needs solving; if we didn't use private inodes, we'd still
> > need a way to walk directory entries in the context of these NFS
> > operations, and there would still be potential races between that and
> > other operations on the filesystem.
> 
> How do you prevent to modify or free the those inode/blocks from other
> path?  Yeah, it is racy. And if races is not solved, that's simply wrong
> and not solution.
> 
> Although I'm not thinking deeply about NFS support on FAT. Just a idea,
> the one of possible solutions would be register it to hash, and find it
> on all path. So, all path will use same inode and lock.
> 
> We need the key, possible key is - if it is only directory, FAT may be
> able to use i_start as additional search key.

Interesting idea. I think this, and reformulating the FAT NFS file
handle to include the parent's i_ino, will greatly simplify (and speed
up) the code.

I am having a hard time seeing how inclusion of i_pos in the file handle
is useful. The only scenarios I can conceive where an i_ino lookup fails
and an i_pos lookup succeeds are the object referenced by the file
handle has:

    (A) been replaced by something else,
or  (2) had its inode evicted, but later re-instantiated

Perhaps the design was intended to support case (2), but since the file
handle of the re-instantiated inode will differ from the original (since
i_ino and i_generation will have changed), NFS clients will cry ESTALE
anyway.

Steve


