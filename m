Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab2KETTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:19:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753Ab2KETTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:19:09 -0500
Date: Mon, 5 Nov 2012 14:19:04 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Bruno Wolff III <bruno@wolff.to>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MODSIGN: Only sign modules if built in-tree
Message-ID: <20121105191903.GG27352@hansolo.jdub.homelinux.org>
References: <20121031132749.GH6627@hansolo.jdub.homelinux.org>
 <87390t6bs0.fsf@rustcorp.com.au>
 <20121101112655.GM6627@hansolo.jdub.homelinux.org>
 <20121101145013.GN6627@hansolo.jdub.homelinux.org>
 <87liek4rt5.fsf@rustcorp.com.au>
 <20121102123404.GO6627@hansolo.jdub.homelinux.org>
 <87vcdkyfi4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vcdkyfi4.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 12:31:39PM +1030, Rusty Russell wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> > diff --git a/Makefile b/Makefile
> > index 14c93b3..7e27d51 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -722,8 +722,14 @@ export mod_strip_cmd
> >  ifeq ($(CONFIG_MODULE_SIG),y)
> >  MODSECKEY = ./signing_key.priv
> >  MODPUBKEY = ./signing_key.x509
> > +ifeq ($(KBUILD_EXTMOD),)
> > +SIGNFAIL = false
> > +else
> > +# External builds might not have a signing key, don't break module_install.
> > +SIGNFAIL = true
> > +endif # KBUILD_EXTMOD
> >  export MODPUBKEY
> > -mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
> > +mod_sign_cmd = $(SIGNFAIL) || perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
> >  else
> >  mod_sign_cmd = true
> >  endif
> 
> Huh?  'true || perl' never runs perl due to short circuiting.

Ah.  Maybe you were going for "sign all modules if keys are available,
but don't break external if they aren't" semantics.  I was just skipping
it entirely for external modules.

> Let's do this instead.  Tested here, please ack.

Either method works for me, and I tested this locally as you asked.
Seems to be working well.

> modules: don't break modules_install on external modules with no key.
> 
> The script still spits out an error ("Can't read private key") but we
> don't break modules_install.
> 
> Reported-by: Bruno Wolff III <bruno@wolff.to>
> Original-patch-by: Josh Boyer <jwboyer@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Josh Boyer <jwboyer@redhat.com>

josh

> 
> diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
> index dda4b2b..ecbb447 100644
> --- a/scripts/Makefile.modinst
> +++ b/scripts/Makefile.modinst
> @@ -16,8 +16,9 @@ PHONY += $(modules)
>  __modinst: $(modules)
>  	@:
>  
> +# Don't stop modules_install if we can't sign external modules.
>  quiet_cmd_modules_install = INSTALL $@
> -      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@) ; $(mod_sign_cmd) $(2)/$(notdir $@)
> +      cmd_modules_install = mkdir -p $(2); cp $@ $(2) ; $(mod_strip_cmd) $(2)/$(notdir $@) ; $(mod_sign_cmd) $(2)/$(notdir $@) $(patsubst %,|| true,$(KBUILD_EXTMOD))
>  
>  # Modules built outside the kernel source tree go into extra by default
>  INSTALL_MOD_DIR ?= extra
