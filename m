Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab0HTMHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:07:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59298 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0HTMHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:07:43 -0400
Date: Fri, 20 Aug 2010 13:07:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Namhyung Kim <namhyung@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] introduce ptr_diff()
Message-ID: <20100820120737.GS31363@ZenIV.linux.org.uk>
References: <1282217856-8625-1-git-send-email-namhyung@gmail.com>
 <87aaoiu6z6.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aaoiu6z6.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 02:23:09PM +0200, Andi Kleen wrote:
> Namhyung Kim <namhyung@gmail.com> writes:
> 
> > When I compiled allyesconfig'ed kernel with C=1, I got 1519 lines of
> > following message:
> >
> >  include/linux/mm.h:599:16: warning: potentially expensive pointer subtraction
> >
> > which is around 10% of total warnings. this was caused by page_to_pfn() macro
> > so I think it's worth to remove it by calculating pointer subtraction
> > manually.
> 
> IMHO it would be better to simply disable the warning in sparse instead
> of uglying the code just to work around sparse bogosity. It doesnt' seem
> to make much sense. A subtraction followed by a shift is not expensive.

"Bogosity" in question is quite real and proposed "fix" actually makes the
things even worse.  At least gcc bothers to optimize the division in there...

Basically, sparse warns about pointer subtractions that divide by constants
that are not powers of two.  Which _does_ have non-trivial price, even with
optimizations done by gcc.

Posted patch is complete crap, since all it does is
	a) confuse sparse into not noticing the operation
	b) confuse gcc into not trying to optimize the thing, which actually
makes the situation *worse*.

Sheesh...
