Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934842Ab0HDUkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:40:12 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:33429 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934911Ab0HDUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:40:04 -0400
Date: Wed, 4 Aug 2010 22:40:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>,
        Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: missing .data.shared_align placement in vmlinux
Message-ID: <20100804204002.GA22147@merkur.ravnborg.org>
References: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com> <20100804115658.GA21357@merkur.ravnborg.org> <AANLkTikz7pvirg7VUxrm-6v=yrLwHy4UeaJTS0wz3BLc@mail.gmail.com> <20100804202806.GA22134@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100804202806.GA22134@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend - this time with Jeremy included in To: ]

Jeremy - you introduced this in ("x86/i386: Put aligned
stack-canary in percpu shared_aligned section")
53f824520b6d84ca5b4a8fd71addc91dbf64357e

Does the following simple fix look correct to you?
[See below]

	Sam

> 
On Wed, Aug 04, 2010 at 10:28:06PM +0200, Sam Ravnborg wrote:
> On Wed, Aug 04, 2010 at 02:12:03PM -0400, Mike Frysinger wrote:
> > On Wed, Aug 4, 2010 at 07:56, Sam Ravnborg wrote:
> > > On Fri, May 21, 2010 at 04:58:53PM -0400, Mike Frysinger wrote:
> > >> am i missing something or does the .data.shared_align section lack
> > >> definition in vmlinux.lds.h and all arch vmlinux.lds.S files ?
> > >>
> > >> with the recent change "net: remove time limit in process_backlog()",
> > >> the softnet_data variable changed from "DEFINE_PER_CPU()" to
> > >> "DEFINE_PER_CPU_ALIGNED()" which moved it from the .data section to
> > >> the .data.shared_align section.  i'm not saying this patch is wrong,
> > >> just that is what caused me to notice this larger problem.  no one
> > >> else in the kernel is using this aligned macro variant, so i imagine
> > >> that's why no one has noticed yet.
> > >>
> > >> since .data.shared_align isnt declared in any vmlinux files that i can
> > >> see, the linker just places it last.  this "just works" for most
> > >> people, but when building a ROM kernel on Blackfin systems, it causes
> > >> section overlap errors:
> > >> bfin-uclinux-ld.real: section .init.data [00000000202e06b8 ->
> > >> 00000000202e48b7] overlaps section .data.shared_aligned
> > >> [00000000202e06b8 -> 00000000202e0723]
> > >> i imagine other arches which support the ROM config option and thus do
> > >> funky placement would see similar issues ...
> > >>
> > >> on x86, it is stuck in a dedicated section:
> > >>   [ 8] .data             PROGBITS        ffffffff810ec000 2ec000
> > >> 0303a8 00  WA  0   0 4096
> > >>   [ 9] .data.shared_alig PROGBITS        ffffffff8111c3c0 31c3c0
> > >> 0000c8 00  WA  0   0 64
> > >>
> > >> the ifdef forest in asm-generic/percpu.h is beyond a quick glance &
> > >> fix, so i leave it up to someone else ;)
> > >
> > > as there any resolution on this?
> > > I briefly looked at it some time ago.
> > > And it looks like a plain oversight.
> > 
> > no, it's still broken in 2.6.35 :(
> > $ make ARCH=blackfin BF537-STAMP_defconfig
> > $ make ARCH=blackfin -s -j4
> > $ readelf -WS vmlinux | grep '\<data\>'
> >   [10] .data             PROGBITS        0018369c 17269c 012964 00  WA  0   0  4
> >   [11] .data..shared_aligned PROGBITS        00196000 185000 00006c 00
> >  WA  0   0  4
> 

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 030a954..e87260f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -150,6 +150,7 @@
 #define DATA_DATA							\
 	*(.data)							\
 	*(.ref.data)							\
+	*(.data..shared_aligned) /* percpu related */			\
 	DEV_KEEP(init.data)						\
 	DEV_KEEP(exit.data)						\
 	CPU_KEEP(init.data)						\
