Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab0EMLb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 07:31:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758696Ab0EMLb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 07:31:56 -0400
Subject: Re: [PATCH] inotify: race use after free/double free in inotify
 inode marks
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100512201631.a6955325.akpm@linux-foundation.org>
References: <1273680480-2550-1-git-send-email-eparis@redhat.com>
	 <20100512201631.a6955325.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 07:31:48 -0400
Message-ID: <1273750308.2772.18.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-12 at 20:16 -0400, Andrew Morton wrote:
> On Wed, 12 May 2010 12:08:00 -0400 Eric Paris <eparis@redhat.com> wrote:
> 
> > From: root <root@tyan-gt24-04.rhts.eng.bos.redhat.com>
> 
> hm.

Well poop.  That's what I get for using git on a random test box.  I
moved it to my real tree with git-format-patch > git-am.  I'll fix the
author.

> > There is a race in the inotify add/rm watch code.  A task can find and
> > remove a mark which doesn't have all of it's references.  This can
> > result in a use after free/double free situation.
> > 
> > Task A					Task B
> > ------------				-----------
> > inotify_new_watch()
> >  allocate a mark (refcnt == 1)
> >  add it to the idr
> > 					inotify_rm_watch()
> > 					 inotify_remove_from_idr()
> > 					  fsnotify_put_mark()
> > 					      refcnt hits 0, free
> >  take reference because we are on idr
> >  [at this point it is a use after free]
> >  [time goes on]
> >  refcnt may hit 0 again, double free
> > 
> > The fix is to take the reference BEFORE the object can be found in the
> > idr.
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> The changelog has no "Cc: <stable@kernel.org>".  I suspect it should
> have that?

Will fix before I ask Linus to pull....

-Eric

