Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2JPLvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:51:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36801 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2JPLvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:51:00 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <507D48EE.9010800@jp.fujitsu.com>
Date: Tue, 16 Oct 2012 20:45:50 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: khalid@gonehiking.org
CC: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, mingo@redhat.com, vgoyal@redhat.com
Subject: Re: [PATCH v4 1/2] x86, pci: Reset PCIe devices at boot time
References: <20121015065516.2832.42378.sendpatchset@indoh>  <20121015065526.2832.90867.sendpatchset@indoh> <1350321429.7065.97.camel@rhapsody>
In-Reply-To: <1350321429.7065.97.camel@rhapsody>
Content-Type: text/plain; charset=Shift_JIS
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/16 2:17), Khalid Aziz wrote:
> On Mon, 2012-10-15 at 16:00 +0900, Takao Indoh wrote:
>> This patch resets PCIe devices at boot time by hot reset when
>> "reset_devices" is specified.
>>
>> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
>> ---
>>   arch/x86/include/asm/pci-direct.h |    1
>>   arch/x86/kernel/setup.c           |    3
>>   arch/x86/pci/early.c              |  344 ++++++++++++++++++++++++++++
>>   include/linux/pci.h               |    2
>>   init/main.c                       |    4
>>   5 files changed, 352 insertions(+), 2 deletions(-)
>>
>
>
> Looks good.
>
> Reviewed-by: Khalid Aziz <khalid@gonehiking.org>
>

Thanks! But unfortunately I found a bug, so I'll post v5 patch soon.

A bug I found is that configuration register is accessed without
delay after reset.

This is an algorithm to reset devices.

  for (each device) {  <===== (A)
    if (does not have downstream devices)
      continue
    for (each downstream device) {
      save config registers
    }
    do_bus_reset <==== (B)
  }
  wait 500 ms
  ...

Let's say my system has the following devices.

00:01.0 (root port)
|
+- 01:00.0 (device)

In this case,
1) At first, 00:01.0 is found at (A). And its downstream devcice 01:00.0
   is reset at (B).
2) Next, 01:00.0 is found at (A). Then config register of 01:00.0 is
   accessed. This is PCIe spec violation because the config register of
   01:00.0 is accessed without delay after reset. PCIe spec requires
   at least 100ms waiting time before sending a config request.

Therefore I'll update patches like this so that devices could be reset
after saving phase is done:

  for (each device) {
    if (does not have downstream devices)
      continue
    for_each (its downstream devices) {
      save config registers
    }
-   do_bus_reset
  }
+ for (each device) {
+   do_bus_reset
+ }
  wait 500 ms
  ...

Thanks,
Takao Indoh

