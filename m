Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2IRWjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 18:39:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35333 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab2IRWj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 18:39:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo54VVFHj4TDA5JELW0LwFVMXjVOJywwFQ4fo4C1rX69mQ@mail.gmail.com>
References: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
	<CAErSpo54VVFHj4TDA5JELW0LwFVMXjVOJywwFQ4fo4C1rX69mQ@mail.gmail.com>
Date: Tue, 18 Sep 2012 15:39:27 -0700
X-Google-Sender-Auth: 7jGvVnH4dCZyN9cJ8_EqLOSJbRc
Message-ID: <CAE9FiQVPHoehcDfVqN-5=Hso0J9vf3+y=3PCz+GncGC5CvvZ4Q@mail.gmail.com>
Subject: Re: [PATCH] PCI, x86: fix default vga ref_count
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 3:15 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Sep 14, 2012 at 6:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> when __ARCH_HAS_VGA_DEFAULT_DEVICE is not defined, aka EFIFB is not used,
>>
>> for static path, vga_default setting is through vga_arbiter_add_pci_device.
>> and for x86 pci_fixup_video, will skip that.
>> because subsys_initcall(vga_arb_device_init) come first to call vga_arbiter_add_pci_device.
>>
>> for hotplug path, even vga_arbiter_add_pci_device is called via notifier, but it
>> will check VGA_RSRC_LEGACY_MASK that is not set for hotplug path.
>> So x86 pci_fixup_video will take over to call vga_set_default_device().
>>
>> We need to hold one dev reference there.
>>
>> otherwise vga_arbiter_del_pci_device that does not check VGA_RSRC_LEGACY_MASK
>> will call put_device and it will cause ref_count to decrease extra.
>> that will have that device get deleted early wrongly.
>
> I'm sure you're fixing a real bug, but this patch is completely unintelligible.

yes, only can hit this bug while remove root bus with vga adapater.

or remove bridge with child pci device that is vga adapter.

for root bus removal, the less one ref_count will call that pci device
get destroyed too early.

>
> I tried to decipher the changelog and I failed.  I tried to figure out
> the PCI reference counting from the vgaarb code, and I failed there
> too.
>
> Apparently the reference is connected with the vga_default device,
> since that's what vga_arbiter_del_pci_device() checks, but
> vga_set_default_device() is blissfully ignorant of references (and it
> isn't used consistently anyway).

yes, could fix vga_set_default_device instead, but it has two versions
- no __ARCH_HAS_VGA_DEFAULT_DEVICE
- EFI version...

also there is one other user for vga switching...

>
> If you can do some rework to make this all make more sense, that would be great.
>
> While you're at it, look at both the x86 and ia64 versions of
> pci_fixup_video().  They are 90% identical, and it's not clear why
> they should be different.  In fact, it's not clear why there's a fixup
> for x86 and ia64 but not for any other architecture with PCI.

ok, will give it a try.

Thanks

Yinghai
