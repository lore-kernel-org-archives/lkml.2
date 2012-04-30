Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab2D3Wku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 18:40:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58037 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab2D3Wks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 18:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <4F9F0AF3.8060409@fold.natur.cuni.cz>
References: <4F9F02A0.9020207@fold.natur.cuni.cz>
	<4F9F0AF3.8060409@fold.natur.cuni.cz>
Date: Mon, 30 Apr 2012 15:40:48 -0700
X-Google-Sender-Auth: TIOxcTcbxWvsEl1Vl1CO_yrPVvM
Message-ID: <CAE9FiQXuR7QJnvZxS7amXW=Z2e49tgrY6-5dHmq2LR1a+yiVdA@mail.gmail.com>
Subject: Re: linux-3.4-rc5: Oops in klist_del()
From: Yinghai Lu <yinghai@kernel.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: linux-pci@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 2:58 PM, Martin Mokrejs
<mmokrejs@fold.natur.cuni.cz> wrote:
> Martin Mokrejs wrote:
>> Hi,
>>   I was removing an ExpressCard with a NEC chipset used by xhci_hcd and the kernel crashed
>> on my Dell Vostro 3550 laptop. Its express slot chipset somehow does not report properly
>> that a card was unplugged, as discussed earlier here on linux-pci under Subject
>> "Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec timeframe".
>>
>>   Maybe this helps somebody to find the cause? Here is a bit of the attached Oops snapshot
>> stacktrace:
>>
>> klist_del
>> fdevice_del
>> device_unregister
>> pci_stop_bus_device
>> pci_stop_and_remove_bus_device
>> devehp_unconfigure_device
>> pciehp_disable_slot
>> ? pciehp_disable_slot
>> pciehp_power_thread
>> process_one_work
>> worker_thriad
>> ? manage_workers.clone
>> ? manage_workers.clone
>> kthrerd
>> ...
>
> This is 100% reproducible. It happens with 3.4-rc5 and 3.3.4 kernels while not with 3.2.14.
> I did not have the external enclosure earlier but repeated unplugs/re-plugs of the NEC-based
> expresscard were/are just not enough to trigger the Oops. One needs the ASMedia2105 in addition.
>
> To hit the Ooops, the disk has to be *RE-detected* and unplugged (so not its very first plugin).
> Express card removal after the very first plugin says usually something about the surprise
> removal. When I re-plug the disk, it gets detected, and it removal hits the Ooops. I am attaching
> dmesg from 3.2.14 kernel which does not have the problem. You can see how many times I did remove
> and re-plug the card. If I waited long ebough for xhci_hcd to timeout waiting for the unplugged
> device, it says
>
> xhci_hcd 0000:11:00.0: Timeout while waiting for configure endpoint command
> xHCI xhci_drop_endpoint called for root hub
> xHCI xhci_check_bandwidth called for root hub
> xhci_hcd 0000:11:00.0: USB bus 5 deregistered
> xhci_hcd 0000:11:00.0: PCI INT A disabled
>
> and then, subsequent re-plug of the card with the disk attached results in detected SCSI device.
> In contrast, if I re-plug the express card earlier express card slot change is reported but the
> disc is not detected (something is blocked in xhci_hcd I think).
>
> The above stacktrace (of actually the camera snapshot is not the first stacktrace, unfortunately).
> I see there are 2-3 screen scrolled away. Hmm, but I do not have anything what could be used as
> a remote console ...

So if you use "echo 1 > /sys/.../0000:11.00.0/remove" before surprise
remove the card,

the oops would not happen?

Yinghai
