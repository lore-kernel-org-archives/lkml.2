Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0ESIwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:52:40 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:34338 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab0ESIwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:52:37 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Dave Chinner <david@fromorbit.com>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
In-Reply-To: <9972.1274253351@jrobl>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <7252.1274150030@jrobl> <87fx1ppy21.fsf@linux.vnet.ibm.com> <20100518064336.GE2150@dastard> <877hn1pl97.fsf@linux.vnet.ibm.com> <9972.1274253351@jrobl>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Wed, 19 May 2010 14:22:22 +0530
Message-ID: <87d3wsl1dl.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 May 2010 16:15:51 +0900, "J. R. Okajima" <hooanon05@yahoo.co.jp> wrote:
> 
> "Aneesh Kumar K. V":
> > Now that we are not doing UUID based vfsmount lookup this make
> > sense. Will update in the next iteration with UUID to be part of
> > super_block.
> 
> Because this UUID is just for some FS's userspace helpers (in other
> words, returning UUID is FS specific behaviour), I am afraid it is not a
> good ideat to put the array into generic super_block.

UUID should be looked at as the file system identifier and IMHO struct
super_block is the right place to hold it. For ex: ext*  put then in
ext*_super_block. File system that doesn't support UUID can leave the
superblock field zero filled.


> 
> About the design or approach, this might have been discussed earlier,
> but I'd like to suggest to clarify some points here.
> - While these new systemcalls provide generic features, the
>   implementation depends upon s_export_op, ie. NFS-exporting.
>   It means there are two requirements for these systemcalls, enabling
>   CONFIG_EXPORTFS and FS has to set s_export_op.
>   Is this acceptable?


I think exportfs is the right interface we want to depend on for
generating a handle. We should not be having another parallel interface for file
handle generation. But agreed that we should return -EOPNOTSUPP in case
EXPORTFS is disabled.


> 
> - exportfs_encode_fh() supports the default encoding
>   export_encode_fh(), but exportfs_decode_fh() doesn't.
>   The latest patch series modifes exportfs_decode_fh() to return ESTALE,
>   but I'd suggest to make the caller of export_encode_fh() to check
>   s_export_op->fh_to_dentry() and return ENOSYS.

I will fix to make the syscall return EOPNOTSUPP in case fh_to_dentry is
not supported. But i guess we still need to keep the change in
exportfs_decode_fh to return -ESTALE in case these operations are not definied.



>   Or implement the default decode routine as a contrast of
>   export_encode_fh().
> 
> - Some FS (or its userspace helper) may want to put UUID into the
>   handle. If those FS already have UUID in their fs private_data, then
>   putting a pointer (instead of an array) is better.
>   Or creating two new operations in s_op to encode/decode handle
>   may be good too (regardless CONFIG_EXPORTFS). The generic
>   implementations should be provided, and when these function pointers
>   in s_op are not set, they should be called as default. These generic
>   implementaions will be able to be used by expfs.c too. And UUID in
>   super_block will be unnecessary.


IMHO that would be over design. We can depend on exportfs
interfaces and if not defined return EOPNOTSUPP.

-aneesh
