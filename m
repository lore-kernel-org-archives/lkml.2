Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab1AUBWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 20:22:06 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48469 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1AUBWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 20:22:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jCUgiVHmr63el8fvYNBnDpLO8+OTSpo5BlxNbRDIyIPPorUIUVZ72JvhWFxEnV98P/
         V2/wQcpebYUYGryDbrQpM8RefG1v5LtrBw3T6ptEv+ySbovIVPRBl9y5eVTBJQ3+BH//
         vxj5EItHedEWGmdHm6Cs1f4O+czHGSSNfN0wE=
MIME-Version: 1.0
In-Reply-To: <20110120010006.GB10069@ram-laptop>
References: <20101006225834.GE2945@ram-laptop>
	<201101181352.08013.bjorn.helgaas@hp.com>
	<20110118214253.GA10069@ram-laptop>
	<201101181511.16343.bjorn.helgaas@hp.com>
	<20110119195815.GD9274@ram-laptop>
	<20110120010006.GB10069@ram-laptop>
Date: Thu, 20 Jan 2011 17:22:02 -0800
X-Google-Sender-Auth: vael9GOcfB_Xtiz4RA_4BiAcSV8
Message-ID: <AANLkTikaSs6eN9hC=S+qrg26LrrMSpKcbsYz9HNOHWJi@mail.gmail.com>
Subject: Re: [PATCH 1/1 v4] PCI: allocate essential resources before reserving
 hotplug resources
From: Yinghai Lu <yinghai@kernel.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        peter.henriksson@gmail.com, ebiederm@aristanetworks.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 5:00 PM, Ram Pai <linuxram@us.ibm.com> wrote:
>    PCI: pre-allocate additional resources to devices only after successful
>            allocation of essential resources.
>
>    Linux tries to pre-allocate minimal resources to hotplug bridges. This
>    works fine as long as there are enough resources  to satisfy all other
>    genuine resource requirements. However if enough resources are not
>    available to satisfy any of these nice-to-have pre-allocations, the
>    resource-allocator reports errors and returns failure.
>
>    This patch distinguishes between must-have resource from nice-to-have
>    resource.  Any failure to allocate nice-to-have resources are ignored.
>
>    This behavior can be particularly useful to trigger automatic
>    reallocation when the OS discovers genuine allocation-conflicts
>    or genuine unallocated-requests caused by buggy allocation behavior
>    of the native BIOS/uEFI.
>
>    https://bugzilla.kernel.org/show_bug.cgi?id=15960 captures the movitation
>    behind the patch.
>
>    changelog v2:  o  fixed a bug where pci_assign_resource() was called on a
>                      resource of zero resource size.
>
>    changelog v3:  addressed Bjorn's comment
>               o  "Please don't indent and right-justify the changelog".
>               o  removed add_size from struct resource.  The additional
>                  size is now tracked using a linked list.
>
>    changelog v4:  o moved freeing up of elements of head list from
>                  assign_requested_resources_sorted() to
>                __assign_resources_sorted(). This fixes a corruption bug.
>               o removed a wrong reference to 'add_size' in
>                   pbus_size_mem(). Erroneously got introduced while
>                   generating the patch.
>               o some code optimizations in adjust_resources_sorted()
>                   and assign_requested_resources_sorted()
>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
>
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 66cb8f4..efbdff2 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -33,11 +33,23 @@ struct resource_list_x {
>        struct pci_dev *dev;
>        resource_size_t start;
>        resource_size_t end;
> +       resource_size_t add_size;
>        unsigned long flags;
>  };
>
> -static void add_to_failed_list(struct resource_list_x *head,
> -                                struct pci_dev *dev, struct resource *res)
> +#define free_list(type, head) do {                      \
> +       struct type *list, *tmp;                        \
> +       for (list = (head)->next; list;) {              \
> +               tmp = list;                             \
> +               list = list->next;                      \
> +               kfree(tmp);                             \
> +       }                                               \
> +       (head)->next = NULL;                            \
> +} while (0)

inline function should be better?

Yinghai
