Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab2FRJDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:03:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32945 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2FRJDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:03:45 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-dd-4fdeeeeff2d1
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hiroshi Doyu'" <hdoyu@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Chunsang Jeong'" <chunsang.jeong@linaro.org>,
        "'Krishna Reddy'" <vdumpa@nvidia.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'Sumit Semwal'" <sumit.semwal@linaro.org>,
        "'Abhinav Kochhar'" <abhinav.k@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
References: <1338988657-20770-1-git-send-email-m.szyprowski@samsung.com>
 <20120618105059.12c709d68240ad18c5f8c7a5@nvidia.com>
In-reply-to: <20120618105059.12c709d68240ad18c5f8c7a5@nvidia.com>
Subject: RE: [PATCH/RFC 0/2] ARM: DMA-mapping: new extensions for buffer
 sharing (part 2)
Date: Mon, 18 Jun 2012 11:03:24 +0200
Organization: SPRC
Message-id: <017b01cd4d31$3c855640$b59002c0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1NJzRK5UMtiFqdRfe4nK6pIBqjwgAAFiJA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9jQd337+75G0xfpWLRsesri8XlXXPY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4MrYvFmjoFmoYsX8T+wNjCf5uhg5OCQETCS+dxl2MXIC
	mWISF+6tZ+ti5OIQEpjOKLFs+Xwo5yejxIdJc5hAqtgEDCW63naxgTSLCKhKPJ3LCFLDLDCH
	VeL+vGmMIHEhgXqJOyc1Qco5BRwlNn74yw5iCwtESyy8eJgRxGYBaj329wwzSDm/gJDExFkK
	IGFeAReJ++emskLYghI/Jt9jAbGZBbQkNm9rYoWw5SU2r3nLDHG+usSjv7ogYREBI4nLmxYw
	QZSISNxteM46gVF4FpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525i
	BIf4M+kdjKsaLA4xCnAwKvHw7nh9z1+INbGsuDL3EKMEB7OSCK9tO1CINyWxsiq1KD++qDQn
	tfgQozQHi5I4b5P1BX8hgfTEktTs1NSC1CKYLBMHp1QDo25kw9+rC3OfdTOILNjj4JzNbHL3
	yabNRp0TU7q//2+XmPqt3+7knz4lvg+FswV15ARZAo6w71Zd9DAudqH2lvwKn6sCUrXGPWKr
	2BJM1n08/9d5E/M923aOQ7JOHdf7bgoe5V6w7kRRvdkCd4bVb3ft3rTERuTCvDWTj7tcUtd1
	MucrPnr6txJLcUaioRZzUXEiAHErFgNtAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, June 18, 2012 9:51 AM Hiroshi Doyu wrote:

> On Wed, 6 Jun 2012 15:17:35 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > This is a continuation of the dma-mapping extensions posted in the
> > following thread:
> > http://thread.gmane.org/gmane.linux.kernel.mm/78644
> >
> > We noticed that some advanced buffer sharing use cases usually require
> > creating a dma mapping for the same memory buffer for more than one
> > device. Usually also such buffer is never touched with CPU, so the data
> > are processed by the devices.
> >
> > From the DMA-mapping perspective this requires to call one of the
> > dma_map_{page,single,sg} function for the given memory buffer a few
> > times, for each of the devices. Each dma_map_* call performs CPU cache
> > synchronization, what might be a time consuming operation, especially
> > when the buffers are large. We would like to avoid any useless and time
> > consuming operations, so that was the main reason for introducing
> > another attribute for DMA-mapping subsystem: DMA_ATTR_SKIP_CPU_SYNC,
> > which lets dma-mapping core to skip CPU cache synchronization in certain
> > cases.
> 
> I had implemented the similer patch(*1) to optimize/skip the cache
> maintanace, but we did this with "dir", not with "attr", making use of
> the existing DMA_NONE to skip cache operations. I'm just interested in
> why you choose attr for this purpose. Could you enlight me why attr is
> used here?

I also thought initially about adding new dma direction for this feature,
but then I realized that there might be cases where the real direction of
the data transfer might be needed (for example to set io read/write
attributes for the mappings) and this will lead us to 3 new dma directions.
The second reason was the compatibility with existing code. There are
already drivers which use DMA_NONE type for their internal stuff. Adding
support for new dma attributes requires changes in all implementations of
dma-mapping for all architectures. DMA attributes are imho better fits
this case. They are by default optional, so other architectures are free
to leave them unimplemented and the drivers should still work correctly.
 
Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


