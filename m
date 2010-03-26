Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0CZVQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:16:42 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43305 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab0CZVQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:16:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=gBTHFk74tawk0YgZD4QY7rPgANoOdxRJygVtQl9uYIDzmZuwC8xhhJ8CJ7pEMaYXw7
         hYD160kRaukUlf4jdXR76d85iVur4BgfD8SypKK8E/h/bsnwIX8uW5uH+0GmZV9UF7c6
         SvEYgh9McYawHKUweiahNDQ/i1RmIQtPdnGBk=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v3 1/6] hid: new driver for PicoLCD device
Date: Fri, 26 Mar 2010 14:16:24 -0700
User-Agent: KMail/1.13.1 (Linux/2.6.34-rc2; KDE/4.4.1; x86_64; ; )
Cc: Bruno =?iso-8859-15?q?Pr=E9mont?= <bonbons@linux-vserver.org>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
References: <20100324233707.7243b04d@neptune.home> <20100326102951.3b9ecda1@neptune.home> <alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003261416.25387.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 March 2010 01:59:19 pm Jiri Kosina wrote:
> On Fri, 26 Mar 2010, Bruno Prémont wrote:
> > > > +	for (i = 0; i < PICOLCD_KEYS; i++) {
> > > > +		int key = ((int *)idev->keycode)[i];
> > > 
> > > Keycodes are now short, not int. Also, just do:
> > > 		input_set_capability(idev, EV_KEY, data->keycode[i]);
> > > 		
> > > > +		if (key < KEY_MAX && key >= 0)
> > > > +			input_set_capability(idev, EV_KEY, key);
> > 
> > Oops, I was not careful enough when switching over...
> 
> Dmitry, thanks a lot for rapid review the driver.
> 
> Bruno, could you please fix this and submit a followup 1/6 patch, so that
> I could queue the driver in my tree?
> 
> I have almost finished going over the driver and haven't encountered any
> other issues that would require immediate fixing.
> 
> Still, it would be nice to have the framebuffer/LCD/backlight bits
> reviewed by respective subsystem maintainers. But I'll probably queue the
> driver nevertheless and add potential ACKs later.

FWIW I am not entrely happy with the whole send-and_wait implementation -
it looks like it is not being called concurrently so we don't need mutex
there... I'd do something like:

send_nand_wait() {

	set_bit(WAITING_RESPONSE, data->state);
	prepare message
	send message
	wait_for_event_interruptible_timeout(&data->wait,
					!test_bit(WAITING_RESPONSE, data->state));
	if (!test_bit()) {
		process
		return 0;
	}

	return -ETIME;
}

irq(...) {

	else if (test_bit(WAITING_RESPONSE, data->state)) {
		copy response...
		clear_bit(WAITING_RESPONSE, data->state);	
		wake_up(&data->wait);
	}
}

and not bother with kmallocing pending structure, but it should not
stop from merging driver.

-- 
Dmitry
