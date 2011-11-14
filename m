Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1KNRrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:47:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63307 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab1KNRrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:47:43 -0500
MIME-Version: 1.0
In-Reply-To: <20111111094509.0de1c139@jbarnes-desktop>
References: <20111110004339.5866.28478.stgit@amt.stowe>
	<20111110004351.5866.40960.stgit@amt.stowe>
	<20111111094509.0de1c139@jbarnes-desktop>
Date: Mon, 14 Nov 2011 10:47:42 -0700
Message-ID: <CAL-B5D3kHX5mysVQk+btD2VSsNi=3E17s1b0fNDD7USyBfG6nw@mail.gmail.com>
Subject: Re: [PATCH 2/3] PCI: Maintain a list of FW-assigned BIOS BAR values
From: Myron Stowe <myron.stowe@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        bhelgaas@google.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 10:45 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 09 Nov 2011 17:43:51 -0700
> Myron Stowe <myron.stowe@redhat.com> wrote:
>
>> From: Myron Stowe <mstowe@redhat.com>
>>
>> Commit 58c84eda075 introduced functionality to try and reinstate the
>> original BIOS BAR addresses of a PCI device when normal resource
>> assignment attempts fail.  To keep track of the BIOS BAR addresses,
>> struct pci_dev was augmented with an array to hold the BAR addresses
>> of the PCI device: 'resource_size_t fw_addr[DEVICE_COUNT_RESOURCE]'.
>>
>> The reinstatement of BAR addresses is an uncommon event leaving the
>> 'fw_addr' array unused normally.  As the use of struct pci_dev is so
>> prevalent, this seems wasteful.
>>
>> This patch introduces a stand alone data structure and corresponding set
>> of interfacing routines for maintaining a list of FW-assigned BIOS BAR
>> value temporary entries.
>>
>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>> ---
>>
>>  drivers/pci/setup-res.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/pci.h     |    1 +
>>  2 files changed, 74 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
>> index ad8c4ae..ab45c11 100644
>> --- a/drivers/pci/setup-res.c
>> +++ b/drivers/pci/setup-res.c
>> @@ -26,6 +26,79 @@
>>  #include "pci.h"
>>
>>
>> +/*
>> + * This list of dynamic mappings is for temporarly maintaining
>> + * original BIOS BAR addresses for possbile reinstatement.
>> + */
>> +struct pci_fwaddrmap {
>> +     struct list_head list;
>> +     struct pci_dev *dev;
>> +     resource_size_t fw_addr[DEVICE_COUNT_RESOURCE];
>> +     unsigned long refcount;
>> +};
>> +
>> +static LIST_HEAD(pci_fwaddrmappings);
>> +static DEFINE_SPINLOCK(pci_fwaddrmap_lock);
>
> Is the refcounting really needed?  Can't we just free the whole list at
> some point to simplify things a bit?

No, refcounting is not absolutely necessary, it's just the approach I came
up with initially.  I'll look into just freeing the entire list once we are done
with it.

Myron
>
> --
> Jesse Barnes, Intel Open Source Technology Center
>
