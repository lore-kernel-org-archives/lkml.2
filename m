Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2DAQHM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:07:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41660 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752151Ab2DAQHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:07:09 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX18o+5B5ckgo7wsnsj/1K5I6hdu9FkhCCBn4k9cJji
	ngo+BOBmX0ZWUd
Message-ID: <4F787D19.506@gmx.net>
Date: Sun, 01 Apr 2012 18:06:49 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] PNP: Allow resources to be set as disabled
References: <4F68D14B.60409@gmx.net> <4F68E1D3.1060309@gmx.net> <CAErSpo75MV2-XvVQdMrcunFbC+bZvPQXmh5Hzt1ihOOjz2pS0w@mail.gmail.com>
In-Reply-To: <CAErSpo75MV2-XvVQdMrcunFbC+bZvPQXmh5Hzt1ihOOjz2pS0w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/12 22:38, Bjorn Helgaas wrote:

[...]

>> The patch achieves this by doing two things: (1) it allows the strings
>> "disabled" and"<none>" to be used as a valid PNP resource value, and (2) when
>> assigning PNP resources, it copies the flags masked by IORESOURCE_BITS from the
>> resource's templates.
>
> These look like reasonable things to do, but (2) doesn't seem to
> depend on (1), so you might just split them into two patches.

Will do.  Actually, (2) solves a problem that apparently had not been observed 
yet: When *any* PNP resource was set using the "/sys/bus/pnp/*/*/resources" 
interface, the IORESOURCE_BITS were always cleared, which might have been, by 
coincidence, a meaningful value. However, once I started disabling IRQ lines, 
I've seen error messages in the kernel logs (an IRQ's IORESOURCE_BITS are never 
cleared, if I am not mistaken).

[...]

>>
>> If the second part of the patch is not applied, the resource flags are not
>> initialized properly and obscure messages in the kernel log have be seen
>
> s/be/been/

ACK. And will be moved to some other patch.

>
>> ("invalid flags").
>>
>> The patch is applied against Linux 3.3.x.
>>
>>
>> Signed-off-by: Witold Szczeponik<Witold.Szczeponik@gmx.net>
>>
>>
>> Index: linux/drivers/pnp/interface.c
>> ===================================================================
>> --- linux.orig/drivers/pnp/interface.c
>> +++ linux/drivers/pnp/interface.c
>> @@ -311,10 +311,14 @@ static char *pnp_get_resource_value(char
>>         if (flags)
>>                 *flags = 0;
>>
>> -       /* TBD: allow for disabled resources */
>> -
>>         buf = skip_spaces(buf);
>> -       if (start) {
>> +       if (flags&&  !strnicmp(buf, "disabled", 8)) {
>> +               buf += 8;
>> +               *flags |= IORESOURCE_DISABLED;
>> +       } else if (flags&&  !strnicmp(buf, "<none>", 6)) {
>> +               buf += 6;
>> +               *flags |= IORESOURCE_DISABLED;
>
> What's the value in supporting both "disabled" and "<none>"?  Having
> both suggests that they do different things, but it looks like they
> have the same effect.

These two values correspond to the two different ways to report "disabled" 
resources by the kernel: drivers/pnp/interface.c uses "disabled" when 
displaying PNP resources and "<none>" when displaying PNP options.  (Maybe 
the latter should be changed to "disabled", too, but this would be a 
change in the ABI.)

>
>> +       } else if (start) {
>>                 *start = simple_strtoull(buf,&buf, 0);
>>                 if (end) {
>>                         buf = skip_spaces(buf);
>> Index: linux/drivers/pnp/manager.c
>> ===================================================================
>> --- linux.orig/drivers/pnp/manager.c
>> +++ linux/drivers/pnp/manager.c
>> @@ -18,11 +18,27 @@
>>
>>   DEFINE_MUTEX(pnp_res_mutex);
>>
>> +static struct resource *pnp_find_resource(struct pnp_dev *dev,
>> +                                         unsigned char rule,
>> +                                         unsigned long type,
>> +                                         unsigned int bar)
>> +{
>> +       struct resource *res = pnp_get_resource(dev, type, bar);
>> +
>> +       /* when the resource already exists, set its resource bits from rule */
>> +       if (res) {
>> +               res->flags&= ~IORESOURCE_BITS;
>> +               res->flags |= rule&  IORESOURCE_BITS;
>> +       }
>> +
>> +       return res;
>> +}
>> +
>>   static int pnp_assign_port(struct pnp_dev *dev, struct pnp_port *rule, int idx)
>>   {
>>         struct resource *res, local_res;
>>
>> -       res = pnp_get_resource(dev, IORESOURCE_IO, idx);
>> +       res = pnp_find_resource(dev, rule->flags, IORESOURCE_IO, idx);
>>         if (res) {
>>                 pnp_dbg(&dev->dev, "  io %d already set to %#llx-%#llx "
>>                         "flags %#lx\n", idx, (unsigned long long) res->start,
>> @@ -65,7 +81,7 @@ static int pnp_assign_mem(struct pnp_dev
>>   {
>>         struct resource *res, local_res;
>>
>> -       res = pnp_get_resource(dev, IORESOURCE_MEM, idx);
>> +       res = pnp_find_resource(dev, rule->flags, IORESOURCE_MEM, idx);
>>         if (res) {
>>                 pnp_dbg(&dev->dev, "  mem %d already set to %#llx-%#llx "
>>                         "flags %#lx\n", idx, (unsigned long long) res->start,
>> @@ -78,6 +94,7 @@ static int pnp_assign_mem(struct pnp_dev
>>         res->start = 0;
>>         res->end = 0;
>>
>> +       /* ??? rule->flags restricted to 8 bits, all tests bogus ??? */
>>         if (!(rule->flags&  IORESOURCE_MEM_WRITEABLE))
>>                 res->flags |= IORESOURCE_READONLY;
>>         if (rule->flags&  IORESOURCE_MEM_CACHEABLE)
>> @@ -123,7 +140,7 @@ static int pnp_assign_irq(struct pnp_dev
>>                 5, 10, 11, 12, 9, 14, 15, 7, 3, 4, 13, 0, 1, 6, 8, 2
>>         };
>>
>> -       res = pnp_get_resource(dev, IORESOURCE_IRQ, idx);
>> +       res = pnp_find_resource(dev, rule->flags, IORESOURCE_IRQ, idx);
>>         if (res) {
>>                 pnp_dbg(&dev->dev, "  irq %d already set to %d flags %#lx\n",
>>                         idx, (int) res->start, res->flags);
>> @@ -182,7 +199,7 @@ static int pnp_assign_dma(struct pnp_dev
>>                 1, 3, 5, 6, 7, 0, 2, 4
>>         };
>>
>> -       res = pnp_get_resource(dev, IORESOURCE_DMA, idx);
>> +       res = pnp_find_resource(dev, rule->flags, IORESOURCE_DMA, idx);
>>         if (res) {
>>                 pnp_dbg(&dev->dev, "  dma %d already set to %d flags %#lx\n",
>>                         idx, (int) res->start, res->flags);
>>
>
