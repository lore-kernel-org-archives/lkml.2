Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2CPVOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:14:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34235 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab2CPVOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:14:48 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Fri, 16 Mar 2012 22:14:42 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc6-wl+; KDE/4.7.4; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        skannan@codeaurora.org, Stephen Boyd <sboyd@codeaurora.org>
References: <201203032122.36745.chunkeey@googlemail.com> <4F62E841.70405@linux.vnet.ibm.com> <201203162123.44927.rjw@sisk.pl>
In-Reply-To: <201203162123.44927.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203162214.42553.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's fine by me.
> 
> If no one objects, I'll apply it.

Congrats on that nice, long and "obvious" explanation. Really,
what do you mean by the "end of resume"? As far as I know it
is NOT "after" all ->resume calls have finished, in fact the
usermodehelper is still disabled during ->complete! Maybe a
hint about "after/before function X() has finished/starts" 

Furthermore, I wonder what happends about built-in modules
for devices that need a firmware at probe [e.g.: different
firmware support different special features. This is quite
common for wifi stuff. e.g.: Special firmwares for APs]?

Because As far as I know "driver_init();" is called before
"usermodehelper_enable();" in "do_basic_setup()".
So, theoretical these people should see the same WARNINGs
and read the comment about suspend/resume and I'm sure
they will be thinking: WTF! 

Regards,
	Chr
> > ---
> > 
> >  drivers/base/firmware_class.c |   16 ++++++++++++++++
> >  1 files changed, 16 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index 6c9387d..9199e3e 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -535,6 +535,22 @@ static int _request_firmware(const struct firmware **firmware_p,
> >  
> >  	read_lock_usermodehelper();
> >  
> > +	/*
> > +	 * It is wrong to request firmware when the system is suspended,
> > +	 * because it simply won't work. Also, it can cause races with
> > +	 * the freezer, leading to freezing failures. Worse than that,
> > +	 * it may even cause a user space process to run when we think
> > +	 * we have frozen the user space! - and that can lead to all kinds
> > +	 * of interesting breakage..
> > +	 *
> > +	 * So check if the system is in a state which is unsuitable for
> > +	 * requesting firmware (because it is suspended or not yet fully
> > +	 * resumed) and bail out early if needed.
> > +	 * Usermodehelpers are disabled at the beginning of suspend, before
> > +	 * freezing tasks and re-enabled only towards the end of resume, after
> > +	 * thawing tasks, when it is safe. So all we need to do here is ensure
> > +	 * that we don't request firmware when usermodehelpers are disabled.
> > +	 */
> >  	if (WARN_ON(usermodehelper_is_disabled())) {
> >  		dev_err(device, "firmware: %s will not be loaded\n", name);
> >  		retval = -EBUSY;
