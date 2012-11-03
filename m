Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964Ab2KCAhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:37:00 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37055 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2KCAg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:36:59 -0400
Date: Sat, 3 Nov 2012 00:42:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH 1/2] PM: make VT switching to the suspend console
 optional
Message-ID: <20121103004205.4ba8b6b7@pyramind.ukuu.org.uk>
In-Reply-To: <5094636A.9050000@virtuousgeek.org>
References: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org>
	<1351892621-4840-2-git-send-email-jbarnes@virtuousgeek.org>
	<20121102234302.28b773a7@pyramind.ukuu.org.uk>
	<5094636A.9050000@virtuousgeek.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> that, but how would I even configure a VT split across two adapters 
> today?  For vgacon we just route VGA to a single adapter, but I'm not 

con2fb /dev/fb1 /dev/tty1

> Dunno about suspend vs unload, how do we deal that in other drivers like 
> the disk driver for suspend for example?  Overall that case seems pretty 
> esoteric...
> 
> What do you mean about hand over to multiple frame buffers?

You have a global but I can insmod i915 move the consoles off it and
unload it (at least in theory - last time I tried it crashed at
least on gma500 which I need to fix 8))

So you've got a global you can't just set back but need to adjust on
unload.

And you've got races like suspend as we are changing framebuffer which
your code doesn't consider as you have no locking.

If we push the logic into the vt layer we can pretty easily dump it under
the vt locks. It's not the whole story as there are all sorts of things
it doesn't handle but it does mean we can handle the case of

"if we are switching from a vt which is on a device that doesn't need it
for suspend then do nothing"

properly, and we can make any future features work right


I think all we need is consw to have a con_sw_suspend/con_sw_resume
method and the framebuffer layer to let kms get at it.

Alan
