Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab1EILM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 07:12:27 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:36237 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1EILMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 07:12:25 -0400
Date: Mon, 9 May 2011 13:12:24 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Hugh Dickins <hughd@google.com>
cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
In-Reply-To: <alpine.LSU.2.00.1105081303540.16151@sister.anvils>
Message-ID: <alpine.DEB.2.00.1105091307570.32299@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz> <alpine.LSU.2.00.1105081303540.16151@sister.anvils>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 May 2011, Hugh Dickins wrote:

> On Sun, 8 May 2011, Mikulas Patocka wrote:
> 
> > Don't mlock guardpage if the stack is growing up
> > 
> > Linux kernel excludes guard page when performing mlock on a VMA with 
> > down-growing stack. However, some architectures have up-growing stack and 
> > locking the guard page should be excluded in this case too.
> > 
> > This patch fixes lvm2 on PA-RISC (and possibly other architectures with 
> > up-growing stack). lvm2 calculates the number of used pages when locking 
> > and when unlocking and reports an internal error if the numbers mismatch. 
> > On PA-RISC, the kernel would incorrectly attempt to mlock the stack guard 
> > page, this causes allocation of one more page and internal error in lvm2.
> > 
> > Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
> 
> Interesting, I'd convinced myself that the growsup case was safe,
> because of how we always approach the vma from its bottom end.
> 
> I've added Michel to the Cc, he's the one with the best grasp here.
> 
> Could you point us to where lvm2 is making these calculations?
> I don't understand quite what it's doing.
> 
> Thanks,
> Hugh

See ./lib/mm/memlock.c in LVM2. It reads /proc/self/maps, parses the file 
and locks each map with mlock, except for glibc locale file.

It calculates how much memory it took when locking and unlocking and 
prints an internal error if the numbers differ. The internal error 
normally means that there was some memory allocated while it was locked 
(that is wrong).

However, on up-growing stack, the internal error is always triggered, 
because mlock() of the stack touches the guard page and allocates one more 
page.

Mikulas
