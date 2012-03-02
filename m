Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab2CBRSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:18:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59185 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2CBRSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:18:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.112.23.66 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <4F50FE1B.7090008@intel.com>
References: <4f50b540.6AzyOmpHR+z7jLk1%tadeusz.struk@intel.com>
 <CAErSpo6JaNXvJf_KEkRUYLed8ET4vSunfCAq9BWq3yd3+dZQpA@mail.gmail.com> <4F50FE1B.7090008@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 2 Mar 2012 10:17:53 -0700
Message-ID: <CAErSpo6QzCy7cgN8boXu4zhGhTbjEG7RyJ6avaVKL_u=vGMOUw@mail.gmail.com>
Subject: Re: [PATCH v2] Dynamically add and remove device specific reset functions
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 10:06 AM, Tadeusz Struk <tadeusz.struk@intel.com> wrote:
> On 02/03/12 16:29, Bjorn Helgaas wrote:
>> Where do you plan to add calls to pci_dev_specific_reset_add()?  In
>> drivers?
>
> Yes, I'm working on a driver for a device with SRIOV capability.
> I'll call it from there.
>
>> Did you consider adding a "reset" function pointer to struct
>> pci_driver?  That might be more natural -- the reset function is right
>> with all the other code that knows about the device, and there's no
>> issue with looking up the correct reset function.
>> With this patch, we sort of have two different ways to map
>> vendor/device IDs to code: the usual pci_register_driver() approach,
>> and this one using reset_list.  If pci_driver had a "reset" pointer,
>> that would be used most of the time.  You might still need the
>> reset_list for generic things, e.g., the reset_intel_generic_dev()
>> function, but it would be a fallback.  It might look something like:
>>
>>     struct pci_driver *drv = dev->driver;
>>
>>     if (drv && drv->reset) {
>>         drv->reset(dev);
>>         return;
>>     }
>>
>>     list_for_each_entry(i, &reset_list, list) {
>>         ...
>
> No, I didn't think about it.
> This is good idea, but for me the pci_dev_specific_reset() works fine.

I know your patch works fine, but I think we should have the
discussion about whether adding a struct pci_driver pointer is a
better long-term solution.

Greg, Jesse, others, chime in if you have any thoughts.

Bjorn
