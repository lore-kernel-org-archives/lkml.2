Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2AIOMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 09:12:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60222 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab2AIOMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 09:12:39 -0500
Date: Mon, 9 Jan 2012 14:12:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Eric Miao <eric.miao@linaro.org>
Cc: Richard Zhao <richard.zhao@linaro.org>, patches@linaro.org,
        vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, dan.j.williams@intel.com, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] dma/imx-sdma: convert _raw_readl/_raw_writel to
	readl/writel
Message-ID: <20120109141214.GP21765@n2100.arm.linux.org.uk>
References: <1326033862-25351-1-git-send-email-richard.zhao@linaro.org> <1326033862-25351-3-git-send-email-richard.zhao@linaro.org> <20120109115143.GL21765@n2100.arm.linux.org.uk> <CAMPhdO84p=0D3KrrFnwup4igoh4oNWXOCbW+BOkoRiC8m=JnmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMPhdO84p=0D3KrrFnwup4igoh4oNWXOCbW+BOkoRiC8m=JnmQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 09:25:12PM +0800, Eric Miao wrote:
> Does this also mean when endian conversion is not necessary, the __raw_*
> version will be better here? Or generally the _relaxed variants are more
> recommended as endian conversion will be optimized away anyway with
> these AMBA accesses as both sides are little-endian?

Useless endian conversions are always optimized away.  Here's the
definitions:

If your CPU is operating in little endian mode, for 32-bit and 16-bit:

#define __cpu_to_le32(x) ((__force __le32)(__u32)(x))
#define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
#define __cpu_to_le16(x) ((__force __le16)(__u16)(x))
#define __le16_to_cpu(x) ((__force __u16)(__le16)(x))

So these are just casts to keep sparse happy and able to check this stuff.

#define __cpu_to_be32(x) ((__force __be32)__swab32((x)))
#define __be32_to_cpu(x) __swab32((__force __u32)(__be32)(x))
#define __cpu_to_be16(x) ((__force __be16)__swab16((x)))
#define __be16_to_cpu(x) __swab16((__force __u16)(__be16)(x))

These do the endian conversion.

If your CPU is running in big endian mode:

#define __cpu_to_le32(x) ((__force __le32)__swab32((x)))
#define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
#define __cpu_to_le16(x) ((__force __le16)__swab16((x)))
#define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))

So these do the endian conversion, and:

#define __cpu_to_be32(x) ((__force __be32)(__u32)(x))
#define __be32_to_cpu(x) ((__force __u32)(__be32)(x))
#define __cpu_to_be16(x) ((__force __be16)(__u16)(x))
#define __be16_to_cpu(x) ((__force __u16)(__be16)(x))

These are just casts.
