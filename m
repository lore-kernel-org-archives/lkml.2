Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab0FRVMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:12:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53215 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab0FRVMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:12:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=W+hrk6W0Ivrada1GX+lf3YliQBhb1BbGYPUb6r5LYl7MFtSd1mtnEJixw96Ed+ExRs
         tJZQxEONEClLimFeQSjPh+2EGOzThK2j/Kt3c/Mp6S0tYIbYOSXVZoZYRUGGa/3HEIF7
         bzlEjnwmcIr/fitAjDTUZD2DMBCZKxFjnH6f8=
Message-ID: <4C1BE149.9040001@gmail.com>
Date: Fri, 18 Jun 2010 14:12:41 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>	<1276666434-11227-5-git-send-email-justinmattock@gmail.com>	<20100618102330.29eccb5b@virtuousgeek.org>	<4C1BBF7D.8090904@kernel.org>	<20100618124956.40c869a0@virtuousgeek.org>	<4C1BD024.1030707@gmail.com>	<20100618130538.0fc562ee@virtuousgeek.org>	<4C1BD678.1020405@gmail.com> <20100618134622.7db9f913@virtuousgeek.org>
In-Reply-To: <20100618134622.7db9f913@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2010 01:46 PM, Jesse Barnes wrote:
> On Fri, 18 Jun 2010 13:26:32 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>> On 06/18/2010 01:05 PM, Jesse Barnes wrote:
>>> On Fri, 18 Jun 2010 12:59:32 -0700
>>> "Justin P. Mattock"<justinmattock@gmail.com>   wrote:
>>>> just added this in(as a test), and the retval warning still shows up.
>>>> with the last post I just added a printk was that legit, and if so what
>>>> else might be added to it to make it complete and proper?
>>>
>>> What's the full warning?  Seems like printing the value should have
>>> been enough to shut up gcc...
>>>
>>
>> this is the warning messg after applying yinghai's patch:
>>
>>     CC      drivers/pci/setup-bus.o
>> drivers/pci/setup-bus.c: In function
>> 'pci_assign_unassigned_bridge_resources':
>> drivers/pci/setup-bus.c:868:6: warning: variable 'retval' set but not used
>
> Right because Yinghai's patch just sets retval but doesn't actually use
> it anywhere.
>

that's what is confusing..(not being used, but is being used, but gcc 
says it's not used..)  :-)

>> if I add a printk then gcc is content.. patch below, but not the best at
>> creating printk's(the whole % thing messes me up) but here goes:
>>
>>   From 48e15b87072c6b4286d943c55bfe2ae26d358795 Mon Sep 17 00:00:00 2001
>> From: Justin P. Mattock<justinmattock@gmail.com>
>> Date: Fri, 18 Jun 2010 13:23:27 -0700
>> Subject: [PATCH 4/4] bus.c_add_print
>>    Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>    drivers/pci/setup-bus.c |    1 +
>>    1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index 66cb8f4..806b766 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -919,6 +919,7 @@ again:
>>
>>    enable_all:
>>    	retval = pci_reenable_device(bridge);
>> +	printk(KERN_DEBUG "PCI%d: re-enabling device\n", retval);
>>    	pci_set_master(bridge);
>>    	pci_enable_bridges(parent);
>>    }
>
> Again, this doesn't have the if (retval) condition around the printk; I
> don't want to see this message everytime regardless.  Also the message
> is misleading, it should be something like:
>    dev_err(&bridge->dev, "failed to re-enable device: %d\n", retval)
> instead.  PCI%d makes it look like we're talking about a specific bus
> or something and not an error code.
>

o.k. I admit I looked at other printk's in this file to get an idea of 
what I might do.. saw PCI%d and figured it would print
"PCI: re-enabling device"
but didnt think it was an error... reason for putting KERN_DEBUG.

here is what the new patch looks like:


 From f910375438be06497d0524bff146c26cafca272b Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Fri, 18 Jun 2010 14:08:37 -0700
Subject: [PATCH 4/4] setup-pci_test
  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  drivers/pci/setup-bus.c |    3 +++
  1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 66cb8f4..2ab5f1e 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -919,6 +919,9 @@ again:

  enable_all:
  	retval = pci_reenable_device(bridge);
+	if (retval) {
+		dev_err(&bridge->dev, "failed to re-enable device: %d\n", retval);
+	}
  	pci_set_master(bridge);
  	pci_enable_bridges(parent);
  }
-- 
1.7.1.rc1.21.gf3bd6


should I have put if (!retval) instead
should I put "failed to re-enable bridge device"
is there an exit code needed?

if not and all is good then I can resend this out..

Justin P. Mattock
