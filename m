Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1JNUzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:55:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23498 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644Ab1JNUzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:55:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Y/4EpaE5tsnN/PJKFyKSRM+gRucOWZ1sNwIUHF3smHVznXnSTz0r/H5cKNOGa45tF
	uRahzKpKX9Sq9VtMJmTlw==
MIME-Version: 1.0
In-Reply-To: <4E989E07.6030404@oracle.com>
References: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
 <20111014042737.23504.46601.stgit@bhelgaas.mtv.corp.google.com>
 <4E97C8F0.7030108@oracle.com> <CAErSpo568q-KOk25RaaZ+=erLEEC4rsPwGNy0drCbqpCLKGybQ@mail.gmail.com>
 <4E989E07.6030404@oracle.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 14 Oct 2011 14:54:46 -0600
Message-ID: <CAErSpo4629XKU=TNp0cb6Cxc+Jm_dQcD4244eTna2TC49_EtTw@mail.gmail.com>
Subject: Re: [PATCH v2 06/29] x86/PCI: convert to pci_create_root_bus() and pci_scan_root_bus()
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 2:39 PM, Yinghai Lu <yinghai.lu@oracle.com> wrote:
> On 10/14/2011 01:32 PM, Bjorn Helgaas wrote:
>
>
>>>>       int node;
>>>> @@ -353,11 +349,18 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_pci_root *root)
>>>>               memcpy(bus->sysdata, sd, sizeof(*sd));
>>>>               kfree(sd);
>>>>       } else {
>>>> -             bus = pci_create_bus(NULL, busnum, &pci_root_ops, sd);
>>>> -             if (bus) {
>>>> -                     get_current_resources(device, busnum, domain, bus);
>>>> -                     bus->subordinate = pci_scan_child_bus(bus);
>>>> +             INIT_LIST_HEAD(&resources);
>>>> +             get_current_resources(device, busnum, domain, &resources);
>>>> +             if (!pci_use_crs) {
>>>> +                     pci_free_resource_list(&resources);
>>>> +                     x86_pci_root_bus_resources(busnum, &resources);
>>>>               }
>>>
>>>
>>> You may need to update get_current_resources() to return status about handling _CRS...
>>> and check that status insteaf of !pci_use_crs.
>>
>> Is the current patch broken here?  I don't think it will be simpler to
>> have get_current_resources() return a status and check that.  But if
>> something's actually broken, I want to fix it, of course.
>>
>
>
> yes. if for some reason, _CRS is not handled right, that root bus resources will not get set to default res.
>
> +             status = get_current_resources(device, busnum, domain, &resources);
> +             if (status) {
> +                     pci_free_resource_list(&resources);
> +                     x86_pci_root_bus_resources(busnum, &resources);
>              }
>
> get_current_resources() will not return 0 if _CRS is not really used.

OK.  I think it was that way before, too.  We created the bus with
default resources, but the first thing get_current_resources() did was
clear them all out.  If there was a problem parsing _CRS, we never
went back and put the defaults back in.

But I think this will do what you suggest and is nicer than what I had before:

                INIT_LIST_HEAD(&resources);
                get_current_resources(device, busnum, domain, &resources);
                if (list_empty(&resources))
                        x86_pci_root_bus_resources(busnum, &resources);
