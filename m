Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2IEM60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:58:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44743 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2IEM6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:58:25 -0400
Date: Wed, 5 Sep 2012 14:03:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ming Lei <ming.lei@canonical.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: A workaround for request_firmware() stuck in module_init
Message-ID: <20120905140304.5c5c58a4@pyramind.ukuu.org.uk>
In-Reply-To: <CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
References: <s5hd3222azc.wl%tiwai@suse.de>
	<CACVXFVP-A7M2dG9bOvAnpzR60=iTYSw=WCOEwgo9KeuioxKanQ@mail.gmail.com>
	<s5hd32122hw.wl%tiwai@suse.de>
	<CACVXFVNE1GHAQJTrQy2AYgUBfq5kv42EjJJ7J+2q3jzXG-E=MQ@mail.gmail.com>
	<s5hpq61j9qx.wl%tiwai@suse.de>
	<CACVXFVOu86J5=1DLDrpLCd-pyk1jm2HT7ks1uzCXm9nURCRo2A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the driver is built in kernel, the request_firmware in .probe() may
> prolong kernel init, and it might be a problem. But looks it is not a
> big deal since most of drivers are built as module.

Doing it by deferring the load also fixes that. The built in ones will
defer their final probe until the firmware appears and all will be well.

If your rootfs needs firmware not in your initrd you already broke it and
there is a certain level beyond which you just have to give up trying to
save people from themselves.

It may actually make sense to push more of it into the core driver layer
and take some of the ability to make mistakes away from driver authors.
For the general case of "load firmware if we see one" there isn't really
any reason we can't have a firmware_name entry in the probe table
entries themselves. If that was present the core bus probe would kick a
firmware load off and only when the firmware had loaded would it call
->probe with dev->firmware pointing at a refcounted firmware struct.

At that point it should be much faster to fix existing drivers and much
harder for a random device driver to get it wrong. We can even add
helpers which manage dev->firmware, and free the relevant objects when
needed, plus doing automatic ref/deref on probe/remove so that for a
typical driver the author only has to do

	{PCI_blah , ... .firmware_name="wibble500.xcr", }

and all the loading, unloading, not loading twice happens by "magic" for
the driver author.

Add a dev_discard_firmware() for drivers that do this and know they can
then dump the file and all is good 8)

Alan
