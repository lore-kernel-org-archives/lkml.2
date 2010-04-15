Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0DOPSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:18:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0DOPSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:18:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Whitehouse <steve@chygwyn.com>
Subject: Re: [PATCH 2/2] [RFC] Remove BKL from fs/locks.c
Date: Thu, 15 Apr 2010 17:17:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Steve French <sfrench@us.ibm.com>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <1271277384-7627-2-git-send-email-arnd@arndb.de> <1271342931.7196.120.camel@localhost.localdomain>
In-Reply-To: <1271342931.7196.120.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004151717.15881.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX195I6iqx9yKhjD3ArYdG8AsXhaMiizRbVAV98J
 LWVT+yu4CWAlBJQDJ3XVmzu6zE5MXYQbE7hcpAoO73mOgS0XX1
 W1MNLVA3OU0La2Zcf22ag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 April 2010, Steven Whitehouse wrote:

> Some comments...

I'll wait for Willy to comment on most of these, except

> On Wed, 2010-04-14 at 22:36 +0200, Arnd Bergmann wrote:
> > @@ -1467,12 +1492,9 @@ int vfs_setlease(struct file *filp, long arg, struct file_lock **lease)
> >  {
> >  	int error;
> >  
> > -	lock_kernel();
> > -	if (filp->f_op && filp->f_op->setlease)
> > -		error = filp->f_op->setlease(filp, arg, lease);
> > -	else
> > -		error = generic_setlease(filp, arg, lease);
> > -	unlock_kernel();
> > +	lock_flocks();
> > +	error = __vfs_setlease(filp, arg, lease);
> > +	unlock_flocks();
> >  
> This looks to me like generic_setlease() or whatever fs specific
> ->setlease() there might be will be called under a spin lock. That
> doesn't look right to me.
> 
> Rather than adding locking here, why not push the BKL down into
> generic_setlease() and ->setlease() first, and then eliminate it on a
> case by case basis later on? That is the pattern that has been followed
> elsewhere in the kernel.

Sounds fair. Besides generic_setlease (which is in this file as well),
the only non-trivial one is cifs_setlease (Cc'ing Steve French now)
and that calls generic_setlease in the end.

If we can show that cifs_setlease does not need locking, the new lock
could be put into generic_setlease directly.

	Arnd
