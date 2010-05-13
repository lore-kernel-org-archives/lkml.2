Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0EMIbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 04:31:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50568 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab0EMIbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 04:31:21 -0400
Subject: Re: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <andreas.dilger@oracle.com>
In-Reply-To: <20100513171114.1629086b@notabene.brown>
Date: Thu, 13 May 2010 02:30:46 -0600
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Serge Hallyn <serue@us.ibm.com>,
       linux-fsdevel@vger.kernel.org, Steven French <sfrench@us.ibm.com>,
       Philippe Deniel <philippe.deniel@CEA.FR>,
       "linux-kernel@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <51B2B398-99A7-43BF-A074-ACFBBA318DF7@oracle.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1273679444-14903-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1DE62DE-D9E1-493B-8AEB-91E10D7D35B2@oracle.com> <20100513084310.5212728b@notabene.brown> <871vdg2ulx.fsf@linux.vnet.ibm.com> <20100513171114.1629086b@notabene.brown>
To: Neil Brown <neilb@suse.de>
X-Mailer: Apple Mail (2.1078)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090206.4BEBB8C2.00F9:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-05-13, at 01:11, Neil Brown wrote:
> Here is my reason (well, one of my reasons) why UUID is clearly not an
> acceptable handle to use - you *must* use an fd or are worst a path name.
> 
> A filesystem can be mounted at multiple places in the namespace and each
> instance can have other filesystems mounted on different directories.
> Each of these is a 'vfsmnt'.
> You need a vfsmnt for most (all?) filesystem operations.
> A UUID does not uniquely identify a vfsmnt.  It might uniquely identify a
> filesystem, though that is debatable.  It definitely does not uniquely
> identify a vfsmnt.
> Therefore, given only a UUID the kernel would have to arbitrarily choose a
> vfsmnt that references to the right filesystem.  If a particular directory in
> the filesystem that you want to access was mounted-on in that vfsmnt, that
> directory would be completely inaccessible to you, even though it might be
> completely accessible in some other vfsmnt.
> So it is quite possible for a scheme based on kernel interpretation of uuids
> to fail.

I think this is exactly the wrong solution for this case.  The lookup from pathname to handle happened ALREADY (in the presence of the right namespace and vfsmnt information) and all that should be required for the handle lookup is to get the exact same inode back from disk.  It is irrelevant what vfsmnt is used to do this lookup, so long as it is in the same filesystem as before.

> This may be a corner case, but I think people are slowly getting more
> adventurous in terms of using the mount table to do interesting things.  It
> may be less of a corner case in 5 years.

I think the important feature for the handle is that _regardless_ of what shenanigans are done with the path, over-mounting of directories, etc, that the same inode is returned.  One would expect that if a real fd was opened by a process, that any later changes to the namespace would not suddenly result in another file with the same pathname to be accessible by that fd.
 
> So to tell the kernel which filesystem is of interest for filehandle
> lookup, you *must* give it a name, whether a textual path, or a filehandle
> obtained by opening a textual path.

No, that is done at the time of open() (or in this case name_to_handle()) and afterward the name/path/vfsmnt is completely irrelevant to the fd/handle.

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

