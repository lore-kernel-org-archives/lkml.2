Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761128Ab2ILSPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:15:43 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:62811 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761115Ab2ILSPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:15:41 -0400
X-IronPort-AV: E=Sophos;i="4.80,410,1344211200"; 
   d="scan'208";a="14503477"
Date: Wed, 12 Sep 2012 19:14:58 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Tim (Xen.org)" <tim@xen.org>, David Vrabel <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 06/25] docs: Xen ARM DT bindings
In-Reply-To: <alpine.DEB.2.02.1208281823270.15568@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1209121849200.15568@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com> <1345131377-14713-6-git-send-email-stefano.stabellini@eu.citrix.com> <503BFCD8.5090804@gmail.com> <alpine.DEB.2.02.1208281823270.15568@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012, Stefano Stabellini wrote:
> On Tue, 28 Aug 2012, Rob Herring wrote:
> > You should look at ePAPR 1.1 which defines hypervisor related bindings.
> > While it is a PPC doc, we should reuse or extend what makes sense.
> > 
> > See section 7.5:
> > 
> > https://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.1.pdf
> 
> Thanks for the link, I wasn't aware of ePAPR.
> 
> The hypervisor node defined by ePAPR is not very different from what I
> am proposing. Should I try to be compatible with the hypervisor
> specification above (as in compatible = "epapr,hypervisor-1.1")?
> Or should I just use it as a reference for my own specification?
> 
> Personally I would rather avoid full compatibility with ePAPR.

In particular reading section 7.5, these are the required properties of
the ePAPR hypervisor node:

- compatible = "epapr,hypervisor-1.1"
compared to what I am proposing, it is laking information about what
hypervisor we are talking about (xen, kvm, vmware, etc) and the version
of the ABI (xen-4.2).

- hcall-instructions
potentially interesting, but given that for Xen we are quite happy with
HVC, we are not going to add any secondary hypercall mechanisms,
therefore at the moment it would just result in a BUG if the specified
hcall instruction is != HVC. Besides if somebody else wanted to
implemented the Xen hypercall interface in a different way they could
just reimplement the hypercall wrappers, that would be easier than
trying to do it with this property.

- guest-id
we usually make a point in trying not to tell the guest its own domid
because if the VM gets migrated to a different host it acquires a new
domid, therefore it should not rely on it.

- guest-name
we could pass the guest name here, but I don't see how it could be
of any use.



On the other hand, thinking more about what Xen needs in the device
tree, I think we could improve the current spec by clarifying the
meaning of the memory region and interrupt properties we currently
require. I thought about moving them to two separate children node with
an explicit name:

---

* Xen hypervisor device tree bindings

Xen ARM virtual platforms shall have the following properties and
children nodes:

- compatible property:
	compatible = "xen,xen", "xen,xen-<version>";
  where <version> is the version of the Xen ABI of the platform.

- grant_table child with the following properties:
    - name:
	    name = "grant_table";
	- reg: specifies the base physical address and size of a region in
	    memory where the grant table should be mapped to, using an
        HYPERVISOR_memory_op hypercall. 

- events child with the following properties:
    - name:
        name = "events";
	- interrupts: the interrupt used by Xen to inject event notifications.


Example:
hypervisor {
		compatible = "xen,xen", "xen,xen-4.2";
		#address-cells = <1>;
		#size-cells = <1>;
		#interrupt-cells = <3>;
		ranges = <0xb0000000 0xb0000000 0x20000>;

		grant_table {
			name = "grant_table";
			reg = <0xb0000000 0x20000>;
		};

		events {
			name = "events";
			interrupts = <1 15 0xf08>;
		};
	};
