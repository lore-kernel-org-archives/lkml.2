Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab1CASeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 13:34:12 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:50070 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755474Ab1CASeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 13:34:11 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+E3aolNOeEec5zpUDdfnS9j5vRe6C2H7whxOlVwf
	Nei0SYLxrGHkj9
Date: Tue, 1 Mar 2011 19:30:06 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/5] fsnotify: grab inode ref in add_inode_mark()
	instead of add_mark()
Message-ID: <20110301183006.GC3492@lsanfilippo.unix.rd.tt.avira.com>
Reply-To: 1298658996.23085.5.camel@localhost.localdomain
References: <1298309609-19218-1-git-send-email-LinoSanfilippo@gmx.de> <1298309609-19218-2-git-send-email-LinoSanfilippo@gmx.de> <1298658996.23085.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298658996.23085.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 01:36:35PM -0500, Eric Paris wrote:
> I think your patch series is making a noticeable change which I don't
> think I'm comfortable with.  The current code does not pin inodes in
> core if they only have ignored masks.  Under memory pressure those
> inodes can get eviced and the mark will get cleaned up.  My glance at
> this code leads me to believe that all inodes with any mark is going to
> be pinned in core.  I don't think that's a good idea for AV vendor use
> where they might want to watch everything on the system with mount point
> marks and put ignored marks on everything that comes along to cache
> allows.
> 
> The fact that inodes might not be pinned in core is the reason for some
> of the stupid difficulty.  There is probably some way to work it out but
> I think it's something I'm going to need to think about.

Youre right, the inode is now also pinned if there is no mask set. This is
a change i did not on purpose. Whether the inode is pinned or not does not 
affect the original purpose of the patch series, which was the decoupling 
of the mark lock and the fsobject lock. I simply forgot to check the mask.
I could replace that part with something like

-       mark->i.inode = igrab(inode);
-       mark->flags |= FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
+       mark->i.inode = inode;
+       if (mark->mask) {       /* only pin if mask is set */   
+               igrab(inode);
+               mark->flags |= FSNOTIFY_MARK_FLAG_OBJECT_PINNED;
+       }

Should i just fix it and resend the patches? Or do you have any other
concerns?
