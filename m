Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab0JLDCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 23:02:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56840 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab0JLDCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 23:02:17 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=dU4oYfqrBGYmSCmYf2cRsBX-Pf6A9X9N0YaZA@mail.gmail.com>
References: <1d3f23371002091921m7f47a1fbt1cf7fd2ef0a927fa@mail.gmail.com>
	<AANLkTi=dU4oYfqrBGYmSCmYf2cRsBX-Pf6A9X9N0YaZA@mail.gmail.com>
Date: Tue, 12 Oct 2010 13:02:16 +1000
Message-ID: <AANLkTimAKXb=iRGOZKDOcELBdNhrDs8pd_yLMt1MD10Y@mail.gmail.com>
Subject: Re: PPC: Possible bug in prom_parse.c:of_irq_map_raw?
From: John Williams <john.williams@petalogix.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Michal Simek <michal.simek@petalogix.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Fri, Oct 8, 2010 at 4:34 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Reaching way back into the past....

Indeed

> John, did you ever solve your issue here?  Comments below.

The fix in our case was to explicitly add child nodes to the PCI
controller, with interrupt-parent and interrupts properties. The
product in question had a fixed set of devices on the PCI bus, so this
was not a problem.

So, it's not really resolved so much as avoided.

Other comments below:

>> Perhaps this is my misunderstanding, but I'm looking at the bit of
>> code in of_irq_map_raw() that iterates the interrupt-map DTS node,
>> which I am seeing to behave strangely when handling the interrupt-map
>> property on a PCI bridge node.
>>
>> Early in the function, we get the #address-cells value from the node -
>> in this case the PCI bridge, and store it in local var addrsize:
>>
>>        /* Look for this #address-cells. We have to implement the old linux
>>         * trick of looking for the parent here as some device-trees rely on it
>>         */
>>        old = of_node_get(ipar);
>>        do {
>>                tmp = of_get_property(old, "#address-cells", NULL);
>>                tnode = of_get_parent(old);
>>                of_node_put(old);
>>                old = tnode;
>>        } while(old && tmp == NULL);
>>        of_node_put(old);
>>        old = NULL;
>>        addrsize = (tmp == NULL) ? 2 : *tmp;
>>
>>        DBG(" -> addrsize=%d\n", addrsize);
>>
>>
>> Later, once we've found the interrupt-map and are iterating over it
>> attempting to match on PCI device addresses, there is this little
>> fragment:
>>
>>                        /* Get the interrupt parent */
>>                        if (of_irq_workarounds & OF_IMAP_NO_PHANDLE)
>>                                newpar = of_node_get(of_irq_dflt_pic);
>>                        else
>>                                newpar =
>> of_find_node_by_phandle((phandle)*imap);
>>                        imap++;
>>                        --imaplen;
>>
>>                        /* Check if not found */
>>                        if (newpar == NULL) {
>>                                DBG(" -> imap parent not found !\n");
>>                                goto fail;
>>                        }
>>
>>                        /* Get #interrupt-cells and #address-cells of new
>>                         * parent
>>                         */
>>                        tmp = of_get_property(newpar, "#interrupt-cells", NULL);
>>                        if (tmp == NULL) {
>>                                DBG(" -> parent lacks #interrupt-cells !\n");
>>                                goto fail;
>>                        }
>>                        newintsize = *tmp;
>>                        tmp = of_get_property(newpar, "#address-cells", NULL);
>>                        newaddrsize = (tmp == NULL) ? 0 : *tmp;
>>
>> Finally, later in the loop we update addrsize=newaddrsize
>>
>> As I read this code, and the behaviour I'm seeing, is that if the
>> interrupt controller parent device doesn't have an #address-cells
>> entry, then this get_property will return fail, therefore setting
>> newaddrsize  to zero.  This then means that subsequent match attempts
>> when iterating the interrupt-map always fail, because the match length
>> (addrsize) is 0.
>
> Correct.  The interrupt-map property contains the following fields:
>
> child-unit-address child-irq irq-controller irq-parent-unit-address parent-irq
>
> In the *vast majority* of cases, the irq-parent-unit-address is a
> zero-length field because #address-cells isn't present on the
> interrupt controller parent.  So effectively interrupt-map becomes:
>
> child-unit-address child-irq irq-controller parent-irq
>
> See epapr 1.0 for a full discussion
>
>>
>> Maybe I'm missing something here, but shouldn't this last bit of code
>> instead be:
>>
>>                        tmp = of_get_property(newpar, "#address-cells", NULL);
>>                        newaddrsize = (tmp == NULL) ? addrsize : *tmp;
>>
>>  ^^^^^^^^^
>> ?
>>
>> In other words, if the parent node has an #address-cells value, then
>> use it, otherwise stick to the #address-cells value we picked up for
>> the actual node in question (ie the PCI bridge).
>
> No, because at this point we absolutely do want to know how big the
> parent #address-cells is, and if it is missing, we need to use 0.  If
> the child's addrsize continued to be used, then the interrupt-map
> parsing would get unaligned.
>
> The inner loop is over the entries in interrupt-map.  addrsize and
> intsize are only updated in the case where a match is found in the
> table.  If a match isn't found, then it should bail out to the 'fail'
> label.
>
>> The way this is manifesting itself in the system I'm looking at is
>> that only the PCI device matching the first entry in the PCI bridge
>> interrupt-map property is correctly matching. For PCI devices that
>> require more than one pass through the interrupt-map loop, addrsize
>> goes to zero and no further match is possible.
>
> Something sounds fishy.  If you're still having problems, can you
> enable #define DEBUG in drivers/of/irq.c and post the output?

OK, this may take me a lilttle while as the test system is in storage!

Thanks,

John
