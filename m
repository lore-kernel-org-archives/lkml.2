Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab2HQRo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:44:58 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60623 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2HQRou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:44:50 -0400
MIME-Version: 1.0
In-Reply-To: <1345223322.2257.75.camel@falcor>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<2114492cd221edc44622e528d66feeed342d2d34.1345055639.git.dmitry.kasatkin@intel.com>
	<CA+5PVA4qONeO+VqWQX+f87cs6KAdVPCOEEkpRzfo0M+LR6JHSA@mail.gmail.com>
	<CALLzPKbP_9jS2E=AG5gHsHYXEfxXh95j=UvwMfVA3OdgYF28eQ@mail.gmail.com>
	<CA+5PVA6UKvmAb+r2PPtKdDhz5CAWkGihfMS=1nwiO4XpBGrD=g@mail.gmail.com>
	<CALLzPKYKTbWZMpjKvnCJeqXDknTtKPLSYEPky49a5yNm=8CcHw@mail.gmail.com>
	<1345164802.2433.21.camel@falcor.watson.ibm.com>
	<CA+5PVA7ffHv7xOom1SNN8=-qYUQAUnHNXi=TNSX_FcKPUBtgzw@mail.gmail.com>
	<1345223322.2257.75.camel@falcor>
Date: Fri, 17 Aug 2012 13:44:49 -0400
Message-ID: <CA+5PVA71aN+OtY4VA6b+VQO-Wg5vVFE0yJE2ORg5bQWoQk+Yqw@mail.gmail.com>
Subject: Re: [RFC v2 7/7] modsig: build rules and scripts to generate keys and
 sign modules
From: Josh Boyer <jwboyer@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, jmorris@namei.org,
        rusty@rustcorp.com.au, dhowells@redhat.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 1:08 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> I don't see a need for the kernel make system to ever delete a key.
>> If one doesn't exist, it should create one if the config options are
>> set and leave it alone entirely after that.  If one exists already,
>> then it should leave it alone as it already does.
>
> Ok.  Other than generating a key the first time, the normal development
> build process now uses the same key, never requiring the developer to do
> anything additional.  The developer controls the frequency the keys are
> created/deleted.  I wonder how often that will be ...

For a developer, probably not often.  Though in reality, the usage of
this by a single developer seems fair small.  A much wider, already
existing usage is distribution kernel signing.

For a distribution kernel there are normally two cases:

1) Existing permanent company/distro key.  This is already handled.
2) per-kernel-build key (equivalent to your ephemeral key).  This would
be handled fine if the key was generated if it didn't already exist and
left alone.  The distro build system would remove it when it cleaned up
the buildroot.

>> If you really want to enforce ephemeral keys in the make system, then
>> doing it via 'make clean' or 'make distclean' would make more sense to
>> me.  But I personally think key management is something the developers
>> or distros should be handling on their own.  Creating a key for them is
>> a convenience so it's worthwhile, but removing it should be done by
>> them.
>
> Sorry, I disagree.  Without the signed_modules_install target, the
> developer would need to do each step manually - create new key, sign
> modules, remove private key, and embed the new public key in the
> bzImage.

Not if the buildsystem just made the key for them at 'make' time.  I'm
still missing why it isn't done until 'modules_install' time.  Seems
pretty sub-optimal.

> I still think the signed_modules_install script, renamed to something
> like ephemeral_signed_modules_install, is worthwhile and becomes a
> convience tool for the developer, wanting to use ephemeral keys.  The
> private key, in Dmitry's updated patches soon to be posted, will be
> password protected with a random number, that is only accessible to the
> current shell.

I think the existence of an additional make target for signed modules
is really confusing.  Particularly when you consider the target still
exists even if the kernel isn't setup to work with signed modules.  If
the config options are set, just have 'make modules_install' do it and
create a key if one doesn't exist (or better yet, have 'make' do it).

Also... password protecting the key that only responds to the current
shell really sounds like a show-stopper for this being used by distros.
There is no way a distro is going to be able to type a password in
during a kernel build.  It completely removes the usability of distros
that want to use a per-kernel build ephemeral key.  If you're going to
do this, please wrap it in a kconfig option so the second distro case
I mentio above is still possible.

josh
