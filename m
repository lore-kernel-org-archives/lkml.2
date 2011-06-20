Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab1FTQiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:38:23 -0400
Received: from mx1.melware.net ([78.47.171.162]:38928 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab1FTQiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:38:22 -0400
Date: Mon, 20 Jun 2011 18:38:20 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: Map PCI resource to user space problem.
In-Reply-To: <alpine.DEB.2.00.1106201132170.14886@justus.melware.de>
Message-ID: <alpine.DEB.2.00.1106201830260.17005@justus.melware.de>
References: <alpine.DEB.2.00.1106201132170.14886@justus.melware.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Armin Schindler wrote:
> Hello,
>
> when I try to map PCI resource of size < PAGE_SIZE to user space
> with e.g. remap_pfn_range() the mapping seems to be created,
> but the access to the PCI device just doesn't work (read returns 0xff).
>
> The same happens when using sysfs. The device has
> # ls -al /sys/bus/pci/devices/0000\:02\:09.0/resource*
> -rw------- 1 root root     512 Jun 20 11:33 
> /sys/bus/pci/devices/0000:02:09.0/resource0
> -rw------- 1 root root     256 Jun 20 11:33 
> /sys/bus/pci/devices/0000:02:09.0/resource1
> -rw------- 1 root root 8388608 Jun 20 11:33 
> /sys/bus/pci/devices/0000:02:09.0/resource2
> -rw------- 1 root root  262144 Jun 20 11:33 
> /sys/bus/pci/devices/0000:02:09.0/resource3
>
> and when I mmap() resource0, a valid address is returned, but reading the 
> area always returns 0xff.
>
> Since a kernel driver can access resource0 here without problems when using
> ioremap(), I'm not sure what is wrong with the sysfs entry for user space
> (or using remap_pfn_range() in own mmap function).
> The only hint I have so far is the size, which is smaller than PAGE_SIZE.

I found the reason. It is not the size of the resource.
The resource0 is assigned to a not page-aligned address.
Example, the pci resource0 has address 0xfe5ffc00. mmap()ing it will
actually seems to map address 0xfe5ff000 and the user needs to add 0xc00 to 
the address returned by mmap().

Armin

