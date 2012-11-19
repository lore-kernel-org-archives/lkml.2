Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab2KSQ2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 11:28:44 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:42898 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2KSQ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 11:28:42 -0500
Message-ID: <1353342518.3229.22.camel@lorien2>
Subject: Re: [PATCH RFT RESEND linux-next] openrisc: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Jonas Bonn <jonas@southpole.se>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>, shuahkhan@gmail.com
Date: Mon, 19 Nov 2012 09:28:38 -0700
In-Reply-To: <1353049393.7748.156.camel@jerome.southpole.se>
References: <1351208548.6851.19.camel@lorien2>
	 <1351267555.4013.15.camel@lorien2> <1353002435.2532.39.camel@lorien2>
	 <1353049393.7748.156.camel@jerome.southpole.se>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 08:03 +0100, Jonas Bonn wrote:
> On Thu, 2012-11-15 at 11:00 -0700, Shuah Khan wrote:
> > On Fri, 2012-10-26 at 10:05 -0600, Shuah Khan wrote:
> > > Add support for debug_dma_mapping_error() call to avoid warning from
> > > debug_dma_unmap() interface when it checks for mapping error checked
> > > status. Without this patch, device driver failed to check map error
> > > warning is generated.
> > > 
> > > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > > ---
> > >  arch/openrisc/include/asm/dma-mapping.h |    1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/arch/openrisc/include/asm/dma-mapping.h b/arch/openrisc/include/asm/dma-mapping.h
> > > index fab8628..f12de49 100644
> > > --- a/arch/openrisc/include/asm/dma-mapping.h
> > > +++ b/arch/openrisc/include/asm/dma-mapping.h
> > > @@ -95,6 +95,7 @@ static inline int dma_supported(struct device *dev, u64 dma_mask)
> > >  
> > >  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
> > >  {
> > > +	debug_dma_mapping_error(dev, dma_addr);
> > >  	return 0;
> > >  }
> > >  
> > 
> > Marek/Jonas,
> > 
> > This one is for openrisc to go through Marek's tree with the other arch
> > debug_dma_mapping_error() patches. Hoping it is ok with Jonas.
> 
> NAK... for a bunch of reasons.
> 
> i)   You've sent this exact patch 4 times already... and this time
> you're trying to bypass me altogether by going through some other tree.
> First it was a PATCH, now it's an RFT... what do you want me to do with
> this?
> 
> ii)  There isn't enough information in the commit message to understand
> what's going on here.  Why do I suddenly need this when I never needed
> it before?
> 
> iii) This doesn't compile... but I figured out that it depends on other
> changes that seem to have snuck into linux-next already.  linux-arch was
> never included in that discussion, despite the fact that you have now
> introduced warnings for everybody

The patch was discussed on linux-next at length and the final version
accepted was Patch v5. So it has gone through lots of reviews prior to
going into linux-next.

My apologies for not cc'ing linux-arch. Maybe checkpatch script could be
improved to include linux-arch for dma-debug and generic dma patches
that end up impacting all architectures, so others don't end up going
down the path I went through by missing linux-arch.

> 
> iv)  From what I can tell, you haven't even attempted to fix all
> architectures... but I could be wrong, see next comment.

> 
> v)  You've sent this patch series per-architecture which really only
> serves to fragment the discussion.  When a change is this
> straight-forward (exact same change in each architecture), then it's
> better to consolidate everything into a single patch to allow a single
> discussion to take place.  As it stands now, I have to go rummaging
> through the threads of all 30 architectures to see what others think of
> this; I'd say the silence is telling, but the few responses you did
> receive all show the same confusion and you're answering the same
> questions over and over.  I realize that you can't inflate your patch
> statistics this way and you'll probably just miss the top 10 of "Who
> wrote 3.8" because of it, but you can always try to write something
> witty in your commit message and hope to make "Quotes of the week"
> instead.

Again apologies. You are correct about fragmenting the discussion
because of my not knowing the best route for patches that touch all
architectures such as this one. Something for me to learn from this
experience. No ill intentions to inflate my patch numbers by the way,
just not knowing the right lists to post the patch to.

> 
> vi)  If you _had_ requested comment on your underlying dma-debug patch
> on linux-arch, I think you would have found that:

Right. It would have made it lot easier linux-arch didn't pop up in
checkpatch.

> 
> 1)  introducing warnings without fixing them _at the same time_ isn't OK
> when the fix is this simple
> 2)  if you make changes to core code, you make it optional until all
> arches have caught up
> 3)  you are using get_dma_ops which isn't even implemented on every
> architecture
> 4)  this change probably doesn't belong in every architecture but should
> be centralized in more generic code

The change I made to add debug_dma_mapping_error() follows the dma-debug
architecture to add debug interfaces to arch specific implementations. I
wanted to get this working on x86 and then propagate it to other
architectures and that is what I have been doing. However, I encountered
some unpleasant surprises such as get_dma_ops() dependency, and the
warnings. Hence, the rush to get the arch patches out.

-- Shuah

