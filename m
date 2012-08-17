Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab2HQRK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:10:56 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34095 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab2HQRKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:10:46 -0400
Message-ID: <1345223322.2257.75.camel@falcor>
Subject: Re: [RFC v2 7/7] modsig: build rules and scripts to generate keys
 and sign modules
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, jmorris@namei.org,
        rusty@rustcorp.com.au, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 17 Aug 2012 13:08:42 -0400
In-Reply-To: <CA+5PVA7ffHv7xOom1SNN8=-qYUQAUnHNXi=TNSX_FcKPUBtgzw@mail.gmail.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	 <2114492cd221edc44622e528d66feeed342d2d34.1345055639.git.dmitry.kasatkin@intel.com>
	 <CA+5PVA4qONeO+VqWQX+f87cs6KAdVPCOEEkpRzfo0M+LR6JHSA@mail.gmail.com>
	 <CALLzPKbP_9jS2E=AG5gHsHYXEfxXh95j=UvwMfVA3OdgYF28eQ@mail.gmail.com>
	 <CA+5PVA6UKvmAb+r2PPtKdDhz5CAWkGihfMS=1nwiO4XpBGrD=g@mail.gmail.com>
	 <CALLzPKYKTbWZMpjKvnCJeqXDknTtKPLSYEPky49a5yNm=8CcHw@mail.gmail.com>
	 <1345164802.2433.21.camel@falcor.watson.ibm.com>
	 <CA+5PVA7ffHv7xOom1SNN8=-qYUQAUnHNXi=TNSX_FcKPUBtgzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081717-9360-0000-0000-000009924208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 07:40 -0400, Josh Boyer wrote:
> On Thu, Aug 16, 2012 at 8:53 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >> >> The reason for "signed_modules_install" is to limit existence of private key.
> >> >> Private key is generate just before install, modules installed and
> >> >> signed, then key is destroyed.
> >> >> So existence of private key is limited to "time make
> >> >> signed_modules_install" execution time.
> >> >>
> >> >> We had a debate about it, and strong message was that we might want to
> >> >> do it like that...
> >> >
> >> > I guess I personally don't see the need to destroy they key so quickly.
> >> > Is the concern that an intruder might grab the key and use it to sign a
> >> > module that the developer would then later on somehow load?  Or
> >> > similarly someone would grab a temporary key from a distro build
> >> > machine?  That limits the attack surface, sure, but I'm not sure it's
> >> > really reasonable.
> >> >
> >> > For a developer that isn't distributing kernels to others, it's just
> >> > adding more time to the compile (which I know can be disabled, but
> >> > still).  For a distribution, most of them are either using a private
> >> > key already or they have a buildsystem that destroys a buildroot after
> >> > a build completes.  The key is already going to be destroyed in that
> >> > scenario.
> >> >
> >> > josh
> >>
> >> Well... Will not argue here. I had similar opinion as well.
> >>
> >> Mimi strongly wanted really to "reduce" the existence time of the key...
> >
> > The options are creating the key during 'make' or 'make
> > modules_install'.  If you create the key during 'make', then you have no
> > way of knowing whether or not it is a persistent or ephemeral key, and
> > whether it should be deleted after signing the modules.
> 
> The buildsystem doesn't really _need_ to know that though.
> 
> > You could create a persistent key using 'make genkey', before 'make',
> > and never delete the private key.  Then there wouldn't be any
> > overhead. :)  If 'CONFIG_INTEGRITY_MODULE' is configured, 'make
> > modules_install' would use the existing key.
> >
> > 'make signed_modules_install' would be for creating and using ephemeral
> > keys.
> >
> > What do you think?
> 
> I don't see a need for the kernel make system to ever delete a key.
> If one doesn't exist, it should create one if the config options are
> set and leave it alone entirely after that.  If one exists already,
> then it should leave it alone as it already does.

Ok.  Other than generating a key the first time, the normal development
build process now uses the same key, never requiring the developer to do
anything additional.  The developer controls the frequency the keys are
created/deleted.  I wonder how often that will be ...

> If you really want to enforce ephemeral keys in the make system, then
> doing it via 'make clean' or 'make distclean' would make more sense to
> me.  But I personally think key management is something the developers
> or distros should be handling on their own.  Creating a key for them is
> a convenience so it's worthwhile, but removing it should be done by
> them.

Sorry, I disagree.  Without the signed_modules_install target, the
developer would need to do each step manually - create new key, sign
modules, remove private key, and embed the new public key in the
bzImage.

I still think the signed_modules_install script, renamed to something
like ephemeral_signed_modules_install, is worthwhile and becomes a
convience tool for the developer, wanting to use ephemeral keys.  The
private key, in Dmitry's updated patches soon to be posted, will be
password protected with a random number, that is only accessible to the
current shell.

thanks,

Mimi

