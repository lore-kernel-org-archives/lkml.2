Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2AaW6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:58:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:59538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256Ab2AaW6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:58:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118786039"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: David Ahern <daahern@cisco.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: VFs go missing with latest kernel
Thread-Topic: VFs go missing with latest kernel
Thread-Index: AQHM4Gs6ffY5XbLoAUGa1L3askdwe5YnFpYA
Date: Tue, 31 Jan 2012 22:58:39 +0000
Message-ID: <C5551D9AAB213A418B7FD5E4A6F30A0702F6489B@ORSMSX106.amr.corp.intel.com>
References: <4F287102.3060600@cisco.com>
In-Reply-To: <4F287102.3060600@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Ahern [mailto:daahern@cisco.com]
> Sent: Tuesday, January 31, 2012 2:54 PM
> To: Rose, Gregory V
> Cc: LKML
> Subject: VFs go missing with latest kernel
> 
> Hi
> 
> I built the kernel.git tree (3.3-rc1) and noticed that even numbered VFs
> go missing for the last 2 ports of a quad nic card.
> 
> This is the relevant output from lspci for the stock Fedora 14 kernel
> (2.6.35.14-106):
> 
> 07:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network
> Connection (rev 01)
> 07:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network
> Connection (rev 01)
> 08:10.0 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:10.1 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:10.2 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:10.3 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:10.4 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:10.5 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:10.6 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:10.7 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:11.0 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:11.1 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:11.2 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:11.3 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:11.4 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:11.5 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 
> 
> For the 3.3.0-rc1 kernel I get:
> 
> 07:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network
> Connection (rev 01)
> 07:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network
> Connection (rev 01)
> 08:10.1 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:10.3 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:10.5 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:10.7 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:11.1 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:11.3 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 08:11.5 Ethernet controller: Intel Corporation 82576 Virtual Function
> (rev 01)
> 
> Note that all of the even numbered VFs have disappeared. Accordingly,
> trying to launch the VM to which the VFs are assigned fails. git bisect
> pointed to this commit:
> 
> 0224d663063d542b3d829706f3fcbd0f640f19b3 is the first bad commit
> commit 0224d663063d542b3d829706f3fcbd0f640f19b3
> Author: Greg Rose <gregory.v.rose@intel.com>
> Date:   Fri Oct 14 02:57:14 2011 +0000
> 
>     igb: Check if subordinate VFs are assigned to virtual machines
> 
>     Kvm and the Xen pci-back driver will set a flag in the virtual
> function
>     pci device dev_flags when the VF is assigned to a guest VM.  Before
>     destroying subordinate VFs check to see if the flag is set and if so
>     skip the call to pci_disable_sriov() to avoid system crashes.
> 
>     Copy the maintainer for the Xen pci-back driver.  Also CC'ing
>     maintainers of all drivers found to call pci_disable_sriov().
> 
> 
> Sure enough reverting the patch on 3.3.0-rc1 makes the VFs visible again.
> 
> I am hitting some other problem trying to use the VF on 3.3.0-rc1 -- KVM
> fails the KVM_CAP_IOMMU check though the server has one (works fine with
> the older kernel) and it is built into the kernel. Debugging that
> problem now.

I'll see if I can reproduce that.  Is this all after a fresh boot with no unloading/reloading of the PF driver?

- Greg

> 
> David
