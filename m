Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2GZWIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 18:08:14 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:55929 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686Ab2GZWIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 18:08:13 -0400
Subject: Re: [PATCH] cx18: Declare MODULE_FIRMWARE usage
From: Andy Walls <awalls@md.metrocast.net>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Date: Thu, 26 Jul 2012 18:07:31 -0400
In-Reply-To: <1343322358-128310-1-git-send-email-tim.gardner@canonical.com>
References: <1343322358-128310-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1343340453.2575.10.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-26_06:2012-07-26,2012-07-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1207260264
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 11:05 -0600, Tim Gardner wrote:
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: ivtv-devel@ivtvdriver.org
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

You missed v4l-cx23418-dig.fw, in cx18-av-firmware.c, which is required
by all CX23418 devices.

You missed dvb-cx18-mpc718-mt352.fw, in cx18-dvb.c, which is only needed
by certain variants of the Yuan MPC-718 mini-PCI card.

In cx18, the dvb-cx18-mpc718-mt352.fw need not exist for all common
CX23418 based cards.  I would not want anything in user space or the
kernel to prevent module load, if this file does not exist.  This
firmware file is especially a pain, since it has to be snipped out of a
Windows driver binary.  Most users will not have it.

Regards,
Andy
> ---
>  drivers/media/video/cx18/cx18-driver.c   |    1 +
>  drivers/media/video/cx18/cx18-firmware.c |   10 ++++++++--
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
> index 7e5ffd6..c67733d 100644
> --- a/drivers/media/video/cx18/cx18-driver.c
> +++ b/drivers/media/video/cx18/cx18-driver.c
> @@ -1357,3 +1357,4 @@ static void __exit module_cleanup(void)
>  
>  module_init(module_start);
>  module_exit(module_cleanup);
> +MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
> diff --git a/drivers/media/video/cx18/cx18-firmware.c b/drivers/media/video/cx18/cx18-firmware.c
> index b85c292..a1c1cec 100644
> --- a/drivers/media/video/cx18/cx18-firmware.c
> +++ b/drivers/media/video/cx18/cx18-firmware.c
> @@ -376,6 +376,9 @@ void cx18_init_memory(struct cx18 *cx)
>  	cx18_write_reg(cx, 0x00000101, CX18_WMB_CLIENT14);  /* AVO */
>  }
>  
> +#define CX18_CPU_FIRMWARE "v4l-cx23418-cpu.fw"
> +#define CX18_APU_FIRMWARE "v4l-cx23418-apu.fw"
> +
>  int cx18_firmware_init(struct cx18 *cx)
>  {
>  	u32 fw_entry_addr;
> @@ -400,7 +403,7 @@ int cx18_firmware_init(struct cx18 *cx)
>  	cx18_sw1_irq_enable(cx, IRQ_CPU_TO_EPU | IRQ_APU_TO_EPU);
>  	cx18_sw2_irq_enable(cx, IRQ_CPU_TO_EPU_ACK | IRQ_APU_TO_EPU_ACK);
>  
> -	sz = load_cpu_fw_direct("v4l-cx23418-cpu.fw", cx->enc_mem, cx);
> +	sz = load_cpu_fw_direct(CX18_CPU_FIRMWARE, cx->enc_mem, cx);
>  	if (sz <= 0)
>  		return sz;
>  
> @@ -408,7 +411,7 @@ int cx18_firmware_init(struct cx18 *cx)
>  	cx18_init_scb(cx);
>  
>  	fw_entry_addr = 0;
> -	sz = load_apu_fw_direct("v4l-cx23418-apu.fw", cx->enc_mem, cx,
> +	sz = load_apu_fw_direct(CX18_APU_FIRMWARE, cx->enc_mem, cx,
>  				&fw_entry_addr);
>  	if (sz <= 0)
>  		return sz;
> @@ -451,3 +454,6 @@ int cx18_firmware_init(struct cx18 *cx)
>  	cx18_write_reg_expect(cx, 0x14001400, 0xc78110, 0x00001400, 0x14001400);
>  	return 0;
>  }
> +
> +MODULE_FIRMWARE(CX18_CPU_FIRMWARE);
> +MODULE_FIRMWARE(CX18_APU_FIRMWARE);


