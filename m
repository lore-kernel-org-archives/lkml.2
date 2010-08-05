Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab0HETEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:04:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203Ab0HETED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:04:03 -0400
Date: Thu, 5 Aug 2010 12:03:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jmorris@namei.org
Subject: Re: [PATCH] kernel: rounddown helper function
Message-Id: <20100805120312.e166a041.akpm@linux-foundation.org>
In-Reply-To: <1281030996.2604.17.camel@dhcp231-200.rdu.redhat.com>
References: <20100803181607.30614.36916.stgit@paris.rdu.redhat.com>
	<20100803112354.8761e49d.randy.dunlap@oracle.com>
	<20100804143504.e7dfade1.akpm@linux-foundation.org>
	<1281030996.2604.17.camel@dhcp231-200.rdu.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Aug 2010 13:56:36 -0400
Eric Paris <eparis@redhat.com> wrote:

> > > I'm more used to seeing it like
> > > 
> > > #define DIV_ROUND_DOWN(n, d)	(((n) / (d)) * (d))
> > > 
> > > but since multiply/divide/modulus are usually slower, your (SELinux) way is better,
> > > I suppose.
> > > 
> > > and the usual caveats apply:  don't use these macros with expressions (nor with y
> > > or d == 0).
> > 
> > Yes, it really shouldn't reference its argument twice.  And that's easy
> > to fix.
> 
> Are you suggesting something like
> 
> #define rounddown(n, d) ({ typeof(n) __n = (n); __n - (__n % (d)); })

looks good.

> If that's what you are hoping for, would you also like to see a patch
> doing the same thing for roundup() ?

Sure.  I doubt if anything accidentally depends on the curent behavior,
although that would be amusing.

> > A fancy version would detect constant-power-of-two and do an `& (d - 1)'
> > instead of the modulus.  But probably the compiler does optimisatons in
> > that case - for unsigned types, at least.
> 
> I don't think we really need to.  My quick test shows:
> 
> #define rounddown(n, d) ({typeof((n)) __n = (n); (__n - (__n % (d)));})
> 
> int round7(unsigned int a)
> {
> 	return rounddown(a, 7);
> }
> 
> int round4(unsigned int a)
> {
> 	return rounddown(a, 4);
> }
> 
> 0000000000400504 <round7>:
>   400504:       b9 07 00 00 00          mov    $0x7,%ecx
>   400509:       89 f8                   mov    %edi,%eax
>   40050b:       31 d2                   xor    %edx,%edx
>   40050d:       f7 f1                   div    %ecx
>   40050f:       89 f8                   mov    %edi,%eax
>   400511:       29 d0                   sub    %edx,%eax
>   400513:       c3                      retq
> 
> 0000000000400514 <round4>:
>   400514:       89 f8                   mov    %edi,%eax
>   400516:       83 e0 fc                and    $0xfffffffffffffffc,%eax
>   400519:       c3                      retq
> 

OK, thanks for checking.
