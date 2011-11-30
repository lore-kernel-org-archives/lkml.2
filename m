Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab1K3SPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 13:15:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63925 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab1K3SP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 13:15:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] [ANNOUNCE] Xen port to Cortex-A15 / ARMv7 with virt extensions
Date: Wed, 30 Nov 2011 18:15:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "android-virt@lists.cs.columbia.edu" 
	<android-virt@lists.cs.columbia.edu>,
        "embeddedxen-devel@lists.sourceforge.net" 
	<embeddedxen-devel@lists.sourceforge.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <alpine.DEB.2.00.1111281009090.31179@kaball-desktop> <201111301432.54463.arnd@arndb.de> <1322670473.31810.129.camel@zakaz.uk.xensource.com>
In-Reply-To: <1322670473.31810.129.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111301815.01297.arnd@arndb.de>
X-Provags-ID: V02:K0:0QF1cQvBrkFixJKucsdEWFs++J4ZdGCXd6xZLH0sUdP
 21sqNZwWW2YwtvqbQU2Vs+iQ4BgIvZVvo/jsjy2ecSHgQveLPk
 Tjz7jIsFzmcDdfNKxCi3i0SWyVisDmPvpwSOiWUs3+qYfYotgY
 SzSFXIT4rrefbhicv0lGTuxjkL8QLX8Rt+d+4AMJRi2qoyJNZk
 hjHtyd8Tvl4d8Pr4lm8BaAqnC29b/z/Ofz4aoYhjXHxQaVhYP1
 sa9U+vGtMYMM4pgmbuMUug7CKpm50HgsgC8Pyanp79QMu5i4kc
 GJLL0GRZ3vW3xUL2hHubZN0QyoqMEefw/Q7qX0RdMYvcLoHidJ
 nlIloH22xJUm+hwTXhNE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 November 2011, Ian Campbell wrote:
> On Wed, 2011-11-30 at 14:32 +0000, Arnd Bergmann wrote:
> > On Wednesday 30 November 2011, Ian Campbell wrote:
> > What I suggested to the KVM developers is to start out with the
> > vexpress platform, but then generalize it to the point where it fits
> > your needs. All hardware that one expects a guest to have (GIC, timer,
> > ...) will still show up in the same location as on a real vexpress,
> > while anything that makes no sense or is better paravirtualized (LCD,
> > storage, ...) just becomes optional and has to be described in the
> > device tree if it's actually there.
> 
> That's along the lines of what I was thinking as well.
> 
> The DT contains the address of GIC, timer etc as well right? So at least
> in principal we needn't provide e.g. the GIC at the same address as any
> real platform but in practice I expect we will.

Yes.

> In principal we could also offer the user options as to which particular
> platform a guest looks like.

At least when using a qemu based simulation. Most platforms have some
characteristics that are not meaningful in a classic virtualization
scenario, but it would certainly be helpful to use the virtualization
extensions to run a kernel that was built for a particular platform
faster than with pure qemu, when you want to test that kernel image.

It has been suggested in the past that it would be nice to run the
guest kernel built for the same platform as the host kernel by
default, but I think it would be much better to have just one
platform that we end up using for guests on any host platform,
unless there is a strong reason to do otherwise.

There is also ongoing restructuring in the ARM Linux kernel to
allow running the same kernel binary on multiple platforms. While
there is still a lot of work to be done, you should assume that
we will finish it before you see lots of users in production, there
is no need to plan for the current one-kernel-per-board case.

> > Ok. It would of course still be possible to agree on an argument passing
> > convention so that we can share the macros used to issue the hcalls,
> > even if the individual commands are all different.
> 
> I think it likely that we can all agree on a common calling convention
> for N-argument hypercalls. It doubt there are that many useful choices
> with conflicting requirements yet strongly compelling advantages.

Exactly. I think it's only lack of communication that has resulted in
different interfaces for each hypervisor on the other architectures.

KVM and Xen at least both fall into the single-return-value category,
so we should be able to agree on a calling conventions. KVM does not
have an hcall API on ARM yet, and I see no reason not to use the
same implementation that you have in the Xen guest.

Stefano, can you split out the generic parts of your asm/xen/hypercall.h
file into a common asm/hypercall.h and submit it for review to the
arm kernel list?

	Arnd
