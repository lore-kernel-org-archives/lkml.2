Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab0J0PYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:24:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab0J0PYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:24:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: nfsd changes for 2.6.37
Date: Wed, 27 Oct 2010 17:23:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-16-generic; KDE/4.5.1; x86_64; ; )
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bryan Schumaker <bjschuma@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101026164549.GD19445@fieldses.org> <20101027145538.GC6328@fieldses.org> <20101027145929.GA5788@infradead.org>
In-Reply-To: <20101027145929.GA5788@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010271723.59734.arnd@arndb.de>
X-Provags-ID: V02:K0:4EGyENZNNtkM1Z+UlbCpRwOc4Cm3oR9GTl61SfJu49k
 LAFBCOG0JixCQla4t8dT18SAfEtmnQZYVupkwuGrdsgTCVDKPJ
 Jqk22pSaS/0Mcw5lJIuoNIufEWBmZQQAYjxE4izzgES/1vFVp4
 Zko/CFTZcxxBhoGCoTYhMYemzfBVOrV6Crgmj007J0iVSIOyrD
 e2dmikk5twut69Igl+Gcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 October 2010, Christoph Hellwig wrote:
> On Wed, Oct 27, 2010 at 10:55:39AM -0400, J. Bruce Fields wrote:
> > Hm, two problems:
> > 	- We introduce the possibility of fcntl(fd, F_SETLEASE, F_UNLCK)
> > 	  failing with ENOMEM.
> 
> splitt ->setlease into ->add_least and ->delete_lease.  No need to pass
> in a structure for the later.  No need to return one either.

That sounds like a good way to get rid of a lot of special cases, too.

> > 	- fasync_helper(.,.,1,.) sleeps.  Argh.
> 
> That's not new..

It comes back to the original problem with Bruce's patch though:
fcntl_setlease wants to atomically add a lease or fail. If
fasync_helper fails, we want to remove the lease that was
just added before anyone can see it. At the very least we need
to keep the flock from getting freed in another thread while
we call fasync_helper without the lock.

locks_delete_lock is also called with lock_flocks held and calls
fasync_helper...

	Arnd
