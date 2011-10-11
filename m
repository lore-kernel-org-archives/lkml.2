Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1JKSmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:42:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57089 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab1JKSmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1317200618.1573.1765.camel@vkoul-udesk3>
	<CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	<1317295068.1573.1780.camel@vkoul-udesk3>
	<CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
	<CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
	<CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
	<CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
	<CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
	<CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
	<20111003161349.GB28287@flint.arm.linux.org.uk>
	<CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com>
	<CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
	<1317966346.1573.2252.camel@vkoul-udesk3>
	<CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
	<CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com>
Date: Wed, 12 Oct 2011 00:12:05 +0530
Message-ID: <CAJe_ZhcGtrsPmpx3OTy0QmHv40Ta=r9oYRA6OykGH+6_DSX+NA@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Russell King <rmk@arm.linux.org.uk>,
        Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>, Alexandre.Bounine@idt.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 October 2011 22:14, Williams, Dan J <dan.j.williams@intel.com> wrote:
> [ Adding Alexandre ]
>
> This is a tangent, but it would be nice if this API extension also
> covered the needs of the incoming RapidIO case which wants to specify
> new device context information per operation (and not once at
> configuration time, like slave case).  Would it be enough if the
> transfer template included a (struct device *context) member at the
> end?  Most dma users could ignore it, but RapidIO could use it to do
> something like:
>
>   struct rio_dev *rdev = container_of(context, typeof(*rdev), device);
>
> That might not be enough, but I'm concerned that making the context a
> (void *) is too flexible.  I'd rather have something like this than
> acquiring a lock in rio_dma_prep_slave_sg() and holding it over
> ->prep().  The alternative is to extend device_prep_slave_sg to take
> an extra parameter, but that impacts all other slave implementations
> with a dead parameter.
>
>From what I read so far, the requirement is closer to prep_slave_sg
than to this api.

IMO, there should be a virtual channel for each device that the real
physical channel, at the backend, can transfer data to/from.

The client driver should request each virtual channel corresponding
to each target device it wants to transfer data with.

In the dmac driver - transfers queued for all virtual channels that are
backed by the same physical channel, could be added to the same
list and executed in FIFO manner.

That way, there won't be any need to hook target device info per transfer
and more importantly "struct dma_chan" would continue to mean
link between fixed 'endpoints'.
