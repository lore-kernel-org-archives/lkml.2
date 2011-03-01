Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab1CAVIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:08:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483Ab1CAVIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:08:00 -0500
Subject: Re: [PATCH 1/5] fsnotify: grab inode ref in add_inode_mark()
 instead of add_mark()
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Tue, 01 Mar 2011 16:07:32 -0500
In-Reply-To: <20110301183006.GC3492@lsanfilippo.unix.rd.tt.avira.com>
References: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de>
	 <1298309609-19218-2-git-send-email-LinoSanfilippo@gmx.de>
	 <1298658996.23085.5.camel@localhost.localdomain>
	 <20110301183006.GC3492@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1299013652.8918.16.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-01 at 19:30 +0100, Lino Sanfilippo wrote:
> On Fri, Feb 25, 2011 at 01:36:35PM -0500, Eric Paris wrote:
> > I think your patch series is making a noticeable change which I don't
> > think I'm comfortable with.  The current code does not pin inodes in
> > core if they only have ignored masks.  Under memory pressure those
> > inodes can get eviced and the mark will get cleaned up.  My glance at
> > this code leads me to believe that all inodes with any mark is going to
> > be pinned in core.  I don't think that's a good idea for AV vendor use
> > where they might want to watch everything on the system with mount point
> > marks and put ignored marks on everything that comes along to cache
> > allows.
> > 
> > The fact that inodes might not be pinned in core is the reason for some
> > of the stupid difficulty.  There is probably some way to work it out but
> > I think it's something I'm going to need to think about.
> 
> Youre right, the inode is now also pinned if there is no mask set. This is
> a change i did not on purpose. Whether the inode is pinned or not does not 
> affect the original purpose of the patch series, which was the decoupling 
> of the mark lock and the fsobject lock. I simply forgot to check the mask.
> I could replace that part with something like
> 
> -       mark->i.inode = igrab(inode);
> -       mark->flags |= FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
> +       mark->i.inode = inode;
> +       if (mark->mask) {       /* only pin if mask is set */   
> +               igrab(inode);
> +               mark->flags |= FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
> +       }
> 
> Should i just fix it and resend the patches? Or do you have any other
> concerns?

No, but it's a rather serious concern to me.  You need to make sure that
mark->i.inode is actually valid before you use it and cannot disappear
underneath you.  I haven't relooked at your code (and clearly will after
you fix) but what I'm most concerned about is some place where we are
trying to delete a mark, either explicitly or by group, and then race
with the inode being evicted from cache.  The inode being evicted from
cache is going to eventually hit the destroy_by_inode code.  When that
function returns we cannot use mark->i.inode any more.  In today's code
we prevent this situation by never dereferencing or using the
mark->i.inode outside of mark->lock.  You're going to have to remember
that after a 'destroy_by_inode' call you can't ever use the inode
again....

-Eric

