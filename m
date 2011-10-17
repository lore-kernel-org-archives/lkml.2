Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1JQRQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:16:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:54696 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab1JQRQl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:16:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ehw3SW4fS0Wk2Dybe1onN1Xfckf/PNmjbRjN7IDrgaRA83duiqq1HjFde7tRD3qtv
	u+R6StxSPv+VvrHFIaG2A==
MIME-Version: 1.0
In-Reply-To: <4E9A3408.9080905@oracle.com>
References: <4E9A3092.4080309@oracle.com> <4E9A3408.9080905@oracle.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Oct 2011 11:16:17 -0600
Message-ID: <CAErSpo5XdM+1OFmoU+rN_QNWCJ0Wzv1VwKxsTo9hTq=2=7KEHA@mail.gmail.com>
Subject: Re: [PATCH 1/8] pci: Make sriov work with hotplug removal
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 7:31 PM, Yinghai Lu <yinghai.lu@oracle.com> wrote:
>
> When hot remove pci express module, got
>
> [ 5918.610127] pciehp 0000:80:02.2:pcie04: pcie_isr: intr_loc 1
> [ 5918.615779] pciehp 0000:80:02.2:pcie04: Attention button interrupt received
> [ 5918.622730] pciehp 0000:80:02.2:pcie04: Button pressed on Slot(3)
> [ 5918.629002] pciehp 0000:80:02.2:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 1f9
> [ 5918.637416] pciehp 0000:80:02.2:pcie04: PCI slot #3 - powering off due to button press.
> [ 5918.647125] pciehp 0000:80:02.2:pcie04: pcie_isr: intr_loc 10
> [ 5918.653039] pciehp 0000:80:02.2:pcie04: pciehp_green_led_blink: SLOTCTRL a8 write cmd 200
> [ 5918.661229] pciehp 0000:80:02.2:pcie04: pciehp_set_attention_status: SLOTCTRL a8 write cmd c0
> [ 5924.667627] pciehp 0000:80:02.2:pcie04: Disabling domain:bus:device=0000:b0:00
> [ 5924.674909] pciehp 0000:80:02.2:pcie04: pciehp_get_power_status: SLOTCTRL a8 value read 2f9
> [ 5924.683262] pciehp 0000:80:02.2:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:b0:00
> [ 5924.693976] libfcoe_device_notification: NETDEV_UNREGISTER eth6
> [ 5924.764979] libfcoe_device_notification: NETDEV_UNREGISTER eth14
> [ 5924.873539] libfcoe_device_notification: NETDEV_UNREGISTER eth15
> [ 5924.995209] libfcoe_device_notification: NETDEV_UNREGISTER eth16
> [ 5926.114407] sxge 0000:b2:00.0: PCI INT A disabled
> [ 5926.119342] BUG: unable to handle kernel NULL pointer dereference at (null)
> [ 5926.127189] IP: [<ffffffff81353a3b>] pci_stop_bus_device+0x33/0x83
> [ 5926.133377] PGD 0
> [ 5926.135402] Oops: 0000 [#1] SMP
> [ 5926.138659] CPU 2
> [ 5926.140499] Modules linked in:
> ...
> [ 5926.143754]
> [ 5926.275823] Call Trace:
> [ 5926.278267]  [<ffffffff81353a38>] pci_stop_bus_device+0x30/0x83
> [ 5926.284180]  [<ffffffff81353af4>] pci_remove_bus_device+0x1a/0xba
> [ 5926.290264]  [<ffffffff81366311>] pciehp_unconfigure_device+0x110/0x17b
> [ 5926.296866]  [<ffffffff81365dd9>] ? pciehp_disable_slot+0x188/0x188
> [ 5926.303123]  [<ffffffff81365d6f>] pciehp_disable_slot+0x11e/0x188
> [ 5926.309206]  [<ffffffff81365e68>] pciehp_power_thread+0x8f/0xe0
> ...
>
> Root cause: when doing pci_stop_bus_device() with phys fn, it will stop virt fn and
> remove the fn, so
>        list_for_each_safe(l, n, &bus->devices)
> will have problem to refer freed n that is pointed to vf entry.
>
> Solution is just call pci_stop_bus_device() with phys fn only. and before that need to
> save phys fn aside and avoid to use bus->devices to loop.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  drivers/pci/remove.c |   33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> Index: linux-2.6/drivers/pci/remove.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/remove.c
> +++ linux-2.6/drivers/pci/remove.c
> @@ -120,10 +120,43 @@ void pci_remove_behind_bridge(struct pci
>                        pci_remove_bus_device(pci_dev_b(l));
>  }
>
> +struct dev_list {
> +       struct pci_dev *dev;
> +       struct list_head list;
> +};
> +
>  static void pci_stop_bus_devices(struct pci_bus *bus)
>  {
>        struct list_head *l, *n;
> +       struct dev_list *dl, *dn;
> +       LIST_HEAD(physfn_list);
> +
> +       /* Save phys_fn aside at first */
> +       list_for_each(l, &bus->devices) {
> +               struct pci_dev *dev = pci_dev_b(l);
> +
> +               if (!dev->is_virtfn) {
> +                       dl = kmalloc(sizeof(*dl), GFP_KERNEL);
> +                       if (!dl)
> +                               continue;
> +                       dl->dev = dev;
> +                       list_add_tail(&dl->list, &physfn_list);
> +               }
> +       }
> +
> +       /*
> +        * stop bus device for phys_fn at first
> +        *  it will stop and remove vf in driver remove action
> +        */
> +       list_for_each_entry_safe(dl, dn, &physfn_list, list) {
> +               struct pci_dev *dev = dl->dev;
> +
> +               pci_stop_bus_device(dev);
> +
> +               kfree(dl);
> +       }
>
> +       /* Do it again for left over in case */
>        list_for_each_safe(l, n, &bus->devices) {
>                struct pci_dev *dev = pci_dev_b(l);
>                pci_stop_bus_device(dev);

Apparently it's a problem to stop a VF before its PF?  Why is that?
Sounds like there's an important dependency here, but I can't figure
it out.  I would have naively expected that you would *want* to stop a
VF first, since it depends on the PF.
