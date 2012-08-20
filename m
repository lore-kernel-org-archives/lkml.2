Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab2HTNPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:15:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35605 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab2HTNPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:15:16 -0400
Message-ID: <1345468396.2355.27.camel@falcor>
Subject: Re: [RFC v2 7/7] modsig: build rules and scripts to generate keys
 and sign modules
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, jmorris@namei.org,
        rusty@rustcorp.com.au, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 20 Aug 2012 09:13:16 -0400
In-Reply-To: <CA+5PVA5=p9Xrd7BWN9XCyG=LJ279wsOfCgWjfhtttUuh9Gp_oQ@mail.gmail.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	 <2114492cd221edc44622e528d66feeed342d2d34.1345055639.git.dmitry.kasatkin@intel.com>
		<CA+5PVA4qONeO+VqWQX+f87cs6KAdVPCOEEkpRzfo0M+LR6JHSA@mail.gmail.com>
		<CALLzPKbP_9jS2E=AG5gHsHYXEfxXh95j=UvwMfVA3OdgYF28eQ@mail.gmail.com>
		<CA+5PVA6UKvmAb+r2PPtKdDhz5CAWkGihfMS=1nwiO4XpBGrD=g@mail.gmail.com>
		<CALLzPKYKTbWZMpjKvnCJeqXDknTtKPLSYEPky49a5yNm=8CcHw@mail.gmail.com>
		<1345164802.2433.21.camel@falcor.watson.ibm.com>
		<CA+5PVA7ffHv7xOom1SNN8=-qYUQAUnHNXi=TNSX_FcKPUBtgzw@mail.gmail.com>
		<1345223322.2257.75.camel@falcor>
		<CA+5PVA71aN+OtY4VA6b+VQO-Wg5vVFE0yJE2ORg5bQWoQk+Yqw@mail.gmail.com>
		<1345424724.2384.15.camel@falcor>
	 <CA+5PVA5=p9Xrd7BWN9XCyG=LJ279wsOfCgWjfhtttUuh9Gp_oQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082013-9360-0000-0000-000009A3555E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 08:32 -0400, Josh Boyer wrote:
> On Sun, Aug 19, 2012 at 9:05 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Fri, 2012-08-17 at 13:44 -0400, Josh Boyer wrote:
> >> On Fri, Aug 17, 2012 at 1:08 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >> >> I don't see a need for the kernel make system to ever delete a key.
> >> >> If one doesn't exist, it should create one if the config options are
> >> >> set and leave it alone entirely after that.  If one exists already,
> >> >> then it should leave it alone as it already does.
> >> >
> >> > Ok.  Other than generating a key the first time, the normal development
> >> > build process now uses the same key, never requiring the developer to do
> >> > anything additional.  The developer controls the frequency the keys are
> >> > created/deleted.  I wonder how often that will be ...
> >>
> >> For a developer, probably not often.  Though in reality, the usage of
> >> this by a single developer seems fair small.  A much wider, already
> >> existing usage is distribution kernel signing.
> >
> > This seems to be the real issue.  Do developers need to sign their own
> > builds?   Nobody is forcing the developer to enable signed modules.  If,
> > however, the developer decides to enforce signed modules, leaving the
> > private key lying around kind of defeats the purpose.
> 
> Right.  The issue is that you're making the kernel buildsystem do key
> management policy instead of trusting the developers using the keys
> mechanism to know what they're doing.
> 
> >> For a distribution kernel there are normally two cases:
> >>
> >> 1) Existing permanent company/distro key.  This is already handled.
> >> 2) per-kernel-build key (equivalent to your ephemeral key).  This would
> >> be handled fine if the key was generated if it didn't already exist and
> >> left alone.  The distro build system would remove it when it cleaned up
> >> the buildroot.
> >
> > Ok, I think we agree here, with the normal 'make', 'make modules_install
> > install', using an existing key or creating a new key if needed.
> >
> >> >> If you really want to enforce ephemeral keys in the make system, then
> >> >> doing it via 'make clean' or 'make distclean' would make more sense to
> >> >> me.  But I personally think key management is something the developers
> >> >> or distros should be handling on their own.  Creating a key for them is
> >> >> a convenience so it's worthwhile, but removing it should be done by
> >> >> them.
> >> >
> >> > Sorry, I disagree.  Without the signed_modules_install target, the
> >> > developer would need to do each step manually - create new key, sign
> >> > modules, remove private key, and embed the new public key in the
> >> > bzImage.
> >>
> >> Not if the buildsystem just made the key for them at 'make' time.  I'm
> >> still missing why it isn't done until 'modules_install' time.  Seems
> >> pretty sub-optimal.
> >
> > Using a private key that has been lying around for an unknown period of
> > time, kind of defeats the purpose.
> 
> Why is that?  Again, you're enforcing policy instead of leaving it up
> to the developers.  In the existing key case, you have no idea how long
> that key has been sitting around either, so I really see a disconnect
> between "existing company/private key" and "no key, create one for them
> during build time" cases.

Either the company build process, creates and cleans up after the build,
removing the private key, as you described above, or the "private key"
is held securely using an existing signing process (or some combination
of the two).

In the "no key, create one for them during build time", there is no
process in place cleaning up, other than the suggested new make target.

> >> > I still think the signed_modules_install script, renamed to something
> >> > like ephemeral_signed_modules_install, is worthwhile and becomes a
> >> > convience tool for the developer, wanting to use ephemeral keys.  The
> >> > private key, in Dmitry's updated patches soon to be posted, will be
> >> > password protected with a random number, that is only accessible to the
> >> > current shell.
> >>
> >> I think the existence of an additional make target for signed modules
> >> is really confusing.  Particularly when you consider the target still
> >> exists even if the kernel isn't setup to work with signed modules.
> >
> > Ok, I see your concern.
> >
> >> If
> >> the config options are set, just have 'make modules_install' do it and
> >> create a key if one doesn't exist (or better yet, have 'make' do it).
> >
> > If creating the key is deferred to 'make modules_install', for the
> > reason given above or any other reason, the public key wasn't available
> > at the time the bzImage was created.  'make modules_install' would now
> > need to rebuild the bzImage.
> 
> Right, which is an utter pain and backwards.  That's why I suggested it
> be done at 'make' time.

Agreed, no doubt about it being a pain or backwards, but the solution
isn't to deny the problem, but to address it.  I'm open to
suggestions. :)

Mimi

