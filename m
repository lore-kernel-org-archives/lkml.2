Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0HTPzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:55:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751452Ab0HTPzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:55:33 -0400
MIME-Version: 1.0
In-Reply-To: <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
References: <20100818203143.735033743@clark.site> <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Aug 2010 08:54:28 -0700
Message-ID: <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 5:54 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
>
> Since we have split the original VMA into 3, shouldn't only the bottom
> one still have VM_GROWSDOWN set? (how can the top two grow down with the
> bottom one in the way?) Certainly it seems wrong to enforce a guard page
> on anything but the bottom VMA (which is what appears to be happening).

Yes, it does seem like we should teach vma splitting to remove
VM_GROWSDOWN on all but the lowest mapping.

> Out of interest how does the guard page interact with processes which do
> alloca(N*PAGE_SIZE)?

It's a guard page, not magic. Some architecture ABI's specify that if
you expand the stack by more than a certain number, you need to touch
a page in between (for example, I think alpha had that rule), because
they don't grow the stack automatically by an arbitrary amount. But
x86 has never had that rule, and you can certainly defeat a guard page
by simply accessing by much more than a page.

As far as I'm concerned, the guard page thing is not - and shouldn't
be thought of - a "hard" feature. If it's needed, it's really a bug in
user space. But given that there are bugs in user space, the guard
page makes it a bit harder to abuse those bugs. But it's about "a bit
harder" rather than anything else.

IOW, it does _not_ make up for user space that willfully does crazy
things, and never will.

                       Linus
