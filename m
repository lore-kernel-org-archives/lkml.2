Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965194Ab1JFRdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:33:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965106Ab1JFRdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:33:45 -0400
Message-ID: <4E8DDBF8.6080905@redhat.com>
Date: Thu, 06 Oct 2011 17:48:56 +0100
From: Niels de Vos <ndevos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Krahn <krahn@niehs.nih.gov>,
        Andrew Morton <akpm@google.com>, Rich.Liu@ite.com.tw,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parport_pc: release IO region properly if unsupported
 ITE887x card is found
References: <alpine.LNX.2.00.1110061654280.31654@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1110061654280.31654@pobox.suse.cz>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 04:38 PM, Jiri Kosina wrote:
> sio_ite_8872_probe() bails out if it detects no-parallel (1S, 2S) or unknown
> card.
> 
> It doesn't call release_region() on the previously allocated resource though.
> This causes
> 
>   (a) leak of the resource
>   (b) kernel oops when parport module is removed and /proc/ioports is read. This
>       is because the string that has been associated to the IO port region
>       is a static char array inside the already removed module.
> 
> Let's call release_region() properly before baling out.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/parport/parport_pc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
> index d1cdb94..d0b597b 100644
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -2595,14 +2595,17 @@ static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
>  		break;
>  	case 0x6:
>  		printk(KERN_INFO "parport_pc: ITE8873 found (1S)\n");
> +		release_region(inta_addr[i], 32);
>  		return 0;
>  	case 0x8:
>  		printk(KERN_INFO "parport_pc: ITE8874 found (2S)\n");
> +		release_region(inta_addr[i], 32);
>  		return 0;
>  	default:
>  		printk(KERN_INFO "parport_pc: unknown ITE887x\n");
>  		printk(KERN_INFO "parport_pc: please mail 'lspci -nvv' "
>  			"output to Rich.Liu@ite.com.tw\n");
> +		release_region(inta_addr[i], 32);
>  		return 0;
>  	}
>  

Looks good to me, now release_region() is now consistent through the
whole of sio_ite_8872_probe().

Also verified that this is not an issue in drivers/tty/serial/8250_pci.c
where a similar logic for the same chip is used.

Acked-by: Niels de Vos <ndevos@redhat.com>
