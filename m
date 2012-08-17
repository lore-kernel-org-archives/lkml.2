Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2HQAyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:54:52 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:40072 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab2HQAyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:54:49 -0400
Message-ID: <1345164802.2433.21.camel@falcor.watson.ibm.com>
Subject: Re: [RFC v2 7/7] modsig: build rules and scripts to generate keys
 and sign modules
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Josh Boyer <jwboyer@gmail.com>, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 20:53:22 -0400
In-Reply-To: <CALLzPKYKTbWZMpjKvnCJeqXDknTtKPLSYEPky49a5yNm=8CcHw@mail.gmail.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	 <2114492cd221edc44622e528d66feeed342d2d34.1345055639.git.dmitry.kasatkin@intel.com>
		<CA+5PVA4qONeO+VqWQX+f87cs6KAdVPCOEEkpRzfo0M+LR6JHSA@mail.gmail.com>
		<CALLzPKbP_9jS2E=AG5gHsHYXEfxXh95j=UvwMfVA3OdgYF28eQ@mail.gmail.com>
		<CA+5PVA6UKvmAb+r2PPtKdDhz5CAWkGihfMS=1nwiO4XpBGrD=g@mail.gmail.com>
	 <CALLzPKYKTbWZMpjKvnCJeqXDknTtKPLSYEPky49a5yNm=8CcHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081700-7408-0000-0000-000007AF5319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 00:04 +0300, Kasatkin, Dmitry wrote:
> On Thu, Aug 16, 2012 at 11:31 PM, Josh Boyer <jwboyer@gmail.com> wrote:
> > On Thu, Aug 16, 2012 at 4:12 PM, Kasatkin, Dmitry
> > <dmitry.kasatkin@intel.com> wrote:
> >>>> 1. signed_modules_install
> >>>> This target creates an ephemeral key pair, signs the kernel modules with
> >>>> the private key, destroys the private key, and embeds the public key in
> >>>> the kernel. (Thanks to Dave Hansen for the target name.)
> >>>
> >>> This requires CONFIG_INTEGRITY_MODULES to be enabled to actually do
> >>> anything useful with the signed modules, correct?
> >>>
> >>
> >> Correct. It does not make sense to sign module if module support is disabled.
> >> But there scripts/genkey.sh and ksign.sh which works without Makefiles.
> >> So possible to generate keys and sign a module...
> >
> > Right, but it won't actually do anything if the config option isn't set.
> > Which means someone calling 'make signed_modules_install' won't actually
> > get signed modules.  That's confusing.
> >
> 
> Yes.. It had to be behind "ifeq CONFIG_INTEGRITY_MODULES"
> 
> >>>> 2. modules_install
> >>>> When CONFIG_INTEGRITY_MODULES is enabled, this target uses an existing
> >>>> private key to sign kernel modules.
> >>>
> >>> If the answer to the above question is yes, then why can't we stick
> >>> with a single modules_install command for signing?  It would seem to me
> >>> that calling signed_modules_install could use an existing key or
> >>> generate an ephemeral key in the absence of one and install the signed
> >>> modules, and modules_install would simply install unsigned modules.
> >>>
> >>> Or, alternatively, just make modules_install sign or not sign depending
> >>> on whether CONFIG_INTEGRITY_MODULES is enabled.
> >>
> >> This is what "make modules_install" does. It uses existing private key
> >> and does not remove it after install.
> >
> > Right.  I should have been more clear.  I was suggesting that "make
> > modules_install" generate a key as well if one does not already exist.
> > Essentially removing the necessity for sign_modules_install.
> >
> >>>  I don't see why you
> >>> would overload a target or create two different ones when both depend
> >>> on that option.
> >>>
> >>> Could you explain the reasoning behind that a bit more?
> >>
> >> The reason for "signed_modules_install" is to limit existence of private key.
> >> Private key is generate just before install, modules installed and
> >> signed, then key is destroyed.
> >> So existence of private key is limited to "time make
> >> signed_modules_install" execution time.
> >>
> >> We had a debate about it, and strong message was that we might want to
> >> do it like that...
> >
> > I guess I personally don't see the need to destroy they key so quickly.
> > Is the concern that an intruder might grab the key and use it to sign a
> > module that the developer would then later on somehow load?  Or
> > similarly someone would grab a temporary key from a distro build
> > machine?  That limits the attack surface, sure, but I'm not sure it's
> > really reasonable.
> >
> > For a developer that isn't distributing kernels to others, it's just
> > adding more time to the compile (which I know can be disabled, but
> > still).  For a distribution, most of them are either using a private
> > key already or they have a buildsystem that destroys a buildroot after
> > a build completes.  The key is already going to be destroyed in that
> > scenario.
> >
> > josh
> 
> Well... Will not argue here. I had similar opinion as well.
> 
> Mimi strongly wanted really to "reduce" the existence time of the key...

The options are creating the key during 'make' or 'make
modules_install'.  If you create the key during 'make', then you have no
way of knowing whether or not it is a persistent or ephemeral key, and
whether it should be deleted after signing the modules.

You could create a persistent key using 'make genkey', before 'make',
and never delete the private key.  Then there wouldn't be any
overhead. :)  If 'CONFIG_INTEGRITY_MODULE' is configured, 'make
modules_install' would use the existing key.

'make signed_modules_install' would be for creating and using ephemeral
keys.

What do you think?

Mimi


