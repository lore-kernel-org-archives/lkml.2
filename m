Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760508Ab0JZXZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 19:25:35 -0400
Received: from mail.perches.com ([173.55.12.10]:3609 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758229Ab0JZXZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 19:25:33 -0400
Subject: Re: [PATCH 06/10] drivers/input/serio/i8042: Use pr_<level>,
 pr_fmt. Fix dbg and __FILE__ use
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101026155028.GA13097@core.coreip.homeip.net>
References: <cover.1288059486.git.joe@perches.com>
	 <63a8deabb7c8167128d0415998692d15279ecb8c.1288059486.git.joe@perches.com>
	 <20101026155028.GA13097@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 16:25:31 -0700
Message-ID: <1288135531.4145.59.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 08:50 -0700, Dmitry Torokhov wrote:
> Hi Joe,

Hi Dmitry.

> On Mon, Oct 25, 2010 at 07:44:24PM -0700, Joe Perches wrote:
> > Standardized message logging prefixes.
> > Removed \n from dbg macro, added \n to each dbg call site.
> Did you test it? It looks for call like:
> > +             dbg("%02x <- i8042 (flush, %s)\n",
> > +                 data, str & I8042_STR_AUXDATA ? "aux" : "kbd");
> the result will be:
> printk(KERN_DEBUG "i8042: %02x <- i8042 (flush, %s)\n [%d]", ...)
> which is not exactly what you want...

Right.  My mistake.
I compile tested only and didn't notice the badly formed string.

Mind if I move the time to the front like this?

+#define dbg(format, arg...)                                            \
+do {									\
+	if (i8042_debug)						\
+		printk(KERN_DEBUG KBUILD_MODNAME ": [%d]" format),	\
+                      (int)(jiffies - i8042_start_time), ##arg);	\
+} while (0)

> >  
> > @@ -1268,7 +1262,7 @@ static void __init i8042_register_ports(void)
> >  
> >  	for (i = 0; i < I8042_NUM_PORTS; i++) {
> >  		if (i8042_ports[i].serio) {
> > -			printk(KERN_INFO "serio: %s at %#lx,%#lx irq %d\n",
> > +			pr_info("%s at %#lx,%#lx irq %d\n",
> >  				i8042_ports[i].serio->name,
> >  				(unsigned long) I8042_DATA_REG,
> >  				(unsigned long) I8042_COMMAND_REG,
> 
> Not quite equivalent conversion, right now every port is registered with
> message "serio: XXX at YYY". I would be OK with having driver prefix
> going in front but I'd like to keep word serio in (like "i8042: serio
> XXX at YYY").

I'll resubmit a pr_<level> series for drivers/input/serio
today/tomorrow with this change.

cheers, Joe

