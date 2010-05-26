Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab0EZVZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:25:36 -0400
Received: from smtp.microsoft.com ([131.107.115.212]:20332 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099Ab0EZVZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:25:35 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
       "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Thread-Topic: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Thread-Index: AQHK/PQk4Q0BKOsjtUu1BYK6E0Db25JkpeQA//+OILA=
Date: Wed, 26 May 2010 21:25:31 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7266B8C72B@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7266B8C4AC@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100526205134.GC7343@suse.de>
In-Reply-To: <20100526205134.GC7343@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@suse.de]
> > +	static atomic_t ic_channel_initcnt = ATOMIC_INIT(0);
> Why is this an atomic_t?

As discussed previously, I used atomic_t to handle more general case 
if vmbus interrupts happen on every cpu.

> > +			    VmbusChannelOpen(newChannel, 2 * PAGE_SIZE,
> > +					     2 * PAGE_SIZE, NULL, 0,
> > +					     hv_cb_utils[cnt].callback,
> > +					     newChannel) == 0) {
> > +				hv_cb_utils[cnt].channel = newChannel;
> > +				mb();
> 
> What is the mb() call for?  Why is it necessary?  (hint, if you need it,
> something else is really wrong...)

It ensures the channel assignment happens before the wakeup call: 
osd_WaitEventSet(ic_channel_ready), if the compiler optimization re-arrange 
the execution order. 

> Something wierd happened with your indentation here, it doesn't line up
> properly.  That call to VmbusChannelOpen() needs to go in a full tab,
> not 4 spaces.
> 
> Please always run your patch through the checkpatch.pl script before
> sending it to me.

Sure, I will replace it with TAB. I already ran checkpatch.pl on 
this patch -- no error:
staging-next-2.6> scripts/checkpatch.pl 0525-Fix-race-condition-on-IC-channel-initialization.patch
total: 0 errors, 0 warnings, 71 lines checked

0525-Fix-race-condition-on-IC-channel-initialization.patch has no obvious style problems and is ready for submission.

> > +struct osd_waitevent *ic_channel_ready;
> 
> What's with the "ic_" naming scheme here?  It should be "hv_" right?

IC stands for "integration components", such as Shutdown, Timesync, 
Heartbeat, etc.

> As you are using this "ic_channel_ready variable only within the
> vmbus_bus_init() call, why not just make it local to there?  Then
> there's no need to do the create/init/wait/free sequence outside the
> init call.
> 
> The init call should just do all of this for us, right?

The ic_channel_ready variable is called by VmbusChannelProcessOffer /  osd_WaitEventSet(ic_channel_ready) to wake up vmbus_init(). So it's 
not a local variable.

Thanks,

- Haiyang

