Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761407Ab2KAL1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:27:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab2KAL1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:27:01 -0400
Date: Thu, 1 Nov 2012 07:26:56 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Bruno Wolff III <bruno@wolff.to>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: Only sign modules if built in-tree
Message-ID: <20121101112655.GM6627@hansolo.jdub.homelinux.org>
References: <20121031132749.GH6627@hansolo.jdub.homelinux.org>
 <87390t6bs0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87390t6bs0.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 05:38:15PM +1030, Rusty Russell wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> > When building out-of-tree modules, the current modules_install target
> > will attempt to sign them if module signing is enabled.  This will only
> > work if the signing keys are present in the build tree.  That will
> > often not be the case for modules that are built out-of-tree against
> > distribution kernel development packages.  This distros will not include
> > the signing keys, and build errors such as:
> >
> >     INSTALL /home/bruno/rpmbuild/BUILD/dahdi-linux-2.6.1/drivers/dahdi/dahdi_dyamic_eth.ko
> >     Can't read private key
> >     make[2]: *** [/home/bruno/rpmbuild/BUILD/dahdi-linux-2.6.1/drivers/dahdi/dahdi_dynamic.ko] Error 2
> >
> > will prevent such modules from successfully being installed.  This changes
> > the mod_sign_cmd to only sign the modules if they are built in-tree.  Those
> > built externally can sign them manually.
> 
> I prefer something like this (untested):
> 
> diff --git a/Makefile b/Makefile
> index 42d0e56..cb66c8d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -722,8 +722,14 @@ export mod_strip_cmd
>  ifeq ($(CONFIG_MODULE_SIG),y)
>  MODSECKEY = ./signing_key.priv
>  MODPUBKEY = ./signing_key.x509
> +ifeq ($(KBUILD_EXTMOD),)
> +SIGNFAIL = false
> +else
> +# External builds might not have a signing key, don't break module_install.
> +SIGNFAIL = true
> +endif # KBUILD_EXTMOD
>  export MODPUBKEY
> -mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
> +mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY) || $(SIGNFAIL)
>  else
>  mod_sign_cmd = true
>  endif

OK.  I'll give this a spin locally today, but at first glance it seems
like it would do the same.

josh
