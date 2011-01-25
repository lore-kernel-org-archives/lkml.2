Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1AYAJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:09:28 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54833 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab1AYAJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:09:27 -0500
Subject: Re: [PATCH 4/4] drivers/staging/lirc: Remove obsolete cleanup for
 clientdata
From: Andy Walls <awalls@md.metrocast.net>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jarod Wilson <jarod@redhat.com>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1295865880-27672-4-git-send-email-w.sang@pengutronix.de>
References: <1295865880-27672-1-git-send-email-w.sang@pengutronix.de>
	 <1295865880-27672-4-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 19:09:02 -0500
Message-ID: <1295914142.2420.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-01-24_10:2011-01-24,2011-01-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1101240172
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 11:44 +0100, Wolfram Sang wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit or error. This is obsolete meanwhile, the core will do it. Simplify the
> kfree() calls after that, the pointers don't need to be checked.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Andy Walls <awalls@md.metrocast.net>

Nak.

In a module where I plan to do more cleanup and add reference counting
to struct IR, IR_tx, and IR_rx objects, I'd like the explicit "NULL"s in
pointer checks to stay in for now.

Removing the explicit constant "NULL" makes searching for checks against
NULL pointers more difficult when auditing the code (No red syntax
highlighting and a /NULL search misses).

Regards,
Andy


> Cc: Jarod Wilson <jarod@redhat.com>
> Cc: Joe Perches <joe@perches.com>
> ---
> 
> Compile tested only.
> 
>  drivers/staging/lirc/lirc_zilog.c |   28 +++++++++-------------------
>  1 files changed, 9 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
> index 3fe5f41..df1055f 100644
> --- a/drivers/staging/lirc/lirc_zilog.c
> +++ b/drivers/staging/lirc/lirc_zilog.c
> @@ -1214,15 +1214,12 @@ static int ir_remove(struct i2c_client *client)
>  
>  	/* Good-bye Rx */
>  	destroy_rx_kthread(ir->rx);
> -	if (ir->rx != NULL) {
> -		if (ir->rx->buf.fifo_initialized)
> -			lirc_buffer_free(&ir->rx->buf);
> -		i2c_set_clientdata(ir->rx->c, NULL);
> -		kfree(ir->rx);
> -	}
> +	if (ir->rx && ir->rx->buf.fifo_initialized)
> +		lirc_buffer_free(&ir->rx->buf);
> +
> +	kfree(ir->rx);
>  
>  	/* Good-bye Tx */
> -	i2c_set_clientdata(ir->tx->c, NULL);
>  	kfree(ir->tx);
>  
>  	/* Good-bye IR */
> @@ -1388,18 +1385,11 @@ out_unregister:
>  out_free_thread:
>  	destroy_rx_kthread(ir->rx);
>  out_free_xx:
> -	if (ir->rx != NULL) {
> -		if (ir->rx->buf.fifo_initialized)
> -			lirc_buffer_free(&ir->rx->buf);
> -		if (ir->rx->c != NULL)
> -			i2c_set_clientdata(ir->rx->c, NULL);
> -		kfree(ir->rx);
> -	}
> -	if (ir->tx != NULL) {
> -		if (ir->tx->c != NULL)
> -			i2c_set_clientdata(ir->tx->c, NULL);
> -		kfree(ir->tx);
> -	}
> +	if (ir->rx && ir->rx->buf.fifo_initialized)
> +		lirc_buffer_free(&ir->rx->buf);
> +
> +	kfree(ir->rx);
> +	kfree(ir->tx);
>  out_free_ir:
>  	del_ir_device(ir);
>  	kfree(ir);


