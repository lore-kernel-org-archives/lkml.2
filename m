Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0K2Pur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:50:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56023 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab0K2Puq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:50:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI Bus
Date: Mon, 29 Nov 2010 16:50:30 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        linux-kernel@vger.kernel.org
References: <1290263224-16965-1-git-send-email-ulli.kroll@googlemail.com> <201011271639.21694.arnd@arndb.de> <20101129142200.GA14941@n2100.arm.linux.org.uk>
In-Reply-To: <20101129142200.GA14941@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201011291650.30982.arnd@arndb.de>
X-Provags-ID: V02:K0:3B3lz184uXv0TuPjdyTe8GRkzch67+I5d71fbiKewOp
 FC9tIOPcxN3qLtiJhb/cSJ13XSuL+XKQuHbaRUFJ3gvCDPetaf
 xde3+f1XNpr4uyViPh+C3fyA92rY5PZ1ew9GWSz7woeTeS0OM2
 kxoOwh5wv5NN9A8p+oL9myqZKUlAegISMtk99Jzdn/Hkkxe469
 KV5DvpZ9XEDj6CiapPLXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 November 2010, Russell King - ARM Linux wrote:
> On Sat, Nov 27, 2010 at 04:39:21PM +0100, Arnd Bergmann wrote:
> > On Saturday 27 November 2010 14:01:20 Michał Mirosław wrote:
>
> Be careful.  There are two things going on here:
> 
> 1. those which PCI support is configurable
> 2. those which always have PCI support
> 
> Making PCI "depend on HAVE_PCI" is wrong, and will throw up lots of
> Kconfig warnings, as those platforms which always have PCI support
> won't select HAVE_PCI - and making them do so such that "PCI support"
> gets offered to them - with the only possible value being 'Y' is
> silly.

We definitely need to be careful with combinations of select and
depends. The obvious danger is enabling two boards, one of which
requires PCI while the other one cannot deal with CONFIG_PCI=y.
As we get to more multiplatform builds, we have to eventually
solve this, along with the problem that certain PCI implementations
are currently mutually exclusive.

What behaviour do you want to see in a multiplatform build where
one board is known to have PCI, one may have it and a third
one cannot have PCI? Should it be enabled, disabled or
user-selected.

> So, rather than HAVE_PCI, it should be MIGHT_HAVE_PCI, and that
> symbol needs to control whether the "PCI support" prompt is offered
> to the user, not whether PCI is available or not.

Most architectures make PCI optional even though it is a bit silly
to disable it like on x86. There are a lot of other useful configuration
options that end up always enabled in practice.

The easiest way would be to always select HAVE_PCI (or MIGHT_HAVE_PCI
if you prefer the term) and make the default CONFIG_PCI default to
yes.

Or you could go fancy and have both HAVE_PCI and MIGHT_HAVE_PCI, with
each platform selecting at most one of the two and this

config PCI
	bool "PCI support"
	depends on MIGHT_HAVE_PCI && !HAVE_PCI
	default HAVE_PCI

This way it will be silently turned on if one of the machines requires
PCI, but stay visible if the machines might want to disable PCI.

	Arnd
