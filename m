Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0DEVDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:03:18 -0400
Received: from imr2.ericy.com ([198.24.6.3]:53553 "EHLO imr2.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab0DEVDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:03:09 -0400
Subject: Re: [PATCH][RESEND] x86: Do not write to VGA memory space if
 CONFIG_VGA_CONSOLE is undefined
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: linux-kernel@vger.kernel.org, hpa@zytor.com
CC: penberg@cs.helsinki.fi, mingo@redhat.com, x86@kernel.org
In-Reply-To: <4BBA473D.9040004@zytor.com>
References: <1270046479-4486-1-git-send-email-guenter.roeck@ericsson.com>
	 <84144f021003310832i3420e4c1g7396b4d1f311f393@mail.gmail.com>
	 <1270491029.1477.453.camel@groeck-laptop>  <4BBA3021.9090504@zytor.com>
	 <1270497725.1477.488.camel@groeck-laptop>  <4BBA473D.9040004@zytor.com>
Content-Type: text/plain
Organization: Ericsson
Date: Mon, 5 Apr 2010 14:04:41 -0700
Message-ID: <1270501481.1477.521.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-05 at 16:25 -0400, H. Peter Anvin wrote:
> On 04/05/2010 01:02 PM, Guenter Roeck wrote:
> >>
> >> You didn't answer my question (c).
> >>
> >> I want to know how you ended up with
> >> boot_params.screen_info.orig_video_isVGA == 1 on a system with no VGA,
> >> which seems like it would have resolved this.
> >>
> >> I am *not* inclined to add a compile-time test for what should have been
> >> handed with a runtime test already.
> >>
> > Sorry, I thought I did answer it.
> >
> 
> You didn't.  You still haven't!
> 
c) boot_params.screen_info.orig_video_isVGA == 1?

boot_params.screen_info.orig_video_isVGA == 0 in the problem case. As I
tried to explain below, the problem happens before setup_early_printk()
is called, and thus the value of orig_video_isVGA is irrelevant for the
problem case. Not sure how else I can explain it.

> > The problem is that early_printk() can be called prior to the call to
> > setup_early_printk(). Since early_console is currently pre-initialized
> > with early_vga_console, output can be written to VGA memory space even
> > if there is no VGA controller in the system (and even if
> > boot_params.screen_info.orig_video_isVGA == 0). This happens for all
> > early_printk() calls executed prior to the call to setup_early_printk().
> 
> If boot_params.screen_info.orig_video_isVGA == 0, at least this bit of
> your patch has no effect:
> 
> > > -		if (!strncmp(buf, "vga", 3) &&
> > > +		if (have_vga_console && !strncmp(buf, "vga", 3) &&
> > >  		    boot_params.screen_info.orig_video_isVGA == 1) {
> 
It does; as a result of this part of the patch, the compiler can
optimize all vga related code away. As I said, this is just an
optimization resulting in less code. It is however not important /
relevant from a functional point of view, and I don't mind taking it
out.

> Now, we have at least two ways to report a non-VGA console at runtime:
> 
> boot_params.screen_info.orig_video_isVGA != 1
> boot_params.screen_info.orig_video_lines == 0
> 
> The former is zero for CGA/MDA/EGA, but early_vga_write() doesn't work
> right for MDA at least, so keying on isVGA is probably right.
> 
> early_printk() being called before setup_early_printk() is a problem,
> and it's not immediately obvious to me how to fix it.  We can of course
> make early_vga_write() simply return if boot_params.screen_info.isVGA ==
> 0, of course, but it really is a bigger problem than that in many ways.
> 
As far as I can see, boot_params.screen_info.orig_video_isVGA is set
early enough during boot, so that should at least solve the immediate
problem. However, it would result in early messages being ignored, which
might not be desirable.

Would you accept a minimized patch like this ?

 /* Direct interface for emergencies */
+#ifdef CONFIG_VGA_CONSOLE
 static struct console *early_console = &early_vga_console;
+#else
+static struct console *early_console = &early_serial_console;
+#endif
 static int __initdata early_console_initialized;

This would prevent the problem while minimizing changes, and at the same
time permit early messages to be written to the serial console.

Guenter


