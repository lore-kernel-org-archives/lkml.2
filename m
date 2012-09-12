Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab2ILBN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 21:13:59 -0400
Received: from eng.riverbed.com ([208.70.196.44]:59814 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2ILBN5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 21:13:57 -0400
From: Jiang Wang <Jiang.Wang@riverbed.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chaitanya Lala <Chaitanya.Lala@riverbed.com>,
        "Francis St. Amant" <Francis.St.Amant@riverbed.com>
Subject: RE: [PATCH 1/1] pci-iov: Fix warnings when CONFIG_PCI_IOV is enabled
Thread-Topic: [PATCH 1/1] pci-iov: Fix warnings when CONFIG_PCI_IOV is
 enabled
Thread-Index: AQHNivLYKtyL80WQPkWVU3yhGVwi5ZeGS56A//+P70A=
Date: Wed, 12 Sep 2012 01:13:55 +0000
Message-ID: <CEE05A0D7856E14880AD5560634EBEA834DB8E96@SFO1EXC-MBXP06.nbttech.com>
References: <1346800307-11041-1-git-send-email-Jiang.Wang@riverbed.com>
 <CAErSpo7vu0uS=06Dr82-LZ3KBzxaje6fV+H=Foi-bD1c6mUcFA@mail.gmail.com>
In-Reply-To: <CAErSpo7vu0uS=06Dr82-LZ3KBzxaje6fV+H=Foi-bD1c6mUcFA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.205.254]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Original Message-----
From: Bjorn Helgaas [mailto:bhelgaas@google.com] 
Sent: Tuesday, September 11, 2012 4:35 PM
To: Jiang Wang
Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; Chaitanya Lala; Francis St. Amant; Jiang Wang
Subject: Re: [PATCH 1/1] pci-iov: Fix warnings when CONFIG_PCI_IOV is enabled

On Tue, Sep 4, 2012 at 5:11 PM, Jiang Wang <Jiang.Wang@riverbed.com> wrote:
> When CONFIG_PCI_IOV is enabled, the kernel will call sriov_init().
> This function tries to allocate virtual resources even if the virtual 
> function of a PCI devive is not enabled by the BIOS.
>
> This sometimes causes following warning messages during boot up:
> pci 0000:02:00.0: BAR 9: can't allocate mem resource 
> [0x000000-0x3fffff] pci 0000:02:00.0: BAR 7: can't allocate mem 
> resource [0x000000-0x03ffff]
>
> Tested on three Mitac motherboards.
>
> Signed-off-by: Jiang Wang <jwang@riverbed.com>
> ---
>  drivers/pci/iov.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c index 
> 6554e1a..0ca8cb2 100644
> --- a/drivers/pci/iov.c
> +++ b/drivers/pci/iov.c
> @@ -441,7 +441,8 @@ static int sriov_init(struct pci_dev *dev, int pos)
>         if (ctrl & PCI_SRIOV_CTRL_VFE) {
>                 pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, 0);
>                 ssleep(1);
> -       }
> +       } else
> +               return 0;

But this would mean that Linux can't *ever* enable VFs unless the BIOS enabled them, right?  I don't think that's what we want -- there's code in sriov_enable() to turn on VFE, assuming we have enough resources for the VFs.

--- I see. I didn't find the code in sriov_enable() before I send out the patch. Thanks for the info.

It's certainly possible that the BIOS didn't allocate large enough apertures in the bridges leading to the SR-IOV device to accommodate all the VFs, and Linux may not be smart enough to enlarge them.  And probably our warning messages in that case are not very enlightening.

---- My purpose here is to remove those warnings. I also tried to disable CONFIG_PCI_IOV, but that causes another strange problem on one of machines. The LSI controller cannot get memory resources and 32 LSI controllers shown up even though only one actually exist.
I will drop this patch and do more debug to see what that problem is. Thanks.
 
Bjorn

>         pci_read_config_word(dev, pos + PCI_SRIOV_TOTAL_VF, &total);
>         if (!total)
> --
> 1.7.1
>

Regards,

Jiang
