Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0K2Upi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 15:45:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab0K2Uph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 15:45:37 -0500
Subject: Re: [PATCH] fanotify: dont destroy mark when ignore mask is cleared
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101124123151.GB26499@lsanfilippo.unix.rd.tt.avira.com>
References: <20101122175229.GC5512@lsanfilippo.unix.rd.tt.avira.com>
	 <1290541879.1443.32.camel@localhost.localdomain>
	 <20101124123151.GB26499@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 15:45:31 -0500
Message-ID: <1291063531.3248.30.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 13:31 +0100, Lino Sanfilippo wrote:

> 2. I just realized that we cant simply call destroy_mark() if the masks are 0. 
> There may be one or more concurrent processes calling fsnotify_find_inode_mark() 
> (see fanotify_add_inode_mark()) and get the mark we are about to destroy at the 
> same time.
> 
> I will take a closer look at it, but it seems to be difficult to me to safely 
> call destroy_mark() as long as we are not in the context of fanotify_release() (in 
> which we dont have to deal with concurrency like that any more). 

I guess it is a question of safe vs racy.  Yes it is safe, nothing will
explode or panic.  But we might have a race between one task removing an
event type causing the mask to go to 0 and we should destroy the mark
and another task adding an event type.  If it raced just right we might
destroy the mark after the second task added to it.  I guess we really
need to serialize fsnotify_mark() per group to solve the race...

Do you want to take a stab at fixing these things or should I?

-Eric

