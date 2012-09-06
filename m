Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab2IFFHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:07:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:54625 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab2IFFHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:07:08 -0400
Message-ID: <1346907992.2385.6.camel@pasglop>
Subject: Re: A workaround for request_firmware() stuck in module_init
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ming Lei <ming.lei@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 06 Sep 2012 15:06:32 +1000
In-Reply-To: <20120906001804.645c243c@pyramind.ukuu.org.uk>
References: <s5hd3222azc.wl%tiwai@suse.de>
	 <CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
	 <s5hd32122hw.wl%tiwai@suse.de>
	 <CACVXFVNE1GHAQJTrQy2AYgUBfq5kv42EjJJ7J+2q3jzXG-E=MQ@mail.gmail.com>
	 <s5hpq61j9qx.wl%tiwai@suse.de>
	 <CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
	 <20120905140304.5c5c58a4@pyramind.ukuu.org.uk>
	 <CACVXFVO+OgvLoFMcDD0gcQnbzUW=SyR=wiSMyT-FtpjWW5sWdw@mail.gmail.com>
	 <20120905173011.7a1111f0@pyramind.ukuu.org.uk>
	 <1346879334.19098.1.camel@pasglop>
	 <20120906001804.645c243c@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 00:18 +0100, Alan Cox wrote:
> > But then you have cases where probe() -> register_with_my_subsystem() ->
> > open(). Network devices come to mind. IE. udev must be able to deal with
> > a synchronous firmware load from probe I'm afraid.
> 
> I don't believe so. You have
> 
> 	begin probe
> 		find match .. .firmware_name is set
> 		issue firmware load request
> 		set defer flag
> 	end probe
> 
> Later..
> 
> 	firmware load complete
> 	kick probe up arse
> 
> 	begin probe
> 		find match .. .firmware is loaded
> 		call ->probe()
> 		register
> 		open
> 		happiness
> 	end probe

Ok, so this is my fault for picking the thread half way through and
missing the crucial point ... deferring probe() itself. BTW. Deferring
probe is useful for other things.

I've long advocated this as a way to deal with various soft dependencies
between services for example. Cases of a driver hooking up to two or 3
different busses, and wanting all the bits to be actually probed &
connected to each other in order, that sort of thing.

This can be done by defining the initialization order, have the "late"
ones defer when the depend aren't initialized yet, and kick probe arse
from bus notifiers (tho that could be moved to the core via some
helpers).

Cheers,
Ben.



