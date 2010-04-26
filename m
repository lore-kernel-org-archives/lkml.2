Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab0DZIbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 04:31:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60380 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab0DZIbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 04:31:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Date: Mon, 26 Apr 2010 10:30:21 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <20100425173912.GA5375@nowhere> <alpine.LFD.2.00.1004251040340.3739@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004251040340.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004261030.21751.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19m+XIiM6B+0trDIcGwWMID1XQx7CGkGqwYjoz
 ROMNEk1abYBiW984p6x2OMH0oNVel5k+GO0EKCkikfmVn9Pgj3
 SBBM9nLkf09cvXMuWuS2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 April 2010 19:49:51 Linus Torvalds wrote:
> In the long run (this is a year from now, when we rename "unlocked_ioctl" 
> back to just "ioctl"), the vfs_ioctl code will just do
> 
>                 struct file_operations *fops = filp->f_op;
> 
>                 if (!fops)
>                         return -ENOTTY;
> 
>                 if (fops->ioctl) {
>                         int error = fops->ioctl(...)
>                         if (error == -ENOIOCTLCMD)
>                                 error = -EINVAL;
>                         return error;
>                 }
>         #ifdef CONFIG_BKL
>                 if (fops->bkl_ioctl) {
>                         int error;
>                         lock_kernel();
>                         error = fops->bkl_ioctl(...)
>                         unlock_kernel();
>                         return error;
>                 }
>         #endif
>                 return -ENOTTY;

We could also stop playing games with with this and just kill the
locked variant of ioctl right away. No rename to bkl_ioctl, no
helper functions.

It's served it's purpose and we now have the list of 157 files
that still use fops->ioctl, so if we just push the BKL into those
files and make them use unlocked_ioctl, we will be able to remove
->ioctl for good. We can do the rename of ->unlocked_ioctl to
->ioctl right after that if you like, or in a year from now, I
don't care.

	Arnd
