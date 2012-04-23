Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2DWWeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:34:06 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37495 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab2DWWeD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:34:03 -0400
MIME-Version: 1.0
In-Reply-To: <4F95B67D.7020706@redhat.com>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com>
 <201204152140.40747.rjw@sisk.pl> <CAErSpo4St6zBBz7131Ne3BEHNO8Xcq8sCy3T5HV1F0B1B1u1cg@mail.gmail.com>
 <201204232153.57351.rjw@sisk.pl> <4F95B67D.7020706@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 23 Apr 2012 16:33:41 -0600
Message-ID: <CAErSpo4MRASkhaeTKozFuBRH13koV6=evC5GVAyJ0K222B6=aw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Fix regression in pci_restore_state()
To: Don Dutile <ddutile@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mikko Vinni <mmvinni@yahoo.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 2:07 PM, Don Dutile <ddutile@redhat.com> wrote:
> On 04/23/2012 03:53 PM, Rafael J. Wysocki wrote:
>>
>> On Monday, April 23, 2012, Bjorn Helgaas wrote:
>>>
>>> On Sun, Apr 15, 2012 at 1:40 PM, Rafael J. Wysocki<rjw@sisk.pl>  wrote:
>>>>
>>>> On Sunday, April 15, 2012, Linus Torvalds wrote:
>>>>>
>>>>> On Sun, Apr 15, 2012 at 11:47 AM, Rafael J. Wysocki<rjw@sisk.pl>
>>>>>  wrote:
>>>>>>
>>>>>>
>>>>>> mdelay(10) doesn't really look good either to me in this case, though.
>>>>>
>>>>>
>>>>> Oh, I agree. What kind of ass-backwards device actually needs that
>>>>> kind of crazy delays? It is almost certainly buggy.
>>>>>
>>>>> With retries, 10ms delays are totally unacceptable. There's something
>>>>> wrong.
>>>>>
>>>>> A single ms *may* be ok.
>>>>>
>>>>> Anyway, can you also split the actual "write _one_ register with
>>>>> retry" into a function of its own? The code looks like crap with those
>>>>> multiple levels of looping, with conditionals inside them etc. With a
>>>>> simple helper function, you could change the break into return, and it
>>>>> would look much better, I bet.
>>>>
>>>>
>>>> Sure.  It appears cleaner this way.
>>>>
>>>> ---
>>>> From: Rafael J. Wysocki<rjw@sisk.pl>
>>>> Subject: PCI: Fix regression in pci_restore_state(), v3
>>>>
>>>> Commit 26f41062f28de65e11d3cf353e52d0be73442be1
>>>>
>>>>    PCI: check for pci bar restore completion and retry
>>>>
>>>> attempted to address problems with PCI BAR restoration on systems
>>>> where FLR had not been completed before pci_restore_state() was
>>>> called, but it did that in an utterly wrong way.
>>>>
>>>> First off, instead of retrying the writes for the BAR registers
>>>> only, it did that for all of the PCI config space of the device,
>>>> including the status register (whose value after the write quite
>>>> obviously need not be the same as the written one).  Second, it
>>>> added arbitrary delay to pci_restore_state() even for systems
>>>> where the PCI config space restoration was successful at first
>>>> attempt.  Finally, the mdelay(10) it added to every iteration of the
>>>> writing loop was way too much of a delay for any reasonable device.
>>>>
>>>> All of this actually caused resume failures for some devices on
>>>> the Mikko's system.
>>>>
>>>> To fix the regression, make pci_restore_state() only retry the
>>>> writes for BAR registers and only wait if the first read from
>>>> the register doesn't return the written value.  Additionaly, make
>>>> it wait for 1 ms, instead of 10 ms, after every failing attempt
>>>> to write into config space.
>>>>
>>>> Reported-by: Mikko Vinni<mmvinni@yahoo.com>
>>>> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
>>>> ---
>>>>  drivers/pci/pci.c |   57
>>>> ++++++++++++++++++++++++++++++++++++------------------
>>>>  1 file changed, 39 insertions(+), 18 deletions(-)
>>>>
>>>> Index: linux/drivers/pci/pci.c
>>>> ===================================================================
>>>> --- linux.orig/drivers/pci/pci.c
>>>> +++ linux/drivers/pci/pci.c
>>>> @@ -967,16 +967,47 @@ pci_save_state(struct pci_dev *dev)
>>>>        return 0;
>>>>  }
>>>>
>>>> +static void pci_restore_config_dword(struct pci_dev *pdev, int offset,
>>>> +                                    u32 saved_val, int retry)
>>>> +{
>>>> +       u32 val;
>>>> +
>>>> +       pci_read_config_dword(pdev, offset,&val);
>>>> +       if (val == saved_val)
>>>> +               return;
>>>> +
>>>> +       for (;;) {
>>>> +               dev_dbg(&pdev->dev, "restoring config space at offset "
>>>> +                       "%#x (was %#x, writing %#x)\n", offset, val,
>>>> saved_val);
>>>> +               pci_write_config_dword(pdev, offset, saved_val);
>>>> +               if (retry--<= 0)
>>>> +                       return;
>>>> +
>>>> +               pci_read_config_dword(pdev, offset,&val);
>>>> +               if (val == saved_val)
>>>> +                       return;
>>>> +
>>>> +               mdelay(1);
>>>> +       }
>>>> +}
>>>> +
>>>> +static void pci_restore_config_space(struct pci_dev *pdev, int start,
>>>> int end,
>>>> +                                    int retry)
>>>> +{
>>>> +       int index;
>>>> +
>>>> +       for (index = end; index>= start; index--)
>>>> +               pci_restore_config_dword(pdev, 4 * index,
>>>> +
>>>>  pdev->saved_config_space[index],
>>>> +                                        retry);
>>>> +}
>>>> +
>>>>  /**
>>>>  * pci_restore_state - Restore the saved state of a PCI device
>>>>  * @dev: - PCI device that we're dealing with
>>>>  */
>>>>  void pci_restore_state(struct pci_dev *dev)
>>>>  {
>>>> -       int i;
>>>> -       u32 val;
>>>> -       int tries;
>>>> -
>>>>        if (!dev->state_saved)
>>>>                return;
>>>>
>>>> @@ -984,24 +1015,14 @@ void pci_restore_state(struct pci_dev *d
>>>>        pci_restore_pcie_state(dev);
>>>>        pci_restore_ats_state(dev);
>>>>
>>>> +       pci_restore_config_space(dev, 10, 15, 0);
>>>>        /*
>>>>         * The Base Address register should be programmed before the
>>>> command
>>>>         * register(s)
>>>>         */
>>>> -       for (i = 15; i>= 0; i--) {
>>>> -               pci_read_config_dword(dev, i * 4,&val);
>>>> -               tries = 10;
>>>> -               while (tries&&  val != dev->saved_config_space[i]) {
>>>>
>>>> -                       dev_dbg(&dev->dev, "restoring config "
>>>> -                               "space at offset %#x (was %#x, writing
>>>> %#x)\n",
>>>> -                               i, val,
>>>> (int)dev->saved_config_space[i]);
>>>> -                       pci_write_config_dword(dev,i * 4,
>>>> -                               dev->saved_config_space[i]);
>>>> -                       pci_read_config_dword(dev, i * 4,&val);
>>>> -                       mdelay(10);
>>>> -                       tries--;
>>>> -               }
>>>> -       }
>>>> +       pci_restore_config_space(dev, 4, 9, 10);
>>>> +       pci_restore_config_space(dev, 0, 3, 0);
>>>> +
>>>>        pci_restore_pcix_state(dev);
>>>>        pci_restore_msi_state(dev);
>>>>        pci_restore_iov_state(dev);
>>>
>>>
>>> I'd feel better about this if there were a way to delay in the FLR
>>> path instead.  If we delay in the restore path, we're only fixing one
>>> of the many ways config space can be written.  Other paths that write
>>> config space will just silently fail.
>>>
>>> The PCIe spec (r3.0, sec 6.6.2) mentions waiting for the "pre-FLR
>>> value for Completion Timeout," but I don't see anything that looks
>>> like that in pcie_flr() or pci_af_flr().  Are there any other direct
>>> ways we can detect when the FLR is complete?
>>
>>
>> I'm not aware of any.
>>
>> Thanks,
>> Rafael
>
> I don't think so, either.
> I believe an ECN is being worked in the PCI-SIG
> to add such a notification, though.
> Even if adopted, need to wait for another crank of the hw before
> the notification can be used.

I agree, we can't do something that works only on new hardware -- we
have to make the existing hardware in the field work.

What about the "waiting for as much time as the pre-FLR value for
Completion Timeout" part?

Or can we do something like asserting FLR, sleeping 100ms, then
attempting a write to something in config space and retrying until it
sticks?  It's kludgy, but I'm not sure it's any worse than putting the
retries in the restore path, and it would have the advantage that
other writers of config space wouldn't have to worry.

Bjorn
