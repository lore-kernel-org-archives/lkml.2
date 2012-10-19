Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691Ab2JSNgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:36:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab2JSNgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:36:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121014085617.GA22544@gmail.com>
References: <20121014085617.GA22544@gmail.com> <11002.1350125310@warthog.procyon.org.uk> <CA+55aFzu83ktX=ereRACNa6stEU0H5vNxKObUN9bymYCCaHyew@mail.gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        paulus@samba.org, davem@davemloft.net, jaxboe@fusionio.com,
        tj@kernel.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] perf: Fix UAPI fallout
Date: Fri, 19 Oct 2012 14:35:37 +0100
Message-ID: <30780.1350653737@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> wrote:

> What we want in .c files are not ../.. inclusions but the 
> 'seemless' <linux/abc.h> inclusions. Which is the overwhelming 
> majority, gladly. Do we want to make that the 100% majority?

I think this is going to be necessary for when x86 gets merged.  x86's
asm/unistd.h #includes uapi/asm/unistd.h, so you can't manually specify the
header without also specifying a -I flag.

I've been having a prod at it, and this seems to partially work:

	-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
	+$(info XXX $(srctree))
	+
	+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I../../arch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE

However, I'm trying to work out what will happen if this is run in a separate
output dir, but if I do:

	make tools/perf O=build_dir

from the bottom directory, I get:

	scripts/Makefile.include:2: *** O=build_dir does not exist.  Stop.

The problem is that the bottom-level Makefile does this:

	tools/: FORCE
		$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/
	tools/%: FORCE
		$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*

which changes the directory, rendering a relative O= that would be good for
building the normal kernel useless for building a tool.  Should these rules
respecify the O= flag here, or should we give an error if someone tries it?

David
