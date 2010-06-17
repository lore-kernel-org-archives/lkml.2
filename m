Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab0FQXjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:39:22 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:22710 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab0FQXjU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:39:20 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=gq0nvmYvp2cA:10 a=ADBQPqJMlbwA:10 a=VphdPIyG4kEA:10
 a=kj9zAlcOel0A:10 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=Vt2AcnKqAAAA:8
 a=mDV3o1hIAAAA:8 a=20KFwNOVAAAA:8 a=KYjeUKazupo3Ttnf_osA:9
 a=l52A5aXkSjbukWT9NB_7jlUgmrIA:4 a=CjuIK1q_8ugA:10 a=ii61gXl28gQA:10
 a=jEp0ucaQiEUA:10 a=68aEXZssAjLDeYIt:21 a=NkkU9VJFCHxCcViF:21
Subject: Re: [PATCH v2] d_ino considered harmful
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <andreas.dilger@oracle.com>
In-Reply-To: <20100616195359.GA24382@shell>
Date: Thu, 17 Jun 2010 17:39:17 -0600
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       "linux-kernel@vger.kernel.org Mailinglist" 
	<linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2F857D9A-3B76-4309-8967-4405C6D609F0@oracle.com>
References: <20100616185913.GA15566@shell> <20100616195359.GA24382@shell>
To: Valerie Aurora <vaurora@redhat.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-16, at 13:54, Valerie Aurora wrote:
> On Wed, Jun 16, 2010 at 02:59:13PM -0400, Valerie Aurora wrote:
>> Who needs d_ino anyway?  I am running a kernel with this patch -
>> Gnome, a browser, IRC, kernel compile, etc. and everything works.
> 
> Gosh, maybe it would help to patch the currently used readdir instead
> of just old_readdir() (thanks, Arnd).  And return 1 instead of 0 so ls
> doesn't think all files are deleted (thanks, Andreas).
> 
> I'm running a kernel with the below patch and everything still works.
> Apparently "ls -i" is still using the bogus d_ino performance
> improvement mentioned here because it returns all 1's for inode
> number.

I don't see why the presence of d_ino is a "bogus" performance optimization.  It is useful for some things, and replacing this with "1" by no means helps anything IMHO, and destroys some useful optimizations (e.g. finding which inodes may be hard links), so I'm against this patch.

> http://www.mail-archive.com/bug-findutils@gnu.org/msg02531.html
> 
> -VAL
> 
> commit 5902fd7b7407e059c5cea1bf1ea101a1ff8a6072
> Author: Valerie Aurora <vaurora@redhat.com>
> Date:   Wed Jun 16 11:05:06 2010 -0700
> 
>    VFS: Always return 1 for d_ino
> 
>    Use of d_ino without the corresponding st_dev is always buggy in the
>    presence of submounts, bind mounts, and union mounts.  E.g., the d_ino
>    of a mountpoint will be the inode number of the directory under the
>    mountpoint, not the mounted directory.  Correct code must call stat(),
>    which returns the correct device ID and inode in st_dev and st_ino.
>    Since no one should be using d_ino anyway, always return 1 to detect
>    bugs.
> 
> diff --git a/fs/readdir.c b/fs/readdir.c
> index dd3eae1..5ff8f10 100644
> --- a/fs/readdir.c
> +++ b/fs/readdir.c
> @@ -91,11 +91,8 @@ static int fillonedir(void * __buf, const char * name, int namlen, loff_t offset
> 
> 	if (buf->result)
> 		return -EINVAL;
> -	d_ino = ino;
> -	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
> -		buf->result = -EOVERFLOW;
> -		return -EOVERFLOW;
> -	}
> +	/* Use of d_ino without st_dev is always buggy. */
> +	d_ino = 1;
> 	buf->result++;
> 	dirent = buf->dirent;
> 	if (!access_ok(VERIFY_WRITE, dirent,
> @@ -172,11 +169,8 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
> 	buf->error = -EINVAL;	/* only used if we fail.. */
> 	if (reclen > buf->count)
> 		return -EINVAL;
> -	d_ino = ino;
> -	if (sizeof(d_ino) < sizeof(ino) && d_ino != ino) {
> -		buf->error = -EOVERFLOW;
> -		return -EOVERFLOW;
> -	}
> +	/* Use of d_ino without st_dev is always buggy. */
> +	d_ino = 1;
> 	dirent = buf->previous;
> 	if (dirent) {
> 		if (__put_user(offset, &dirent->d_off))


Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

