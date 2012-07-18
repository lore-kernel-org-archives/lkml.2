Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2GRMib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 08:38:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51901 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466Ab2GRMi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 08:38:29 -0400
Date: Wed, 18 Jul 2012 13:38:20 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Revert "KVM: Export asm-generic/kvm_para.h"
Message-ID: <20120718123820.GF25929@mudshark.cambridge.arm.com>
References: <1342607393-32254-1-git-send-email-will.deacon@arm.com>
 <201207181158.07236.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207181158.07236.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, Jul 18, 2012 at 12:58:06PM +0100, Arnd Bergmann wrote:
> On Wednesday 18 July 2012, Will Deacon wrote:
> > This reverts commit 56457f38f212344fb38b250cfa7e7311c065022f.
> > 
> > For architectures without asm/kvm_para.h, asm-generic/Kbuild
> > unconditionally tries to export the non-existent header file, resulting
> > in failure to build the user headers. Since the logic in
> > asm-generic/Kbuild.asm will only export the file if it exists (which in
> > turn causes linux/kvm_para.h to be exported), we can just remove the
> > unconditional header export.
> 
> This doesn't look right.

Ok, something's still amiss with my headers though (see below).

> > I'm not sure what specific problem the original commit was fixing, so we
> > may need to solve this another way if there's something I've missed.
> > 
> >  include/asm-generic/Kbuild |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
> > index 2c85a0f..53f91b1 100644
> > --- a/include/asm-generic/Kbuild
> > +++ b/include/asm-generic/Kbuild
> > @@ -8,7 +8,6 @@ header-y += int-ll64.h
> >  header-y += ioctl.h
> >  header-y += ioctls.h
> >  header-y += ipcbuf.h
> > -header-y += kvm_para.h
> >  header-y += mman-common.h
> >  header-y += mman.h
> >  header-y += msgbuf.h
> 
> include/asm-generic/Kbuild lists the header files in the asm-generic
> directory, and the asm-generic/kvm_para.h always exists, it's
> not architecture specific.

Right. Why do we have a conditional export of kvm_para.h in
include/linux/Kbuild if the asm-generic version always exists? Is it
permitted for an architecture to neither have it's own copy or use the
generic version?

> arch/arm/include/asm/kvm_para.h also always exists, it was added
> in 3b5d56b93 "kvmclock: Add functions to check if the host has
> stopped the vm", although it should have added that to the generated
> header files listed in arch/arm/include/asm/Kbuild.

Why does that have to be added to the list of generated files?
include/asm-generic/Kbuild.asm exports the header if it exists.

> I'm still not sure what you are actually trying to fix here.

Sorry, should've mentioned: this is for AArch64 as opposed to ARM. Trying
to build the headers_check target results in:

  linux/usr/include/linux/kvm_para.h:26: included file 'asm-aarch64/kvm_para.h' is not exported

because the presence of asm-generic/kvm_para.h causes linux/kvm_para.h to
be exported. Ideally, we wouldn't need the header (if that's possible) but
if we have to have it, a generic-y += kvm_para.h would be better than
having a file just containing the line: #include <asm-generic/kvm_para.h>

Thanks,

Will
