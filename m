Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458Ab0GGO7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 10:59:14 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:48811 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab0GGO7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 10:59:12 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=oACb-Ty_HC0A:10 a=ygRHs6EKU7oA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=pGLkceISAAAA:8
 a=q5w7pDEZZBJ0lJ9crBkA:9 a=3SjviPVbt9FhZMJEd9RsTZTuPi0A:4 a=CjuIK1q_8ugA:10
 a=MSl-tDqOz04A:10
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats available [ver #3]
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <4859.1278341989@redhat.com>
Date: Wed, 7 Jul 2010 08:57:54 -0600
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, linux-ext4@vger.kernel.org,
       linux-api@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9A36AB6B-7EC3-4789-89CD-D00715BEF34C@dilger.ca>
References: <AANLkTinms69HPgZF4blqr962Ami3oS9FC-txQj9P37SC@mail.gmail.com> <20100630233614.32422.97038.stgit@warthog.procyon.org.uk> <4859.1278341989@redhat.com>
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-05, at 08:59, David Howells wrote:
> Michael Kerrisk <mtk.manpages@gmail.com> wrote:
> 
>> * Include information from the "inode_info" structure, most notably
>> i_flags, but perhaps other info as well.
> 
> This thought has occurred to me, but are the contents of i_flags identical for
> all filesystems?  Certainly, i_flags doesn't seem to match the FS_IOC_GETFLAGS
> mask.  For example:
> 
> 	#define	FS_SECRM_FL			0x00000001
> 
> vs:
> 
> 	#define S_SYNC		1	/* Writes are synced at once */
> 
> (1) Does it make sense to rearrange the S_xxxx flags to match the numbers for
>   FS_xxxx_FL?

I saw your patch to that effect.  I'm of mixed feelings about this, since the S_* flags have traditionally been changed on an ad-hoc basis and I don't necessarily want to let this leak into the on-disk format of these flags for ext*.

One way to ensure that this holds true is to have a compile-time assertion that the respective S_* flags match FS_*_FL and EXT_*_FL.

We use a macro in Lustre for compile-time assertions that depends on the detection of duplicate values in a switch() statement:

/** Compile-time assertion.
* Check an invariant described by a constant expression at compile time by
* forcing a compiler error if it does not hold.  @cond must be a constant
* expression as defined by the ISO C Standard:
*
*       6.8.4.2  The switch statement
*       ....
*       [#3] The expression of each case label shall be  an  integer
*       constant   expression  and  no  two  of  the  case  constant
*       expressions in the same switch statement shall have the same
*       value after conversion...
*
*/
#define CLASSERT(cond) do {switch(42) {case (cond): case 0: break;}} while (0)

> (2) Does it make sense to do the BSD st_flags compatibility in userspace?
> 
> (3) Can we add a couple more flags to make Samba's life easier?  Say an
>   archived bit and a hidden bit?

I wouldn't object to that.  The BSD flags indicate that the hidden bit should only affect GUI display managers, not "ls".

> (4) Do I actually need to provide a mask saying what st_flags are applicable
>   to the file you've just queried?

Hmm, good question.

> (5) How often are these flags required?  E.g. does it make more sense to keep
>   them as an additional result, or does it make sense to stick them in the
>   kstat and xstat structs, knowing that these are allocated on the kernel
>   stack maybe as three times if an ecryptfs file?

If they aren't requested by userspace, the cost is mostly irrelevant.  I think on OSX these flags are returned for every "ls" call, to mark the inodes with xattrs every time.

Cheers, Andreas





