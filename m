Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab2KPReV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:34:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34221 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2KPReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:34:18 -0500
Date: Fri, 16 Nov 2012 17:34:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Kent <ikent@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] autofs4 - use simple_empty() for empty directory check
Message-ID: <20121116173415.GA16916@ZenIV.linux.org.uk>
References: <20121116041523.18624.46918.stgit@perseus.themaw.net>
 <CA+55aFx-9A0xknhX7z9KmLAoGMf5GXhuFgroZUixHtevGAFsOQ@mail.gmail.com>
 <1353083773.2332.40.camel@perseus.themaw.net>
 <CA+55aFz+JUthf-HAdYLzQH=r0niB4+X1ymn5egLpdhiptYXr7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz+JUthf-HAdYLzQH=r0niB4+X1ymn5egLpdhiptYXr7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 08:43:28AM -0800, Linus Torvalds wrote:
> On Fri, Nov 16, 2012 at 8:36 AM, Ian Kent <ikent@redhat.com> wrote:
> >
> > Sure, are you recommending I alter the fs/libfs.c functions to add a
> > function that doesn't have the outer lock, and have simple_empty() call
> > that, then use it in autofs?
> 
> Yup. That's the standard pattern, although usually we *strive* to make
> the unlocked versions be static to the internal code, and then use
> them there for the various helpers. In your case that seems
> impossible, since you do depend on holding the d_lock in the caller
> after the tests. But at least we don't have to duplicate the code and
> have it in two unrelated places.
> 
> Al? Comments?

The thing is, I'm not convinced we really need ->d_lock held downstream.
E.g.  __autofs4_add_expiring() ought to be OK with just sbi->lookup_lock.
Not sure about the situation in autofs4_d_automount() - the thing is messy
as hell ;-/

Ian, do we really need that __simple_empty() variant in either caller?  What
is getting protected by ->d_lock after it and do we really need ->d_lock
continuously held for that?
