Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab1BWEUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:20:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46288 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1BWEUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:20:03 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF03112A5C22@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF03112A5C22@HQMAIL01.nvidia.com>
Date: Tue, 22 Feb 2011 20:20:01 -0800
Message-ID: <AANLkTin3VFp=JhiCb5Sft3pvGw2o4k4qqtbx-PNUGfUD@mail.gmail.com>
Subject: Re: Problem with "ARM: tegra: Move tegra_common_init to tegra_init_early"
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@nvidia.com>
Cc: "Colin Cross (ccross@android.com)" <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King - ARM Linux (linux@arm.linux.org.uk)" 
	<linux@arm.linux.org.uk>,
        "konkers@android.com" <konkers@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grmbl. I missed the:

[    0.000000] Failed to register IRQ 136 for DMA 0

When I booted the series on harmony and seaboard last night, since the
board came up to prompt and seemed otherwise healthy. Sorry about
that.


-Olof


On Tue, Feb 22, 2011 at 7:12 PM, Stephen Warren <swarren@nvidia.com> wrote:
> The following commit makes the Tegra APB DMA engine fail to initialize correctly:
>
> commit 0cf6230af909a86f81907455eca2a5c9b8f68fe6
>
>    ARM: tegra: Move tegra_common_init to tegra_init_early
>
>    Move tegra_common_init to tegra_init_early, and set it
>    as the init_early entry in the machine struct.
>    Initializes the clocks earlier so that timers can enable
>    their clocks.
>
>    Also reorders the members in the Harmony and Trimslice
>    boards' machine structs to match the order they are
>    called in.
>
> The reason is that tegra_init_early_ calls tegra_dma_init which calls
> request_threaded_irq, which fails since the IRQ hasn't yet been marked valid;
> that only happens in tegra_init_irq, which gets called after tegra_init_early.
>
> This used to work OK, since tegra_init_early was tegra_common_init, which got
> called after tegra_init_irq, basically from the beginning of tegra_harmony_init.
>
> I tried moving the call to tegra_dma_init back to each of the very end of
> tegra_init_irq and the very beginning of tegra_harmony_init. Both of these
> resulted in a kernel that wouldn't boot.
>
> Simply removing the call to tegra_dma_init completely does allow the kernel
> to boot, but obviously, DMA isn't available.
>
> I'm a little stumped why moving tegra_dma_init causes a boot failure. Does
> anyone have any helpful ideas, or any alternative ways to fix the underlying
> problem?
>
> Thanks.
>
> --
> nvpublic
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
