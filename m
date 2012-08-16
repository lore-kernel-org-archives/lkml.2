Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030470Ab2HPUOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 16:14:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56974 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030338Ab2HPUOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 16:14:19 -0400
Message-ID: <1345147963.3402.37.camel@falcor.watson.ibm.com>
Subject: Re: [RFC v2 7/7] modsig: build rules and scripts to generate keys
 and sign modules
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, jmorris@namei.org,
        rusty@rustcorp.com.au, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 16:12:43 -0400
In-Reply-To: <CA+5PVA4qONeO+VqWQX+f87cs6KAdVPCOEEkpRzfo0M+LR6JHSA@mail.gmail.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	 <2114492cd221edc44622e528d66feeed342d2d34.1345055639.git.dmitry.kasatkin@intel.com>
	 <CA+5PVA4qONeO+VqWQX+f87cs6KAdVPCOEEkpRzfo0M+LR6JHSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081620-9360-0000-0000-00000989603F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 15:10 -0400, Josh Boyer wrote:
> On Wed, Aug 15, 2012 at 2:43 PM, Dmitry Kasatkin
> <dmitry.kasatkin@intel.com> wrote:
> > This patch adds build rules and scripts to generate keys and sign modules.
> >
> > Two scripts has been added. genkey.sh is used to generate private and
> > public keys. ksign.sh is used to sign kernel modules. Both scripts
> > use only standard utilites from coreutils and additionally requires
> > openssl tool for RSA keys creation and signing.
> >
> > The patch modifies 'modules_install' target and adds two new targets to
> > the main kernel Makefile.
> >
> > 1. signed_modules_install
> > This target creates an ephemeral key pair, signs the kernel modules with
> > the private key, destroys the private key, and embeds the public key in
> > the kernel. (Thanks to Dave Hansen for the target name.)
> 
> This requires CONFIG_INTEGRITY_MODULES to be enabled to actually do
> anything useful with the signed modules, correct?
> 
> >
> > 2. modules_install
> > When CONFIG_INTEGRITY_MODULES is enabled, this target uses an existing
> > private key to sign kernel modules.
> 
> If the answer to the above question is yes, then why can't we stick
> with a single modules_install command for signing?  It would seem to me
> that calling signed_modules_install could use an existing key or
> generate an ephemeral key in the absence of one and install the signed
> modules, and modules_install would simply install unsigned modules.
> 
> Or, alternatively, just make modules_install sign or not sign depending
> on whether CONFIG_INTEGRITY_MODULES is enabled.  I don't see why you
> would overload a target or create two different ones when both depend
> on that option.
> 
> Could you explain the reasoning behind that a bit more?

If the key exists during the build, there is no need for the additional
'make bzImage'.  I'll update the patch description based on the
following explaination taken from the cover letter:

For the developer, these patches create an ephemeral key during module
install, in order to limit the duration of the private key's existence.
Unfortunately, this necessitates embedding the public key in the kernel,
after the kernel has already been built.  A new make target called
'signed_modules_install', creates the keypair, signs the modules,
removes the private key, and then, for now, recompiles the kernel using
'make bzImage'.  For the developer, instead of doing 'make
modules_install', the new build process would be 'make', followed by
'make signed_modules_install' and 'make install'.

thanks,

Mimi

