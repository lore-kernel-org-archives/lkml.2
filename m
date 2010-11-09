Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab0KIMJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 07:09:17 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:23469 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0KIMJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 07:09:09 -0500
Date: Tue, 9 Nov 2010 13:08:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jim Cromie <jim.cromie@gmail.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/32] drivers/hwmon/pc87360.c: Use pr_fmt and 
 pr_<level>
Message-ID: <20101109130855.7f45e1a7@endymion.delvare>
In-Reply-To: <1289296784.1823.45.camel@Joe-Laptop>
References: <20101020035346.GA20178@ericsson.com>
	<190459d6c56001d564155d8a73ee8e47024b6149.1287556801.git.joe@perches.com>
	<20101109103119.4cb66327@endymion.delvare>
	<1289296784.1823.45.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, 09 Nov 2010 01:59:44 -0800, Joe Perches wrote:
> On Tue, 2010-11-09 at 10:31 +0100, Jean Delvare wrote:
> > On Tue, 19 Oct 2010 23:51:43 -0700, Joe Perches wrote:
> > > Added #define pr_fmt KBUILD_MODNAME ": " fmt
> > > Converted printks to pr_<level>
> > > Coalesced any long formats
> > > Removed prefixes from formats
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > ---
> > >  drivers/hwmon/pc87360.c |   32 +++++++++++++-------------------
> > >  1 files changed, 13 insertions(+), 19 deletions(-)
> > The following is left in the driver:
> > #ifdef DEBUG
> > 			printk(KERN_DEBUG "pc87360: Fan 1: mon=%d "
> > 			       "ctrl=%d inv=%d\n", (confreg[0]>>2)&1,
> > 			       (confreg[0]>>3)&1, (confreg[0]>>4)&1);
> > 			printk(KERN_DEBUG "pc87360: Fan 2: mon=%d "
> > 			       "ctrl=%d inv=%d\n", (confreg[0]>>5)&1,
> > 			       (confreg[0]>>6)&1, (confreg[0]>>7)&1);
> > 			printk(KERN_DEBUG "pc87360: Fan 3: mon=%d "
> > 			       "ctrl=%d inv=%d\n", confreg[1]&1,
> > 			       (confreg[1]>>1)&1, (confreg[1]>>2)&1);
> > #endif
> > 
> > Is there any reason why you didn't convert these to pr_debug()?
> 
> No.  These should be converted to pr_debug as well.
> 
> The conversion was done via script and the script doesn't
> convert printk(KERN_DEBUG to pr_debug to avoid changing output.
> 
> Let me know if you want another patch.

I'll fix these myself, no problem.

> 
> > > @@ -1071,14 +1072,11 @@ static int __init pc87360_find(int sioaddr, u8 *devid, unsigned short *addresses
> > >  				confreg[3] = superio_inb(sioaddr, 0x25);
> > >  
> > >  				if (confreg[2] & 0x40) {
> > > -					printk(KERN_INFO "pc87360: Using "
> > > -					       "thermistors for temperature "
> > > -					       "monitoring\n");
> > > +					pr_info("Using thermistors for temperature monitoring\n");
> > 
> > I know checkpatch.pl no longer complains about long lines when they
> > include a string, but 98 columns seems excessive to me. It would be
> > easy enough to spread over two lines.
> 
> Also converted via a script.
> 
> If the string is split, it doesn't matter where it's split.
> The split just makes it harder to use grep.

I've heard this argument many times, but it doesn't really hold
examination, I'm afraid. If nothing else, your patches are enforcing
the use of the module name as the log message prefix. So there's no
reason to grep for the message itself, when you can use "find" and
search for the module name 80 times faster.

Secondly, grep will find strings in binaries, and there it doesn't
matter if the string was split in the source file or not. If you
consider that grepping the whole kernel tree is acceptable
performance-wise, you probably don't mind processing the binary files
as well. The only drawback of this approach, I concede, is that it
assumes that the module in question has already been build locally. But
I doubt this is a problem in practice.

Thirdly, log messages aren't raw messages, they are format strings, so
grepping the sources for the output is never guaranteed to work in the
first place, split strings or not.

Fourthly, log messages aren't guaranteed to be unique over the kernel
tree, and as the tree grows, duplicates are more frequent.

And for completeness: if you really want to use grep, then yes, the
point at which the strings are split does matter. If you choose
carefully the split point, then it doesn't prevent grepping for the
message. If you split right before or after a % format specification,
the effect is zero with regards to grepping.

> Personally, I think it's better to ignore the line length
> of format strings completely.  Once it wraps in an editor,
> it really doesn't matter how long the line is.

Except that not all editors are configured to wrap. Mine in particular
isn't - I find it very difficult to read source code when long lines
are wrapped. So the extra characters are simply not displayed - and
there it matters somewhat if this is just the trailing "); that I don't
see, or half of the message.

> 
> Of course, there are multiple strings in this file that
> use dev_<level> that are split across lines that could be
> converted as well so it's up to you if you want to leave
> those as is.  Let me know if you want another patch to
> integrate those dev_<level> format strings.

I'll do things the way I like them, I think it will be more efficient
for everyone than discussing the costs and benefits of split strings
for the rest of the day ;)

-- 
Jean Delvare
