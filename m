Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab2LEOZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:25:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab2LEOZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:25:51 -0500
Message-ID: <50BF5950.2040805@redhat.com>
Date: Wed, 05 Dec 2012 12:25:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Hans Verkuil'" <hans.verkuil@cisco.com>,
        "'Giancarlo Asnaghi'" <giancarlo.asnaghi@st.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com> <055901cd9a52$5995fcd0$0cc1f670$%szyprowski@samsung.com> <50BE1F06.10308@redhat.com> <1685240.Ttn3DTWMJc@harkonnen>
In-Reply-To: <1685240.Ttn3DTWMJc@harkonnen>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-12-2012 10:50, Federico Vaga escreveu:
> On Tuesday 04 December 2012 14:04:22 Mauro Carvalho Chehab wrote:
>> Em 24-09-2012 09:44, Marek Szyprowski escreveu:
>>> Hello,
>>>
>>> On Monday, September 24, 2012 12:59 PM Federico Vaga wrote:
>>>> The DMA streaming allocator is similar to the DMA contig but it use the
>>>> DMA streaming interface (dma_map_single, dma_unmap_single). The
>>>> allocator allocates buffers and immediately map the memory for DMA
>>>> transfer. For each buffer prepare/finish it does a DMA synchronization.
>>
>> Hmm.. the explanation didn't convince me, e. g.:
>> 	1) why is it needed;
>
> This allocator is needed because some device (like STA2X11 VIP) cannot work
> with DMA sg or DMA coherent. Some other device (like the one used by Jonathan
> when he proposes vb2-dma-nc allocator) can obtain much better performance with
> DMA streaming than coherent.

Ok, please add such explanations at the patch's descriptions, as it is
important not only for me, but to others that may need to use it..

>
>> 	2) why vb2-dma-config can't be patched to use dma_map_single
>> (eventually using a different vb2_io_modes bit?);
>
> I did not modify vb2-dma-contig because I was thinking that each DMA memory
> allocator should reflect a DMA API.

The basic reason for having more than one VB low-level handling (vb2 was
inspired on this concept) is that some DMA APIs are very different than
the other ones (see vmalloc x DMA S/G for example).

I didn't make a diff between videobuf2-dma-streaming and videobuf2-dma-contig,
so I can't tell if it makes sense to merge them or not, but the above
argument seems too weak. I was expecting for a technical reason why
it wouldn't make sense for merging them.

>
>> 	3) what are the usecases for it.
>>
>> Could you please detail it? Without that, one that would be needing to
>> write a driver will have serious doubts about what would be the right
>> driver for its usage. Also, please document it at the driver itself.
>
> I did not write all this details because the reasons to use vb2-dma-contig,
> vb2-dma-sg or vb2-dma-streaming are the same reasons because someone choose
> SG, coherent or streaming API. This is already documented in the DMA-*.txt
> files, so I did not rewrite it to avoid duplication.

I see. It doesn't hurt to add a short explanation then at the patch description,
pointing to Documentation/DMA-API-HOWTO.txt, describing when using it instead
of vb2-dma-config (or vb2-dma-sg) would likely give better performance results,
and when the reverse is true.

Btw, from Documentation/DMA-API-HOWTO.txt:

   "Good examples of what to use streaming mappings for are:

	- Networking buffers transmitted/received by a device.
	- Filesystem buffers written/read by a SCSI device.

    The interfaces for using this type of mapping were designed in
    such a way that an implementation can make whatever performance
    optimizations the hardware allows.  To this end, when using
    such mappings you must be explicit about what you want to happen."

I'm not a DMA performance expert. As such, from that comment, it sounded to me
that replacing dma-config/dma-sg by dma streaming will always give "performance
optimizations the hardware allow".

If this is always true, why to preserve the old vb2-dma-config/vb2-dma-sg?

In other words, I suspect that the above is just half of the history ;)

On a separate but related issue, while doing DMABUF tests with an Exynos4
hardware, using a s5p sensor, sending data to s5p-tv, I noticed a CPU
consumption of about 42%, which seems too high. Could it be related to
not using the DMA streaming API?

(c/c Sylwester, due to this last comment)

Regards,
Mauro



