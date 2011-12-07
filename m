Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab1LGQdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:33:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52178 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab1LGQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:32:58 -0500
Date: Wed, 7 Dec 2011 16:32:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
Message-ID: <20111207163253.GD2203@ZenIV.linux.org.uk>
References: <CA+55aFyaz7K4V5xLmaQ9GK=5LA1mbRdVGCFspET=y6ode_i=jg@mail.gmail.com>
 <20111207011047.GQ2203@ZenIV.linux.org.uk>
 <20111207013720.GS2203@ZenIV.linux.org.uk>
 <201112070326.pB73QPZo042162@www262.sakura.ne.jp>
 <20111207034238.GX2203@ZenIV.linux.org.uk>
 <201112070501.pB751LoP064331@www262.sakura.ne.jp>
 <20111207051908.GA2203@ZenIV.linux.org.uk>
 <201112070544.pB75iX12072157@www262.sakura.ne.jp>
 <20111207065437.GB2203@ZenIV.linux.org.uk>
 <201112070859.pB78xn7x007845@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112070859.pB78xn7x007845@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 05:59:49PM +0900, Tetsuo Handa wrote:
> Al Viro wrote:
> > BTW, what your current code does if you have a file bound on another
> > file, open it, umount -l it, let the dust settle and then do some operation
> > that triggers tomoyo_get_absolute_path() on it?  Because you'll be getting
> > a vfsmount/dentry pair that has
> > 	* dentry == vfsmount->mnt_root
> > 	* vfsmount->mnt_parent == vfsmount
> > 	* dentry->d_inode being a non-directory
> > and there is nothing whatsoever in what remains of the pathname.  Not a single
> > component.  IOW, you'll get "/" in buf.  Might be good in a testsuite - is
> > there any code in security/tomoyo that would be relying on assumption that
> > only directory might have a name entirely without components?
> 
> TOMOYO assumes that only directory ends with '/'.

Then it's broken in the current mainline (and had been for as long as it
had been using __d_path()).  Because that's all you'll get from it
for such vfsmount/dentry pair...

> Among above three results, the last one will be the best.

OK, I'm fine with your patch; for bisectability sake it ought to go before
mine, with mine on top of it.

How will we do that?  Should I put it into vfs.git#for-linus before __d_path()
patch and ask Linus to pull that?
