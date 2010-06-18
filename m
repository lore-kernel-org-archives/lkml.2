Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0FRBmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 21:42:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21234 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab0FRBmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 21:42:44 -0400
References: <20100616185913.GA15566@shell> <20100616195359.GA24382@shell> <1276721084.13788.53.camel@lap75545.ornl.gov> <30568.1276797848@jrobl>
Message-Id: <A8B216D0-06C5-4D85-9AA6-EB4C9E87D26B@oracle.com>
From: Andreas Dilger <andreas.dilger@oracle.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
In-Reply-To: <30568.1276797848@jrobl>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7E18)
Mime-Version: 1.0 (iPhone Mail 7E18)
Subject: Re: [PATCH v2] d_ino considered harmful
Date: Thu, 17 Jun 2010 19:41:25 -0600
Cc: David Dillow <dillowda@ornl.gov>, Valerie Aurora <vaurora@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Andreas Dilger <adilger@sun.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4C1ACEEE.010D:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2010-06-17, at 12:04, "J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:

>
> I am interested in this simplified
> problem such as "find the pathname(s) from an inum in a huge fs."
> Is ne2scan essentially equivalent to "debugfs ncheck inum"?

The (n)e2scan program is essentially just an optimized ext3 inode  
table scanner we wrote for Lustre that walks the inode table in order,  
and optimistically reads directory inode blocks (in disk offset order)  
and matches the inode numbers to an icrementally-build tree of parent  
directories when the directory entries appear. Since the most common  
case is that parent has a lower inode number than the subdirectories  
there is rarely a need to keep whole subdirectories in memory.  This  
is fairly efficient when dumping the whole Filesystem, since it makes  
a single pass over the metadata, though it is inefficient when doing a  
small subset of the filesystem.

As the name implies, it is very extN specific. For Lustre 2.0 we use a  
different method to get O(1) FID (inode number) to pathname(s)  
lookup.  Each file stores an xattr with the {parent FID, filename}  
tuples for each link to the file, whenever an inode is created,  
linked, unlinked, or renamed.

In the common case, storing the filename and parent FID adds no  
overhead to these operations since the inode needs to be written to  
update the nlink count anyway, and the xattr can be stored in the  
inode and does not generate extra IO unless there are more hard links  
than can fit in the inode.

This allows doing optimized pathname generation for all links to a  
file, and can in theory be used for any type of filesystem that has  
efficient xattr storage.
