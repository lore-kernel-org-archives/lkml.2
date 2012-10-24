Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab2JXLgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:36:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab2JXLgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:36:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 2/2] arm: mvebu: Add hardware I/O Coherency support
Date: Wed, 24 Oct 2012 11:36:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, "Eran Ben-Avi" <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1351065841-18654-1-git-send-email-gregory.clement@free-electrons.com> <1351065841-18654-3-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1351065841-18654-3-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210241136.12779.arnd@arndb.de>
X-Provags-ID: V02:K0:d7XU2qSx/ELGe62RtVrV3RNtrStFp50leu6sV+i6IX1
 jwLiqL1eMIo3RICQJvSukPk5n+fmNOeZoONSpSYlYsRR+YV+NT
 8AozW0pvuH4RrSYuaMN7bNGvbNSD9Ha7N6iHbxFZDWfR16cnj7
 W6Nt1n/95ZrSHfCtfnaARI2jxzgXtAKDlixH6ExT1a9f9+Ignh
 JeATHQ4MOolPhNPoupTnEYgpObyFgeHVpMi0aIvcWDxNc82ab8
 MzL2KcRLM9c70QcPaNIz03htOP+9XQwRP4gPghrk/PjndxsXop
 KbknhkGZRn/NusvADoV+7iEBy8L4fYexMqM3EfOkL2+1WvKWjb
 eMjFOMeNNMvWxtNFNmDk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Gregory CLEMENT wrote:
> +void __init armada_370_xp_coherency_iocache_init(void)
> +{
> +       /* When the coherency fabric is available, the Armada XP and
> +        * Aramada 370 are close to a coherent architecture, so we based
> +        * our dma ops on the coherent one, and just changes the
> +        * operations which need a arch io sync */
> +       if (of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric")) {
> +               struct dma_map_ops *dma_ops = &armada_xp_dma_ops;
> +               memcpy(dma_ops, &arm_coherent_dma_ops, sizeof(*dma_ops));
> +               dma_ops->map_page = armada_xp_dma_map_page;
> +               dma_ops->unmap_page = armada_xp_dma_unmap_page;
> +               dma_ops->unmap_sg = arm_dma_ops.unmap_sg;
> +               dma_ops->sync_single_for_cpu = armada_xp_dma_sync;
> +               dma_ops->sync_single_for_device = armada_xp_dma_sync;
> +               dma_ops->sync_sg_for_cpu = arm_dma_ops.sync_sg_for_cpu;
> +               dma_ops->sync_sg_for_device = arm_dma_ops.sync_sg_for_device;
> +       }
> +       bus_register_notifier(&platform_bus_type, &armada_xp_platform_nb);

I think it would be cleaner to statically define the operations in a constant
structure and point directly to the functions you need. If necessary, use
multiple structures.

	Arnd
