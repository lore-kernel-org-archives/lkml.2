Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1BWDMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:12:12 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17925 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab1BWDMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:12:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 22 Feb 2011 19:12:08 -0800
From: Stephen Warren <swarren@nvidia.com>
To: "Colin Cross (ccross@android.com)" <ccross@android.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King - ARM Linux (linux@arm.linux.org.uk)" 
	<linux@arm.linux.org.uk>,
        "konkers@android.com" <konkers@android.com>,
        "Olof Johansson (olof@lixom.net)" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Feb 2011 19:12:07 -0800
Subject: Problem with "ARM: tegra: Move tegra_common_init to
 tegra_init_early"
Thread-Topic: Problem with "ARM: tegra: Move tegra_common_init to
 tegra_init_early"
Thread-Index: AcvTBmzkyoYt24uYSgSE1glBq3mDeg==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF03112A5C22@HQMAIL01.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit makes the Tegra APB DMA engine fail to initialize correctly:

commit 0cf6230af909a86f81907455eca2a5c9b8f68fe6

    ARM: tegra: Move tegra_common_init to tegra_init_early
    
    Move tegra_common_init to tegra_init_early, and set it
    as the init_early entry in the machine struct.
    Initializes the clocks earlier so that timers can enable
    their clocks.
    
    Also reorders the members in the Harmony and Trimslice
    boards' machine structs to match the order they are
    called in.

The reason is that tegra_init_early_ calls tegra_dma_init which calls
request_threaded_irq, which fails since the IRQ hasn't yet been marked valid;
that only happens in tegra_init_irq, which gets called after tegra_init_early.

This used to work OK, since tegra_init_early was tegra_common_init, which got
called after tegra_init_irq, basically from the beginning of tegra_harmony_init.

I tried moving the call to tegra_dma_init back to each of the very end of
tegra_init_irq and the very beginning of tegra_harmony_init. Both of these
resulted in a kernel that wouldn't boot.

Simply removing the call to tegra_dma_init completely does allow the kernel
to boot, but obviously, DMA isn't available.

I'm a little stumped why moving tegra_dma_init causes a boot failure. Does
anyone have any helpful ideas, or any alternative ways to fix the underlying
problem?

Thanks.

-- 
nvpublic

