Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611Ab1LOW2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:28:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756395Ab1LOW2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:28:18 -0500
Message-ID: <1323988092.22363.11.camel@localhost>
Subject: Re: [PATCH resend] audit: fix mark refcounting
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Dec 2011 17:28:12 -0500
In-Reply-To: <20111215200631.GA2379@Neptun>
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
	 <87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
	 <CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
	 <20111215084050.GQ2203@ZenIV.linux.org.uk>
	 <87fwgmjjr9.fsf@tucsk.pomaz.szeredi.hu>
	 <87aa6ujjf6.fsf@tucsk.pomaz.szeredi.hu> <20111215200631.GA2379@Neptun>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 21:06 +0100, Lino Sanfilippo wrote:
> On Thu, Dec 15, 2011 at 10:03:41AM +0100, Miklos Szeredi wrote:
> >  
> > +	audit_get_parent(parent);
> >  	fsnotify_destroy_mark(&parent->mark);
> > +	audit_put_parent(parent);
> 
> Hi,
> 
> What about taking an extra ref on an inode mark in send_to_group()
> before we call handle_event()?
> So we dont have to handle the cases in which a mark is destroyed
> explicitly...

Yes, but it puts atomic operations on a much hotter path.  I don't
believe there is actually a bug in the code here, but clearly we're
tripping over a BUG() I put in the code.  These patches shut up the
BUG() with minimal overhead, but don't really solve any problem.

Lino is right, the 'right' place to do this would be to take a reference
in fs/notify/fsnotify.c::fsnotify() when we find a mark under the srcu
lock and drop that reference when we are finished using that mark.
Since that function only ever uses the mark to call the handler() if it
gets destroyed in the handler that is fine.  We'd have a real bug here
if fsnotify() used the mark after the handler call...

How expensive is an atomic_inc()/atomic_dec() combo?  If it's mostly
free we can do it in the right place.

-Eric

