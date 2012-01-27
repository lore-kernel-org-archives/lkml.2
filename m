Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2A0Abw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:31:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab2A0Abv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:31:51 -0500
Date: Thu, 26 Jan 2012 16:31:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Nebojsa Trpkovic <trx.lists@gmail.com>, minchan@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, riel@redhat.com,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] mm: implement WasActive page flag (for improving
 cleancache)
Message-Id: <20120126163150.31a8688f.akpm@linux-foundation.org>
In-Reply-To: <9fcd06f5-360e-4542-9fbb-f8c7efb28cb6@default>
References: <ea3b0850-dfe0-46db-9201-2bfef110848d@default>
	<4F218D36.2060308@linux.vnet.ibm.com>
	<9fcd06f5-360e-4542-9fbb-f8c7efb28cb6@default>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 13:28:02 -0800 (PST)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > I do think it also needs to get cleared on the way in to the page
> > allocator.  Otherwise:
> > 
> > 	PageSetWasActive(page);
> > 	free_page(page);
> > 	...
> > 	another_user_page = get_free_page()
> > 	// now cleancache sees the active bit for the prev user
> > 
> > Or am I missing somewhere it gets cleared non-explicitly somewhere?
> 
> True, it is not getting cleared and it should be, good catch!

It should be added to PAGE_FLAGS_CHECK_AT_FREE.

> I'll find the place to add the call to ClearPageWasActive() for v2.

AFAICT this patch consumes our second-last page flag, or close to it. 
We'll all be breaking out in hysterics when the final one is gone.

This does appear to be a make or break thing for cleancache - if we
can't fix https://lkml.org/lkml/2012/1/22/61 then cleancache is pretty
much a dead duck.  But I'm going to ask for great effort to avoid
consuming another page flag.  Either fix cleancache via other means or,
much less desirably, find an existing page flag and overload it.

And I'm afraid that neither I nor other MM developers are likely to
help you with "fix cleancache via other means" because we weren't
provided with any description of what the problem is within cleancache,
nor how it will be fixed.  All we are given is the assertion "cleancache
needs this".
