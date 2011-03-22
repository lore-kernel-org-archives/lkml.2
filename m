Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1CVOLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:11:15 -0400
Received: from realvnc.com ([146.101.152.142]:45010 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab1CVOLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:11:09 -0400
Message-ID: <4D88ADFB.10206@realvnc.com>
Date: Tue, 22 Mar 2011 14:11:07 +0000
From: Toby Gray <toby.gray@realvnc.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] USB: cdc-acm: Prevent data loss when filling tty buffer.
References: <1300722745-2404-1-git-send-email-toby.gray@realvnc.com> <1300730698-17099-1-git-send-email-toby.gray@realvnc.com> <20110322100526.GB21343@localhost>
In-Reply-To: <20110322100526.GB21343@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/2011 10:05, Johan Hovold wrote:
> Say you fill up the tty buffer using the last of the sixteen buffers and
> return in the else clause above, how will the tasklet ever get
> re-scheduled?
That's a good point. I did check that this was happening during testing, 
but looking into n_tty.c some more it seems that I probably just got 
lucky with  n_tty_receive_buf running to completion (and so throttling) 
before  n_tty_read got to run (and so un-throttling).

However I'm not 100% sure that I'm correctly understanding how 
n_tty_receive_buf and n_tty_read interact. I can't see why it's safe for 
n_tty_receive_buf to not have any sort of synchronization mechanism 
between checking tty->receive_room and calling tty_throttle.

Is there a mechanism preventing a different thread from running 
n_tty_read between n_tty_receive_buf finding receive_room to be below 
the threshold and tty_throttle being called? If not then isn't there a 
race condition when the following happens:

         1. n_tty_receive_buf fills up the buffer so that the free space 
is below TTY_THRESHOLD_THROTTLE
         2. n_tty_receive_buf comes to the check at the end and decide 
that it needs to call tty_throttle
         3. Thread rescheduling happens and a different thread runs 
n_tty_read which empties the buffer
         4. After emptying the buffer n_tty_read calls tty_unthrottle, 
which does nothing as the throttling bit isn't set
         5. The n_tty_receive_buf thread is executed again, calling 
tty_throttle, causing throttling, but with an empty buffer.

Or have I not understood a complexity in the interactions within n_tty.c?

> [By the way, did you see Filippe Balbi's patch posted today claiming to
> fix a bug in n_tty which could cause data loss at high speeds?]
I'd not seen that. Thanks for pointing that out.
> I was just about to submit a patch series killing the rx tasklet and
> heavily simplifying the cdc-acm driver when you posted last night. I
> think that if this mechanism is needed it is more straight-forwardly
> implemented on top of those as they removes a lot of complexity and
> makes it easier to spot corner cases such as the one pointed out above.
Makes sense. The cdc-acm driver is certainly far more readable with your 
changes.
> I would also prefer a more generic solution to the problem so that we
> don't need to re-introduce driver buffering again. Since we already have
> the throttelling mechanism in place, if we could only be notified/find
> out that the tty buffers are say half-full, we could throttle (from
> within the driver) but still push the remaining buffer still on the wire
> as they arrive. It would of course require a guarantee that such a
> throttle-is-about-to-happen notification is actually followed by (a
> throttle and) unthrottle. Thoughts on that?
I was thinking about this too. Would it be good enough to add the 
ability for forcing tty throttling and to call that instead of issuing 
another URB read when the space remaining in the buffer would then be 
less than the pending URB reads? Or would having a notification at a 
particular level be more useful for other drivers?

Regards,

Toby
