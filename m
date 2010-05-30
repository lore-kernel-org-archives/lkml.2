Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0E3Ota (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 10:49:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49502 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0E3Ot3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 10:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lpQ4tqeLgCN30C2Zh+eQHX1WMbe71gJMRWbaCgHoIrxUATsbkFdEs1H8WEsB4I8Jlz
         qxE1Il/rLHzAnKYMGhzJAc7Hk/FjD7/iJtQZqn6bbk06S+ZIE35rsbSxH2noLlprgbRO
         mYrlsGyYyi5bbN0Dvo2C0TvSqXP64affkV0Ns=
Date: Sun, 30 May 2010 16:52:40 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: schedule inside spin_lock_irqsave?
Message-ID: <20100530145240.GA21559@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

came across following snippet of code (2.6.34:drivers/media/dvb/siano/smscoreapi.c) and 
since prepare_to_wait is new for me I am wondering if this is can work?

struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
{
	struct smscore_buffer_t *cb = NULL;
	unsigned long flags;

	DEFINE_WAIT(wait);

	spin_lock_irqsave(&coredev->bufferslock, flags);

	/* This function must return a valid buffer, since the buffer list is
	 * finite, we check that there is an available buffer, if not, we wait
	 * until such buffer become available.
	 */

	prepare_to_wait(&coredev->buffer_mng_waitq, &wait, TASK_INTERRUPTIBLE);

	if (list_empty(&coredev->buffers))
		schedule();

	finish_wait(&coredev->buffer_mng_waitq, &wait);

	cb = (struct smscore_buffer_t *) coredev->buffers.next;
	list_del(&cb->entry);

	spin_unlock_irqrestore(&coredev->bufferslock, flags);

	return cb;
}

Regards
Richard
