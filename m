Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987Ab0HER4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369Ab0HER4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:56:51 -0400
Subject: Re: [PATCH] kernel: rounddown helper function
From: Eric Paris <eparis@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jmorris@namei.org
In-Reply-To: <20100804143504.e7dfade1.akpm@linux-foundation.org>
References: <20100803181607.30614.36916.stgit@paris.rdu.redhat.com>
	 <20100803112354.8761e49d.randy.dunlap@oracle.com>
	 <20100804143504.e7dfade1.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 13:56:36 -0400
Message-ID: <1281030996.2604.17.camel@dhcp231-200.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 14:35 -0700, Andrew Morton wrote:
> On Tue, 3 Aug 2010 11:23:54 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Tue, 03 Aug 2010 14:16:07 -0400 Eric Paris wrote:
> > 
> > > The roundup() helper function will round a given value up to a multiple of
> > > another given value.  aka  roundup(11, 7) would give 14 = 7 * 2.  This new
> > > function does the opposite.  It will round a given number down to the
> > > nearest multiple of the second number: rounddown(11, 7) would give 7.
> > > 
> > > I need this in some future SELinux code and can carry the macro myself, but
> > > figured I would put it in the core kernel so others might find and use it
> > > if need be.
> > > 
> > > Signed-off-by: Eric Paris <eparis@redhat.com>
> > > ---
> > > 
> > >  include/linux/kernel.h |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > > index 7d5b10f..d6092fd 100644
> > > --- a/include/linux/kernel.h
> > > +++ b/include/linux/kernel.h
> > > @@ -59,6 +59,7 @@ extern const char linux_proc_banner[];
> > >  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
> > >  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> > >  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> > > +#define rounddown(x, y) ((x) - ((x) % (y)))
> > >  #define DIV_ROUND_CLOSEST(x, divisor)(			\
> > >  {							\
> > >  	typeof(divisor) __divisor = divisor;		\
> > > 
> > > --
> > 
> > I'm more used to seeing it like
> > 
> > #define DIV_ROUND_DOWN(n, d)	(((n) / (d)) * (d))
> > 
> > but since multiply/divide/modulus are usually slower, your (SELinux) way is better,
> > I suppose.
> > 
> > and the usual caveats apply:  don't use these macros with expressions (nor with y
> > or d == 0).
> 
> Yes, it really shouldn't reference its argument twice.  And that's easy
> to fix.

Are you suggesting something like

#define rounddown(n, d) ({ typeof(n) __n = (n); __n - (__n % (d)); })

If that's what you are hoping for, would you also like to see a patch
doing the same thing for roundup() ?

> A fancy version would detect constant-power-of-two and do an `& (d - 1)'
> instead of the modulus.  But probably the compiler does optimisatons in
> that case - for unsigned types, at least.

I don't think we really need to.  My quick test shows:

#define rounddown(n, d) ({typeof((n)) __n = (n); (__n - (__n % (d)));})

int round7(unsigned int a)
{
	return rounddown(a, 7);
}

int round4(unsigned int a)
{
	return rounddown(a, 4);
}

0000000000400504 <round7>:
  400504:       b9 07 00 00 00          mov    $0x7,%ecx
  400509:       89 f8                   mov    %edi,%eax
  40050b:       31 d2                   xor    %edx,%edx
  40050d:       f7 f1                   div    %ecx
  40050f:       89 f8                   mov    %edi,%eax
  400511:       29 d0                   sub    %edx,%eax
  400513:       c3                      retq

0000000000400514 <round4>:
  400514:       89 f8                   mov    %edi,%eax
  400516:       83 e0 fc                and    $0xfffffffffffffffc,%eax
  400519:       c3                      retq



