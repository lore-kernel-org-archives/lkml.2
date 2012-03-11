Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2CKRGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 13:06:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46770 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2CKRGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 13:06:05 -0400
Date: Sun, 11 Mar 2012 17:05:51 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: santosh prasad nayak <santoshprasadnayak@gmail.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Video : Amba: Use in_interrupt() in clcdfb_sleep().
Message-ID: <20120311170551.GF13336@n2100.arm.linux.org.uk>
References: <20120311132746.GA13336@n2100.arm.linux.org.uk> <CAOD=uF7kQHABCmxUL3-J-hZ1E2mXrb7dgsYq7msHhiPJ4Gm-Ew@mail.gmail.com> <20120311143615.GB13336@n2100.arm.linux.org.uk> <CAOD=uF5GbsyHS5iXjJ1YcqJyGLHwT8Wjhiie1daJAVqu527Umg@mail.gmail.com> <20120311150311.GC13336@n2100.arm.linux.org.uk> <CAOD=uF5F4tOG0Y2tZdDeMgqs4-46HXYzA3RR-t8KuNuYRarJbg@mail.gmail.com> <20120311154846.GD13336@n2100.arm.linux.org.uk> <CAOD=uF6OtpX-1eoJB3X5ZywNUeU2_-tsE+Ksu33ZFXqoxVK_aQ@mail.gmail.com> <20120311164243.GE13336@n2100.arm.linux.org.uk> <CAOD=uF6sckygJf+76jY65N1-0BSD4E6VYf0KcZAQpyNmtxi_+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOD=uF6sckygJf+76jY65N1-0BSD4E6VYf0KcZAQpyNmtxi_+A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 10:27:12PM +0530, santosh prasad nayak wrote:
> Russel,
> 
> Is this what you want ?
> 
>  static inline void clcdfb_sleep(unsigned int ms)
>  {
> -       if (in_atomic()) {
>                 mdelay(ms);
> -       } else {
> -               msleep(ms);
> -       }
>  }

"want" is a strong word - I would not say "want" because I don't want the
system busy-spinning for 20ms at a time during normal blank and unblank
events preventing any other thread in the system from running.

Looking at do_unblank_screen() in drivers/tty/vt/vt.c:

/*
 * Called by timer as well as from vt_console_driver
 */
void do_unblank_screen(int leaving_gfx)
{
        struct vc_data *vc;

        /* This should now always be called from a "sane" (read: can schedule)
         * context for the sake of the low level drivers, except in the special
         * case of oops_in_progress
         */
        if (!oops_in_progress)
                might_sleep();

There may be another option of changing in_atomic() to be oops_in_progress()
if that comment is to be believed.  However, that comment conflicts with
the comment immediately above the function.  That said, the code is more
authorative than the comment above it because if that comment were true,
we'd see might_sleep() warnings.

So, I suspect:

 static inline void clcdfb_sleep(unsigned int ms)
 {
-       if (in_atomic()) {
+       if (oops_in_progress) {
                mdelay(ms);
        } else {
                msleep(ms);

is about the best that can be hoped for.

However, I think framebuffer people need to comment about what contexts
a framebuffer driver's fb_blank method would be called from (including
when oops-dumping.)
