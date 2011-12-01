Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1LAQo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:44:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53796 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab1LAQo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:44:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [Android-virt] [Embeddedxen-devel] [Xen-devel] [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with virt extensions
Date: Thu, 1 Dec 2011 16:44:40 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "android-virt@lists.cs.columbia.edu" 
	<android-virt@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "embeddedxen-devel@lists.sourceforge.net" 
	<embeddedxen-devel@lists.sourceforge.net>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop> <201112011542.19377.arnd@arndb.de> <20111201160241.GH27394@arm.com>
In-Reply-To: <20111201160241.GH27394@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011644.41101.arnd@arndb.de>
X-Provags-ID: V02:K0:p490NXiUoEFWV5EAU4sSp3+/rvpahtzfRdSmhYrWno5
 q5LsxWBu6wn990QuYgcEQDvPApnRTtcU3kNrsyYTCYQtLTUhIr
 23rhsoQbtwt3kcaUPuCVnFFoCmEfeDEVd8JCESh3gyx0CQcsU2
 mUnZSamNxIsRaB9j+2rq/kKdoM3UC6f9h8SksK2EZPUtZgnNNL
 HEGn+plDVWSLWDpjNXD5LBt2LmLm6kxBNb1eAgPP1R98ll1F5W
 MI7FwFW/0V6lJnSULvISihVYWoFHJ/g4u5v/RsuVXSwlx2WGOP
 cTQRDc2DeENy7buG8dTwO557HYz4xyxr4nRLkcLSWU+K094G9S
 ydysH5u8YaveLHbvhCm8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 December 2011, Catalin Marinas wrote:
> On Thu, Dec 01, 2011 at 03:42:19PM +0000, Arnd Bergmann wrote:
> > On Thursday 01 December 2011, Catalin Marinas wrote:
> > How do you deal with signed integer arguments passed into SVC or HVC from
> > a caller? If I understand the architecture correctly, the upper
> > halves of the argument register end up zero-padded, while the callee
> > expects sign-extension.
> 
> If you treat it as an "int" (32-bit) and function prototype defined
> accordingly, then the generated code only accesses it as a W (rather
> than X) register and the top 32-bit part is ignored (no need for
> sign-extension). If it is defined as a "long" in the 32-bit world, then
> it indeed needs explicit conversion given the different sizes for long
> (for example sys_lseek, the second argument is a 'long' and we do
> explicit sign extension in the wrapper).

Ok, so it's actually different from most other 64 bit architectures, which
normally operate on 64-bit registers and expect the caller to do the
correct sign-extension.

Doing the sign-extension for long arguments then falls into the same
category as long long and unsigned long long arguments, which also need
a wrapper, as you mentioned. Strictly speaking, we only need to do it
for those where the long argument has a meaning outside of the 0..2^31
range, e.g. io_submit can only take small positive numbers although
the type is 'long'.

What about unsigned long and pointer? Can we always rely on the upper
half of the register to be zero-filled when we get an exception from 32
bit into 64 bit state, or do we also have to zero-extend those?

	Arnd
