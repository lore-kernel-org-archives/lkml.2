Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589Ab0E0KGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:06:44 -0400
Received: from forward1.mail.yandex.net ([77.88.46.6]:32813 "EHLO
	forward1.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170Ab0E0KGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:06:43 -0400
From: Sergey Temerkhanov <temerkhanov@yandex.ru>
To: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH][RFC] AIO: always reinitialize iocb->ki_run_list at the end of aio_run_iocb()
Date: Thu, 27 May 2010 14:06:36 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.34-39-desktop; KDE/4.3.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>
References: <201004280251.43430.temerkhanov@yandex.ru> <20100521144739.56c1ce0b.akpm@linux-foundation.org> <x49k4qqa1xg.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49k4qqa1xg.fsf@segfault.boston.devel.redhat.com>
Organization: Cifronic ZAO
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005271406.36489.temerkhanov@yandex.ru>
X-Yandex-TimeMark: 1274954801
X-Yandex-Spam: 1
X-Yandex-Front: smtp1.mail.yandex.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010 23:38:35 Jeff Moyer wrote:
...
> I can vaguely recall discussion surrounding the reference counting of
> cancel methods, but I have no idea what the actual contents of those
> discussions were.  Sorry, my memory has failed me.  Either Zach or
> Suparna might remember better.
> 
> Sergey, the cancellation path, unfortunately, is not well exercised as
> I'm sure you are aware.  As you pointed out, the only implementation of
> a cancel method is the usb gadget interface.  Now, given that they've
> worked fine with the extra put in their cancel method, I'm not sure why
> you can't do the same. 
Well, in fact, they have only one aio_put_req() in their cancel method. This 
is the code from 2.6.34:

static int ep_aio_cancel(struct kiocb *iocb, struct io_event *e)
{
	struct kiocb_priv	*priv = iocb->private;
	struct ep_data		*epdata;
	int			value;

	local_irq_disable();
	epdata = priv->epdata;
	// spin_lock(&epdata->dev->lock);
	kiocbSetCancelled(iocb);
	if (likely(epdata && epdata->ep && priv->req))
		value = usb_ep_dequeue (epdata->ep, priv->req);
	else
		value = -EINVAL;
	// spin_unlock(&epdata->dev->lock);
	local_irq_enable();

	aio_put_req(iocb);
	return value;
}

And adding extra aio_put_req() to the cancel method will not fix failing 
kick_iocb() which is another problem and this patch is supposed to address it.

> I'd rather not muddy these waters even further.  Unless there is a
> compelling reason why the patch author cannot do an extra put in his
> cancel method, I'd say that is the best way forward.
> 

This patch is not about reference counting - it's about kick_iocb() failing 
due to NULL values of iocb->ki_run_list.next and iocb->ki_run_list.prev which 
are left after aio_run_iocb().

> Cheers,
> Jeff
> 

-- 
Regards, Sergey Temerkhanov,
Cifronic ZAO
