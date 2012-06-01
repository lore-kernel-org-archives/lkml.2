Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163Ab2FACiD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:38:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:45434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932682Ab2FAChu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:37:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150221219"
Message-ID: <4FC82AFB.6020209@linux.intel.com>
Date: Fri, 01 Jun 2012 10:37:47 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb_edac: Only register mce_decode_chain once
References: <1338488391-20755-1-git-send-email-roland@kernel.org>
In-Reply-To: <1338488391-20755-1-git-send-email-roland@kernel.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/1 2:19, Roland Dreier 写道:
> From: Roland Dreier <roland@purestorage.com>
> 
> I was lucky enough to get a 4-socket Sandy Bridge system.
> Unfortunately it hangs on boot when loading the sb_edac module, with
> the NMI watchdog giving the following trace:
> 
>     EDAC MC0: Giving out device to 'sbridge_edac.c' 'Sandy Bridge Socket#0': DEV 0000:3f:0e.0
>     EDAC MC1: Giving out device to 'sbridge_edac.c' 'Sandy Bridge Socket#1': DEV 0000:7f:0e.0
>     EDAC MC2: Giving out device to 'sbridge_edac.c' 'Sandy Bridge Socket#2': DEV 0000:bf:0e.0
>     ------------[ cut here ]------------
>     WARNING: at /home/roland/linux-2.6/kernel/watchdog.c:242 watchdog_overflow_callback+0x9a/0xc0()
>     Hardware name:
>     Watchdog detected hard LOCKUP on cpu 11
>     Modules linked in: sb_edac(+) edac_core kvm_intel coretemp kvm mei acpi_pad joydev ghash_clmulni_intel hid_generic aesni_intel cryptd aes_x86_64 acpi_power_meter lpc_ich shpchp microcode usbhid hid ses enclosure bnx2x libcrc32c megaraid_sas mdio
>     Pid: 2408, comm: modprobe Tainted: G        W    3.4.0+ #1
>     Call Trace:
>      <NMI>  [<ffffffff810515ff>] warn_slowpath_common+0x7f/0xc0
>      [<ffffffff810516f6>] warn_slowpath_fmt+0x46/0x50
>      [<ffffffff810db3da>] watchdog_overflow_callback+0x9a/0xc0
>      [<ffffffff81115ffc>] __perf_event_overflow+0x9c/0x220
>      [<ffffffff81024faa>] ? x86_perf_event_set_period+0xda/0x150
>      [<ffffffff81116ad4>] perf_event_overflow+0x14/0x20
>      [<ffffffff8102a190>] intel_pmu_handle_irq+0x180/0x300
>      [<ffffffff813a0ed0>] ? ghes_read_estatus+0x90/0x180
>      [<ffffffff816550d1>] perf_event_nmi_handler+0x21/0x30
>      [<ffffffff81654851>] nmi_handle.isra.0+0x51/0x80
>      [<ffffffff81654a21>] do_nmi+0x1a1/0x380
>      [<ffffffff81653e7c>] end_repeat_nmi+0x1a/0x1e
>      [<ffffffff8107aa05>] ? atomic_notifier_chain_register+0x35/0x60
>      [<ffffffff8107aa05>] ? atomic_notifier_chain_register+0x35/0x60
>      [<ffffffff8107aa05>] ? atomic_notifier_chain_register+0x35/0x60
>      <<EOE>>  [<ffffffff8102b5dd>] mce_register_decode_chain+0x2d/0x120
>      [<ffffffffa00fdbdb>] sbridge_probe+0xa86/0xbab [sb_edac]
>      [<ffffffff811eaf05>] ? sysfs_link_sibling+0xa5/0xe0
>      [<ffffffff81339c1c>] local_pci_probe+0x5c/0xd0
>      [<ffffffff8133b551>] pci_device_probe+0x101/0x120
>      [<ffffffff813fbf3e>] driver_probe_device+0x7e/0x220
>      [<ffffffff813fc18b>] __driver_attach+0xab/0xb0
>      [<ffffffff813fc0e0>] ? driver_probe_device+0x220/0x220
>      [<ffffffff813fa376>] bus_for_each_dev+0x56/0x90
>      [<ffffffff813fba5e>] driver_attach+0x1e/0x20
>      [<ffffffff813fb610>] bus_add_driver+0x1a0/0x270
>      [<ffffffffa000a000>] ? 0xffffffffa0009fff
>      [<ffffffffa000a000>] ? 0xffffffffa0009fff
>      [<ffffffff813fc6e6>] driver_register+0x76/0x130
>      [<ffffffffa000a000>] ? 0xffffffffa0009fff
>      [<ffffffff8133b225>] __pci_register_driver+0x55/0xd0
>      [<ffffffffa000a033>] sbridge_init+0x33/0x1000 [sb_edac]
>      [<ffffffff8100203f>] do_one_initcall+0x3f/0x170
>      [<ffffffff810b2c0e>] sys_init_module+0xbe/0x230
>      [<ffffffff8165b7a9>] system_call_fastpath+0x16/0x1b
>     ---[ end trace a7919e7f17c0a727 ]---
> 
> The problem is that the system has multiple memory controllers but
> registers the same static notifier_block multiple times.  Fix this by
> moving the registration/unregistration to the module init/exit function.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/edac/sb_edac.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> index 4adaf4b..a21ace0 100644
> --- a/drivers/edac/sb_edac.c
> +++ b/drivers/edac/sb_edac.c
> @@ -1604,8 +1604,6 @@ static void sbridge_unregister_mci(struct sbridge_dev *sbridge_dev)
>  	debugf0("MC: " __FILE__ ": %s(): mci = %p, dev = %p\n",
>  		__func__, mci, &sbridge_dev->pdev[0]->dev);
>  
> -	mce_unregister_decode_chain(&sbridge_mce_dec);
> -
>  	/* Remove MC sysfs nodes */
>  	edac_mc_del_mc(mci->dev);
>  
> @@ -1682,7 +1680,6 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
>  		goto fail0;
>  	}
>  
> -	mce_register_decode_chain(&sbridge_mce_dec);
>  	return 0;
>  
>  fail0:
> @@ -1811,8 +1808,10 @@ static int __init sbridge_init(void)
>  
>  	pci_rc = pci_register_driver(&sbridge_driver);
>  
> -	if (pci_rc >= 0)
> +	if (pci_rc >= 0) {
> +		mce_register_decode_chain(&sbridge_mce_dec);
>  		return 0;
> +	}
>  
>  	sbridge_printk(KERN_ERR, "Failed to register device with error %d.\n",
>  		      pci_rc);
> @@ -1828,6 +1827,7 @@ static void __exit sbridge_exit(void)
>  {
>  	debugf2("MC: " __FILE__ ": %s()\n", __func__);
>  	pci_unregister_driver(&sbridge_driver);
> +	mce_unregister_decode_chain(&sbridge_mce_dec);
>  }
>  
>  module_init(sbridge_init);

Hi, please refer this:
https://lkml.org/lkml/2012/5/8/62
