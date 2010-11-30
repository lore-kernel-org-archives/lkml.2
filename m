Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab0K3QBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:01:55 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:56343 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754169Ab0K3QBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:01:54 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1/38517j/z3qzvoohm9j1OnG6hnYR3w8VI/5MqZVd
	xET9rsnGpQjSJd
Date: Tue, 30 Nov 2010 16:59:51 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fanotify: dont destroy mark when ignore mask is cleared
Message-ID: <20101130155951.GB4814@lsanfilippo.unix.rd.tt.avira.com>
References: <20101130121635.277910@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130121635.277910@gmx.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 01:16:35PM +0100, Lino Sanfilippo wrote:

> I guess it is a question of safe vs racy.  Yes it is safe, nothing will
> explode or panic.  But we might have a race between one task removing an
> event type causing the mask to go to 0 and we should destroy the mark
> and another task adding an event type.  If it raced just right we might
> destroy the mark after the second task added to it.  I guess we really
> need to serialize fsnotify_mark() per group to solve the race...
> 
> Do you want to take a stab at fixing these things or should I?
> 
> -Eric

IMHO the right thing to serialize this would be to do 

LOCK(groups->mark_lock)
- get the inode mark
- set the marks mask
- possibly destroy the mask
UNLOCK(groups->mark_lock)

But we cant do this since setting the marks mask requires the lock of the mark 
- which would mean an incorrect lock order according to fsnotify_add_mark():

mark->lock
group->mark_lock
inode->i_lock

What we could do very easily is use another mutex instead (use an existing one like the 
groups notification_mutex, or a completely new one) which is responsible for synchronising
add_mark()/remove_mark().  

If that solution is ok I'll prepare the patches for it. Otherwise i am not sure how to solve this... 


Lino

