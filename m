Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1BVHCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 02:02:43 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:62199 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390Ab1BVHCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 02:02:40 -0500
Date: Mon, 21 Feb 2011 23:02:40 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
 module versions
Message-ID: <20110222070240.GA21765@dtor-ws.eng.vmware.com>
References: <AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com>
 <20110217.140119.39175251.davem@davemloft.net>
 <20110217221957.GA11244@dtor-ws.eng.vmware.com>
 <20110217.142320.102554706.davem@davemloft.net>
 <AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com>
 <AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com>
 <1298074455.2460.85.camel@pasglop>
 <87pqqmrq9q.fsf@rustcorp.com.au>
 <1298339909.8833.135.camel@pasglop>
 <AANLkTimyaA+JdBHekm69R5Y2A2DEdPdndFLrKJAaz=vt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimyaA+JdBHekm69R5Y2A2DEdPdndFLrKJAaz=vt@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 06:03:16PM -0800, Linus Torvalds wrote:
> On Mon, Feb 21, 2011 at 5:58 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > The only sane thing I can see is make sure that such structures that
> > we put into sections "arrays" like that are naturally aligned with
> > padding.
> 
> The sad part is, that assuming I read the gcc sources correctly (see
> the earlier emails where David pointed to it), that alignment is:
>  - architecture-specific
>  - depends on the size of the structure
>  - seems to depend on the version of gcc itself.
> 
> The _one_ safe case is likely to be "structure size is a power of
> two". And it does look like using a pointer is going to be safe, not
> only because the gcc auto-alignment only triggers for things like
> structs/unions/arrays, but because at least the x86 code only does it
> if the structure was bigger than the alignment size itself.
> 
> So using pointer indirection is likely to be safe. It's still ugly and
> annoying as heck, though.
> 

Regardless the approach we'll take I think the following patch is also
needed (for cris architecture). I am not sure why __param section is
inly defined for one specific subarch but I they need __param they'll
need __modev as well.

Thanks,

Dmitry

>From a567280f900c15891a55e7ea4e2919b38e1d1a01 Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dtor@vmware.com>
Date: Thu, 17 Feb 2011 13:12:26 -0800
Subject: [PATCH] cris: add missing __modver section

Commit e94965ed5beb23c6fabf7ed31f625e66d7ff28de added a new __modver
section to store module version information for drivers built into the
kernel, but missed the fact that cris does some additional steps to
set up sections.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 arch/cris/kernel/vmlinux.lds.S |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
index 4422189..fae1b7b 100644
--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -73,6 +73,10 @@ SECTIONS
 	.init.data : { INIT_DATA }
 	.init.setup : { INIT_SETUP(16) }
 #ifdef CONFIG_ETRAX_ARCH_V32
+	__start___modver = .;
+	__modver : { *(__modver) }
+	__stop___modver = .;
+
 	__start___param = .;
 	__param : { *(__param) }
 	__stop___param = .;
-- 
1.7.3.2

