Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab2K0BAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:00:33 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:55998 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2K0BAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:00:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com>
 <20121126224245.248f0901@neptune.home> <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 26 Nov 2012 18:00:09 -0700
Message-ID: <CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com>
Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
 bug question
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, support@supermicro.com,
        linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Try Dan's current email address; sorry Dan]

On Mon, Nov 26, 2012 at 5:56 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Dan]
>
> On Mon, Nov 26, 2012 at 2:42 PM, Bruno Prémont
> <bonbons@linux-vserver.org> wrote:
>> Hi Justin,
>>
>> On Sat, 24 November 2012 "Justin Piszcz" wrote:
>>> Is the following normal on an X9SRL-F board (bios 1.0a)?
>>>
>>> In the manual it states:
>>>
>>> Data Direct I/O
>>> Select Enabled to enable Intel I/OAT (I/O Acceleration Technology), which
>>> significantly reduces CPU overhead by leveraging CPU architectural
>>> improvements and freeing the system resource for other tasks. The options
>>> are Disabled and Enabled.
>>>
>>> Default is Enabled.
>>>
>>> When enabled in the kernel, I see the following:
>>>
>>> [    0.696357] ioatdma: Intel(R) QuickData Technology Driver 4.00
>>> [    0.696487] ioatdma 0000:00:04.0: channel error register unreachable
>>> [    0.696546] ioatdma 0000:00:04.0: channel enumeration error
>>> [    0.696604] ioatdma 0000:00:04.0: Intel(R) I/OAT DMA Engine init failed
>>> [    0.696721] ioatdma 0000:00:04.1: channel error register unreachable
>>> [    0.696779] ioatdma 0000:00:04.1: channel enumeration error
>>> [    0.697522] ioatdma 0000:00:04.1: Intel(R) I/OAT DMA Engine init failed
>>> [    0.697617] ioatdma 0000:00:04.2: channel error register unreachable
>>> [    0.697681] ioatdma 0000:00:04.2: channel enumeration error
>>> [    0.697739] ioatdma 0000:00:04.2: Intel(R) I/OAT DMA Engine init failed
>>> [    0.697831] ioatdma 0000:00:04.3: channel error register unreachable
>>> [    0.697890] ioatdma 0000:00:04.3: channel enumeration error
>>> [    0.697948] ioatdma 0000:00:04.3: Intel(R) I/OAT DMA Engine init failed
>>> [    0.698037] ioatdma 0000:00:04.4: channel error register unreachable
>>> [    0.698095] ioatdma 0000:00:04.4: channel enumeration error
>>> [    0.698153] ioatdma 0000:00:04.4: Intel(R) I/OAT DMA Engine init failed
>>> [    0.698245] ioatdma 0000:00:04.5: channel error register unreachable
>>> [    0.698303] ioatdma 0000:00:04.5: channel enumeration error
>>> [    0.698360] ioatdma 0000:00:04.5: Intel(R) I/OAT DMA Engine init failed
>>> [    0.698449] ioatdma 0000:00:04.6: channel error register unreachable
>>> [    0.698508] ioatdma 0000:00:04.6: channel enumeration error
>>> [    0.698565] ioatdma 0000:00:04.6: Intel(R) I/OAT DMA Engine init failed
>>> [    0.698676] ioatdma 0000:00:04.7: channel error register unreachable
>>> [    0.698735] ioatdma 0000:00:04.7: channel enumeration error
>>> [    0.698792] ioatdma 0000:00:04.7: Intel(R) I/OAT DMA Engine init failed
>>>
>>> --
>>>
>>> Also, I tried using ASPM (enabled in BIOS), but since ACPI Linux query is
>>> ignored, it fails to work:
>>> [    0.562229] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
>>>
>>> I assume this is something Supermicro has to fix?
>>
>> You are probably missing some kernel config option(s) :) - I did fight similar
>> issues on a Fujitsu SandyBridge Xeon based server.
>>
>> Check if enabling CONFIG_X86_X2APIC helps as well as other APIC/IOMMU options.
>
> Changing config options is not a valid fix for error messages like
> this.  We should be able to make the config smarter by adding
> dependencies or something, or else make the driver smart enough to
> give a more useful diagnostic.
>
> The "channel error register unreachable" message indicates that
> pci_read_config_dword() failed.  The register in question
> (IOAT_PCI_CHANERR_INT_OFFSET) is at 0x180, so possibly we don't have
> PCI config accessors for the extended config space (0x100-0xfff).  A
> complete dmesg log should show that.
