Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134Ab2CBTcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:32:18 -0500
Received: from mga12.intel.com ([143.182.124.36]:20112 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752319Ab2CBTcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:32:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dan.j.williams@intel.com designates 10.60.20.6 as permitted sender) smtp.mail=dan.j.williams@intel.com
MIME-Version: 1.0
In-Reply-To: <20120302175719.GA1468@wavehammer.waldi.eu.org>
References: <CAJ75kXZ-2vWZpG7Uz3firg6ew4y_DdorXotkAkUGSK0GWLMUQQ@mail.gmail.com>
	<20120127144737.GA27750@andromeda.dapyr.net>
	<20120219223125.GA820@burratino>
	<20120220181618.GD17566@burratino>
	<4F4891B8.9050008@goirand.fr>
	<20120302055715.GA692@burratino>
	<CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>
	<20120302162159.GB31683@wavehammer.waldi.eu.org>
	<CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>
	<20120302175719.GA1468@wavehammer.waldi.eu.org>
Date: Fri, 2 Mar 2012 11:31:56 -0800
Message-ID: <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
From: Dan Williams <dan.j.williams@intel.com>
To: Dan Williams <dan.j.williams@intel.com>,
        Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 9:57 AM, Bastian Blank <waldi@debian.org> wrote:
> On Fri, Mar 02, 2012 at 08:44:00AM -0800, Dan Williams wrote:
>> On Fri, Mar 2, 2012 at 8:21 AM, Bastian Blank <waldi@debian.org> wrote:
>> > On Thu, Mar 01, 2012 at 10:42:44PM -0800, Dan Williams wrote:
>> >> WARN_ON may work, but then kernel may be subject random hangs from missed
>> >> i/o completions.
>> ...actually descriptors completing too early.
>
> The interrupt happens while the module is still loading, so most likely
> directly after enabling them. There should be no request in flight yet.
>
> What puzzles me is the mix of different data types in the ioatdma
> driver:
>
> | u64 completion = *chan->completion;
> | unsigned long phys_complete = completion & ~0x3f;
>
> The state is 64bit long, but is down converted to a 32bit value without
> anything.
>
> phys_complete (a 32 bit value) gets compared to struct
> dma_async_tx_descriptor.phys, which is defined as dma_addr_t, a _64_ bit
> value.

The assumption is that the driver's control structures are not in high
memory so all address values will only have 32-bits of valid data, but
maybe xen32 changes that assumption?

Can you send the log of the driver load with debug enabled?

diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index a4d6cb0..82472de 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -24,7 +24,7 @@
  * This driver supports an Intel I/OAT DMA engine, which does asynchronous
  * copy operations.
  */
-
+#define DEBUG
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 5d65f83..da337e7 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -24,7 +24,7 @@
  * This driver supports an Intel I/OAT DMA engine (versions >= 2), which
  * does asynchronous data movement and checksumming operations.
  */
-
+#define DEBUG
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
