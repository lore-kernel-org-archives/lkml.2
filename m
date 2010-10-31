Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0JaCy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 22:54:26 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51425 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab0JaCyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 22:54:24 -0400
MIME-Version: 1.0
In-Reply-To: <20101030063237.GC2456@angua.secretlab.ca>
References: <1288227827-5447-1-git-send-email-ddaney@caviumnetworks.com> <20101030063237.GC2456@angua.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 30 Oct 2010 22:54:03 -0400
X-Google-Sender-Auth: ex8Q8GWngSMSh6looT5NHTVQUF4
Message-ID: <AANLkTi=24H4RNonXu=i3CHhYqbLniDya+BKnj_evw_p6@mail.gmail.com>
Subject: Re: [PATCH] of: of_mdio: Fix some endianness problems.
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 2:32 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Wed, Oct 27, 2010 at 06:03:47PM -0700, David Daney wrote:
>> In of_mdiobus_register(), the __be32 *addr variable is dereferenced.
>> This will not work on little-endian targets.  Also since it is
>> unsigned, checking for less than zero is redundant.
>>
>> Fix these two issues.
>>
>> Signed-off-by: David Daney <ddaney@caviumnetworks.com>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Dan Carpenter <error27@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> ---
>>  drivers/of/of_mdio.c |   23 ++++++++++++++---------
>>  1 files changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
>> index 1fce00e..b370306 100644
>> --- a/drivers/of/of_mdio.c
>> +++ b/drivers/of/of_mdio.c
>> @@ -52,27 +52,32 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>>
>>       /* Loop over the child nodes and register a phy_device for each one */
>>       for_each_child_of_node(np, child) {
>> -             const __be32 *addr;
>> +             const __be32 *paddr;
>> +             u32 addr;
>>               int len;
>>
>>               /* A PHY must have a reg property in the range [0-31] */
>> -             addr = of_get_property(child, "reg", &len);
>> -             if (!addr || len < sizeof(*addr) || *addr >= 32 || *addr < 0) {
>> +             paddr = of_get_property(child, "reg", &len);
>> +             if (!paddr || len < sizeof(*paddr)) {
>> +addr_err:
>>                       dev_err(&mdio->dev, "%s has invalid PHY address\n",
>>                               child->full_name);
>>                       continue;
>>               }
>> +             addr = be32_to_cpup(paddr);
>> +             if (addr >= 32)
>> +                     goto addr_err;
>
> goto's are fine for jumping to the end of a function to unwind
> allocations, but please don't use it in this manner.  The original
> structure will actually work just fine if you do it thusly:
>
>                if (!paddr || len < sizeof(*paddr) ||
>                    *(addr = be32_to_cpup(paddr)) >= 32) {
>                        dev_err(&mdio->dev, "%s has invalid PHY address\n",
>                                child->full_name);
>                        continue;
>                }
>
> Otherwise this patch looks good. After you've reworked and retested
> I'll pick it up for 2.6.37 (or dave will).

Actually, I mistyped this.  I think it should be:

               if (!paddr || len < sizeof(*paddr) ||
                   (addr = be32_to_cpup(paddr)) >= 32) {
                       dev_err(&mdio->dev, "%s has invalid PHY address\n",
                               child->full_name);
                       continue;
               }

g.
