Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab1LOI5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:57:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56614 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab1LOI5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:57:14 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] audit: fix mark refcounting
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
	<87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
	<CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
	<20111215084050.GQ2203@ZenIV.linux.org.uk>
Date: Thu, 15 Dec 2011 09:56:26 +0100
In-Reply-To: <20111215084050.GQ2203@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 15 Dec 2011 08:40:50 +0000")
Message-ID: <87fwgmjjr9.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Wed, Dec 14, 2011 at 06:15:11PM -0800, Linus Torvalds wrote:
>> Looks reasonable, but why doesn't all callers have that "put_mark()" thing?
>> 
>> And if/when all callers *do* have that put_mark() thing, maybe we
>> should make destroy_mark() just do it?
>> 
>> In particular, a quick grep shows that there are destroy_mark users still in:
>> 
>>  - fs/notify/fanotify/fanotify_user.c
>> 
>>  - fs/notify/dnotify/dnotify.c (2 of them)
>> 
>>  - fs/notify/inotify/inotify_fsnotify.c
>> 
>> 
>> that don't do "put_mark()" after the destroy. Why is it ok there?
>
> Um?  dnotify has fsnotify_put_mark() called in both cases...
>  
>> I don't know the code, it's probably fine, but I'd like to know why
>> the audit code needs it but not the other sites (but my grep didn't
>> look at context)
>> 
>> And I'd like Al to say something. Al?
>
> I don't like it; it's called from ->handle_event() and parent->mark is
> exactly the inode_mark argument of that method.  It ought to be pinned
> by caller.  In other places we *do* need get/put around that destroy
> and we generally do that.
>
> AFAICS, we have the following picture:
> 	* that place in audit_watch - argument of ->handle_event()
> 	* audit_remove_watch_rule() - pinned explicitly
> 	* audit_tree - pinned explicitly
> 	* dnotify (both callrs) - pinned explicitly, and refcount is
> dropped unconditionally while fsnotify_destroy_mark() is *not*; IOW,
> that's a very strong argument against folding put_mark into destroy_mark.
> 	* inotify_fsnotify.c - argument of ->handle_event()
> 	* fanotify_user.c - pinned and dropped by caller; again, refcount
> manipulations are unconditional while destroy_mark is not; it's even
> worse than in dnotify case, since here we do put_mark is a place where
> we don't *know* whether destroy_mark has happened.  We could move the
> calls of fsnotify_put_mark() into the fanotify_mark_remove_from_mask()
> (where destroy_mark is done), but then we'll get something like
> 	if (!(oldmask & ~mask))
>                 fsnotify_destroy_mark(fsn_mark);
> 	else
>                 fsnotify_put_mark(fsn_mark);
> in there, which is IMO ugly.
>
> Guys, does anybody have a real demonstration of the breakage cured by
> pinning the mark down in audit_watch.c ->handle_event()?  Or is that
> a pure theory?

Yes it does fix the BUG.  Test case in patch.

> Is ->handle_event() argument held by caller?

Well, obviously not, otherwise we wouldn't hit the bug.

>   Eric?  If that's the case,
> we don't need to do anything with audit_watch.c instance; otherwise,
> both that one and inotify_handle_event() are in trouble...

Yep.

Thanks,
Miklos
