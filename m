Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1BOAyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 19:54:37 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:10078 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab1BOAyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 19:54:35 -0500
Subject: Re: cx23885-input.c does in fact use a workqueue....
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, stoth@kernellabs.com
In-Reply-To: <20110214110339.GC18742@htj.dyndns.org>
References: <1297647322.19186.61.camel@localhost>
	 <20110214043355.GA28090@core.coreip.homeip.net>
	 <20110214110339.GC18742@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 19:54:36 -0500
Message-ID: <1297731276.2394.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-02-14_08:2011-02-14,2011-02-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1102140164
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 12:03 +0100, Tejun Heo wrote:
> Hello,
> 
> On Sun, Feb 13, 2011 at 08:33:55PM -0800, Dmitry Torokhov wrote:
> > > The cx23885 driver does in fact schedule work for IR input handling:
> > > 
> > > Here's where it is scheduled for CX23888 chips:
> > > 
> > > http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-ir.c;h=7125247dd25558678c823ee3262675570c9aa630;hb=HEAD#l76
> > > 
> > > Here's where it is scheduled for CX23885 chips:
> > > 
> > > http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-core.c;h=359882419b7f588b7c698dbcfb6a39ddb1603301;hb=HEAD#l1861
> 
> Ah, sorry about missing those.

There's a lot of indirection in drivers under drivers/media/video so it
doesn't surprise me when someone misses something.

(BTW, I only checked cx23885 since I wrote the IR handling and added the
work queue usage for IR that driver.)



> > > So what should be done about the flush_scheduled_work()?  I think it
> > > belongs there.
> > > 
> > 
> > Convert to using threaded irq?

Too big of a regression testing job for me to take on at the moment.


> Or
> 
> 1. Just flush the work items explicitly using flush_work_sync().

That will do for now.

> 2. Create a dedicated workqueue to serve as flushing domain.

I have gotten reports of the IR Rx FIFO overflows for the CX23885 IR Rx
unit (the I2C connected one).  I eventually should either set the Rx
FIFO service interrupt watermark down from 4 measurments to 1
measurment, or use a kthread_worker with some higher priority to respond
to the IR Rx FIFO service interrupt. 



> The first would look like the following.  Does this look correct?

Yes, your patch below looks sane to me.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

Thanks,
Andy

> Thanks.
> 
> diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
> index 199b996..e27cedb 100644
> --- a/drivers/media/video/cx23885/cx23885-input.c
> +++ b/drivers/media/video/cx23885/cx23885-input.c
> @@ -229,6 +229,9 @@ static void cx23885_input_ir_stop(struct cx23885_dev *dev)
>  		v4l2_subdev_call(dev->sd_ir, ir, rx_s_parameters, &params);
>  		v4l2_subdev_call(dev->sd_ir, ir, rx_g_parameters, &params);
>  	}
> +	flush_work_sync(&dev->cx25840_work);
> +	flush_work_sync(&dev->ir_rx_work);
> +	flush_work_sync(&dev->ir_tx_work);
>  }
>  
>  static void cx23885_input_ir_close(struct rc_dev *rc)
> 


