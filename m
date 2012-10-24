Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab2JXLxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:53:48 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:47984 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2JXLxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:53:47 -0400
Message-ID: <5087D6B8.10209@free-electrons.com>
Date: Wed, 24 Oct 2012 13:53:28 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Jon Masters <jcm@redhat.com>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 2/2] arm: mvebu: Add hardware I/O Coherency support
References: <1351065841-18654-1-git-send-email-gregory.clement@free-electrons.com> <1351065841-18654-3-git-send-email-gregory.clement@free-electrons.com> <201210241136.12779.arnd@arndb.de> <5087D574.4030503@free-electrons.com>
In-Reply-To: <5087D574.4030503@free-electrons.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 01:48 PM, Gregory CLEMENT wrote:
> On 10/24/2012 01:36 PM, Arnd Bergmann wrote:
>> On Wednesday 24 October 2012, Gregory CLEMENT wrote:
>>> +void __init armada_370_xp_coherency_iocache_init(void)
>>> +{
>>> +       /* When the coherency fabric is available, the Armada XP and
>>> +        * Aramada 370 are close to a coherent architecture, so we based
>>> +        * our dma ops on the coherent one, and just changes the
>>> +        * operations which need a arch io sync */
>>> +       if (of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric")) {
>>> +               struct dma_map_ops *dma_ops = &armada_xp_dma_ops;
>>> +               memcpy(dma_ops, &arm_coherent_dma_ops, sizeof(*dma_ops));
>>> +               dma_ops->map_page = armada_xp_dma_map_page;
>>> +               dma_ops->unmap_page = armada_xp_dma_unmap_page;
>>> +               dma_ops->unmap_sg = arm_dma_ops.unmap_sg;
>>> +               dma_ops->sync_single_for_cpu = armada_xp_dma_sync;
>>> +               dma_ops->sync_single_for_device = armada_xp_dma_sync;
>>> +               dma_ops->sync_sg_for_cpu = arm_dma_ops.sync_sg_for_cpu;
>>> +               dma_ops->sync_sg_for_device = arm_dma_ops.sync_sg_for_device;
>>> +       }
>>> +       bus_register_notifier(&platform_bus_type, &armada_xp_platform_nb);
>>
>> I think it would be cleaner to statically define the operations in a constant
>> structure and point directly to the functions you need. If necessary, use
>> multiple structures.
> 
> My problem was that these functions are not exposed, only arm_dma_op and
> arm_coherent_dma_ops are exported.
> Or do you think about something like this:
> 
> struct dma_map_ops *dma_ops = {
> 	.alloc			= arm_dma_ops.arm_coherent_dma_alloc,
> 	.free			= arm_dma_ops.arm_coherent_dma_free,
> 	.mmap			= arm_dma_ops.arm_dma_mmap,
> 	.get_sgtable		= arm_dma_ops.arm_dma_get_sgtable,
> 	.map_sg			= arm_dma_ops.arm_dma_map_sg,
> 	.set_dma_mask		= arm_dma_ops.arm_dma_set_mask,
> 	.map_page 		= armada_xp_dma_map_page,
> 	.unmap_page 		= armada_xp_dma_unmap_page,
> 	.unmap_sg 		= arm_dma_ops.unmap_sg,
> 	.sync_single_for_cpu 	= armada_xp_dma_sync,
> 	.sync_single_for_device = armada_xp_dma_sync,
> 	.sync_sg_for_cpu 	= arm_dma_ops.sync_sg_for_cpu,
> 	.sync_sg_for_device	= arm_dma_ops.sync_sg_for_device,
> };

I was too fast to reply this struct is wrong, it should be as this one:

struct dma_map_ops *dma_ops = {
	.alloc			= arm_coherent_dma_ops.arm_coherent_dma_alloc,
	.free			= arm_coherent_dma_ops.arm_coherent_dma_free,
	.mmap			= arm_coherent_dma_ops.arm_dma_mmap,
	.get_sgtable		= arm_coherent_dma_ops.arm_dma_get_sgtable,
	.map_sg			= arm_coherent_dma_ops.arm_dma_map_sg,
	.set_dma_mask		= arm_coherent_dma_ops.arm_dma_set_mask,
	.map_page 		= armada_xp_dma_map_page,
	.unmap_page 		= armada_xp_dma_unmap_page,
	.unmap_sg 		= arm_dma_ops.unmap_sg,
	.sync_single_for_cpu 	= armada_xp_dma_sync,
	.sync_single_for_device = armada_xp_dma_sync,
	.sync_sg_for_cpu 	= arm_dma_ops.sync_sg_for_cpu,
	.sync_sg_for_device 	= arm_dma_ops.sync_sg_for_device,
};

Thanks,
Gregory
