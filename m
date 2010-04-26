Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0DZQQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 12:16:01 -0400
Received: from imr1.ericy.com ([198.24.6.9]:49931 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab0DZQP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 12:15:59 -0400
Date: Mon, 26 Apr 2010 09:11:20 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3] x86: Do not write into VGA memory space if there is
	no  VGA device in the system
Message-ID: <20100426161120.GA18509@ericsson.com>
References: <1271780217-27472-1-git-send-email-guenter.roeck@ericsson.com> <t2o195c7a901004260843k947fdf2cy3b137e3056db8b62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <t2o195c7a901004260843k947fdf2cy3b137e3056db8b62@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 11:43:44AM -0400, Bastien ROUCARIES wrote:
> On Tue, Apr 20, 2010 at 6:16 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
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
> >  arch/x86/kernel/early_printk.c |   17 +++++++++++++----
> >  1 files changed, 13 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
> > index b9c830c..783cb25 100644
> > --- a/arch/x86/kernel/early_printk.c
> > +++ b/arch/x86/kernel/early_printk.c
> > @@ -170,10 +170,13 @@ asmlinkage void early_printk(const char *fmt, ...)
> >        int n;
> >        va_list ap;
> >
> > -       va_start(ap, fmt);
> > -       n = vscnprintf(buf, sizeof(buf), fmt, ap);
> > -       early_console->write(early_console, buf, n);
> > -       va_end(ap);
> > +       if (early_console && (early_console_initialized ||
> > +                             boot_params.screen_info.orig_video_isVGA == 1)) {
> > +               va_start(ap, fmt);
> > +               n = vscnprintf(buf, sizeof(buf), fmt, ap);
> > +               early_console->write(early_console, buf, n);
> > +               va_end(ap);
> > +       }
> >  }
> 
> Instead to this ugly if why not creating a null early_console (write
> will do nothing) ?
> 
> >  static inline void early_console_register(struct console *con, int keep_early)
> > @@ -233,6 +236,12 @@ static int __init setup_early_printk(char *buf)
> >  #endif
> >                buf++;
> >        }
> > +
> > +       /* If there is no VGA device, don't try to use it as early console. */
> > +       if (early_console == &early_vga_console &&
> > +           boot_params.screen_info.orig_video_isVGA != 1)
> > +               early_console = NULL;
> > +
> >        return 0;
> >  }
> 
> And assign null console as the last console as a fallback ?
> 
Sounds good to me. Peter, would that get your approval ?

Guenter
