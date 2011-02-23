Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1BWHnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 02:43:17 -0500
Received: from smtp-out.google.com ([74.125.121.67]:55236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1BWHnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 02:43:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=d+7//uhTIOZvTaXwLsBLWIjmCHtC8Z907kQ4WvqPaR/C4cQ+kuzL2xaRYTMUdh44f7
         MGZGi04vIUoJiGZOe7aA==
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF03112A5C22@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF03112A5C22@HQMAIL01.nvidia.com>
Date: Tue, 22 Feb 2011 23:43:10 -0800
X-Google-Sender-Auth: 8PmdNLXdOuaK8lIJ76lgx-M-lPA
Message-ID: <AANLkTimgw6kruGMp=wJUVka+Gj2cn9X=qRucbnuq-b9V@mail.gmail.com>
Subject: Re: Problem with "ARM: tegra: Move tegra_common_init to tegra_init_early"
From: Colin Cross <ccross@android.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King - ARM Linux (linux@arm.linux.org.uk)" 
	<linux@arm.linux.org.uk>,
        "konkers@android.com" <konkers@android.com>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

I don't know why it still fails if you put it back at the beginning of
the machine init, and it boots without errors on my board if I move
tegra_dma_init to a postcore_initcall, but I don't have any drivers on
my board that use DMA.

Can you provide kernel logs?
