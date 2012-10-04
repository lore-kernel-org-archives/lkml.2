Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422814Ab2JDQC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:02:27 -0400
Received: from relay2.sgi.com ([192.48.179.30]:49965 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422640Ab2JDQC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:02:26 -0400
Message-ID: <506DB30F.2000704@sgi.com>
Date: Thu, 4 Oct 2012 11:02:23 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] revert "PCI: log vendor/device ID always"
References: <1349187780-25692-1-git-send-email-nzimmer@sgi.com> <CAErSpo7ZQEm9==nsGiH2c_ZG8LPP8MAA8M9xSPyWPtCW2EHUUQ@mail.gmail.com>
In-Reply-To: <CAErSpo7ZQEm9==nsGiH2c_ZG8LPP8MAA8M9xSPyWPtCW2EHUUQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 05:54 PM, Bjorn Helgaas wrote:
> On Tue, Oct 2, 2012 at 8:23 AM, Nathan Zimmer <nzimmer@sgi.com> wrote:
>> Revert commit id 2c6413aee215a43b1f95e218067abcde50ccbc5e
>> On larger systems (256 cores+) with signifigant IO attached this single message
>> represents over 20% of the messages at boot.
> Is this causing a problem?  The messages are at KERN_DEBUG, so they
> shouldn't be going to the console by default anyway.

The problems is that it really does tend to overwhelm dmesg on large 
systems.
This causes two issues, one is it makes it harder to notice unexpected 
messages, second it tends to push out more other messages.

At many of our customer sites the log level is set to KERN_DEBUG. It 
helps avoid reboots due to operator impatience.  Machines this large 
take significantly longer then typical to boot and seeing the extra 
messages reassures them that the kernel isn't hung.

> I/O devices normally have at least one BAR, as well as some PME
> messages, so a change like this won't affect them too much.  My guess
> is that it's really the large number of CPUs, where we find all the
> uncore/memory controller/etc stuff where this is a problem.  Those
> devices don't have BARs, so
> this line is probably the only information about them in dmesg.
It certainly appears that this is the only line about them in dmesg.

>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>>
>> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
>> ---
>>   drivers/pci/probe.c |    4 ++--
>>   1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index 9f8a6b7..a1add54 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -1002,8 +1002,8 @@ int pci_setup_device(struct pci_dev *dev)
>>          dev->revision = class & 0xff;
>>          dev->class = class >> 8;                    /* upper 3 bytes */
>>
>> -       dev_printk(KERN_DEBUG, &dev->dev, "[%04x:%04x] type %02x class %#08x\n",
>> -                  dev->vendor, dev->device, dev->hdr_type, dev->class);
>> +       dev_dbg(&dev->dev, "[%04x:%04x] type %02x class %#08x\n",
>> +               dev->vendor, dev->device, dev->hdr_type, dev->class);
>>
>>          /* need to have dev->class ready */
>>          dev->cfg_size = pci_cfg_space_size(dev);
>> --
>> 1.6.0.2
>>

