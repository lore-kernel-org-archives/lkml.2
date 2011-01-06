Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1AFAWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:22:08 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49142 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1AFAWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:22:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=IxpYj8vaCiEzhpnXcipfqt+ckJNBboBSUz53T7Xmo0VTX4KgtCGFEAW21pd3lu61oM
         OY+55YOUvDFi6MhL4i5ZEr7tpRdr4DJrKIKjWW4fgOgI4/7aGNHE9VwhCSz9dcGA/kRe
         jjwB60QAf2S93adWI136YwV86K9XGuOCJw6f8=
Message-ID: <4D250B2B.8090901@gmail.com>
Date: Wed, 05 Jan 2011 18:22:03 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Linux-usb <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Sleeping function called from invalid context in 2.6.37 xhci_hcd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just saw this on booting up on the latest Fedora Rawhide kernel based on 
2.6.37. Looks like we were trying to do a runtime suspend on the xHCI 
USB controller and it disabled MSI-X while interrupts were disabled?

    10.805829] xhci_hcd 0000:08:00.0: PCI INT A -> GSI 17 (level, low) 
-> IRQ 17
[   10.806683] xhci_hcd 0000:08:00.0: setting latency timer to 64
[   10.806686] xhci_hcd 0000:08:00.0: xHCI Host Controller
[   10.807868] xhci_hcd 0000:08:00.0: new USB bus registered, assigned 
bus number 3
[   10.812000] xhci_hcd 0000:08:00.0: irq 17, io mem 0xf7dfe000
[   10.812769] xhci_hcd 0000:08:00.0: irq 48 for MSI/MSI-X
[   10.812773] xhci_hcd 0000:08:00.0: irq 49 for MSI/MSI-X
[   10.812777] xhci_hcd 0000:08:00.0: irq 50 for MSI/MSI-X
[   10.812780] xhci_hcd 0000:08:00.0: irq 51 for MSI/MSI-X
[   10.812783] xhci_hcd 0000:08:00.0: irq 52 for MSI/MSI-X
[   10.815323] usb usb3: No SuperSpeed endpoint companion for config 1 
interface 0 altsetting 0 ep 129: using minimum values
[   10.816028] usb usb3: New USB device found, idVendor=1d6b, idProduct=0003
[   10.816712] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[   10.817399] usb usb3: Product: xHCI Host Controller
[   10.818072] usb usb3: Manufacturer: Linux 2.6.37-1.fc15.x86_64 xhci_hcd
[   10.818730] usb usb3: SerialNumber: 0000:08:00.0
[   10.819481] xHCI xhci_add_endpoint called for root hub
[   10.819483] xHCI xhci_check_bandwidth called for root hub
[   10.819518] hub 3-0:1.0: USB hub found
[   10.820178] hub 3-0:1.0: 4 ports detected

...


[   12.966754] BUG: sleeping function called from invalid context at 
kernel/mutex.c:85
[   12.967269] in_atomic(): 0, irqs_disabled(): 1, pid: 11, name: 
kworker/0:1
[   12.967766] Pid: 11, comm: kworker/0:1 Not tainted 
2.6.37-1.fc15.x86_64 #1
[   12.968247] Call Trace:
[   12.968733]  [<ffffffff81041f05>] __might_sleep+0xeb/0xf0
[   12.969204]  [<ffffffff81476a0e>] mutex_lock+0x24/0x50
[   12.969670]  [<ffffffff810abd14>] free_desc+0x2e/0x5f
[   12.970164]  [<ffffffff810abd80>] irq_free_descs+0x3b/0x71
[   12.970649]  [<ffffffff8102567d>] free_irq_at+0x31/0x36
[   12.971120]  [<ffffffff81027065>] destroy_irq+0x69/0x71
[   12.971590]  [<ffffffff810272a0>] native_teardown_msi_irq+0xe/0x10
[   12.972048]  [<ffffffff81255220>] default_teardown_msi_irqs+0x57/0x80
[   12.972494]  [<ffffffff81254ce6>] free_msi_irqs+0x8b/0xe9
[   12.972939]  [<ffffffff81255be4>] pci_disable_msix+0x35/0x39
[   12.973391]  [<ffffffffa018211a>] xhci_cleanup_msix+0x31/0x51 [xhci_hcd]
[   12.973834]  [<ffffffffa0182d35>] xhci_suspend+0x199/0x1ab [xhci_hcd]
[   12.974284]  [<ffffffffa01875ce>] xhci_pci_suspend+0x23/0x25 [xhci_hcd]
[   12.974737]  [<ffffffff8134feed>] suspend_common+0x65/0xe2
[   12.975195]  [<ffffffff8134ff83>] hcd_pci_runtime_suspend+0x19/0x43
[   12.975650]  [<ffffffff8124508b>] pci_pm_runtime_suspend+0x58/0xea
[   12.976102]  [<ffffffff81245033>] ? pci_pm_runtime_suspend+0x0/0xea
[   12.976548]  [<ffffffff812ef338>] rpm_suspend+0x285/0x3c5
[   12.976991]  [<ffffffff814778af>] ? _raw_spin_unlock_irqrestore+0x17/0x19
[   12.977436]  [<ffffffff812ef73c>] ? __pm_runtime_idle+0x5f/0x6f
[   12.977877]  [<ffffffff812efeef>] __pm_runtime_suspend+0x51/0x6d
[   12.978318]  [<ffffffff81244d4b>] ? pci_pm_runtime_idle+0x0/0x4d
[   12.978758]  [<ffffffff81244d92>] pci_pm_runtime_idle+0x47/0x4d
[   12.979193]  [<ffffffff812ef63d>] rpm_idle+0x14d/0x18f
[   12.979624]  [<ffffffff812effc6>] ? pm_runtime_work+0x0/0xa0
[   12.980053]  [<ffffffff812f0031>] pm_runtime_work+0x6b/0xa0
[   12.980476]  [<ffffffff810664ab>] process_one_work+0x18c/0x285
[   12.980891]  [<ffffffff810672b2>] worker_thread+0x104/0x1a4
[   12.981306]  [<ffffffff810671ae>] ? worker_thread+0x0/0x1a4
[   12.981720]  [<ffffffff8106a8e3>] kthread+0x82/0x8a
[   12.982129]  [<ffffffff8100bae4>] kernel_thread_helper+0x4/0x10
[   12.982533]  [<ffffffff8106a861>] ? kthread+0x0/0x8a
[   12.982926]  [<ffffffff8100bae0>] ? kernel_thread_helper+0x0/0x10

