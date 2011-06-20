Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab1FTQmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:42:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26565 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1FTQmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=blBe9xt/YKZWXTwtgEVVYdXp5STWQ0N0go1Tx3Ni/v9gOv9C+gAePDOmCXQm1vGMYF
         p6uhZHVI3/oshO0xROzQ==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106201830260.17005@justus.melware.de>
References: <alpine.DEB.2.00.1106201132170.14886@justus.melware.de> <alpine.DEB.2.00.1106201830260.17005@justus.melware.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 20 Jun 2011 10:41:38 -0600
Message-ID: <BANLkTim9fBeY3L_+M9B5GECs8QtuAeUrTw@mail.gmail.com>
Subject: Re: Map PCI resource to user space problem.
To: Armin Schindler <armin@melware.de>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+cc linux-pci

On Mon, Jun 20, 2011 at 10:38 AM, Armin Schindler <armin@melware.de> wrote:
> On Mon, 20 Jun 2011, Armin Schindler wrote:
>>
>> Hello,
>>
>> when I try to map PCI resource of size < PAGE_SIZE to user space
>> with e.g. remap_pfn_range() the mapping seems to be created,
>> but the access to the PCI device just doesn't work (read returns 0xff).
>>
>> The same happens when using sysfs. The device has
>> # ls -al /sys/bus/pci/devices/0000\:02\:09.0/resource*
>> -rw------- 1 root root     512 Jun 20 11:33
>> /sys/bus/pci/devices/0000:02:09.0/resource0
>> -rw------- 1 root root     256 Jun 20 11:33
>> /sys/bus/pci/devices/0000:02:09.0/resource1
>> -rw------- 1 root root 8388608 Jun 20 11:33
>> /sys/bus/pci/devices/0000:02:09.0/resource2
>> -rw------- 1 root root  262144 Jun 20 11:33
>> /sys/bus/pci/devices/0000:02:09.0/resource3
>>
>> and when I mmap() resource0, a valid address is returned, but reading the
>> area always returns 0xff.
>>
>> Since a kernel driver can access resource0 here without problems when
>> using
>> ioremap(), I'm not sure what is wrong with the sysfs entry for user space
>> (or using remap_pfn_range() in own mmap function).
>> The only hint I have so far is the size, which is smaller than PAGE_SIZE.
>
> I found the reason. It is not the size of the resource.
> The resource0 is assigned to a not page-aligned address.
> Example, the pci resource0 has address 0xfe5ffc00. mmap()ing it will
> actually seems to map address 0xfe5ff000 and the user needs to add 0xc00 to
> the address returned by mmap().
>
> Armin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
