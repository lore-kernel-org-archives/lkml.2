Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0GBWwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 18:52:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49768 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab0GBWwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 18:52:51 -0400
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <andreas.dilger@Oracle.com>
In-Reply-To: <20100703080904.78e4e7e1@notabene.brown>
Date: Fri, 2 Jul 2010 16:47:56 -0600
Cc: hch@infradead.org, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "adilger@sun.com" <adilger@sun.com>, "corbet@lwn.net" <corbet@lwn.net>,
       "serue@us.ibm.com" <serue@us.ibm.com>,
       "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
       "bfields@fieldses.org" <bfields@fieldses.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "sfrench@us.ibm.com" <sfrench@us.ibm.com>,
       "philippe.deniel@CEA.FR" <philippe.deniel@CEA.FR>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <51D3ECAD-F5AA-4090-91EE-0B3A2C67F335@oracle.com>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <871vbn2mk9.fsf@linux.vnet.ibm.com> <20100702064108.64034561@notabene.brown> <A44260DA-245D-47DD-820E-2F4F1F50BB9D@oracle.com> <20100702070548.GA6959@infradead.org> <BEEA47B4-4C9E-4086-96D2-FA6B8F68DA68@oracle.com> <20100703080904.78e4e7e1@notabene.brown>
To: Neil Brown <neilb@suse.de>
X-Mailer: Apple Mail (2.1078)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C2E6DAD.01D6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-02, at 16:09, Neil Brown wrote:
> On Fri, 2 Jul 2010 10:12:47 -0600
> Andreas Dilger <andreas.dilger@oracle.com> wrote:
>> 
>> I haven't looked at this part of the VFS in a while, but it looks like reconnect_path() is an implementation issue specific to knfsd, and shouldn't be needed for regular files.  i.e. if exportfs_encode_fh() is never used on a disconnected file, then this overhead is not incurred.
>> 
>> The above use of open_by_handle() is not for userspace NFS/Samba re-export, but to allow applications to open regular files for IO.  
> 
> Firstly it is needed for directories so that the VFS can effectively lock
> against directory rename races which could otherwise create disconnected
> subtrees (where the first parent is a member only of one of its
> descendants).  So if you get a filehandle for a directory it *must* be
> properly connected to the root for rename to be safe.  This operation is
> faster than a full path lookup if the dentry is already is cache, and slower
> if it and any of the path is not in cache.

OK, so this requirement is specific for directories, and not at all needed for regular files.

> Secondly it is needed if you want to enforce the rule that the contents of a
> directory are only accessible if the 'x' bit on the directory is set.
> kNFSd does not enforce this (unless subtree_check is specified), partly
> because it is hard to do correctly and partly because we have to trust the
> client any, so trusting it to check the 'x' bit is very little extra trust.

If the application that called name_to_handle() already had to traverse the whole pathname to get the file handle, then there shouldn't necessarily be a requirement to do this when calling open_by_handle().  The only possible permission checking in open_by_handle() is the permission on the inode itself.

> Note that it is not possible to reliably perform filehandle lookup for
> non-directories if you need a fully reconnected dentry, as
> cross-directory-renames can confuse the situation beyond recovery.

For normal file IO, a fully connected dentry is not needed, and in fact the handle_to_path->exportfs_decode_fh() code will accept any inode alias for reguar file use.

> Maybe open-by-handle should require DAC_OVERRIDE, or maybe a new
> DAC_X_OVERRIDE. And if those aren't provided it only works for directories. 

That's the big question.  If the file handle has some "non-public" information in it (i.e. a capability that cannot be (easily) guessed or forged), then there should not be any need for DAC_OVERRIDE.  This could easily be enforced if there was a provision for "short term" file handles that only had to live a few minutes or less, so the kernel could just store a random cookie in each file handle and require applications to get a new handle if the cookie expires or the server crashes.

However, even a "plain" file handle containing only the inode/generation is relatively secure in this respect, since the only way to get the inode number of a particular file is "ls -li" (which either assumes path "x" traversal permission, OR guessing the inode number), and ioctl(FS_IOC_GETVERSION) which requires being able to open the inode already.

Guessing the inode number by itself is fairly weak, at most 2^32 inodes in most filesystems, usually far fewer.  Guessing the generation number is much harder (though not impossible).

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

