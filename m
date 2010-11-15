Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab0KOTAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:00:37 -0500
Received: from sunsite.ms.mff.cuni.cz ([195.113.15.26]:48119 "EHLO
	sunsite.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab0KOTAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:00:36 -0500
Date: Mon, 15 Nov 2010 19:58:48 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Jim Bos <jim876@xs4all.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115185848.GI2583@sunsite.ms.mff.cuni.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <m31v6nmmr3.fsf@jhcloos.com> <AANLkTim2rCuF4p0719YQ3=0s7jhk5FOuTHHAeBWBhvR=@mail.gmail.com> <20101115085605.GE2583@sunsite.ms.mff.cuni.cz> <20101115100331.GG2583@sunsite.ms.mff.cuni.cz> <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com> <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com> <4CE17098.8090000@xs4all.nl> <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com> <4CE17C4B.1070305@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE17C4B.1070305@xs4all.nl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 07:30:35PM +0100, Jim Bos wrote:
> On 11/15/2010 07:08 PM, Linus Torvalds wrote:
> > On Mon, Nov 15, 2010 at 9:40 AM, Jim Bos <jim876@xs4all.nl> wrote:
> >>
> >> Hmm, that doesn't work.
> >>
> >> [ Not sure if you read to whole thread but initial workaround was to
> >> change the asm(..) to asm volatile(..) which did work. ]
> > 
> > Since I have a different gcc than yours (and I'm not going to compile
> > my own), have you posted your broken .s file anywhere? In fact, with
> > the noinline (and the removal of the "+m" thing - iow just the patch
> > you tried), what does just the "i8k_smm" function assembly look like
> > for you after you've done a "make drivers/char/i8k.s"?
> > 
> > If the asm just doesn't exist AT ALL, that's just odd. Because every
> > single call-site of i8k_smm() clearly looks at the return value. So
> > the volatile really shouldn't make any difference from that
> > standpoint. Odd.
> > 
> >                        Linus
> > 
> 
> Attached version with plain 2.6.36 source and version with the committed
> patch, i.e with the '"+m" (*regs)'

Thanks, this actually helped to see the problem.
The problem is not inside of i8k_smm, which is not inlined, but in the
callers.
ipa-pure-const.c pass thinks i8k_smm is a pure function, thus
regs = {};
regs.eax = 166;
x = i8k_smm (&regs);
if (!x) x = regs.eax;
in the callers is optimized into
regs = {}
regs.eax = 166;
x = i8k_smm (&regs);
if (!x) x = 166;
Now, not sure why this happens, as there is
    case GIMPLE_ASM:
      for (i = 0; i < gimple_asm_nclobbers (stmt); i++)
        {
          tree op = gimple_asm_clobber_op (stmt, i);
          if (simple_cst_equal(TREE_VALUE (op), memory_identifier_string) == 1)
            {
              if (dump_file)
                fprintf (dump_file, "    memory asm clobber is not const/pure");
              /* Abandon all hope, ye who enter here. */
              local->pure_const_state = IPA_NEITHER;
            }
        }
Debugging...

	Jakub
