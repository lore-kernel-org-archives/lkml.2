Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab2GLANR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:13:17 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60608 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab2GLANE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:13:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo49u=NP0MwY6AVPJJC0YqvDmo092cbV4DzTT10m4jPHSA@mail.gmail.com>
References: <1340222160.77018.19.camel@localhost.localdomain>
	<1340322477.56127.2.camel@localhost.localdomain>
	<CAErSpo7AWQCofnTRhtMKVP3pm_BDq9v+axGpide0RbmignsV9A@mail.gmail.com>
	<1340657687.36341.178.camel@localhost.localdomain>
	<CAErSpo49u=NP0MwY6AVPJJC0YqvDmo092cbV4DzTT10m4jPHSA@mail.gmail.com>
Date: Wed, 11 Jul 2012 17:13:04 -0700
X-Google-Sender-Auth: ZLbU2noXAMFlVIJTtZpKNha7jeg
Message-ID: <CAE9FiQXtsKomU3U=+HNB8K+6L1btJLtuV7S04K=T-PcQomdxJg@mail.gmail.com>
Subject: Re: [PATCH] pci: support alignments upto 8Gb in pbus_size_mem()
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Nikhil P Rao <nikhil.rao@intel.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 3:53 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Jun 25, 2012 at 2:54 PM, Nikhil P Rao <nikhil.rao@intel.com> wrote:
>> On Sat, 2012-06-23 at 12:15 -0600, Bjorn Helgaas wrote:
>>> On Thu, Jun 21, 2012 at 5:47 PM, Nikhil P Rao <nikhil.rao@intel.com> wrote:
>>> > I ran into the "disabling BAR .." error message when
>>> > trying to use a 8Gb PCIe card on a system with a BIOS
>>> > that didnt have support for BAR size > 2Gb.
>>>
>>> So the BIOS left the 8Gb BAR unassigned, and you got the "disabling
>>> BAR ... (bad alignment)" message when Linux tried to enable it?
>>
>> Yes.
>>
>>> How do we know 8Gb is the correct new limit?  Are we going to be
>>> fixing this again when we see a 16Gb or a 32Gb BAR?  Do we need a
>>> better algorithm that doesn't have a limit like this?
>>>
>>
>> The original error message seems applicable to 32bit archs. and not to
>> 64 bit archs. How about the patch below - is aligns[44] (256bytes more)
>> acceptable ?
>>
>>
>> From: Nikhil P Rao <nikhil.rao@intel.com>
>> Date: Mon, 25 Jun 2012 13:33:55 -0700
>> Subject: [PATCH] pci: fix resource size check
>>
>> Support a PCI BAR alignment of > 2Gb, the original check was
>> only applicable to 32 bit kernels,
>>
>> Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
>> ---
>>  drivers/pci/setup-bus.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index 8fa2d4b..9f8d9ea 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -780,7 +780,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>>  {
>>         struct pci_dev *dev;
>>         resource_size_t min_align, align, size, size0, size1;
>> -       resource_size_t aligns[12];     /* Alignments from 1Mb to 2Gb */
>> +       resource_size_t aligns[44];     /* Alignments from 1Mb to 2^63 */
>>         int order, max_order;
>>         struct resource *b_res = find_free_bus_resource(bus, type);
>>         unsigned int mem64_mask = 0;
>> @@ -819,7 +819,8 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>>                         /* For bridges size != alignment */
>>                         align = pci_resource_alignment(dev, r);
>>                         order = __ffs(align) - 20;
>> -                       if (order > 11) {
>> +                       if ((sizeof(size_t) == 4 && order > 11) ||
>> +                                       (sizeof(size_t) == 8 && order > 43)) {
>>                                 dev_warn(&dev->dev, "disabling BAR %d: %pR "
>>                                          "(bad alignment %#llx)\n", i, r,
>>                                          (unsigned long long) align);
>
> Yinghai, what's your opinion on this?  The aligns[] array on the stack
> is currently 96 bytes and would grow to 352 with this patch, which
> does seem like quite a bit.
>
> I do think the 2GB limit here is out-of-date.

yeah,  should be ok.

only thing that sanity checking is not complete enough, for example,
for bar that only support 32bit, we will have get range for under 4g.
that will still need 2g limitation to fend off some bad
devices.

Thanks

Yinghai
