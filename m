Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0FBHpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:45:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58850 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab0FBHp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WNL8F62T+KtkZC3tVFSeVfbd0jM4ZbEurmTM1fEkAmRYk8IEq1JMgrIM14bhfQzsQT
         5Gwu9fZiPHtU3Aw1vtE56mI20XcJ2nlOTFBh5/bhx6CCTCxtNUkLchACtkwCvpCbZVx6
         1R0Jg/O9oRrFpYvFbhlBPBhaV5j2ZIBpZhe5c=
Date: Wed, 2 Jun 2010 00:45:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Long playing threaded interrupt handlers
Message-ID: <20100602074520.GI3713@core.coreip.homeip.net>
References: <20100602070922.GC3713@core.coreip.homeip.net>
 <alpine.LFD.2.00.1006020913310.2933@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006020913310.2933@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 09:19:21AM +0200, Thomas Gleixner wrote:
> On Wed, 2 Jun 2010, Dmitry Torokhov wrote:
> 
> > HI Thomas,
> > 
> > The threaded IRQ infrastructure that went into the kernel is extremely
> > helpful, however in the input land there are quite a few devices that
> > require polling after an IRQ has been raised.
> > 
> > Currently most such drivers, instead of threaded interrupts, still use
> > [delayed] work to do the polling, and still face the issue of shutting
> > down interrupt and scheduled work in a raceless way leaving irq enable
> > counter balanced. Is it allowed to have threaded ISR execute for
> > extended a amount of time, and do the required polling, provided that
> > ISR does certain checks to finish promply in case when we unbind the
> > driver or try to suspend the device?
> 
> Sure, why not ?

Great, that is what I wanted to hear!

> The only thing we need to think about is when the poll
> is busy polling for a long time, then we need to lower the irq thread
> priority to SCHED_OTHER in order not to hog the CPU.

I don't think the drivers will actively polling for a long time, they
are likely to poll and then sleep for some time (100-200-300 msecs), so
typical loop will be:

handler()
{
	while (!shutdown_or_suspend) {
		poll_device();

		if (all_up)
			break;

		msleep(poll_interval);
	}

	return IRQ_HANDLED;
}

Thanks.

-- 
Dmitry
