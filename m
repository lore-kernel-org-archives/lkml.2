Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905Ab0GJE7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 00:59:01 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47908 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0GJE67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 00:58:59 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@dilger.ca>, Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
       Christoph Hellwig <hch@infradead.org>,
       "viro\@zeniv.linux.org.uk Viro" <viro@zeniv.linux.org.uk>,
       "corbet\@lwn.net Corbet" <corbet@lwn.net>,
       "hooanon05\@yahoo.co.jp Okajima" <hooanon05@yahoo.co.jp>,
       linux-fsdevel@vger.kernel.org,
       "sfrench\@us.ibm.com French" <sfrench@us.ibm.com>,
       "philippe.deniel\@CEA.FR Deniel" <philippe.deniel@CEA.FR>,
       "linux-kernel\@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
In-Reply-To: <5DF5C974-092B-4CE6-B11D-2DBB73782149@dilger.ca>
References: <20100706161002.GD7387@fieldses.org> <87eifgfsez.fsf@linux.vnet.ibm.com> <20100706232351.GD25018@dastard> <20100707093629.10c2feab@notabene.brown> <20100707021150.GF25018@dastard> <20100707125726.3695587a@notabene.brown> <20100707125701.GA19872@fieldses.org> <E1OWUOL-0004DM-Ul@pomaz-ex.szeredi.hu> <20100707131721.GB19872@fieldses.org> <E1OWUn0-0004JI-7F@pomaz-ex.szeredi.hu> <20100707144511.GA24360@fieldses.org> <20100708082143.3701bfc7@notabene.brown> <87wrt6dzp2.fsf@linux.vnet.ibm.com> <20100708222121.5c0612ef@notabene.brown> <5DF5C974-092B-4CE6-B11D-2DBB73782149@dilger.ca>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sat, 10 Jul 2010 10:28:37 +0530
Message-ID: <87r5jcc4qq.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010 12:42:42 -0600, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2010-07-08, at 06:21, Neil Brown wrote:
> > On Thu, 08 Jul 2010 16:10:09 +0530
> > "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> >> How about adding mnt_id to the handle ? Documentation file says it is unique 
> >> 
> >> (1) mount ID:  unique identifier of the mount (may be reused after umount)
> 
> But this value is not persistent across a reboot, or even an
> umount/mount so it is not useful as an identifier.


mount id should not be looked at as a persistent identifier. It should
be used to derive a persistent identifier from /proc/self/mountinfo. The
persistent identifier could be the combination of device properties,
file system properties or the uuid which is going to be an optional
tag in /proc/self/mountinfo. 

This also implies we need to hold a reference in the mount to make sure
we can safely lookup uuid using mount id.

> 
> I suppose one way to resolve this issue is to just allow the
> underlying filesystem to supply a completely opaque filehandle to
> userspace.  For local filesystems that don't care about persistence or
> uniqueness between nodes they can use something like mount_id, and for
> distributed/clustered filesystems they can include a globally-unique
> identifier.


We could use mountid to get the persistent id from mountinfo right ? So
file handle request would include

fd = open(name);
file_handle = fd_to_handle(fd);
fs_uuid = get_uuid(file_handle.mnt_id);
close(fd);

So for your usecase the handle send to other nodes include will include
cluster_fs_uuid and file_identifier. 

-aneesh


