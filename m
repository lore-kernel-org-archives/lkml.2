Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab1CDSm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:42:57 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:47473 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759425Ab1CDSm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:42:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MNRCLGOzSBrrYGCImqhl78dJyWguh2Rao0vcNbCIxlHgzpX+DxBX+n795uWx72tHdSIoxsCxQIPhqQVw4z0DBVJNAyafMZPxS3t52FEFNQjjNMsK533wVxRUa8eFgBva;
Date: Fri, 4 Mar 2011 10:42:51 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        linux-pci@vger.kernel.org, Allen Kay <allen.m.kay@intel.com>
Subject: Re: [RFC PATCH] set current_state to D0 in register_slot
Message-ID: <20110304104251.45b257c4@jbarnes-desktop>
In-Reply-To: <alpine.DEB.2.00.1102281605130.2917@kaball-desktop>
References: <alpine.DEB.2.00.1102281605130.2917@kaball-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 16:20:11 +0000
Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

> Hi all,
> if a device doesn't support power management (pm_cap == 0) but it is
> acpi_pci_power_manageable() because there is a _PS0 method declared for
> it and _EJ0 is also declared for the slot then nobody is going to set
> current_state = PCI_D0 for this device.  This is what I think it is
> happening:
> 
> 
> pci_enable_device
>     |
> __pci_enable_device_flags
> /* here we do not set current_state because !pm_cap */
>     |
> do_pci_enable_device
>     |
> pci_set_power_state
>     |
> __pci_start_power_transition
>     |
> pci_platform_power_transition
> /* platform_pci_power_manageable() calls acpi_pci_power_manageable that
>  * returns true */
>     |
> platform_pci_set_power_state
> /* acpi_pci_set_power_state gets called and does nothing because the
>  * acpi device has _EJ0, see the comment "If the ACPI device has _EJ0,
>  * ignore the device" */
> 
> 
> at this point if we refer to the commit message that introduced the
> comment above (10b3dcae0f275e2546e55303d64ddbb58cec7599), it is up to
> the hotplug driver to set the state to D0.
> However AFAICT the pci hotplug driver never does, in fact
> drivers/pci/hotplug/acpiphp_glue.c:register_slot sets the slot flags to
> (SLOT_ENABLED | SLOT_POWEREDON) but it does not set the pci device
> current state to PCI_D0.
> 
> So my proposed fix is also to set current_state = PCI_D0 in
> register_slot.
> Comments are very welcome.
> 
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Yeah, looks fine.  ACPIPHP is happy for the attention. :)

-- 
Jesse Barnes, Intel Open Source Technology Center
