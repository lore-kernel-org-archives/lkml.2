Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2IJUoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:44:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47331 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2IJUox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:44:53 -0400
MIME-Version: 1.0
In-Reply-To: <1347305801-7712-1-git-send-email-jslaby@suse.cz>
References: <1347305801-7712-1-git-send-email-jslaby@suse.cz>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Sep 2012 14:44:32 -0600
Message-ID: <CAErSpo4+zvG-MmQ2V2QNKjx=mX+nLpqZNj5niJkG4f22XqYZNg@mail.gmail.com>
Subject: Re: [PATCH 1/1] PCI: fix on-stack pci_device_id's
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Feng Tang <feng.tang@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 1:36 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> Commit "PCI: Use pci_device_id on stack for pci_get_subsys/class() to
> avoid kmalloc" changed heap allocations to on-stack variables, but it
> did not add initialization of other than set members. This causes
> random failures during bootup wherever pci device is needed to be
> found. Hence the boot just hangs or panics.
>
> This patches fixes it by setting the content of pci_device_id directly
> in the initializer.

Nice!  I fixed this already by adding a memset(), but I like your way
better.  I knew we could initialize members of a structure on the
stack, but I didn't know C guaranteed that uninitialized members would
be implicitly initialized also.  But apparently it does:

http://stackoverflow.com/questions/10828294/c-and-c-partial-initialization-of-automatic-structure

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  drivers/pci/search.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 00d486a..bf969ba 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -243,12 +243,12 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
>                                unsigned int ss_vendor, unsigned int ss_device,
>                                struct pci_dev *from)
>  {
> -       struct pci_device_id id;
> -
> -       id.vendor = vendor;
> -       id.device = device;
> -       id.subvendor = ss_vendor;
> -       id.subdevice = ss_device;
> +       struct pci_device_id id = {
> +               .vendor = vendor,
> +               .device = device,
> +               .subvendor = ss_vendor,
> +               .subdevice = ss_device,
> +       };
>
>         return pci_get_dev_by_id(&id, from);
>  }
> @@ -289,11 +289,14 @@ pci_get_device(unsigned int vendor, unsigned int device, struct pci_dev *from)
>   */
>  struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from)
>  {
> -       struct pci_device_id id;
> -
> -       id.vendor = id.device = id.subvendor = id.subdevice = PCI_ANY_ID;
> -       id.class_mask = PCI_ANY_ID;
> -       id.class = class;
> +       struct pci_device_id id = {
> +               .vendor = PCI_ANY_ID,
> +               .device = PCI_ANY_ID,
> +               .subvendor = PCI_ANY_ID,
> +               .subdevice = PCI_ANY_ID,
> +               .class_mask = PCI_ANY_ID,
> +               .class = class,
> +       };
>
>         return pci_get_dev_by_id(&id, from);
>  }
> --
> 1.7.11.5
>
>
