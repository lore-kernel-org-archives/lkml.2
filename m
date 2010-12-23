Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab0LWJUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 04:20:02 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40438 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0LWJT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 04:19:59 -0500
Date: Thu, 23 Dec 2010 09:18:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20101223091822.GB3636@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk> <20101222122904.GC14693@n2100.arm.linux.org.uk> <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com> <20101223001012.GF29368@n2100.arm.linux.org.uk> <AANLkTimirgsuoM2che_ocrkvCZqGu6xEJjrjdmt9-69p@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimirgsuoM2che_ocrkvCZqGu6xEJjrjdmt9-69p@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 05:11:24PM -0800, Dan Williams wrote:
> On Wed, Dec 22, 2010 at 4:10 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Wed, Dec 22, 2010 at 03:45:39PM -0800, Dan Williams wrote:
> >> 3.6 Constraints:
> >> 1/ Calls to async_<operation> are not permitted in IRQ context.  Other
> >>    contexts are permitted provided constraint #2 is not violated.
> >
> > BTW, this is misleading.  Have the functions been renamed dma_async_xxx(),
> > eg dma_async_memcpy_buf_to_buf etc, or are you referring just to:
> >
> >        async_dmaengine_get
> >        async_dmaengine_put
> >        async_dma_find_channel
> >        async_dma_find_channel
> >        async_tx_ack
> >        async_tx_clear_ack
> >        async_tx_test_ack
> >
> > Beware of just renaming it to dma_async_<operation> as there's other
> > functions in that namespace which may not be appropriate.
> >
> > Eg, is it really illegal to issue call dma_async_issue_pending() from
> > IRQ context?  That'd make it exceedingly difficult to use the DMA
> > engine with the slave API in a lot of device drivers.
> 
> This is generic offload (async_{memcpy|xor|etc...}) versus the slave
> usage confusion.

My point is that async_<operation> refers to something that doesn't
exist.  What we do have:

dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
        void *dest, void *src, size_t len);
dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,
        struct page *page, unsigned int offset, void *kdata, size_t len);
dma_cookie_t dma_async_memcpy_pg_to_pg(struct dma_chan *chan,
        struct page *dest_pg, unsigned int dest_off, struct page *src_pg,
        unsigned int src_off, size_t len);

Nothing in dmaengine.h matches 'async_xor', so that suggests it's
incomplete.  There's another problem with referring to them as
dma_async_<operation> because we also have:

static inline void dma_async_issue_pending(struct dma_chan *chan)
#define dma_async_memcpy_issue_pending(chan) dma_async_issue_pending(chan)
static inline enum dma_status dma_async_is_tx_complete(struct dma_chan *chan,
        dma_cookie_t cookie, dma_cookie_t *last, dma_cookie_t *used)
#define dma_async_memcpy_complete(chan, cookie, last, used)\
static inline enum dma_status dma_async_is_complete(dma_cookie_t cookie,
                        dma_cookie_t last_complete, dma_cookie_t last_used)
int dma_async_device_register(struct dma_device *device);
void dma_async_device_unregister(struct dma_device *device);

So just referring to dma_async_<operation> will also be confusing.

There's also a bunch of other async_* named functions which makes it
look like these are what's being referred to (see the list above).
So, the documentation is confusing.

Maybe it would be better to refer to struct dma_device's device_prep_dma_*
methods and anything which calls them, with the exception of
device_prep_dma_cyclic?  (Shouldn't that be device_prep_slave_cyclic?)
