Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab2ISQ53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:57:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51608 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab2ISQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:57:26 -0400
Date: Wed, 19 Sep 2012 09:54:47 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH 07/11] tty/serial: Add kgdb_nmi driver
Message-ID: <20120919165447.GA6316@lizard>
References: <20120913150133.GA16238@lizard>
 <1347548615-18227-7-git-send-email-anton.vorontsov@linaro.org>
 <5059B200.9040706@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5059B200.9040706@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 06:52:32AM -0500, Jason Wessel wrote:
[...]
> > --- a/drivers/tty/serial/kgdboc.c
> > +++ b/drivers/tty/serial/kgdboc.c
> > @@ -145,6 +145,8 @@ __setup("kgdboc=", kgdboc_option_setup);
> >  
> >  static void cleanup_kgdboc(void)
> >  {
> > +	if (kgdb_unregister_nmi_console())
> > +		return;
> >  	kgdboc_unregister_kbd();
> >  	if (configured == 1)
> >  		kgdb_unregister_io_module(&kgdboc_io_ops);
> > @@ -198,6 +200,10 @@ do_register:
> >  	if (err)
> >  		goto noconfig;
> >  
> > +	err = kgdb_register_nmi_console();
> > +	if (err)
> > +		goto noconfig;
> > +
> 
> Just one question on this one, what do you expect to happen, or how
> does this work when you use a different serial port for example on a
> board that has a real serial port and an FIQ port?   It was not
> obvious that there was a path to check if the port you are
> registering is an FIQ enabled port and then call the
> kgdb_register_nmi_console at that point.

Yes, it works perfectly fine. If the port is not FIQ-enabled (which,
technically, can be enabled later -- it's just not implemented), then
ttyNMI just won't able to receive data.

The reason why I register nmi console in KGDB code (as opposite to arch
code), is the dependcy: the port should be initialized before it can be
used as ttyNMI. We could place the ttyNMI registration code into
late_initcall in arch/, and check for dbg_io_ops, but that is ugly by
itself, plus dbg_io_ops can change.

But with your kgdb_arch->enable_nmi suggestion (which I'll surely
implement), we can skip the registration at least for the cases when
the arch doesn't have this feature.

Thanks!

Anton.
