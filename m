Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab2JDTpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:45:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44967 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2JDTpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:45:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWDnrk7VccFLLHucCVSxN5RRS0-8pwYazLy2aw3oqmPLQ@mail.gmail.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
 <1349305214-3241-1-git-send-email-yinghai@kernel.org> <20121004174746.GA24119@google.com>
 <CAE9FiQWDnrk7VccFLLHucCVSxN5RRS0-8pwYazLy2aw3oqmPLQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 4 Oct 2012 13:44:42 -0600
Message-ID: <CAErSpo48XLzLvziACEi+0nWuRXurHCLnw+iwgqu8-BRutjNtWw@mail.gmail.com>
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 12:36 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Oct 4, 2012 at 10:47 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Wed, Oct 03, 2012 at 04:00:10PM -0700, Yinghai Lu wrote:
>> This is a fundamental difference: at boot-time, all the ACPI devices below the
>> host bridge already exist before the pci_root.c driver claims the bridge,
>> while at hot-add time, pci_root.c claims the bridge *before* those ACPI
>> devices exist.
>>
>> I think this is wrong.  The hot-plug case (where the driver is already
>> loaded and binds to the device as soon as it's discovered, before the
>> ACPI hierarchy below it is enumerated) seems like the obviously correct
>> order.  I think we should change the boot-time order to match that, i.e.,
>> we should register pci_root.c *before* enumerating ACPI devices.
>
> in booting path, all device get probed at first, and then register driver...
> do you want to register all pci driver before probing pci devices?

I don't think we should have dependencies either way.  It shouldn't
matter whether we enumerate devices first or we register the driver
first.  That's why I think the current PCI/ACPI binding is broken --
it assumes that we fully enumerate ACPI before the driver is
registered.

To answer your specific question, yes, I do think drivers that are
statically built in probably should be registered before devices are
enumerated.  That way, the boot-time case is more similar to the
hot-add case.

Obviously, for drivers that can be modules, the reverse must work as
well (enumerate devices, then load and register the driver).  And then
the other order (register driver, then enumerate device) must also
work so future hot-adds of the same device type work.

Bjorn
