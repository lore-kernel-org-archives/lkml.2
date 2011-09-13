Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab1IMUXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 16:23:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470Ab1IMUXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 16:23:01 -0400
Date: Tue, 13 Sep 2011 16:22:48 -0400
From: Jason Baron <jbaron@redhat.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Nelson Elhage <nelhage@nelhage.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        stable@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] epoll: Fix spurious lockdep warnings
Message-ID: <20110913202248.GA6580@redhat.com>
References: <1312913515-432-1-git-send-email-nelhage@nelhage.com>
 <20110908000429.GK10700@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908000429.GK10700@zod.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 08:04:29PM -0400, Josh Boyer wrote:
> On Tue, Aug 09, 2011 at 02:11:55PM -0400, Nelson Elhage wrote:
> > epoll can acquire recursively acquire ep->mtx on multiple "struct
> > eventpoll"s at once in the case where one epoll fd is monitoring
> > another epoll fd. This is perfectly OK, since we're careful about the
> > lock ordering, but it causes spurious lockdep warnings. Annotate the
> > recursion using mutex_lock_nested, and add a comment explaining the
> > nesting rules for good measure.
> > 
> > Recent versions of systemd are triggering this, and it can also be
> > demonstrated with the following trivial test program:
> > 
> > --------------------8<--------------------
> > 
> > int main(void) {
> >    int e1, e2;
> >    struct epoll_event evt = {
> >        .events = EPOLLIN
> >    };
> > 
> >    e1 = epoll_create1(0);
> >    e2 = epoll_create1(0);
> >    epoll_ctl(e1, EPOLL_CTL_ADD, e2, &evt);
> >    return 0;
> > }
> > --------------------8<--------------------
> > 
> > Cc: stable@kernel.org
> > Reported-by: Paul Bolle <pebolle@tiscali.nl>
> > Tested-by: Paul Bolle <pebolle@tiscali.nl>
> > Signed-off-by: Nelson Elhage <nelhage@nelhage.com>
> 
> Any progress on this heading upstream?
> 

Patch looks good to me, feel free to add:

Acked-by: Jason Baron <jbaron@redhat.com>

However, I am going to have to re-base the epoll path I recently posted:
https://lkml.org/lkml/2011/9/2/295, if this goes in first. Perhaps,
Andrew (added to the 'cc), can help us sort out the ordering...

Thanks,

-Jason
