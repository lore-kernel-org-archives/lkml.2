Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0ESHVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 03:21:40 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:33789 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab0ESHVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 03:21:38 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, neilb@suse.de, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
In-Reply-To: <877hn1pl97.fsf@linux.vnet.ibm.com>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <7252.1274150030@jrobl> <87fx1ppy21.fsf@linux.vnet.ibm.com> <20100518064336.GE2150@dastard> <877hn1pl97.fsf@linux.vnet.ibm.com>
Date: Wed, 19 May 2010 16:15:51 +0900
Message-ID: <9972.1274253351@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"Aneesh Kumar K. V":
> Now that we are not doing UUID based vfsmount lookup this make
> sense. Will update in the next iteration with UUID to be part of
> super_block.

Because this UUID is just for some FS's userspace helpers (in other
words, returning UUID is FS specific behaviour), I am afraid it is not a
good ideat to put the array into generic super_block.

About the design or approach, this might have been discussed earlier,
but I'd like to suggest to clarify some points here.
- While these new systemcalls provide generic features, the
  implementation depends upon s_export_op, ie. NFS-exporting.
  It means there are two requirements for these systemcalls, enabling
  CONFIG_EXPORTFS and FS has to set s_export_op.
  Is this acceptable?

- exportfs_encode_fh() supports the default encoding
  export_encode_fh(), but exportfs_decode_fh() doesn't.
  The latest patch series modifes exportfs_decode_fh() to return ESTALE,
  but I'd suggest to make the caller of export_encode_fh() to check
  s_export_op->fh_to_dentry() and return ENOSYS.
  Or implement the default decode routine as a contrast of
  export_encode_fh().

- Some FS (or its userspace helper) may want to put UUID into the
  handle. If those FS already have UUID in their fs private_data, then
  putting a pointer (instead of an array) is better.
  Or creating two new operations in s_op to encode/decode handle
  may be good too (regardless CONFIG_EXPORTFS). The generic
  implementations should be provided, and when these function pointers
  in s_op are not set, they should be called as default. These generic
  implementaions will be able to be used by expfs.c too. And UUID in
  super_block will be unnecessary.

If my English is broken and hard to understand, please let me know.


J. R. Okajima
