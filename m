Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2B0R3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:29:35 -0500
Received: from mail.betterlinux.com ([199.58.199.50]:46596 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2B0R3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:29:34 -0500
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 40ED982A20
Date: Mon, 27 Feb 2012 18:29:30 +0100
From: Andrea Righi <andrea@betterlinux.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@kernel.org,
        Alex =?iso-8859-1?B?VmlsbGFj7a1z?= Lasso 
	<a_villacis@palosanto.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] zcache: avoid AB-BA deadlock condition
Message-ID: <20120227172930.GB1650@thinkpad>
References: <1329739909-3174-1-git-send-email-andrea@betterlinux.com>
 <e60d5136-c2d2-45a4-97f4-5d8e58b12000@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e60d5136-c2d2-45a4-97f4-5d8e58b12000@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 09:23:24AM -0800, Dan Magenheimer wrote:
> > From: Andrea Righi [mailto:andrea@betterlinux.com]
> > Sent: Monday, February 20, 2012 5:12 AM
> > To: Greg Kroah-Hartman
> > Cc: Dan Magenheimer; Seth Jennings; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org;
> > stable@kernel.org
> > Subject: [PATCH] zcache: avoid AB-BA deadlock condition
> > 
> > Commit 9256a47 fixed a deadlock condition, being sure that the buddy
> > list spinlock is always taken before the page spinlock.
> > 
> > However in zbud_free_and_delist() locking order is the opposite
> > (page lock -> list lock).
> > 
> > Possible unsafe locking scenario (reported by lockdep):
> > 
> >         CPU0                    CPU1
> >         ----                    ----
> >    lock(&(&zbpg->lock)->rlock);
> >                                 lock(zbud_budlists_spinlock);
> >                                 lock(&(&zbpg->lock)->rlock);
> >    lock(zbud_budlists_spinlock);
> > 
> > Fix by grabbing the locks in opposite order in zbud_free_and_delist().
> > 
> > Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> 
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> Thanks for catching this Andrea!  (And thanks also to
> Alex Vallacis-Lasso for independently reporting and testing:
> http://permalink.gmane.org/gmane.linux.kernel/1257214 )
> 
> Greg, this patch could be targeted for 3.3-rc6 and 3.2-stable.
> AFAIK, nobody has actually experienced a deadlock from this so
> if Linus has the screws down tight for -rc6, it could wait
> until the 3.4 window.

If it helps, without the fix I can easily trigger the lockdep splat
running a echo 3 > /proc/sys/vm/drop_caches.

-Andrea
