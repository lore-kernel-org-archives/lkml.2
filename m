Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab2IKXff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:35:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53795 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759039Ab2IKXfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:35:33 -0400
MIME-Version: 1.0
In-Reply-To: <1346800307-11041-1-git-send-email-Jiang.Wang@riverbed.com>
References: <1346800307-11041-1-git-send-email-Jiang.Wang@riverbed.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Sep 2012 17:35:11 -0600
Message-ID: <CAErSpo7vu0uS=06Dr82-LZ3KBzxaje6fV+H=Foi-bD1c6mUcFA@mail.gmail.com>
Subject: Re: [PATCH 1/1] pci-iov: Fix warnings when CONFIG_PCI_IOV is enabled
To: Jiang Wang <Jiang.Wang@riverbed.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        clala@riverbed.com, Francis.St.Amant@riverbed.com,
        Jiang Wang <jwang@riverbed.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 5:11 PM, Jiang Wang <Jiang.Wang@riverbed.com> wrote:
> When CONFIG_PCI_IOV is enabled, the kernel will call sriov_init().
> This function tries to allocate virtual resources even if the
> virtual function of a PCI devive is not enabled by the BIOS.
>
> This sometimes causes following warning messages during boot up:
> pci 0000:02:00.0: BAR 9: can't allocate mem resource [0x000000-0x3fffff]
> pci 0000:02:00.0: BAR 7: can't allocate mem resource [0x000000-0x03ffff]
>
> Tested on three Mitac motherboards.
>
> Signed-off-by: Jiang Wang <jwang@riverbed.com>
> ---
>  drivers/pci/iov.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
> index 6554e1a..0ca8cb2 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -441,7 +441,8 @@ static int sriov_init(struct pci_dev *dev, int pos)
>         if (ctrl & PCI_SRIOV_CTRL_VFE) {
>                 pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, 0);
>                 ssleep(1);
> -       }
> +       } else
> +               return 0;

But this would mean that Linux can't *ever* enable VFs unless the BIOS
enabled them, right?  I don't think that's what we want -- there's
code in sriov_enable() to turn on VFE, assuming we have enough
resources for the VFs.

It's certainly possible that the BIOS didn't allocate large enough
apertures in the bridges leading to the SR-IOV device to accommodate
all the VFs, and Linux may not be smart enough to enlarge them.  And
probably our warning messages in that case are not very enlightening.

Bjorn

>         pci_read_config_word(dev, pos + PCI_SRIOV_TOTAL_VF, &total);
>         if (!total)
> --
> 1.7.1
>
