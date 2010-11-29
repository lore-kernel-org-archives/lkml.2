Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0K2Sw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:52:59 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62926 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab0K2Sw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:52:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Woc1v6bmYfqzBFrWrkdHlQKnJIzZPrDNvXHWxiXCqYyNhgBpgD8U3yf2vG7g2oYgb4
         QIT79mnBUXpeCaGUnPp9czjHCCFTCI/bZ9ENKtW+4rUAfDX6QRKl8XsKhb571kh2YrX9
         JwcipIYPgQvu/bD5af73SVxyHDtp7/h5yToPs=
Message-ID: <4CF3F687.6040801@gmail.com>
Date: Mon, 29 Nov 2010 20:52:55 +0200
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: Add support for PCI BUS
References: <1290860675-15453-1-git-send-email-ulli.kroll@googlemail.com> <201011282056.17389.arnd@arndb.de> <4CF3CF33.20407@gmail.com> <201011291745.22566.arnd@arndb.de>
In-Reply-To: <201011291745.22566.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 06:45 PM, Arnd Bergmann wrote:
> On Monday 29 November 2010, Paulius Zaleckas wrote:
>>> The I/O ordering is probably not what you think it is.
>>> There is no ordering guarantee between __raw_writel and
>>> spin_lock/spin_unlock, so you really should be using
>>> readl/writel.
>>
>> No he really should NOT use readl/writel. The ONLY difference
>> between readl/writel and __raw_readl/__raw_writel is endianess
>> conversion. __raw_*l is not doing it. Which to use depend only
>> on HW.
>
> There are many differences between readl and __raw_readl, including
>
> * __raw_readl does not have barriers and does not serialize with
>    spinlocks, so it breaks on out-of-order CPUs.
> * __raw_readl does not have a specific endianess, while readl is
>    fixed little-endian, just as the hardware is in this case.
>    The endian-conversion is a NOP on little-endian ARM, but required
>    if you actually run on a big-endian ARM (you don't).
> * __raw_readl may not be atomic, gcc is free to split the access
>    into byte wise reads (it normally does not, unless you mark
>    the pointer __attribute__((packed))).
>
> In essence, it is almost never a good idea to use __raw_readl, and
> the double underscores should tell you so.

You are wrong:

Since CONFIG_ARM_DMA_MEM_BUFFERABLE is NOT defined for FA526 core,
no barriers are in use when using readl. It just translates into
le32_to_cpu(__raw_readl(x)). Now this CPU has physical pin for endianess
configuration and if you will chose big-endian you will fail to read
internal registers, because they ALSO change endianess and le32_to_cpu()
will screw it. However it is different when accessing registers through
PCI bus, then you need to use readl().
