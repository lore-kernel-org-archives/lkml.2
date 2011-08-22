Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1HVN1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:27:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54110 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1HVN1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:27:17 -0400
Date: Mon, 22 Aug 2011 14:27:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Boyer <jwboyer@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: INFO: possible circular locking dependency detected
 3.1.0-rc2-00190-g3210d19
Message-ID: <20110822132713.GT2203@ZenIV.linux.org.uk>
References: <4E51CFD8.2090508@gmail.com>
 <CA+5PVA6KUMDEygjxrqwvpRDNfJ3WobUs7rwyP+pZrX9-atZUgw@mail.gmail.com>
 <20110822131621.GS2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822131621.GS2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 02:16:21PM +0100, Al Viro wrote:
> On Mon, Aug 22, 2011 at 09:09:14AM -0400, Josh Boyer wrote:
> 
> > We've had a report of this on 3.0.1 as well.  Slightly different
> > scenario and fs, but the locks in question are the same.
> > https://bugzilla.redhat.com/show_bug.cgi?id=730998
> > 
> > It seems that with CONFIG_PROVE_LOCKING on, might_fault will always
> > attempt to grab mm->mmap_sem.  The common flow here is that getdents
> > calls filldir, which calls copy_to_user, which is what is calling
> > might_fault.
> > 
> > Beyond that, I'm a bit over my head at the moment because I don't know
> > if the VFS is right and we just need some more lockdep annotations or
> > if there really is a problem.
> 
> Don't grab ->i_mutex in ->evict_inode().  Why are you doing that, anyway?

Note, BTW, that readdir() is a red herring here; there is a much more
relevant reason for that ranking.  Namely, write() doing copy_from_user()
when the file we are writing into has i_mutex held by us.  That can fault
and in this case we have a non-directory inode.  While you can't have
directory mmapped, regular files can be mmapped just fine.
