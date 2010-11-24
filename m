Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab0KXMdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:33:52 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:60435 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751189Ab0KXMdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:33:50 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+dilot+9SdHrwQHCE4QuOGfgL8Vc33S/Dp/fFJp4
	8Vyb7jfu4rcEK+
Date: Wed, 24 Nov 2010 13:31:51 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fanotify: dont destroy mark when ignore mask is cleared
Message-ID: <20101124123151.GB26499@lsanfilippo.unix.rd.tt.avira.com>
References: <20101122175229.GC5512@lsanfilippo.unix.rd.tt.avira.com> <1290541879.1443.32.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290541879.1443.32.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 02:51:19PM -0500, Eric Paris wrote:

> 
> Hmmmm, really I'm not sure if that is right either (but it's certainly
> closer)  What about something like:
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 81df3ad..29fbf17 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -527,7 +527,7 @@ static __u32 fanotify_mark_remove_from_mask(struct fsnotify_mark *fsn_mark,
>  	}
>  	spin_unlock(&fsn_mark->lock);
>  
> -	if (!(oldmask & ~mask))
> +	if (!fsn_mark->mask && !fsn_mark->ignored_mask)
>  		fsnotify_destroy_mark(fsn_mark);
>  
>  	return mask & oldmask;
> 
> 

Yep, youre right, we should also check the ignore mask before we destroy the mark.

BUT:
1. There is this flag FAN_MARK_ONDIR which is set implicitly in the ignore mask
whenever it has not explicitly been set by the user (see fanotify_mark_add_to_mask()).
If that flag has been set the ignore mask will never get cleared unless the
user does something like

fanotify_mark(fd, FAN_MARK_REMOVE | FAN_MARK_IGNORED_MASK, FAN_MARK_ONDIR,...)

which presumes that he knows that this flag has been set. 



Btw.: 
every time a user _forgets_ to explicitly set FAN_MARK_ONDIR, it will be set
in the ignored mask and thus events on dirs are skipped. Thus calls like

fanotify_mark(fd, FAN_MARK_ADD, FAN_MARK_ONDIR, ...)  /* get dir events */
fanotify_mark(fd, FAN_MARK_ADD, ...) /* add mark for some kind of event */

will result in dir events being ignored by the second call to fanotify_mark(),
although the user has requested those events in his first call.
This is very likely not what the user expected. Is there a reason why ONDIR is 
set implicitly in the ignore mask?
Otherwise i would suggest to not set it implicitly in mark->ignored_mask,
but to set it in mark->mask if requested by the user. Then we could ignore dir 
events as long as the flag has not been set there. 


2. I just realized that we cant simply call destroy_mark() if the masks are 0. 
There may be one or more concurrent processes calling fsnotify_find_inode_mark() 
(see fanotify_add_inode_mark()) and get the mark we are about to destroy at the 
same time.

I will take a closer look at it, but it seems to be difficult to me to safely 
call destroy_mark() as long as we are not in the context of fanotify_release() (in 
which we dont have to deal with concurrency like that any more). 





 
