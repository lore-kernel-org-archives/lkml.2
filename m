Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab2KIQ5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:57:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39799 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab2KIQ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:56:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4xn9t=4yXGLdPQMtUJF=n38tYrMutAoj7NCsLUzQEbcg@mail.gmail.com>
References: <201211081915083774239@gmail.com>
	<509B962C.6070002@gmail.com>
	<C5551D9AAB213A418B7FD5E4A6F30A072D565E76@ORSMSX106.amr.corp.intel.com>
	<CANmqhJDJXcbUxyt6YD6ktxZCDJ=VqiwhGXP+fLMukQr0o-XwxQ@mail.gmail.com>
	<CAErSpo4xn9t=4yXGLdPQMtUJF=n38tYrMutAoj7NCsLUzQEbcg@mail.gmail.com>
Date: Fri, 9 Nov 2012 08:56:56 -0800
X-Google-Sender-Auth: E3mXlR-lUp2bGymSDHRP8r6BHkE
Message-ID: <CAE9FiQVeX6=LzhkX6aUF9yMMX4g-AUsT+oVqsRTN58xes4RLew@mail.gmail.com>
Subject: Re: SR-IOV problem with Intel 82599EB (not enough MMIO resources for SR-IOV)
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jason Gao <pkill.2012@gmail.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 7:26 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+ linux-pci, Yinghai]
>
> On Thu, Nov 8, 2012 at 8:59 PM, Jason Gao <pkill.2012@gmail.com> wrote:
>>> The BIOS in your machine doesn't support SR-IOV.  You'll need to ask the manufacturer for a BIOS upgrade, if in fact one is available.  Sometimes they're not.
>>
>> very thanks Greg,my server Dell R710 with latest BIOS version and
>> option for SR-IOV(SR-IOV Global Enable->Enabled)  opened,I'm confused
>> that Does R710 provide full support for SR-IOV, kernel or  ixgbe
>> driver's bug? but I'm not sure where the problem lies,anyone has any
>> experience about this?   .
>
> Linux normally uses the resource assignments done by the BIOS, but it
> is possible for the kernel to reassign those.  We don't have good
> automatic support for that yet, but on a recent upstream kernel, you
> can try "pci=realloc".  I doubt this option is in CentOS 6.3, though.
>
> If an upstream kernel with "pci=realloc" still doesn't work, please
> post the entire dmesg log.

Even better, upstream kernel will enable realloc automatically if it
finds some SRIOV BAR is not assigned.
related logic is in pci_realloc_detect().

BTW, we may need another patch about realloc.

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=patch;h=afb9975bddd92b17c2f9859676ce521e2e014997

>From afb9975bddd92b17c2f9859676ce521e2e014997 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Wed, 3 Oct 2012 19:15:57 -0700
Subject: [PATCH] PCI: Add root bus children dev's res to fail list

We can stop trying according to try number now and do not need to use
root_bus checking as stop sign anymore.
In extreme case we could need to reallocate resource for device just
under root bus.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/setup-bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 1e808ca..9e625d84 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -283,7 +283,7 @@ static void
assign_requested_resources_sorted(struct list_head *head,
 		idx = res - &dev_res->dev->resource[0];
 		if (resource_size(res) &&
 		    pci_assign_resource(dev_res->dev, idx)) {
-			if (fail_head && !pci_is_root_bus(dev_res->dev->bus)) {
+			if (fail_head) {
 				/*
 				 * if the failed res is for ROM BAR, and it will
 				 * be enabled later, don't add it to the list
-- 
1.7.7.6
