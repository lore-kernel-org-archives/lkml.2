Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506Ab1IOTUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:20:53 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54899 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934209Ab1IOTUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:20:51 -0400
Date: Thu, 15 Sep 2011 20:20:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kbuild@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.1-rc1 link failure
Message-ID: <20110915192034.GM6267@n2100.arm.linux.org.uk>
References: <4E402FBB.2070401@gmail.com> <20110808195804.GD19367@n2100.arm.linux.org.uk> <4E724715.1030505@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E724715.1030505@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 11:42:29AM -0700, Stephen Boyd wrote:
> ( Including full text for other lists)
> 
> On 08/08/11 12:58, Russell King - ARM Linux wrote:
> > On Mon, Aug 08, 2011 at 01:49:31PM -0500, Rob Herring wrote:
> >> Russell,
> >>
> >> This commit is causing some link failures:
> >>
> >>     ARM: vmlinux.lds: move discarded sections to beginning
> >>
> >>     Rather than scattering the discarded sections throughout the linker
> >>     file, move them to the start.
> >>
> >>     Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> >>     Tested-by: Stephen Boyd <sboyd@codeaurora.org>
> >>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> >>
> >> The error is this:
> >>
> >> `.exit.text' referenced in section `.alt.smp.init' of
> >> drivers/built-in.o: defined in discarded section `.exit.text' of
> >> drivers/built
> >> -in.o
> >> `.exit.text' referenced in section `.alt.smp.init' of net/built-in.o:
> >> defined in discarded section `.exit.text' of net/built-in.o
> >>
> >> I traced the one in net/ to CONFIG_SMP_ON_UP=y and CONFIG_DCB=y.
> >> dcbnl_exit calls dcb_flushapp which contains a spinlock. dcb_flushapp is
> >> getting inlined into dcbnl_exit.
> > Argh.  This is going to be an absolute _pig_ to fix.
> >
> > This is the relevent part of the linker script (reformatted to make it
> > clearer):
> >
> > | SECTIONS
> > | {
> > |  /*
> > |   * unwind exit sections must be discarded before the rest of the
> > |   * unwind sections get included.
> > |   */
> > |  /DISCARD/ : {
> > |   *(.ARM.exidx.exit.text)
> > |   *(.ARM.extab.exit.text)
> > |  }
> > | ...
> > |  .exit.text : {
> > |   *(.exit.text)
> > |   *(.memexit.text)
> > |  }
> > | ...
> > |  /DISCARD/ : {
> > |   *(.exit.text)
> > |   *(.memexit.text)
> > |   *(.exit.data)
> > |   *(.memexit.data)
> > |   *(.memexit.rodata)
> > |   *(.exitcall.exit)
> > |   *(.discard)
> > |   *(.discard.*)
> > |   }
> > | }
> >
> > Now, this is what the linker manual says about discarded output sections:
> >
> > |    The special output section name `/DISCARD/' may be used to discard
> > | input sections.  Any input sections which are assigned to an output
> > | section named `/DISCARD/' are not included in the output file.
> >
> > No questions, no exceptions.  It doesn't say "unless they are listed
> > before the /DISCARD/ section."  Now, this is what asn-generic/vmlinux.lds.S
> > says:
> >
> > | /*
> > |  * Default discarded sections.
> > |  *
> > |  * Some archs want to discard exit text/data at runtime rather than
> > |  * link time due to cross-section references such as alt instructions,
> > |  * bug table, eh_frame, etc.  DISCARDS must be the last of output
> > |  * section definitions so that such archs put those in earlier section
> > |  * definitions.
> > |  */
> >
> > And guess what - the list _always_ includes .exit.text etc.
> >
> > Now, what's actually happening is that the linker is reading the script,
> > and it finds the first /DISCARD/ output section at the beginning of the
> > script.  It continues reading the script, and finds the 'DISCARD' macro
> > at the end, which having been postprocessed results in another
> > /DISCARD/ output section.  As the linker already contains the earlier
> > /DISCARD/ output section, it adds it to that existing section, so it
> > effectively is placed at the start.  This can be seen by using the -M
> > option to ld:
> >
> > | Linker script and memory map
> > | 
> > |                 0xc037c080                jiffies = jiffies_64
> > | 
> > | /DISCARD/
> > |  *(.ARM.exidx.exit.text)
> > |  *(.ARM.extab.exit.text)
> > |  *(.exit.text)
> > |  *(.memexit.text)
> > |  *(.exit.data)
> > |  *(.memexit.data)
> > |  *(.memexit.rodata)
> > |  *(.exitcall.exit)
> > |  *(.discard)
> > |  *(.discard.*)
> > | 
> > |                 0xc0008000                . = 0xc0008000
> > | 
> > | .head.text      0xc0008000      0x1d0
> > |                 0xc0008000                _text = .
> > |  *(.head.text)
> > |  .head.text     0xc0008000      0x1d0 arch/arm/kernel/head.o
> > |                 0xc0008000                stext
> > | 
> > | .text           0xc0008200   0x2d78d0
> > |                 0xc0008200                _stext = .
> > |                 0xc0008200                __exception_text_start = .
> > |  *(.exception.text)
> > |  .exception.text
> > | ...
> >
> > As you can see, all the discarded sections are grouped together - and
> > as a result of it being the first output section, they all appear before
> > any other section.
> >
> > The result is that not only is the unwind information discarded (as
> > intended), but also the .exit.text, despite us wanting to have the
> > .exit.text preserved.
> >
> > We can't move the unwind information elsewhere, because it'll then be
> > included even when we do actually discard the .exit.text (and similar)
> > sections.
> >
> > The only solution that I can think of is to stop using this
> > asm-generic/vmlinux.lds.S and write our own fully conditionalized
> > linker script, ensuring that no input section is mentioned more than
> > once in the output sections.
> >
> > Or someone sorts out the asm-generic/vmlinux.lds.S stuff to actually
> > conform to the linker manual, and stop relying on implementation defined
> > behaviour of the linker - again by having it fully conditionalized.
> >
> 
> Now that the generic bug patch has been merged to linux-next a lot of
> ARM builds are failing like so:
> 
> `.exit.text' referenced in section `__bug_table' of net/built-in.o: defined in discarded section `.exit.text' of net/built-in.o
> `.exit.text' referenced in section `__bug_table' of net/built-in.o: defined in discarded section `.exit.text' of net/built-in.o
> `.exit.text' referenced in section `__bug_table' of net/built-in.o: defined in discarded section `.exit.text' of net/built-in.o
> 
> 
> I'm not sure what the fix is here. Hopefully we can figure out how to
> keep using the asm-generic stuff.

At the moment, I still have no solution to this problem other than the
undesirable one I mention in the quote.
