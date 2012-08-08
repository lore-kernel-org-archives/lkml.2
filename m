Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab2HHPuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:50:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab2HHPuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:50:19 -0400
Message-ID: <50228AA2.1090004@gmail.com>
Date: Wed, 08 Aug 2012 23:49:54 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v1 00/22] introduce PCI bus lock to serialize PCI
 hotplug operations
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com> <50215A5B.2020508@redhat.com>
In-Reply-To: <50215A5B.2020508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 02:11 AM, Don Dutile wrote:
> On 08/07/2012 12:10 PM, Jiang Liu wrote:
>> From: Jiang Liu<liuj97@gmail.com>
>>
>> This is the second take to resolve race conditions when hot-plugging PCI
>> devices/host bridges. Instead of using a globla lock to serialize all hotplug
>> operations as in previous version, now we introduce a state machine and bit
>> lock mechanism for PCI buses to serialize hotplug operations. For discussions
>> related to previous version, please refer to:
>> http://comments.gmane.org/gmane.linux.kernel.pci/15007
>>
>> This patch-set is still in early stages, so sending it out just requesting
>> for comments. Any comments are welcomed, especially about whether it's the
>> right/suitable way to solve these race condition issues.
>>
>> patch 1-5:
>>     Preparing for coming PCI bus lock
>> patch 6-7:
>>     Core of the new PCI bus lock mechanism.
>> patch 8-13:
>>     Enhance PCI core to support PCI bus lock mechanism.
>> patch 14-18:
>>     Enhance several PCI hotplug drivers to use PCI bus lock to serialize
>>     hotplug operations.
>> patch 19-20:
>>     Enable PCI bus lock mechanism for x86 and IA64, still need to enable
>>     PCI bus lock for other archs.
>> patch 21-22:
>>     Cleanups for unsed code.
>>
>> There are multiple methods to trigger PCI hotplug requests/operations
>> concurrently, such as:
>> 1. Sysfs interfaces exported by the PCI core subsystem
>>     /sys/devices/pcissss:bb/ssss:bb:dd.f/.../remove
>>     /sys/devices/pcissss:bb/ssss:bb:dd.f/.../rescan
>>     /sys/devices/pcissss:bb/ssss:bb:dd.f/.../pci_bus/ssss:bb/rescan
>>     /sys/bus/pci/rescan
>> 2. Sysfs interfaces exported by the PCI hotplug subsystem
>>     /sys/bus/pci/slots/xx/power
>> 3. PCI hotplug events triggered by PCI Hotplug Controllers
>> 4. ACPI hotplug events for PCI host bridges
>> 5. Driver binding/unbinding events
>>     binding/unbinding pci drivers with SR-IOV support
>>
> 6. PCI reset
>    --> a PCIe device-level reset is done by KVM when it assigns a device
>        to a guest.  a PCI config-save before reset, and PCI config-restore after reset
>        is done in this case.
>    --> VF devices are interesting, since they are reset, then bound to
>        pci-stub driver.  when more than 1 VF is enabled in a PF,
>        and several device-assignments are done simultaneously, you
>        get a storm of reset (save/restore pci cfg space), and pci-stub binding
>        (pci cfg read for resource allocation/deallocation), and depending on
>        the hw design: an AER caused by the FLR reset -- not suppose to, but
>        hw has bugs too! ;-)
>    PCI locking is 'challenged' in the above scenario.
> 
>   So, I ask: have you tried your patch set doing something like:
>     a) modprobe an SRIOV device with > 1 vf enabled
>   you may also have to do:
>     b) while assigning another SRIOV device's VF to another KVM guest
> 
> Unfortunately, the PCI cfg-space locking, esp. on x86 (ok, I'll say it:
> damn, mutually exclusive, IO-port-based cfg registers), doesn't lend itself
> to this multi-task, dynamic PCI scenario.
> Much less complicated on linearly-mapped, PCI-mmconf-only accesses.
> 
> - Don
Hi Don,
	Thanks for your comments. Haven't done such tests for SR-IOV yet. We will
try to find some NICs with SR-IOV capability for testing and will send the result
to you once done.
	Regards!
	Gerry

