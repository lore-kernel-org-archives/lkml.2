Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2AaXD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 18:03:28 -0500
Received: from mtv-iport-1.cisco.com ([173.36.130.12]:2054 "EHLO
	mtv-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2AaXD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 18:03:27 -0500
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jan 2012 18:03:27 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkHADxwKE+rRDoI/2dsb2JhbABCgw2rWoEFggsBZQEvDRYYAwIBAgFYAQUCAQEeog8BnlGLEQEEAgECAgkCAgEGBwMTAQgFAwMJgxEZBAMMAxQFVw0BBAQKAQEBAQEBAgEBAQEBAQEBAQGDOwSIQIxghVeNHQ
X-IronPort-AV: E=Sophos;i="4.71,599,1320624000"; 
   d="scan'208";a="26381547"
Message-ID: <4F287102.3060600@cisco.com>
Date: Tue, 31 Jan 2012 15:53:54 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: gregory.v.rose@intel.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: VFs go missing with latest kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I built the kernel.git tree (3.3-rc1) and noticed that even numbered VFs
go missing for the last 2 ports of a quad nic card.

This is the relevant output from lspci for the stock Fedora 14 kernel
(2.6.35.14-106):

07:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network
Connection (rev 01)
07:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network
Connection (rev 01)
08:10.0 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:10.1 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:10.2 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:10.3 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:10.4 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:10.5 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:10.6 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:10.7 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:11.0 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:11.1 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:11.2 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:11.3 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:11.4 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:11.5 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)


For the 3.3.0-rc1 kernel I get:

07:00.0 Ethernet controller: Intel Corporation 82576 Gigabit Network
Connection (rev 01)
07:00.1 Ethernet controller: Intel Corporation 82576 Gigabit Network
Connection (rev 01)
08:10.1 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:10.3 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:10.5 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:10.7 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:11.1 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:11.3 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)
08:11.5 Ethernet controller: Intel Corporation 82576 Virtual Function
(rev 01)

Note that all of the even numbered VFs have disappeared. Accordingly,
trying to launch the VM to which the VFs are assigned fails. git bisect
pointed to this commit:

0224d663063d542b3d829706f3fcbd0f640f19b3 is the first bad commit
commit 0224d663063d542b3d829706f3fcbd0f640f19b3
Author: Greg Rose <gregory.v.rose@intel.com>
Date:   Fri Oct 14 02:57:14 2011 +0000

    igb: Check if subordinate VFs are assigned to virtual machines

    Kvm and the Xen pci-back driver will set a flag in the virtual function
    pci device dev_flags when the VF is assigned to a guest VM.  Before
    destroying subordinate VFs check to see if the flag is set and if so
    skip the call to pci_disable_sriov() to avoid system crashes.

    Copy the maintainer for the Xen pci-back driver.  Also CC'ing
    maintainers of all drivers found to call pci_disable_sriov().


Sure enough reverting the patch on 3.3.0-rc1 makes the VFs visible again.

I am hitting some other problem trying to use the VF on 3.3.0-rc1 -- KVM
fails the KVM_CAP_IOMMU check though the server has one (works fine with
the older kernel) and it is built into the kernel. Debugging that
problem now.

David
