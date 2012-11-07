Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2KGXAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 18:00:43 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37362 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2KGXAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 18:00:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6+dnxjCaqE=hiYUfDTKi3SCg0SYfuoHVuCse6_nG1mEA@mail.gmail.com>
References: <1347994314.9011.1.camel@joe2Laptop> <CAErSpo6+dnxjCaqE=hiYUfDTKi3SCg0SYfuoHVuCse6_nG1mEA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 7 Nov 2012 16:00:19 -0700
Message-ID: <CAErSpo4ESkfXEEv9USu5kEP+oTWvLV+Ke+g8AUoF6ifJV7cc-g@mail.gmail.com>
Subject: Re: [PATCH] pci: Convert pci_resource_<foo> macros to static inlines
To: Joe Perches <joe@perches.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 3:28 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Sep 18, 2012 at 12:51 PM, Joe Perches <joe@perches.com> wrote:
>> Get the compiler to verify the argument type of struct pci_dev *.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>
> I applied this to my pci/misc branch as v3.8 material.  Thanks!

I dropped this for now because of these build failures:

drivers/staging/telephony/ixj.c: In function 'ixj_probe_pci':
drivers/staging/telephony/ixj.c:7732:13: warning: assignment makes
integer from pointer without a cast [enabled by default]
drivers/staging/telephony/ixj.c:7732:38: error: expected ';' before
'pci_resource_start'
drivers/scsi/gdth.c: In function 'gdth_init_pci':
drivers/scsi/gdth.c:1111:34: error: lvalue required as left operand of
assignment

I posted a fix for the gdth.c problem, and ixj.c is apparently being
deleted.  When those happen, we can try again.

Bjorn

>> ---
>>
>> Another possible improvement is to range check index.
>>
>>  include/linux/pci.h |   36 ++++++++++++++++++++++++++----------
>>  1 files changed, 26 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 5faa831..971d0e9 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -1396,16 +1396,32 @@ static inline struct pci_dev *pci_dev_get(struct pci_dev *dev)
>>
>>  /* these helpers provide future and backwards compatibility
>>   * for accessing popular PCI BAR info */
>> -#define pci_resource_start(dev, bar)   ((dev)->resource[(bar)].start)
>> -#define pci_resource_end(dev, bar)     ((dev)->resource[(bar)].end)
>> -#define pci_resource_flags(dev, bar)   ((dev)->resource[(bar)].flags)
>> -#define pci_resource_len(dev,bar) \
>> -       ((pci_resource_start((dev), (bar)) == 0 &&      \
>> -         pci_resource_end((dev), (bar)) ==             \
>> -         pci_resource_start((dev), (bar))) ? 0 :       \
>> -                                                       \
>> -        (pci_resource_end((dev), (bar)) -              \
>> -         pci_resource_start((dev), (bar)) + 1))
>> +static inline resource_size_t
>> +pci_resource_start(const struct pci_dev *dev, int index)
>> +{
>> +       return dev->resource[index].start;
>> +}
>> +
>> +static inline resource_size_t
>> +pci_resource_end(const struct pci_dev *dev, int index)
>> +{
>> +       return dev->resource[index].end;
>> +}
>> +
>> +static inline unsigned long
>> +pci_resource_flags(const struct pci_dev *dev, int index)
>> +{
>> +       return dev->resource[index].flags;
>> +}
>> +
>> +static inline resource_size_t
>> +pci_resource_len(const struct pci_dev *dev, int index)
>> +{
>> +       if (pci_resource_start(dev, index) == 0 &&
>> +           pci_resource_end(dev, index) == 0)
>> +               return 0;
>> +       return resource_size(&dev->resource[index]);
>> +}
>>
>>  /* Similar to the helpers above, these manipulate per-pci_dev
>>   * driver-specific data.  They are really just a wrapper around
>>
>>
>>
