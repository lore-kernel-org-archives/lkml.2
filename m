Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab0HYPSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 11:18:14 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:4818 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0HYPSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 11:18:13 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Huang Shijie <shijie8@gmail.com>
Subject: Re: [PATCH] avoiding the same resource to be inserted
Date: Wed, 25 Aug 2010 09:17:52 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <1281974138-5553-1-git-send-email-shijie8@gmail.com> <20100824164622.a3b2c1ed.akpm@linux-foundation.org> <AANLkTin+0xZBFJSc48yqzrxQQL0ukA8Q0fksy1bM4mUj@mail.gmail.com>
In-Reply-To: <AANLkTin+0xZBFJSc48yqzrxQQL0ukA8Q0fksy1bM4mUj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008250917.54845.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 24, 2010 10:31:52 pm Huang Shijie wrote:
> On Wed, Aug 25, 2010 at 7:46 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Mon, 16 Aug 2010 23:55:38 +0800
> > Huang Shijie <shijie8@gmail.com> wrote:
> >
> >>   If the same resource is inserted to the resource tree
> >> (maybe not on purpose), a dead loop will be created. In this situation,
> >> The kernel does not report any warning or error       :(
> >>
> >>   The command below will show a endless print.
> >>   #cat /proc/iomem
> >
> > OK, we shouldn't do that.
> >
> >>   So, adding the check for the same resource is needed for the stability
> >> and reliability of the kernel.
> >>
> >> Signed-off-by: Huang Shijie <shijie8@gmail.com>
> >> ---
> >>  kernel/resource.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/kernel/resource.c b/kernel/resource.c
> >> index 7b36976..60daab4 100644
> >> --- a/kernel/resource.c
> >> +++ b/kernel/resource.c
> >> @@ -451,7 +451,7 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
> >>               if (!first)
> >>                       return first;
> >>
> >> -             if (first == parent)
> >> +             if (first == parent || first == new)
> >>                       return first;
> >
> > However, inserting the same thing twice _is_ a bug, and we shouldn't
> > silently accept it like this.  We should tell the programmer!
> 
> Indeed, this is a bug caused by the driver programmer.I had spent
> nearly two day to find it in my colleague's code.

insert_resource() is a hack to deal with the fact that we don't
discover resources in the logical order, so sometimes we have to
go back and add a resource after we've already added "children"
of the new resource.

In my opinion, the ugliness of using insert_resource() should be
confined to core architecture code, and drivers shouldn't use it
at all.

That said, I think it's a good idea to add the WARN_ON().

In fact, I wonder if we should also "WARN_ON(first == parent)".

Bjorn
