Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031127Ab2CAOjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 09:39:07 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:39651 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966059Ab2CAOjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 09:39:04 -0500
Date: Thu, 1 Mar 2012 09:38:59 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Jacek Luczak <difrost.kernel@gmail.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: getdents - ext4 vs btrfs performance
Message-ID: <20120301143859.GX5054@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Theodore Tso <tytso@MIT.EDU>,
	Jacek Luczak <difrost.kernel@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
 <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F4F8A06.0139,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 11:44:31PM -0500, Theodore Tso wrote:
> You might try sorting the entries returned by readdir by inode number before you stat them.    This is a long-standing weakness in ext3/ext4, and it has to do with how we added hashed tree indexes to directories in (a) a backwards compatible way, that (b) was POSIX compliant with respect to adding and removing directory entries concurrently with reading all of the directory entries using readdir.
> 
> You might try compiling spd_readdir from the e2fsprogs source tree (in the contrib directory):
> 
> http://git.kernel.org/?p=fs/ext2/e2fsprogs.git;a=blob;f=contrib/spd_readdir.c;h=f89832cd7146a6f5313162255f057c5a754a4b84;hb=d9a5d37535794842358e1cfe4faa4a89804ed209
> 
> … and then using that as a LD_PRELOAD, and see how that changes things.
> 
> The short version is that we can't easily do this in the kernel since it's a problem that primarily shows up with very big directories, and using non-swappable kernel memory to store all of the directory entries and then sort them so they can be returned in inode number just isn't practical.   It is something which can be easily done in userspace, though, and a number of programs (including mutt for its Maildir support) does do, and it helps greatly for workloads where you are calling readdir() followed by something that needs to access the inode (i.e., stat, unlink, etc.)
> 

For reading the files, the acp program I sent him tries to do something
similar.  I had forgotten about spd_readdir though, we should consider
hacking that into cp and tar.

One interesting note is the page cache used to help here.  Picture two
tests:

A) time tar cf /dev/zero /home

and

cp -a /home /new_dir_in_new_fs
unmount / flush caches
B) time tar cf /dev/zero /new_dir_in_new_fs

On ext, The time for B used to be much faster than the time for A
because the files would get written back to disk in roughly htree order.
Based on Jacek's data, that isn't true anymore.

-chris
