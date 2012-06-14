Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2FNIsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:48:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12265 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab2FNIsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:48:09 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-ed-4fd9a54841b4
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Daniel Vetter'" <daniel@ffwll.ch>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>
Cc: linux-arch@vger.kernel.org, "'Abhinav Kochhar'" <abhinav.k@samsung.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org
References: <1339588218-24398-1-git-send-email-m.szyprowski@samsung.com>
 <20120613141211.GJ5979@phenom.dumpdata.com>
 <20120613190131.GO4829@phenom.ffwll.local>
In-reply-to: <20120613190131.GO4829@phenom.ffwll.local>
Subject: RE: [Linaro-mm-sig] [PATCHv2 0/6] ARM: DMA-mapping: new extensions for
 buffer sharing
Date: Thu, 14 Jun 2012 10:47:48 +0200
Organization: SPRC
Message-id: <002901cd4a0a$667e1600$337a4200$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1Jlr96dUALIW4ySOaySyu8PoMmFwAcx2fQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t9jQV2PpTf9DTZ/krHo2PWVxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVMP/eHueC2QMXexmesDYzLebsYOTkkBEwkXi1tYoKw
	xSQu3FvP1sXIxSEkMJ1R4uHxpYwQzk9GidmLJrOBVLEJGEp0ve0Csjk4RAQiJVbc9gepYRbY
	yiyxbk4jVMNiRokFD6+ygzRwCphLnOg+xAJiCwskSLw+thNsEIuAqsS3nUtYQAbxCwhJTJyl
	ABLmFXCRWNI8mw3CFpT4MfkeWCuzgJbE+p3HmSBseYnNa94yg7RKCKhLPPqrCxIWETCSOPrr
	BlS5iMTdhuesExiFZyGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnCoP5PawbiyweIQowAHoxIP7+G+m/5CrIllxZW5hxglOJiVRHhDFgOFeFMSK6tSi/Lji0pz
	UosPMUpzsCiJ8zZZX/AXEkhPLEnNTk0tSC2CyTJxcEo1MHYUH5u9mbH8g+3xsw3rXk6fy1Ge
	2Gsc9XH6o5hfoXe097/b9lH4dVb5+Ym64hMuGEZWM54rTv25uUk5Z8+6ORej/68We3fy5/qP
	Yae15wRX5qpN8Put67+b/arqZ7EJeqHSa2u3Wi2t0agVMf3TIdP7deL+Hqbj5hyCVnezZE5f
	Mf96aPtDriAlluKMREMt5qLiRADXQ9fScQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wednesday, June 13, 2012 9:02 PM Daniel Vetter wrote:

> On Wed, Jun 13, 2012 at 10:12:12AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Wed, Jun 13, 2012 at 01:50:12PM +0200, Marek Szyprowski wrote:

> (snipped)

> > > The third extension solves the performance issues which we observed with
> > > some advanced buffer sharing use cases, which require creating a dma
> > > mapping for the same memory buffer for more than one device. From the
> > > DMA-mapping perspective this requires to call one of the
> > > dma_map_{page,single,sg} function for the given memory buffer a few
> > > times, for each of the devices. Each dma_map_* call performs CPU cache
> > > synchronization, what might be a time consuming operation, especially
> > > when the buffers are large. We would like to avoid any useless and time
> > > consuming operations, so that was the main reason for introducing
> > > another attribute for DMA-mapping subsystem: DMA_ATTR_SKIP_CPU_SYNC,
> > > which lets dma-mapping core to skip CPU cache synchronization in certain
> > > cases.
> 
> Ah, here's the use-case I've missed ;-) I'm a bit vary of totally insane
> platforms that have additional caches only on the device side, and only
> for some devices. Well, tlbs belong to that, but the iommu needs to handle
> that anyway.
> 
> I think it would be good to add a blurb to the documentation that any
> device-side flushing (of tlbs or special caches or whatever) still needs
> to happen and that this is only a performance optimization to avoid the
> costly cpu cache flushing. This way the dma-buf exporter could keep track
> of whether it's 'device-coherent' and set that flag if the cpu caches don't
> need to be flushed.
> 
> Maybe also make it clear that implementing this bit is optional (like your
> doc already mentions for NO_KERNEL_MAPPING).

Ok, I can add additional comment, but support for all dma attributes is optional
(attributes are considered only as hints that might improve performance for some
use cases on some hw platforms).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



