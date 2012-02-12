Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab2BLXvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 18:51:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50220 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab2BLXvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 18:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXrFARy4+ynOTRyEuoyRxTc9qqzUaYJH8e19Wt3JRRxug@mail.gmail.com>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org>
 <1328425088-6562-5-git-send-email-yinghai@kernel.org> <CAErSpo6=t1XtdUMBAn7Ag5XNLS3wKueybfrsUzmht6GL9XSGLQ@mail.gmail.com>
 <CAE9FiQXrFARy4+ynOTRyEuoyRxTc9qqzUaYJH8e19Wt3JRRxug@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sun, 12 Feb 2012 15:51:20 -0800
Message-ID: <CAErSpo5_9N-HX3Ja8k04QaS6nss8SAm-NUtuQyHt0t-Dczt8-w@mail.gmail.com>
Subject: Re: [PATCH 04/24] PCI: Add busn_res operation functions
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 12:45 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Feb 6, 2012 at 10:59 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Sat, Feb 4, 2012 at 10:57 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> will use them insert/update busn res in pci_bus
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> ---
>>>  drivers/pci/probe.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/pci.h |    3 +++
>>>  2 files changed, 45 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>>> index a114173..8d4de5e 100644
>>> --- a/drivers/pci/probe.c
>>> +++ b/drivers/pci/probe.c
>>> @@ -1622,6 +1622,48 @@ err_out:
>>>        return NULL;
>>>  }
>>>
>>> +void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
>>> +{
>>> +       struct resource *res = &b->busn_res;
>>> +       struct resource *parent_res = &iobusn_resource;
>>> +       int ret;
>>> +
>>> +       res->start = busn(pci_domain_nr(b), bus);
>>> +       res->end = busn(pci_domain_nr(b), bus_max);
>>> +       res->flags = IORESOURCE_BUS;
>>> +
>>> +       if (!pci_is_root_bus(b))
>>> +               parent_res = &b->parent->busn_res;
>>> +
>>> +       ret = insert_resource(parent_res, res);
>>> +
>>> +       dev_printk(KERN_DEBUG, &b->dev,
>>> +                       "busn_res: %pR %s inserted under %pR\n",
>>> +                       res, ret ? "can not be" : "is", parent_res);
>>> +}
>>> +
>>> +void pci_bus_update_busn_res_end(struct pci_bus *b, int bus_max)
>>> +{
>>> +       struct resource *res = &b->busn_res;
>>> +       struct resource old_res = *res;
>>> +
>>> +       res->end = busn_update_bus_nr(res->end, bus_max);
>>
>> I think this design is a mistake.  Here's what you're doing:
>>
>>  - initialize struct resource (keys are "start" and "end")
>>  - insert into tree (placed in tree by kernel/resource.c based on
>> "start" and "end")
>>  - update "end"
>>
>> You "know" in this case that the update is safe because the caller has
>> validated "bus_max."  But that still breaks the kernel/resource.c
>> encapsulation.  If we change the kernel/resource.c implementation,
>> this code might break.
>
> the point is: I only want to reuse allocate_resource() to get right position.
> and the code does not depends to kernel/resource.c much.
>
>>
>> I think it would be better to remove the bus resource from the tree,
>> change its "end," then re-insert it.
>
> how about parent buses that have extended top?

I don't understand your question.  I assume you mean there's a case
where remove/update/reinsert doesn't work, but I don't see why that
would be a problem.  Can you show an example?
