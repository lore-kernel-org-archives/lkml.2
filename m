Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab1JRRAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:00:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:60998 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab1JRRAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:00:42 -0400
Message-ID: <4E9DB11A.7030505@oracle.com>
Date: Tue, 18 Oct 2011 10:02:18 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101215 CentOS/3.1.7-4 Lightning/1.0b2 OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/LAF_1309888596830-328557394 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] pci: Make sriov work with hotplug removal
References: <4E9A3092.4080309@oracle.com> <4E9A3408.9080905@oracle.com> <CAErSpo5XdM+1OFmoU+rN_QNWCJ0Wzv1VwKxsTo9hTq=2=7KEHA@mail.gmail.com> <4E9C6F0E.40501@oracle.com> <CAErSpo7ofdVixyGR74_mc6ND5C3LROiR9PVzwNZaDe23ptJ2=Q@mail.gmail.com> <4E9CAB21.2020302@oracle.com> <CAErSpo4PLDfapndXJp-sXS-SJtv0a7PaD=UKX0HV0OV34an3kQ@mail.gmail.com>
In-Reply-To: <CAErSpo4PLDfapndXJp-sXS-SJtv0a7PaD=UKX0HV0OV34an3kQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E9DB0B9.0022:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2011 09:49 AM, Bjorn Helgaas wrote:
> On Mon, Oct 17, 2011 at 4:24 PM, Yinghai Lu<yinghai.lu@oracle.com>  wrote:
>> On 10/17/2011 03:12 PM, Bjorn Helgaas wrote:
>>>
>>> Maybe this is the best we can do, but it still doesn't seem ideal, and
>>> it's certainly not obvious when reading the code.  It doesn't seem
>>> right for the driver ->remove() method to be calling
>>> pci_destroy_dev().   Won't the core data structures be corrupted if a
>>> defective driver doesn't call pci_disable_sriov()?  Seems like we
>>> could end up with a device that's been physically removed, but still
>>> has pci_dev structs hanging around.
>>
>> i did add some print out in
>>         pci_stop_bus_device
>> when stop PF, that function is called for those VFs.
>>
>> also driver have to call pci_disable_sriov() and that is current design.
>
> Yep.  But I don't have to like the current design :)  It doesn't seem
> as robust as it could be.
>
> It took me a long time to puzzle out what was happening here.  Here's
> some possible changelog text that would have saved me a lot of time:
>
>      The PCI hot-remove path calls pci_stop_bus_devices() via
>      pci_remove_bus_device().
>
>      pci_stop_bus_devices() traverses the bus->devices list (point A below),
>      stopping each device in turn, which calls the driver remove() method.  When
>      the device is an SR-IOV PF, the driver calls pci_disable_sriov(), which
>      also uses pci_remove_bus_device() to remove the VF devices from the
>      bus->devices list (point B).
>
>          pci_remove_bus_device
>            pci_stop_bus_device
>              pci_stop_bus_devices(subordinate)
>                list_for_each(bus->devices)<-- A
>                  pci_stop_bus_device(PF)
>                    ...
>                      driver->remove
>                        pci_disable_sriov
>                          ...
>                            pci_remove_bus_device(VF)
>                                <remove from bus_list>   <-- B
>
>      At B, we're changing the same list we're iterating through at A, so when
>      the driver remove() method returns, the pci_stop_bus_devices() iterator has
>      a pointer to a list entry that has already been freed.
>
>      This patch avoids the problem by building a separate list of all PFs on
>      the bus and traversing that at A instead of the bus->devices list.

yes.
