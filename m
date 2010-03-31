Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab0DKIAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 04:00:20 -0400
Received: from imr1.ericy.com ([198.24.6.9]:49063 "EHLO imr1.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab0DKIAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 04:00:18 -0400
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if
 CONFIG_VGA_CONSOLE is undefined
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>
In-Reply-To: <4BB39518.2020200@zytor.com>
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>
	 <4BB39518.2020200@zytor.com>
Content-Type: text/plain
Organization: Ericsson
Date: Wed, 31 Mar 2010 12:08:15 -0700
Message-ID: <1270062495.1477.404.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-31 at 14:31 -0400, H. Peter Anvin wrote:
> On 03/31/2010 07:41 AM, Guenter Roeck wrote:
> > Current early_printk code writes into VGA memory space even
> > if CONFIG_VGA_CONSOLE is undefined. This can cause problems
> > if there is no VGA device in the system, especially if the memory
> > is used by another device.
> > 
> > Fix problem by redirecting output to early_serial_console
> > if CONFIG_VGA_CONSOLE is undefined.
> > 
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> >  
> >  asmlinkage void early_printk(const char *fmt, ...)
> > @@ -216,7 +224,7 @@ static int __init setup_early_printk(char *buf)
> >  			early_serial_init(buf + 4);
> >  			early_console_register(&early_serial_console, keep);
> >  		}
> > -		if (!strncmp(buf, "vga", 3) &&
> > +		if (have_vga_console && !strncmp(buf, "vga", 3) &&
> >  		    boot_params.screen_info.orig_video_isVGA == 1) {
> >  			max_xpos = boot_params.screen_info.orig_video_cols;
> >  			max_ypos = boot_params.screen_info.orig_video_lines;
> 
> I'm confused in a big way about how you could end up with a system where:
> 
> a) there is no VGA;
> b) VGA memory is used by another device(!!!);
> c) boot_params.screen_info.orig_video_isVGA == 1?
> 
> 	-hpa

Look for
	early_printk("Kernel alive");

That function is called prior to early_console_register(). Even though
the call is now conditional, it can still happen if the log level is
high enough. There are a couple of other early_printk() calls which can
be executed before early_console_register() as well. The value of isVGA
is thus irrelevant.

Regarding a) and b), we have hardware which does not have VGA and does
use the same memory space for another device. This was actually how the
problem was found.

Guenter


