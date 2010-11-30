Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0K3QTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:19:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267Ab0K3QTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:19:49 -0500
Subject: Re: [PATCH] fanotify: dont destroy mark when ignore mask is cleared
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101130155951.GB4814@lsanfilippo.unix.rd.tt.avira.com>
References: <20101130121635.277910@gmx.net>
	 <20101130155951.GB4814@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 11:19:39 -0500
Message-ID: <1291133979.3169.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 16:59 +0100, Lino Sanfilippo wrote:
> On Tue, Nov 30, 2010 at 01:16:35PM +0100, Lino Sanfilippo wrote:
> 
> > I guess it is a question of safe vs racy.  Yes it is safe, nothing will
> > explode or panic.  But we might have a race between one task removing an
> > event type causing the mask to go to 0 and we should destroy the mark
> > and another task adding an event type.  If it raced just right we might
> > destroy the mark after the second task added to it.  I guess we really
> > need to serialize fsnotify_mark() per group to solve the race...
> > 
> > Do you want to take a stab at fixing these things or should I?
> > 
> > -Eric
> 
> IMHO the right thing to serialize this would be to do 
> 
> LOCK(groups->mark_lock)
> - get the inode mark
> - set the marks mask
> - possibly destroy the mask
> UNLOCK(groups->mark_lock)
> 
> But we cant do this since setting the marks mask requires the lock of the mark 
> - which would mean an incorrect lock order according to fsnotify_add_mark():
> 
> mark->lock
> group->mark_lock
> inode->i_lock
> 
> What we could do very easily is use another mutex instead (use an existing one like the 
> groups notification_mutex, or a completely new one) which is responsible for synchronising
> add_mark()/remove_mark().

I'd think a new per group mutex would be the right way to go.  I'm not
sure how I feel about notification_mutex.  I guess you can go ahead and
overload it and we can split it off later if someone finds it to be a
performance blocker.

-Eric


