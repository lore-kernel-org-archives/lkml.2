Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2CZIjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:39:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54673 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2CZIjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:39:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH RESEND] misc: Fix irq leak in max8997_muic_probe error path
Date: Mon, 26 Mar 2012 08:17:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Donggeun Kim <dg77.kim@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Greg Kroah-Hartman" <greg@kroah.com>
References: <1332727028.7078.4.camel@phoenix>
In-Reply-To: <1332727028.7078.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203260817.29733.arnd@arndb.de>
X-Provags-ID: V02:K0:153mAVLqheaPsymC2AYuh6Qhv5k9TCZT7H0XRxlnEzO
 0+vUTRTqMl/bImB+cfNffPMdA+nr+lfYKHFXGjlkcR7XNNIeCh
 cSZgqnhpFSm3FmZ5SNldO0EJrig74uP0mOeOafUt9yPq7uup0t
 Vq/m3y85HFoMd2nMd2r41QtQeGmr39SdCvIutWoXdGjxmFYfDl
 oMZENi+kpGCgewSDPWOcBrjHEH2KAHrkeJhNb7AXXcNNsMsXNA
 JUjyEwKY37xnEcdA9b/QYKOj3vmCb5N2McCobQbcRrhgoetv2V
 gRLqk7TK+8EFcK/FzL92DZlLFgCHuXwqCSplq4dxyq7Dw0OWV2
 ESZWHcBJPO87DfFPg+y4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2012, Axel Lin wrote:
> 
> Current code does not properly free allocated irqs if request_threaded_irq
> returns error, fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

It took me a while to see why this is correct.

Acked-by: Arnd Bergmann <arnd@arndb.de>

Note: It would be nicer to move the dev_err() down into the error path as well
and also fix the message to print the correct irq number, but your patch is
the important part.

Note to the driver maintainers: It looks like there is a race in the 
max8997_muic_irq_handler() function assigning the info->irq member
when multiple interrupts come in at the same time. Also, calling
sched_work from a threaded interrupt handler is pointless. I would suggest
fixing both of these by removing the work function and calling moving
its contents into the interrupt handler directly. Please correct me if I
am missing somehting here.

	Arnd

