Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1HRTb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:31:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34896 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1HRTb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:31:57 -0400
Date: Thu, 18 Aug 2011 20:31:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Sam Ravnborg <sam@ravnborg.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] ARM: zImage: Skip relinking if nothing changes
Message-ID: <20110818193132.GA28546@n2100.arm.linux.org.uk>
References: <4E457682.5020107@codeaurora.org> <1313175602-21834-1-git-send-email-sboyd@codeaurora.org> <CACqU3MUq5M-XPOxV=8GKyEzjEzpmdeaF+mGrXJrK+ZZxa4SdeQ@mail.gmail.com> <CACqU3MXtcg_8si9WiuZngMB2C977PS4zen8_cQ9oyNtwTbt75Q@mail.gmail.com> <alpine.LFD.2.00.1108172339270.20358@xanadu.home> <CACqU3MUV=-hQ_y3wLPBYRh+DhLcFqneWbURNQ66UyArb5UJcxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACqU3MUV=-hQ_y3wLPBYRh+DhLcFqneWbURNQ66UyArb5UJcxw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 02:03:43PM -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Wed, Aug 17, 2011 at 11:44 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
> > On Fri, 12 Aug 2011, Arnaud Lacombe wrote:
> >> On Fri, Aug 12, 2011 at 4:48 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> >> > On Fri, Aug 12, 2011 at 3:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >> >> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> >> >> index 0c74a6f..937fd26 100644
> >> >> --- a/arch/arm/boot/compressed/Makefile
> >> >> +++ b/arch/arm/boot/compressed/Makefile
> >> >> @@ -91,7 +91,7 @@ suffix_$(CONFIG_KERNEL_LZMA) = lzma
> >> >>
> >> >>  targets       := vmlinux vmlinux.lds \
> >> >>                 piggy.$(suffix_y) piggy.$(suffix_y).o \
> >> >> -                font.o font.c head.o misc.o $(OBJS)
> >> >> +                font.o font.c head.o misc.o lib1funcs.o lib1funcs.S $(OBJS)
> >> >>
> >> >>  # Make sure files are removed during clean
> >> >>  extra-y       += piggy.gzip piggy.lzo piggy.lzma lib1funcs.S
> >> >> @@ -121,9 +121,7 @@ LDFLAGS_vmlinux += -X
> >> >>  LDFLAGS_vmlinux += -T
> >> >>
> >> >>  # For __aeabi_uidivmod
> >> >> -lib1funcs = $(obj)/lib1funcs.o
> >> >> -
> >> >> -$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S FORCE
> >> >> +$(obj)/lib1funcs.S: $(srctree)/arch/$(SRCARCH)/lib/lib1funcs.S
> >> >>        $(call cmd,shipped)
> >> >>
> >> > You should be able to avoid the extra copy altogether by doing something ala:
> >> >
> >> > $(obj)/lib1funcs.o: $(srctree)/arch/arm/lib/lib1funcs.S
> >> >        $(call cmd,as_o_S)
> >> >
> >> > note that I also remove the $(SRCARCH), as there is no other
> >> > `arch/*/lib/lib1funcs.S' than `arch/arm/lib/lib1funcs.S'
> >> >
> >> I withdraw this proposal and will hack around this to find a proper
> >> solution from within kbuild, and eventually come back on these uses
> >> :-)
> >
> > Any progress on this?
> >
> > I have a patch doing multiple similar $(call cmd,shipped) at the moment
> > and this is far from looking nice.
>
> What is your use-case ? Is it re-use of code in a different
> subdirectory (use-case presented in this thread), or aliasing of the
> same source under different object name in the same directory (as used
> in the alpha tree) ?

It is to be able to reuse the same file source file in both the main
kernel and the decompressor, sometimes rebuilding it with differing
options from the main kernel build.

As the two environments are entirely separate, it is not always
appropriate to clone the previously built object file.

Hence, we copy the source file and re-build it.

The alternative is that we could keep two copies of the same source
in two different locations, but that's just plain idiotic just to
satisfy some silly kbuild restriction.
