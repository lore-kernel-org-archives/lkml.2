Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab1ATStW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:49:22 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:25848 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753260Ab1ATStV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:49:21 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ac1AbAYVM1l2p2129CMATX9YkcM_QJWZDcLYKURvRcRWGj1
 Xl7YD916KXMnWil4IRhG4RZR7zZS2Rq9Wgk4c3DwwVvnJ0w3qGFFOV708W6T
 RkFsrsfEJNbjnaR6NGbESVjx2crDuTFLUApCDu32tUP63YBIkPy5l_A_UNeY
 6RZp9EhIpczb_yrwBbSUazeO4t8f6FXO1k2EH.qUz5HmwVdfhHZ5TxZ3svDg
 n8XMC7mK3FFQK3K8SG80PGwvqWiOXrZsY162SWC9rdvL8t7ZUEw9veNkvhns
 lWOpsUp5mvdjVRaVUGhfFFEurw80HtUqexToXac5PSdWRgCs-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 20 Jan 2011 12:49:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/3] When migrate_pages returns 0, all pages must have
 been released
In-Reply-To: <20110120182444.GA9506@random.random>
Message-ID: <alpine.DEB.2.00.1101201233001.20633@router.home>
References: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com> <alpine.DEB.2.00.1101201130100.10695@router.home> <20110120182444.GA9506@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Andrea Arcangeli wrote:

> Hello,
>
> On Thu, Jan 20, 2011 at 11:30:35AM -0600, Christoph Lameter wrote:
> > On Fri, 21 Jan 2011, Minchan Kim wrote:
> >
> > > diff --git a/mm/migrate.c b/mm/migrate.c
> > > index 46fe8cc..7d34237 100644
> > > --- a/mm/migrate.c
> > > +++ b/mm/migrate.c
> > > @@ -772,6 +772,7 @@ uncharge:
> > >  unlock:
> > >  	unlock_page(page);
> > >
> > > +move_newpage:
> > >  	if (rc != -EAGAIN) {
> > >   		/*
> > >   		 * A page that has been migrated has all references
> > > @@ -785,8 +786,6 @@ unlock:
> > >  		putback_lru_page(page);
> > >  	}
> > >
> > > -move_newpage:
> > > -
> > >  	/*
> > >  	 * Move the new page to the LRU. If migration was not successful
> > >  	 * then this will free the page.
> > >
> >
> > What does this do? Not covered by the description.
>
> It makes a difference for the two goto move_newpage, when rc =
> 0. Otherwise the function will return 0, despite
> putback_lru_page(page) wasn't called (and the caller of migrate_pages
> won't call putback_lru_pages if migrate_pages returned 0).

Think about the difference:

Moving the move_newpage will now cause another removal and freeing of the
page if rc != -EAGAIN.

The first goto move_newpage (because page count is 1) will now mean that
the page is freed twice. One because of the rc != EAGAIN branch and then
another time by the following putback_lru_page().


