Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab0EMWzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:55:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51084 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab0EMWzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:55:22 -0400
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <andreas.dilger@oracle.com>
In-Reply-To: <878w7n1xb3.fsf@linux.vnet.ibm.com>
Date: Thu, 13 May 2010 16:54:11 -0600
Cc: Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Serge Hallyn <serue@us.ibm.com>,
       linux-fsdevel@vger.kernel.org, Steven French <sfrench@us.ibm.com>,
       Philippe Deniel <philippe.deniel@CEA.FR>,
       "linux-kernel\@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <B93EA6D0-4D21-46B2-988C-A7A307EBE0B7@oracle.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1273679444-14903-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com> <20100513084310.5212728b@notabene.brown> <871vdg2ulx.fsf@linux.vnet.ibm.com> <20100513171114.1629086b@notabene.brown> <51B2B398-99A7-43BF-A074-ACFBBA318DF7@oracle.com> <8739xvevbw.fsf@linux.vnet.ibm.com> <878w7n1xb3.fsf@linux.vnet.ibm.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1078)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4BEC834A.0160:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-05-13, at 12:17, Aneesh Kumar K. V wrote:
> How about below interface
> 
> sys_open_by_handle_at(int mountdirfd, struct file_handle *handle, int
> flags)
> 
> if mountdirfd == 0
>   use UUID specified in the file handle to lookup vfsmount
> else
>   else use mountdirfd to get the vfsmount

fd = 0 is a valid descriptor, though -1 is not.  I'd be OK with this, because it still means we can use the UUID to positively identify the filesystem (it would also avoid the need to do a by-UUID lookup in most cases, since the dirfd would already point to a filesystem and we can just compare the handle UUID with the UUID for that superblock.

The question is what to do if the UUID in the file handle does not match the filesystem that is passed via vfsmount?  It would seem that vfsmount is needed for determining the namespace and possibly disambiguating multiple mounts of snapshots with the same UUID.  Independent of that if the UUID is not matching the underlying filesystem that the vfsmount is pointing to the open should fail with -ESTALE.

If the UUID is not the same, then the chance that the inode/generation stored in the file handle are still useful is slim.  If someone is cloning the filesystem down to the inode number, then they can clone the UUID as well.

In summary, I'm OK with this approach.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

