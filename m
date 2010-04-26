Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab0DZORE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:17:04 -0400
Received: from imr1.ericy.com ([198.24.6.9]:53727 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0DZORB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:17:01 -0400
Date: Mon, 26 Apr 2010 07:05:35 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3] x86: Do not write into VGA memory space if there is
	no VGA device in the system
Message-ID: <20100426140535.GA17135@ericsson.com>
References: <1271780217-27472-1-git-send-email-guenter.roeck@ericsson.com> <4BD55E85.4020709@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4BD55E85.4020709@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 05:36:05AM -0400, Pekka Enberg wrote:
> Guenter Roeck kirjoitti:
> > Ensure that early_printk() does not write into VGA memory space
> > if there is not VGA device in the system.
> > 
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> > ---
> > v3:
> > Changes are now limited to early_printk.c. Functionality is retained, meaning
> > there will still be output on the VGA console before setup_early_printk()
> > is called, but only if a VGA device is known to exist in the system.
> > 
> >  arch/x86/kernel/early_printk.c |   17 +++++++++++++----
> >  1 files changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
> > index b9c830c..783cb25 100644
> > --- a/arch/x86/kernel/early_printk.c
> > +++ b/arch/x86/kernel/early_printk.c
> > @@ -170,10 +170,13 @@ asmlinkage void early_printk(const char *fmt, ...)
> >  	int n;
> >  	va_list ap;
> >  
> > -	va_start(ap, fmt);
> > -	n = vscnprintf(buf, sizeof(buf), fmt, ap);
> > -	early_console->write(early_console, buf, n);
> > -	va_end(ap);
> > +	if (early_console && (early_console_initialized ||
> > +			      boot_params.screen_info.orig_video_isVGA == 1)) {
> > +		va_start(ap, fmt);
> > +		n = vscnprintf(buf, sizeof(buf), fmt, ap);
> > +		early_console->write(early_console, buf, n);
> > +		va_end(ap);
> > +	}
> >  }
> >  
> >  static inline void early_console_register(struct console *con, int keep_early)
> > @@ -233,6 +236,12 @@ static int __init setup_early_printk(char *buf)
> >  #endif
> >  		buf++;
> >  	}
> > +
> > +	/* If there is no VGA device, don't try to use it as early console. */
> > +	if (early_console == &early_vga_console &&
> > +	    boot_params.screen_info.orig_video_isVGA != 1)
> > +		early_console = NULL;
> 
> Wouldn't it be better to switch to, say, serial console here to avoid 
> the NULL check in early_printk()?
> 
This would be another possibility.

However, since the serial console was not explicitly selected, it would possibly
not be initialized. My understanding is that Peter had a problem with that.

One can argue that it would still be better to select the serial console in that case,
even though it might not be initialized. Actually, most likely it is (if it exists),
since the system must presumably have some means to communicate with the world.

I am pretty much open to either option, if that results in the patch being accepted. 
Just let me know which way to go.

Guenter

