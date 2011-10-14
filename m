Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab1JNUjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:39:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:52330 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab1JNUjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:39:49 -0400
Message-ID: <4E989E07.6030404@oracle.com>
Date: Fri, 14 Oct 2011 13:39:35 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH v2 06/29] x86/PCI: convert to pci_create_root_bus() and
 pci_scan_root_bus()
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com> <20111014042737.23504.46601.stgit@bhelgaas.mtv.corp.google.com> <4E97C8F0.7030108@oracle.com> <CAErSpo568q-KOk25RaaZ+=erLEEC4rsPwGNy0drCbqpCLKGybQ@mail.gmail.com>
In-Reply-To: <CAErSpo568q-KOk25RaaZ+=erLEEC4rsPwGNy0drCbqpCLKGybQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E989E13.0155:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 01:32 PM, Bjorn Helgaas wrote:


>>>       int node;
>>> @@ -353,11 +349,18 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
>>>               memcpy(bus->sysdata, sd, sizeof(*sd));
>>>               kfree(sd);
>>>       } else {
>>> -             bus = pci_create_bus(NULL, busnum, &pci_root_ops, sd);
>>> -             if (bus) {
>>> -                     get_current_resources(device, busnum, domain, bus);
>>> -                     bus->subordinate = pci_scan_child_bus(bus);
>>> +             INIT_LIST_HEAD(&resources);
>>> +             get_current_resources(device, busnum, domain, &resources);
>>> +             if (!pci_use_crs) {
>>> +                     pci_free_resource_list(&resources);
>>> +                     x86_pci_root_bus_resources(busnum, &resources);
>>>               }
>>
>>
>> You may need to update get_current_resources() to return status about handling _CRS...
>> and check that status insteaf of !pci_use_crs.
> 
> Is the current patch broken here?  I don't think it will be simpler to
> have get_current_resources() return a status and check that.  But if
> something's actually broken, I want to fix it, of course.
> 


yes. if for some reason, _CRS is not handled right, that root bus resources will not get set to default res.

+             status = get_current_resources(device, busnum, domain, &resources);
+             if (status) {
+                     pci_free_resource_list(&resources);
+                     x86_pci_root_bus_resources(busnum, &resources);
              }

get_current_resources() will not return 0 if _CRS is not really used.

Thanks

	Yinghai
