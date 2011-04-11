Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1DKHTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:19:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab1DKHTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:19:42 -0400
Message-ID: <4DA2AB80.5070209@redhat.com>
Date: Mon, 11 Apr 2011 08:19:28 +0100
From: Niels de Vos <ndevos@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Jiri Kosina <jkosina@suse.cz>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers/parport/parport_pc.c: Convert release_resource
 to release_region/release_mem_region
References: <1300814123-25314-2-git-send-email-julia@diku.dk>
In-Reply-To: <1300814123-25314-2-git-send-email-julia@diku.dk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 05:15 PM, Julia Lawall wrote:
> Request_region should be used with release_region, not
> release_resource.
> 
> base_res is also dropped because it is no longer needed.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,E;
> @@
> *x = request_region(...)
> ... when != release_region(x)
>     when != x = E
> * release_resource(x);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> In the original code, the second argument of request_region is 32 and the
> second argument of the following release_region is 0x8.  I have thus used
> 0x8 as the second argument of the call to release_region introduced to
> replace the call to release_resource.  But shouldn't the second arguments
> of all of the functions be the same?

Yes, they should. The size of the requested region was changed with
commit e7c310c36e5fdf1b83a459e5db167bfbd86137db, but one occurrence of
release_region() was not changed accordingly.


>  drivers/parport/parport_pc.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
> index 8d62fb7..320a4df 100644
> --- a/drivers/parport/parport_pc.c
> +++ b/drivers/parport/parport_pc.c
> @@ -2550,7 +2550,6 @@ static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
>  					 const struct parport_pc_via_data *via)
>  {
>  	short inta_addr[6] = { 0x2A0, 0x2C0, 0x220, 0x240, 0x1E0 };
> -	struct resource *base_res;
>  	u32 ite8872set;
>  	u32 ite8872_lpt, ite8872_lpthi;
>  	u8 ite8872_irq, type;
> @@ -2561,8 +2560,7 @@ static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
>  
>  	/* make sure which one chip */
>  	for (i = 0; i < 5; i++) {
> -		base_res = request_region(inta_addr[i], 32, "it887x");
> -		if (base_res) {
> +		if (request_region(inta_addr[i], 32, "it887x")) {
>  			int test;
>  			pci_write_config_dword(pdev, 0x60,
>  						0xe5000000 | inta_addr[i]);
> @@ -2635,7 +2633,7 @@ static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
>  	/*
>  	 * Release the resource so that parport_pc_probe_port can get it.
>  	 */
> -	release_resource(base_res);
> +	release_region(inta_addr[i], 0x8);

0x8 is not the correct size, this should be 32. As there is an other
occurance already, I'll post an updated patch in a bit.

>  	if (parport_pc_probe_port(ite8872_lpt, ite8872_lpthi,
>  				   irq, PARPORT_DMA_NONE, &pdev->dev, 0)) {
>  		printk(KERN_INFO
> 

-- 
Niels de Vos, RHCE
Senior Technical Support Engineer
Global Support Services
Red Hat UK, Ltd.
