Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768580Ab2KORpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:45:06 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:29901 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768556Ab2KORpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:45:04 -0500
Message-ID: <1353001500.2532.29.camel@lorien2>
Subject: Re: [PATCH RFT RESEND linux-next] c6x: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Mark Salter <msalter@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, a-jacquiot@ti.com,
        linux-c6x-dev@linux-c6x.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Thu, 15 Nov 2012 10:45:00 -0700
In-Reply-To: <1351890491.3161.23.camel@lorien2>
References: <1351206082.6851.6.camel@lorien2>
	 <1351266055.4013.1.camel@lorien2> <1351874655.2721.16.camel@lorien2>
	 <1351883445.15973.24.camel@deneb.redhat.com>
	 <1351885999.3161.11.camel@lorien2>
	 <1351887326.15973.35.camel@deneb.redhat.com>
	 <1351887967.3161.17.camel@lorien2>
	 <1351889957.15973.43.camel@deneb.redhat.com>
	 <1351890491.3161.23.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 15:08 -0600, Shuah Khan wrote:
> On Fri, 2012-11-02 at 16:59 -0400, Mark Salter wrote:
> > On Fri, 2012-11-02 at 14:26 -0600, Shuah Khan wrote:
> > > On Fri, 2012-11-02 at 16:15 -0400, Mark Salter wrote:
> > > > On Fri, 2012-11-02 at 13:53 -0600, Shuah Khan wrote:
> > > > > On Fri, 2012-11-02 at 15:10 -0400, Mark Salter wrote:
> > > > > > On Fri, 2012-11-02 at 10:44 -0600, Shuah Khan wrote:
> > > > > > > On Fri, 2012-10-26 at 09:40 -0600, Shuah Khan wrote:
> > > > > > > > Add support for debug_dma_mapping_error() call to avoid warning from
> > > > > > > > debug_dma_unmap() interface when it checks for mapping error checked
> > > > > > > > status. Without this patch, device driver failed to check map error
> > > > > > > > warning is generated.
> > > > > > > > 
> > > > > > > > Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> > > > > > > > ---
> > > > > > > >  arch/c6x/include/asm/dma-mapping.h |    1 +
> > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > 
> > > > > > > Would you like to this patch go through c6x arch tree or linux-next?
> > > > > > > Please let me know your preference.
> > > > > > 
> > > > > > I tried to test this but I get a build error with CONFIG_DMA_API_DEBUG:
> > > > > > 
> > > > > > /linux-next/lib/dma-debug.c: In function 'has_mapping_error':
> > > > > > /linux-next/lib/dma-debug.c:863:15: error: implicit declaration of function 'get_dma_ops' [-Werror=implicit-function-declaration]
> > > > > > /linux-next/lib/dma-debug.c:863:34: warning: initialization makes pointer from integer without a cast [enabled by default]
> > > > > > 
> > > > > > C6X (along with some other architectures) doesn't have a get_dma_ops()
> > > > > > function defined.
> > > > > 
> > > > > That is a problem I didn't think about. I did a check and looks like c6x
> > > > > and frv are the only ones that don't have get_dma_ops() defined. frv is
> > > > 
> > > > By my count, there are 14 architectures with get_dma_ops() and 14
> > > > without.
> > > Right. I should have explained more. The following archs
> > > 
> > > arch/avr32/include/asm/dma-mapping.h
> > > arch/blackfin/include/asm/dma-mapping.h
> > > arch/cris/include/asm/dma-mapping.h
> > > arch/mn10300/include/asm/dma-mapping.h
> > > arch/parisc/include/asm/dma-mapping.h
> > > arch/xtensa/include/asm/dma-mapping.h
> > > 
> > > define dma_map_page() and dma_map_single() and not call
> > > debug_dma_map_page() interface. There is no risk of mis-matched debug
> > > and non-debug mapping and mapping error checks like in the case of other
> > > archs and c6x.
> > 
> > Ah, okay. Not all architectures support HAVE_DMA_API_DEBUG. So, of those
> > that do, c6x seems to be the only one with dma_ops.
> > 
> > > 
> > > > > in a different category as it doesn't use dma_debug interfaces. IN the
> > > > > case c6x, now with my change to add debug_dma_mapping_error(), we will
> > > > > start seeing warnings since dma_map_page() and dma_map_single() are
> > > > > debugged with a call to debug_dma_map_page() and the corresponding
> > > > > dma_mapping_error() interface doesn't call debug_dma_mapping_error()
> > > > > interface
> > > > > 
> > > > > - Does adding get_dma_ops() make sense? Doesn't look like c6x exports
> > > > > dma_ops?
> > > > > 
> > > > > Any other ideas?
> > > > 
> > > > I'm not sure. I don't know what get_dma_ops() does and it doesn't seem
> > > > to be documented anywhere.
> > > 
> > > It returns pointer to dma_ops like the one on alpha:
> > > 
> > > static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> > > {
> > >         return dma_ops;
> > > }
> > 
> > Okay, so what is dma_ops used for? Looks like maybe supporting different
> > dma features/functionality on different busses/devices.
> > 
> > > 
> > > c6x doesn't define dma_ops looks like. Is that correct? Returning null
> > > from get_dma_ops() is not an option as get_dma_ops() return is assumed
> > > to be not null.
> > 
> > As things stand, c6x DMA hw doesn't really need dma_ops and until this
> > patch, I could build in DMA debug support without dma_ops. So do we
> > really want to require dma_ops for dma debug support even for those
> > architectures which don't otherwise need it? I could add dma_ops, but
> > it seems silly to do so only for dma debug.
> 
> I agree it doesn't make sense to add dma_ops when there is no need to.
> Until now dma-debug didn't depend on dma_ops. This dependency has been
> introduced with the debug_dma_mapping_error() interface I added :(
> 
> Let me go back and see if I can come up with a way to not require
> dma_ops for debug-dma.

Mark/Marek,

This is for c6x to go through Marek's tree with all the other arch
patches. Hope that is ok with you Mark.

https://lkml.org/lkml/2012/11/3/219 fixes the debug_dma_mapping_error()
dependency on get_dma_ops() that caused compile errors on c6x.

Thanks,
-- Shuah

