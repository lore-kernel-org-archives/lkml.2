Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2A3Swz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:52:55 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63451 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2A3Swx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:52:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7RsR+2gDJvWic4ta-_SWfUwECaVxRrCVnTFZyFG5RCkw@mail.gmail.com>
References: <1327718971-9598-1-git-send-email-yinghai@kernel.org>
	<1327718971-9598-11-git-send-email-yinghai@kernel.org>
	<CAErSpo7RsR+2gDJvWic4ta-_SWfUwECaVxRrCVnTFZyFG5RCkw@mail.gmail.com>
Date: Mon, 30 Jan 2012 10:52:52 -0800
X-Google-Sender-Auth: 6ZjD1z4NPV05FqSx1P8lsbhepZo
Message-ID: <CAE9FiQU64Ev66D+044m+ZLn+tWSVtnZWXnyaNjkaM+aQD_1CQw@mail.gmail.com>
Subject: Re: [PATCH 10/13] PCI: Strict checking of valid range for bridge
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 8:04 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Jan 27, 2012 at 6:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> children bridges busn range should be able to be allocated from parent bus range.
>>
>> to avoid overlapping between sibling bridges on same bus.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/probe.c |   27 +++++++++++++++++++++++++++
>>  1 files changed, 27 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index 83df3fb..e12f65f0 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -791,6 +791,33 @@ reduce_needed_size:
>>        return ret;
>>  }
>>
>> +static int __devinit pci_bridge_check_busn_res(struct pci_bus *bus,
>> +                               struct pci_dev *dev,
>> +                               int secondary, int subordinate)
>
> This function returns a boolean, but the function name doesn't give
> any clue about what a true/false return means.  Something like
> "busn_valid" would make the callers more readable.

ok

>
>> +{
>> +       int broken = 0;
>> +
>> +       struct resource busn_res;
>> +       int ret;
>> +
>> +       memset(&busn_res, 0, sizeof(struct resource));
>> +       dev_printk(KERN_DEBUG, &dev->dev,
>> +                "check if busn %02x-%02x is in busn_res: %06llx-%06llx\n",
>> +                secondary, subordinate,
>> +                (unsigned long long)bus->busn_res.start,
>> +                (unsigned long long)bus->busn_res.end);
>> +       ret = allocate_resource(&bus->busn_res, &busn_res,
>> +                        (subordinate - secondary + 1),
>> +                        (pci_domain_nr(bus)<<8) | secondary,
>> +                        (pci_domain_nr(bus)<<8) | subordinate,
>
> I think this "(pci_domain_nr(bus)<<8) | secondary" stuff needs to be a
> macro or something.

maybe.
