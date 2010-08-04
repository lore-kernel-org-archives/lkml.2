Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab0HDVgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:36:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab0HDVfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:35:55 -0400
Date: Wed, 4 Aug 2010 14:35:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jmorris@namei.org
Subject: Re: [PATCH] kernel: rounddown helper function
Message-Id: <20100804143504.e7dfade1.akpm@linux-foundation.org>
In-Reply-To: <20100803112354.8761e49d.randy.dunlap@oracle.com>
References: <20100803181607.30614.36916.stgit@paris.rdu.redhat.com>
	<20100803112354.8761e49d.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010 11:23:54 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 03 Aug 2010 14:16:07 -0400 Eric Paris wrote:
> 
> > The roundup() helper function will round a given value up to a multiple of
> > another given value.  aka  roundup(11, 7) would give 14 = 7 * 2.  This new
> > function does the opposite.  It will round a given number down to the
> > nearest multiple of the second number: rounddown(11, 7) would give 7.
> > 
> > I need this in some future SELinux code and can carry the macro myself, but
> > figured I would put it in the core kernel so others might find and use it
> > if need be.
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> > 
> >  include/linux/kernel.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index 7d5b10f..d6092fd 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -59,6 +59,7 @@ extern const char linux_proc_banner[];
> >  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
> >  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> >  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> > +#define rounddown(x, y) ((x) - ((x) % (y)))
> >  #define DIV_ROUND_CLOSEST(x, divisor)(			\
> >  {							\
> >  	typeof(divisor) __divisor = divisor;		\
> > 
> > --
> 
> I'm more used to seeing it like
> 
> #define DIV_ROUND_DOWN(n, d)	(((n) / (d)) * (d))
> 
> but since multiply/divide/modulus are usually slower, your (SELinux) way is better,
> I suppose.
> 
> and the usual caveats apply:  don't use these macros with expressions (nor with y
> or d == 0).

Yes, it really shouldn't reference its argument twice.  And that's easy
to fix.

A fancy version would detect constant-power-of-two and do an `& (d - 1)'
instead of the modulus.  But probably the compiler does optimisatons in
that case - for unsigned types, at least.
