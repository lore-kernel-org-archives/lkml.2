Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2AXSn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:43:57 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:36420 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2AXSnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:43:55 -0500
Subject: Re: [PATCH v1] vfs: fix IMA lockdep circular locking dependency
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-security-module@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Date: Tue, 24 Jan 2012 13:40:50 -0500
In-Reply-To: <1327427142.4131.4.camel@localhost>
References: <1327426472-25275-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1327427142.4131.4.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1327430451.2129.22.camel@falcor>
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012418-2398-0000-0000-000003A70AE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 12:45 -0500, Eric Paris wrote:
> On Tue, 2012-01-24 at 12:34 -0500, Mimi Zohar wrote:
> > The circular lockdep is caused by allocating the 'iint' for mmapped
> > files.  Originally when an 'iint' was allocated for every inode
> > in inode_alloc_security(), before the inode was accessible, no
> > locking was necessary.  Commits bc7d2a3e and 196f518 changed this
> > behavior and allocated the 'iint' on a per need basis, resulting in
> > the mmap_sem being taken before the i_mutex for mmapped files.
> > 
> > Possible unsafe locking scenario:
> >        CPU0                    CPU1
> >        ----                    ----
> > lock(&mm->mmap_sem);
> >                               lock(&sb->s_type->i_mutex_key);
> >                               lock(&mm->mmap_sem);
> > lock(&sb->s_type->i_mutex_key);
> > 
> > The existing security_file_mmap() hook is after the mmap_sem is taken.
> > This patch moves the ima_file_mmap() call from security_file_mmap() to
> > prior to the mmap_sem being taken.
> > 
> > Changelog v1:
> > - Instead of just pre-allocating the iint in a new hook, do ALL of the
> > work in the new/moved ima_file_mmap() hook. (Based on Eric Paris' suggestion.)
> > - Removed do_mmap_with_sem() helper function.
> > - export ima_file_mmap()
> 
> Why does it need to be exported?  What module might call this?

Without it, I'm getting:

Kernel: arch/x86/boot/bzImage is ready  (#246)
ERROR: "ima_file_mmap" [arch/x86/ia32/ia32_aout.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Mimi

