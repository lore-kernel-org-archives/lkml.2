Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1ACQgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:36:05 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40487 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1ACQgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:36:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=DGB2xPqZsGFvzeze1FRGMUj/mN6omH3jEP9RAoFtskr6FV+ZMdmoYqf781C1za57ub
         mx4+H1T4H2N0L8HXrz6Q3IANXhVmT/Rz4yv77rql7bqeULwb1B/T5rTBM37BpcApsydF
         uUCFIu6KSVdbSYqVZzTWiKsEMGzKX5zCxa4/0=
MIME-Version: 1.0
Date: Mon, 3 Jan 2011 08:36:00 -0800
X-Google-Sender-Auth: 6gJdcX9TNZ5lgbzBbC-GKC4E_VI
Message-ID: <AANLkTinJAULeb1EsWk=S=b32h69X1x-noRw73Ok0uyfx@mail.gmail.com>
Subject: dmaengine: fix dma_unmap (was: Re: [PATCH 06/13] DMAENGINE: driver
 for the ARM PL080/PL081 PrimeCells)
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 3:14 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Jan 02, 2011 at 09:33:34PM +0100, Linus Walleij wrote:
>> As for the in-tree PL08x driver I'd say it's doing pretty well for
>> memcpy() so we could add platform data for that on supported
>> platforms, then for device transfers we need more elaborative
>> work.
>
> It has the issue that it's not unmapping the buffers after the memcpy()
> operation has completed, so on ARMv6+ we have the possibility for
> speculative prefetches to corrupt the destination buffer.
>
> Neither are a number of the other DMA engine drivers.  This is why I'd
> like to see some common infrastructure in the DMA engine core for saying
> "this tx descriptor is now complete" so that DMA engine driver authors
> don't have to even think about whether they should be unmapping buffers.

This requires that a copy of the mapped addresses be maintained
outside the driver's physical descriptor.  This needs support from the
client to set up storage for this information (probably a
scatterlist).  The dmaengine core could use this to implement a common
unmap routine.  However,  this still has the problem of how to prevent
unmapping too early in the multi-operation raid case and how to
communicate the full set of addresses to unmap to the final descriptor
in such a chain.  I think the only way to fully solve this is to make
the client solely responsible for both mapping and unmapping.

For raid this will have implications for architectures that split
operation types on to different physical channels.  Preparing the
entire operation chain ahead of time is not possible on such
configuration because we need to remap the buffers for each channel
transition.  So, raid will have an optimized path for engines like
mv_xor, ioatdma, and iop-adma (iop13xx) where all buffers can be
mapped upfront (against a single physical channel) and then unmapped
when all stripe operations complete.  For the others iop-adma (iop3xx)
and ppc44x we need to wait for each leg to finish before mapping and
issuing the next leg.  There will most likely be negative performance
implications of waiting and reissuing, but as far as I can see this is
unavoidable.

> I'd also like to see DMA_COMPL_SKIP_*_UNMAP always set by prep_slave_sg()
> in tx->flags so we don't have to end up with "is this a slave operation"
> tests in the completion handler.

Longer term I do not see these flags surviving, but yes a 2.6.38
change along these lines makes sense.

--
Dan
