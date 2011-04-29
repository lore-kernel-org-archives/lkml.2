Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1D2Guk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 02:50:40 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49459 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1D2Gui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 02:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=hQ2goGkiSRVgQRkLmatfVPVu1JnA11qXXd2IYZbr20OPYVDNW4sxgaSHKrq6/rQWZG
         CVNXpt3+KBqIjWduG9AxHIpcScjkLqWoBG8OUgbIBQqGEC3qbcup5BW0j0aEUEl2+6gr
         GbtS53Engc3TWZcg3WvqNglz2NM/H5fGSSXqE=
MIME-Version: 1.0
Date: Thu, 28 Apr 2011 23:50:37 -0700
X-Google-Sender-Auth: 11IlNGNHGJFjVEWzrUk2zdPpfMM
Message-ID: <BANLkTim1kL+8Amv4t+s0K-OHxOASqNyYeA@mail.gmail.com>
Subject: pci/iommu: possible circular locking dependency detected
From: Yinghai Lu <yinghai@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>,
        "Barnes, Jesse" <jesse.barnes@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

during one one pci express module hot remove got:

[  284.592228] pciehp 0000:c0:03.0:pcie04: pcie_isr: intr_loc 1
[  284.596437] pciehp 0000:c0:03.0:pcie04: Attention button interrupt received
[  284.611468] pciehp 0000:c0:03.0:pcie04: Button pressed on Slot(8)
[  284.613882] pciehp 0000:c0:03.0:pcie04: pciehp_get_power_status:
SLOTCTRL a8 value read 1f9
[  284.632536] pciehp 0000:c0:03.0:pcie04: PCI slot #8 - powering off
due to button press.
[  284.651843] pciehp 0000:c0:03.0:pcie04: pcie_isr: intr_loc 10
[  284.654264] pciehp 0000:c0:03.0:pcie04: pciehp_green_led_blink:
SLOTCTRL a8 write cmd 200
[  284.672525] pciehp 0000:c0:03.0:pcie04:
pciehp_set_attention_status: SLOTCTRL a8 write cmd c0
[  285.687854] pciehp 0000:c0:03.0:pcie04: Command not completed in 1000 msec
[  290.687752] pciehp 0000:c0:03.0:pcie04: Disabling
domain:bus:device=0000:c4:00
[  290.689785] pciehp 0000:c0:03.0:pcie04: pciehp_get_power_status:
SLOTCTRL a8 value read 2f9
[  290.701717] pciehp 0000:c0:03.0:pcie04: pciehp_unconfigure_device:
domain:bus:dev = 0000:c4:00
[  290.727301] mpt2sas0: sending message unit reset !!
[  290.735028] mpt2sas0: message unit reset: SUCCESS
[  290.741044] mpt2sas 0000:c4:00.0: PCI INT A disabled
[  290.813002]
[  290.813004] =======================================================
[  290.816138] [ INFO: possible circular locking dependency detected ]
[  290.831050] 2.6.39-rc5-tip-yh-03892-g99e29c6-dirty #892
[  290.833783] -------------------------------------------------------
[  290.851566] kworker/u:7/14234 is trying to acquire lock:
[  290.853452]  (&(&iommu->lock)->rlock){......}, at:
[<ffffffff813711ca>] domain_remove_one_dev_info+0x1a9/0x1f3
[  290.873971]
[  290.873972] but task is already holding lock:
[  290.891038]  (device_domain_lock){..-...}, at: [<ffffffff81371141>]
domain_remove_one_dev_info+0x120/0x1f3
[  290.909942]
[  290.909943] which lock already depends on the new lock.
[  290.909944]
[  290.913929]
[  290.913930] the existing dependency chain (in reverse order) is:
[  290.931771]
[  290.931772] -> #1 (device_domain_lock){..-...}:
[  290.950181]        [<ffffffff810aefa9>] validate_chain+0x4c4/0x5e2
[  290.952674]        [<ffffffff810b166e>] __lock_acquire+0x790/0x819
[  290.970167]        [<ffffffff810b1c7a>] lock_acquire+0xcb/0xf1
[  290.972368]        [<ffffffff81c28217>] _raw_spin_lock_irqsave+0x41/0x7b
[  290.990752]        [<ffffffff81371843>] iommu_support_dev_iotlb+0x53/0xd0
[  290.994113]        [<ffffffff813721a7>]
domain_context_mapping_one+0x1e9/0x34d
[  291.013680]        [<ffffffff8137234a>] domain_context_mapping+0x3f/0xe8
[  291.030390]        [<ffffffff813743e2>]
iommu_prepare_identity_map+0x17f/0x19e
[  291.034072]        [<ffffffff82751dfd>] init_dmars.clone.3+0x3a2/0x507
[  291.051829]        [<ffffffff8275213e>] intel_iommu_init+0x1dc/0x1eb
[  291.054893]        [<ffffffff8272ae13>] pci_iommu_init+0x16/0x41
[  291.071892]        [<ffffffff810002cf>] do_one_initcall+0x57/0x134
[  291.089628]        [<ffffffff82723f9b>] kernel_init+0x137/0x1bb
[  291.093546]        [<ffffffff81c306d4>] kernel_thread_helper+0x4/0x10
[  291.110506]
[  291.110507] -> #0 (&(&iommu->lock)->rlock){......}:
[  291.115017]        [<ffffffff810ae676>] check_prev_add+0x10c/0x57b
[  291.130534]        [<ffffffff810aefa9>] validate_chain+0x4c4/0x5e2
[  291.132745]        [<ffffffff810b166e>] __lock_acquire+0x790/0x819
[  291.151668]        [<ffffffff810b1c7a>] lock_acquire+0xcb/0xf1
[  291.154427]        [<ffffffff81c28217>] _raw_spin_lock_irqsave+0x41/0x7b
[  291.172250]        [<ffffffff813711ca>]
domain_remove_one_dev_info+0x1a9/0x1f3
[  291.190965]        [<ffffffff8137329a>] device_notifier+0x52/0x78
[  291.194025]        [<ffffffff81c2bd4a>] notifier_call_chain+0x68/0x9f
[  291.210956]        [<ffffffff810a1ca9>]
__blocking_notifier_call_chain+0x4c/0x61
[  291.229363]        [<ffffffff810a1cd2>]
blocking_notifier_call_chain+0x14/0x16
[  291.233327]        [<ffffffff814215a5>] __device_release_driver+0xc2/0xd4
[  291.250875]        [<ffffffff814215dc>] device_release_driver+0x25/0x32
[  291.253943]        [<ffffffff81421163>] bus_remove_device+0x8e/0x9f
[  291.276172]        [<ffffffff8141f1ec>] device_del+0x137/0x186
[  291.289248]        [<ffffffff8141f251>] device_unregister+0x16/0x23
[  291.291867]        [<ffffffff81354ac9>] pci_stop_bus_device+0x61/0x83
[  291.309583]        [<ffffffff81354b75>] pci_remove_bus_device+0x1a/0xba
[  291.312096]        [<ffffffff81366a05>] pciehp_unconfigure_device+0x110/0x17b
[  291.330879]        [<ffffffff81366461>] pciehp_disable_slot+0x11e/0x188
[  291.349132]        [<ffffffff8136655a>] pciehp_power_thread+0x8f/0xe0
[  291.351652]        [<ffffffff81096dff>] process_one_work+0x237/0x3ec
[  291.369486]        [<ffffffff810972ed>] worker_thread+0x17c/0x240
[  291.372841]        [<ffffffff8109c949>] kthread+0xa0/0xa8
[  291.389713]        [<ffffffff81c306d4>] kernel_thread_helper+0x4/0x10
[  291.392216]
[  291.392216] other info that might help us debug this:
[  291.392217]
[  291.411212]  Possible unsafe locking scenario:
[  291.411213]
[  291.429320]        CPU0                    CPU1
[  291.431471]        ----                    ----
[  291.434178]   lock(device_domain_lock);
[  291.450478]                                lock(&(&iommu->lock)->rlock);
[  291.453838]                                lock(device_domain_lock);
[  291.470818]   lock(&(&iommu->lock)->rlock);
[  291.473533]
[  291.473533]  *** DEADLOCK ***
[  291.473534]
[  291.490450] 5 locks held by kworker/u:7/14234:
[  291.492593]  #0:  (name){.+.+.+}, at: [<ffffffff81096d70>]
process_one_work+0x1a8/0x3ec
[  291.511017]  #1:  ((&info->work)#2){+.+.+.}, at:
[<ffffffff81096d70>] process_one_work+0x1a8/0x3ec
[  291.529483]  #2:  (&__lockdep_no_validate__){+.+.+.}, at:
[<ffffffff814215d4>] device_release_driver+0x1d/0x32
[  291.549158]  #3:  (&(&priv->bus_notifier)->rwsem){.+.+.+}, at:
[<ffffffff810a1c8e>] __blocking_notifier_call_chain+0x31/0x61
[  291.569119]  #4:  (device_domain_lock){..-...}, at:
[<ffffffff81371141>] domain_remove_one_dev_info+0x120/0x1f3
[  291.588744]
[  291.588744] stack backtrace:
[  291.590339] Pid: 14234, comm: kworker/u:7 Not tainted
2.6.39-rc5-tip-yh-03892-g99e29c6-dirty #892
[  291.609653] Call Trace:
[  291.611457]  [<ffffffff810ad9aa>] print_circular_bug+0xce/0xdf
[  291.628949]  [<ffffffff810ae676>] check_prev_add+0x10c/0x57b
[  291.633454]  [<ffffffff810aefa9>] validate_chain+0x4c4/0x5e2
[  291.648925]  [<ffffffff810b166e>] __lock_acquire+0x790/0x819
[  291.652876]  [<ffffffff810a27ea>] ? local_clock+0x2b/0x3c
[  291.668622]  [<ffffffff813711c2>] ? domain_remove_one_dev_info+0x1a1/0x1f3
[  291.674679]  [<ffffffff810ac443>] ? trace_hardirqs_off_caller+0x1f/0x10e
[  291.690379]  [<ffffffff813711ca>] ? domain_remove_one_dev_info+0x1a9/0x1f3
[  291.698614]  [<ffffffff810b1c7a>] lock_acquire+0xcb/0xf1
[  291.712157]  [<ffffffff813711ca>] ? domain_remove_one_dev_info+0x1a9/0x1f3
[  291.728464]  [<ffffffff81c281f4>] ? _raw_spin_lock_irqsave+0x1e/0x7b
[  291.734229]  [<ffffffff81c28217>] _raw_spin_lock_irqsave+0x41/0x7b
[  291.749095]  [<ffffffff813711ca>] ? domain_remove_one_dev_info+0x1a9/0x1f3
[  291.756271]  [<ffffffff810ac53f>] ? trace_hardirqs_off+0xd/0xf
[  291.770041]  [<ffffffff813711ca>] domain_remove_one_dev_info+0x1a9/0x1f3
[  291.775450]  [<ffffffff8137329a>] device_notifier+0x52/0x78
[  291.791365]  [<ffffffff81c2bd4a>] notifier_call_chain+0x68/0x9f
[  291.797619]  [<ffffffff810a1ca9>] __blocking_notifier_call_chain+0x4c/0x61
[  291.813753]  [<ffffffff810a1cd2>] blocking_notifier_call_chain+0x14/0x16
[  291.829241]  [<ffffffff814215a5>] __device_release_driver+0xc2/0xd4
[  291.835845]  [<ffffffff814215dc>] device_release_driver+0x25/0x32
[  291.849271]  [<ffffffff81421163>] bus_remove_device+0x8e/0x9f
[  291.851170]  [<ffffffff8141f1ec>] device_del+0x137/0x186
[  291.869762]  [<ffffffff8141f251>] device_unregister+0x16/0x23
[  291.872516]  [<ffffffff81354ac9>] pci_stop_bus_device+0x61/0x83
[  291.889445]  [<ffffffff81354b75>] pci_remove_bus_device+0x1a/0xba
[  291.892216]  [<ffffffff81366a05>] pciehp_unconfigure_device+0x110/0x17b
[  291.910924]  [<ffffffff813664cb>] ? pciehp_disable_slot+0x188/0x188
[  291.928156]  [<ffffffff81366461>] pciehp_disable_slot+0x11e/0x188
[  291.929821]  [<ffffffff8136655a>] pciehp_power_thread+0x8f/0xe0
[  291.948411]  [<ffffffff81096dff>] process_one_work+0x237/0x3ec
[  291.950612]  [<ffffffff81096d70>] ? process_one_work+0x1a8/0x3ec
[  291.968443]  [<ffffffff810972ed>] worker_thread+0x17c/0x240
[  291.970359]  [<ffffffff810afdc3>] ? trace_hardirqs_on+0xd/0xf
[  291.989238]  [<ffffffff81097171>] ? manage_workers+0xab/0xab
[  291.991442]  [<ffffffff8109c949>] kthread+0xa0/0xa8
[  292.008322]  [<ffffffff81c306d4>] kernel_thread_helper+0x4/0x10
[  292.011365]  [<ffffffff81c28c80>] ? retint_restore_args+0xe/0xe
[  292.029190]  [<ffffffff8109c8a9>] ? __init_kthread_worker+0x5b/0x5b
[  292.033106]  [<ffffffff81c306d0>] ? gs_change+0xb/0xb
[  292.929287] pciehp 0000:c0:03.0:pcie04: pcie_isr: intr_loc 10
[  292.931020] pciehp 0000:c0:03.0:pcie04: pciehp_power_off_slot:
SLOTCTRL a8 write cmd 400

looks like : iommu_detech_dev will call lock &iommu->lock without lock
&device_domain_lock
                        spin_unlock_irqrestore(&device_domain_lock, flags);

                        iommu_disable_dev_iotlb(info);
                        iommu_detach_dev(iommu, info->bus, info->devfn);
                        iommu_detach_dependent_devices(iommu, pdev);
                        free_devinfo_mem(info);

                        spin_lock_irqsave(&device_domain_lock, flags);

....
later &iommu->lock get reqest to lock with &device_domain_lock locked.
                spin_lock_irqsave(&iommu->lock, tmp_flags);
                clear_bit(domain->id, iommu->domain_ids);
                iommu->domains[domain->id] = NULL;
                spin_unlock_irqrestore(&iommu->lock, tmp_flags);
        }

        spin_unlock_irqrestore(&device_domain_lock, flags);

Please fix it.

Thanks

Yinghai
