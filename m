Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2JBMRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:17:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2JBMRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:17:15 -0400
Date: Tue, 2 Oct 2012 08:17:04 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
        pjones@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Message-ID: <20121002121703.GC20849@hansolo.jdub.homelinux.org>
References: <87ipay3cof.fsf@rustcorp.com.au>
 <87bogs492s.fsf@rustcorp.com.au>
 <87ehlp30pd.fsf@rustcorp.com.au>
 <5555.1348531649@warthog.procyon.org.uk>
 <8168.1348650575@warthog.procyon.org.uk>
 <16088.1348736905@warthog.procyon.org.uk>
 <27378.1348819793@warthog.procyon.org.uk>
 <29407.1348902805@warthog.procyon.org.uk>
 <20121001204150.GA20849@hansolo.jdub.homelinux.org>
 <87626t4kos.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87626t4kos.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:58:03PM +0930, Rusty Russell wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> 
> > On Sat, Sep 29, 2012 at 08:13:25AM +0100, David Howells wrote:
> >> Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> 
> >> > [    2.808075] Loading module verification certificates
> >> > [    2.809331] X.509: Cert 6e03943da0f3b015ba6ed7f5e0cac4fe48680994 has expired
> >> > [    2.810500] MODSIGN: Problem loading in-kernel X.509 certificate (-127)
> >> 
> >> Hmmm...  Other people have seen that.
> >> 
> >> Ahhhhh!
> >> 
> >> I wonder if the problem is that the certificate is valid for 100 years....
> >> That might well cause an overflow on a 32-bit system.
> >
> > That does seem quite plausible.  The comparisons are done with time_t,
> > which boils down to 'long' and 100 years in seconds would overflow
> > LONG_MAX.
> >
> >> Could you try changing the '36500' in kernel/Makefile to something shorter,
> >> like 365?
> >
> > I tried two values today.  One close to LONG_MAX (24800 or ~68 years),
> > and 10 years (3650).  The former still seemed to overflow, but
> > specifying a 10yr lifetime appears to have worked.
> 
> That's because the timestamp is absolute, right?  Indeed, that seems to
> be the limit here.

Yep.

> Here's my solution (tested, and it breaks if you change 2147300000 to
> 2147600000 as expected):
> 
> From 2a4b91c2c29739191c6f7db9abee9296ae505c39 Mon Sep 17 00:00:00 2001
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Tue, 2 Oct 2012 12:55:06 +0930
> Subject: [PATCH] MODSIGN: fix expiry of auto-generated certificates on 32-bit
>  systems
> 
> 100-year certificates make time_t wrap, resulting in:
> 
> [    2.835272] X.509: Cert a94f6776f3f5483b0764011d1fcc6c0298362e63 has expired
> [    2.836346] MODSIGN: Problem loading in-kernel X.509 certificate (-127)
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/kernel/Makefile b/kernel/Makefile
> index e951adf..86336c9 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -168,6 +168,13 @@ endif
>  ifeq ($(sign_key_with_hash),)
>  $(error Could not determine digest type to use from kernel config)
>  endif
> +ifeq ($(CONFIG_64BIT),y)
> +# 100 years is beyond my best-before date, anyway.
> +end_of_time_days=36500
> +else
> +# Until 32-bit time_t wraps, with some slack.
> +end_of_time_days=$(shell expr \( 2147300000 - `date -u +%s` \) / 86400 )
> +endif
>  
>  signing_key.priv signing_key.x509: x509.genkey
>  	@echo "###"
> @@ -180,7 +187,8 @@ signing_key.priv signing_key.x509: x509.genkey
>  	@echo "###"
>  	@echo "###     rngd -r /dev/hwrandom"
>  	@echo "###"
> -	openssl req -new -nodes -utf8 $(sign_key_with_hash) -days 36500 -batch \
> +	openssl req -new -nodes -utf8 $(sign_key_with_hash) \
> +		-days $(end_of_time_days) -batch \
>  		-x509 -config x509.genkey \
>  		-outform DER -out signing_key.x509 \
>  		-keyout signing_key.priv

That would likely work just fine.  David actually has another patch that
makes 100yrs still work on 32-bit as well that I've tested locally in a
KVM instance.  He was waiting on positive testing confirmation from me
so hopefully he'll send it soon.

josh
