Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab2IFMzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:55:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46387 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2IFMzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:55:19 -0400
Date: Thu, 6 Sep 2012 13:59:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ming Lei <ming.lei@canonical.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: A workaround for request_firmware() stuck in module_init
Message-ID: <20120906135957.2e705a9d@pyramind.ukuu.org.uk>
In-Reply-To: <CACVXFVMbCOov6nFqmmVu+9QYXuGc_1uwYKLcevqERZw4CRvVCA@mail.gmail.com>
References: <s5hd3222azc.wl%tiwai@suse.de>
	<CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
	<s5hd32122hw.wl%tiwai@suse.de>
	<CACVXFVNE1GHAQJTrQy2AYgUBfq5kv42EjJJ7J+2q3jzXG-E=MQ@mail.gmail.com>
	<s5hpq61j9qx.wl%tiwai@suse.de>
	<CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
	<20120905140304.5c5c58a4@pyramind.ukuu.org.uk>
	<CACVXFVO+OgvLoFMcDD0gcQnbzUW=SyR=wiSMyT-FtpjWW5sWdw@mail.gmail.com>
	<20120905173011.7a1111f0@pyramind.ukuu.org.uk>
	<CACVXFVMbCOov6nFqmmVu+9QYXuGc_1uwYKLcevqERZw4CRvVCA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, I don't see anyone explained clearly why request_firmware()
> can't be called inside module_init() in module case, so maybe it is
> a bit early to say it is a fix on 'bug', :-)

Because the firmware load may trigger a need to load a driver to load the
firmware.

> > dev_discard_firmware()
> >
> > so you an instance can drop its firmware reference if it doesn't need it
> > post probe.
> 
> This kind of mechanism has been implemented already: request_firmware()
> and release_firmware() will get and put a refcount.  And, the reference
> count is associated with firmware name, and it should be so, IMO.

Yes - so a dev_ firmware interface is very thin.

> > You broke suspend/resume for lots of devices.
> 
> The firmware cache mechanism will keep the firmware during suspend/resume
> cycle to address the problem.

Ok

> For drivers, I understand request_firmware()/request_firmware_nowait()
> and release_firmware() are enough. If many devices share one firmware,
> there is only one firmware kept in memory for their requests if one holds
> the firmware, and there is a refcount for it already, :-)
> 
> So I don't see why it is difficult to use request/release_firmware() inside
> drivers, :-)

The big problem can be summed up in one word "asynchronous". Having
either an automated handler for it before ->probe is called or having the
driver author cut and paste in

	if (!dev_request_firmware(dev, blah))
		return -EPROBE_DEFER;

avoids the need to deal with async completion after probe (and the
*horrible* case of 

	probe
		request firmware
	remove
	
	firmware ready
)

in each driver

Having an auto unload for it at the end is just neatness. Perhaps in fact
it should be devm_request_firmware() and use the mechanism we have ?
