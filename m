Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab1FIXmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:42:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:41359 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab1FIXmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:42:53 -0400
Subject: Re: [PATCH] [RFC][V3] bluegene: use MMU feature flag to
 conditionalize L1 writethrough code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <BANLkTinD+1+QTUhKvQP-T_bZgbi1YS1jwQ@mail.gmail.com>
References: <1307482573-25440-1-git-send-email-ericvh@gmail.com>
	 <1307494057.2874.212.camel@pasglop>
	 <BANLkTinD+1+QTUhKvQP-T_bZgbi1YS1jwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 09:42:28 +1000
Message-ID: <1307662948.2874.293.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 09:58 -0500, Eric Van Hensbergen wrote:
> On Tue, Jun 7, 2011 at 7:47 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Tue, 2011-06-07 at 16:36 -0500, Eric Van Hensbergen wrote:
> >
> >> open to alternatives.  jimix also suggested changing NEED_L1_WRITETHROUGH
> >> to DCBZ_BROKEN, which I'm open to if you think appropriate, or maybe
> >> DCBZ_BROKEN_DAMNIT would be more apt.
> >
> > :-)
> >
> > I think NEED_L1_WRITETHROUGH isn't great since we are dealing with more
> > than just that here. Let's call it 44x_SMP since afaik, all
> > implementations, whether it's BG or other variants of the same hack
> > (AMCC/APM has one too) need the same stuff here, no ?
> >
> > Let's not use more than one feature bit, it's not needed in practice, a
> > better name is all we need. Might even call it MMU_FTR_BLUEGENE_44x_SMP
> > if you want.
> >
> 
> I've got it as MMU_FTR_44x_SMP now, 

Keep it BGP for now as my understanding is that some of those TLB bits
are quite specific to the way the BGP ASIC operates. AFAIK The only
possible other user of that is that dual 464 chip from AMCC/APM but I
yet have to see them try to get SMP on that, and I don't know how their
caches work at this point.

> just wanted to bounce off of Josh to
> make sure he's okay with it since he owns the 44x stuff.  If he'd
> rather, I'll change
> it to MMU_FTR_BGP_44x_SMP.
> 
> >
> > I'll add comments inline:
> >
> >>  #define PPC44x_MMUCR_TID     0x000000ff
> >>  #define PPC44x_MMUCR_STS     0x00010000
> >> +#define PPC44x_MMUCR_U2              0x00200000
> >
> > Please document in a comment what is the effect of U2 on the BG/P ASIC
> > caches.
> >
> 
> Is a comment sufficient, or would you rather also have something along
> the lines of
> +#define PPC44x_MMUCR_U2              0x00200000
> +#define PPC44x_MMUCR_U2_SWOAE   PPC44x_MMUCR_U2 /* store without allocation */
>
> or even...
> +#define PPC44x_MMUCR_U2_BGP_SWOAE   PPC44x_MMUCR_U2 /* store without
> allocation on BGP */

My point was more like: You have U2, that other W1 bit etc... it's
unclear which does what here and a blurb explaining how the caches
operate on this setup would be useful.

I don't care much about the name of the constants, "SWOAE" isn't very
informative either, I'm really talking about adding a nice comment
explaining what they do :-)

> Seems like its getting a bit too verbose, maybe that's not a bad
> thing.  As long as I don't have to type it
> too many times :)

Right, don't make the constant horrible, just explain what it does.

> > BTW. Care to explain to me why you have U2 -both- in the arguments to
> > tlbwe and in MMUCR ? That doesn't look right to me... which one is used
> > where and when ?
> >
> 
> My reading of the databook is that U2SWOAE is an enable bit that lets the U2
> storage attribute control the behavior.

You mean the MMUCR variant ?

> >> @@ -814,7 +829,15 @@ skpinv:  addi    r4,r4,1                         /* Increment */
> >>       /* attrib fields */
> >>       /* Added guarded bit to protect against speculative loads/stores */
> >>       li      r5,0
> >> -     ori     r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | PPC44x_TLB_G)
> >> +BEGIN_MMU_FTR_SECTION
> >> +     ori     r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
> >> +                                             PPC44x_TLB_G | PPC44x_TLB_U2)
> >> +     oris    r5,r5,PPC44x_TLB_WL1@h
> >> +END_MMU_FTR_SECTION_IFSET(MMU_FTR_NEED_L1_WRITETHROUGH)
> >> +BEGIN_MMU_FTR_SECTION
> >> +     ori     r5,r5,(PPC44x_TLB_SW | PPC44x_TLB_SR | PPC44x_TLB_SX | \
> >> +                     PPC44x_TLB_G)
> >> +END_MMU_FTR_SECTION_IFCLR(MMU_FTR_NEED_L1_WRITETHROUGH)
> >>
> >>          li      r0,63                    /* TLB slot 63 */
> >
> > This isn't going to work. This happens before the CPU feature bits are
> > established.
> >
> > I see two ways out of that dilemna:
> >
> >  - One is you find a way to identify the BG case at runtime from that
> > very early asm code. It's a bit tricky since we never added the MMU type
> > information to the device-tree blob header (but we're adding it to ePAPR
> > via a register iirc, so we could hijack that), or maybe via inspecting
> > what the FW left behind in the TLB...
> >
> 
> Well, if we are using the u-boot scenario, I can control how the
> bootloader sets up the device tree and add markers that we can use to
> let us do this.

Well, point is, parsing the device-tree from early boot asm is nasty,
unless you start extending the header but that sucks. That's why I'm
thinking it might be a good idea to look at what it takes to "convert"
the initial entry instead, even if that involves some cache flushing
(provided that's workable at all of course).

Cheers
Ben.



