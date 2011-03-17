Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab1CQHXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 03:23:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53853 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1CQHXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 03:23:48 -0400
Date: Thu, 17 Mar 2011 07:23:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] mnt_devname queue
Message-ID: <20110317072344.GZ22723@ZenIV.linux.org.uk>
References: <20110316235608.GY22723@ZenIV.linux.org.uk>
 <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimF9ExskxBmebk7X2=g5S6OK5vAa05G1cgeVVCP@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 01:45:33PM +0800, Xiaotian Feng wrote:

> I guess we need also switch pstore from ->get_sb() to ->mount()
> 
> fs/pstore/inode.c:253: error: unknown field ???get_sb??? specified in initializer
> fs/pstore/inode.c:253: warning: initialization makes integer from
> pointer without a cast
> fs/pstore/inode.c:253: error: initializer element is not computable at load time
> fs/pstore/inode.c:253: error: (near initialization for
> ???pstore_fs_type.fs_flags???)

Yes.  I've just looked at that thing and I see several, er, issues.

a) What the hell would you expect to happen if userland mounts it twice
and unmount the first one?  pstore_sb = NULL, pstore_mnt = NULL, AFAICS.

b) pstore_writefile() - struct file on stack?  Really?  Again, in the
scenario above, what'll happen to you if pstore_mnt gets dropped and
freed in the middle of all that?

c) in the same function:
+       memset(&f, '0', sizeof f);
Ahem...

d)
+               if (pstore_is_mounted())
+                       pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id,
+                                     psinfo->buf, hsize + l1_cpy + l2_cpy,
+                                     CURRENT_TIME, psinfo->erase);

And what happens if it's unmounted between the check and use?  pstore_mkfile()
pretty much starts with dereferencing pstore_sb...

e) as the matter of fact, what happens if it's unmounted in the _middle_ of
pstore_mkfile()?

f) in general it's a lousy policy to tie that kind of difference in behaviour
to "somebody has it mounted someplace at the moment", even without the races
a-la (a)...
