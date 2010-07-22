Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab0GVGz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:55:27 -0400
Received: from smtp.nokia.com ([192.100.122.230]:47811 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab0GVGzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:55:25 -0400
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nick Piggin <npiggin@suse.de>, Kristo Tero Tapani <tero.kristo@nokia.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100722031922.GA3446@amd>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
	 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
	 <20100722031922.GA3446@amd>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 09:48:24 +0300
Message-ID: <1279781304.3044.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jul 2010 06:55:15.0673 (UTC) FILETIME=[D6C57C90:01CB296A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Thu, 2010-07-22 at 13:19 +1000, Nick Piggin wrote:
> >  out:
> >  	spin_unlock(&inode_lock);
> > +
> > +	if (wakeup_bdi) {
> > +		spin_lock(&bdi->wb_lock);
> > +		if (!bdi->wb.task)
> > +			wake_up_process(default_backing_dev_info.wb.task);
> > +		else
> > +			wake_up_process(bdi->wb.task);
> > +		spin_unlock(&bdi->wb_lock);
> > +	}
> >  }
> 
> We really want to wake up the bdi right away when first dirtying
> the inode? I haven't looked at where the state of the bdi code is
> now, but isn't it better to have a a delay there?

Yes, I guess we want to wake up the bdi thread after 5 secs (assuming
default settings). I could implement a "wake_up_process_delayed"
function which would use a timer, but I think it is not necessary to
introduce these complications. We can just wake-up the bdi thread, it'll
find out there is nothing to do, and will go sleep for 5 secs. I think
this is good enough.

IOW, delayed wake-up is not worth the trouble.

> And rather than spreading details of how bdi tasks are managed
> would you consider putting this into its own function?

Sure, will do.

> Other than that, I like your patches.

Thanks :-)

>  Out of interest, is 5 seconds
> very detremental to power usage? What is a reasonable goal for
> wakeups? (eg. 95%+ of possible efficiency)

I cannot tell for sure. In Nokia N900 phone we use OMAP3 and we have
dynamic OFF-mode, so we switch off the CPU and peripherals completely
when there is nothing to do, and SDRAM stays in low-power auto-refresh
mode. Every useless wake-up makes us do a lot of job re-constructing the
CPU state. I cannot tell the numbers, but I'm CCing Tero, who is working
on OMAP3 PM and makes a lot of battery current measurements, he can
provide some numbers.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

