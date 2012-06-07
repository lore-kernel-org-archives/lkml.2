Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2FGMsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 08:48:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab2FGMsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 08:48:08 -0400
Date: Thu, 7 Jun 2012 08:48:00 -0400
From: Don Zickus <dzickus@redhat.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Jan Beulich <JBeulich@suse.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
Message-ID: <20120607124800.GH32472@redhat.com>
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com>
 <4FCDDB7D0200007800088390@nat28.tlf.novell.com>
 <20120605144734.GU32472@redhat.com>
 <4FCE44FC0200007800088524@nat28.tlf.novell.com>
 <20120605183539.GA32472@redhat.com>
 <4FCF57B902000078000887EA@nat28.tlf.novell.com>
 <20120606140357.GB32472@redhat.com>
 <1339055005.18639.11.camel@ThinkPad-T420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339055005.18639.11.camel@ThinkPad-T420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 03:43:25PM +0800, Li Zhong wrote:
> On Wed, 2012-06-06 at 10:03 -0400, Don Zickus wrote:
> > On Wed, Jun 06, 2012 at 12:14:33PM +0100, Jan Beulich wrote:
> > > > I didn't think it would be compiler dependent as I do not know what
> > > > compiler the reporter was using.  I used a RHEL-6 4.4.4 compiler (which
> > > > you probably don't have :^) ).
> > > 
> > > Indeed, somehow I failed to see the obvious - it's commit
> > > 72b3fb24713755cf9740b403e95aa67ceedf3509 that causes
> > > these problems. Instantiating static data like this just doesn't
> > > play with any of the pointers passed being into .init.*.
> > > 
> > > I'd suggest either open coding register_nmi_handler() (with
> > > the static data put into __initdata), or further abstracting it
> > > by allowing an optional fifth argument (specifying the section
> > > annotation if needed).
> > 
> > Ah.  Thanks for figuring that out!!  I will post a patch opencoding it.
> > 
> 
> Hi Don, 
> 
> How about the following patch, adding an optional fifth argument as Jan
> mentioned? We don't need change other users of register_nmi_handler(). 

Ah, ok.  I forgot about the variable args syntax.  That works too.  I give
a quick test.

Thanks,
Don

> 
> Thanks, 
> Zhong
> 
> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> ---
> diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
> index 0e3793b..c0fa356 100644
> --- a/arch/x86/include/asm/nmi.h
> +++ b/arch/x86/include/asm/nmi.h
> @@ -44,14 +44,14 @@ struct nmiaction {
>  	const char		*name;
>  };
>  
> -#define register_nmi_handler(t, fn, fg, n)		\
> +#define register_nmi_handler(t, fn, fg, n, init...)	\
>  ({							\
> -	static struct nmiaction fn##_na = {		\
> +	static struct nmiaction init fn##_na = {	\
>  		.handler = (fn),			\
>  		.name = (n),				\
>  		.flags = (fg),				\
>  	};						\
> -	__register_nmi_handler((t), &fn##_na);	\
> +	__register_nmi_handler((t), &fn##_na);		\
>  })
>  
>  int __register_nmi_handler(unsigned int, struct nmiaction *);
> diff --git a/arch/x86/kernel/nmi_selftest.c
> b/arch/x86/kernel/nmi_selftest.c
> index e31bf8d..6d9582e 100644
> --- a/arch/x86/kernel/nmi_selftest.c
> +++ b/arch/x86/kernel/nmi_selftest.c
> @@ -42,7 +42,8 @@ static int __init nmi_unk_cb(unsigned int val, struct
> pt_regs *regs)
>  static void __init init_nmi_testsuite(void)
>  {
>  	/* trap all the unknown NMIs we may generate */
> -	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
> +	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk",
> +			__initdata);
>  }
>  
>  static void __init cleanup_nmi_testsuite(void)
> @@ -65,7 +66,7 @@ static void __init test_nmi_ipi(struct cpumask *mask)
>  	unsigned long timeout;
>  
>  	if (register_nmi_handler(NMI_LOCAL, test_nmi_ipi_callback,
> -				 NMI_FLAG_FIRST, "nmi_selftest")) {
> +				 NMI_FLAG_FIRST, "nmi_selftest", __initdata)) {
>  		nmi_fail = FAILURE;
>  		return;
>  	}
> 
> 
