Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab1KOVhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:37:43 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:64928 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432Ab1KOVhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:37:42 -0500
Date: Tue, 15 Nov 2011 22:37:34 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com
Subject: Re: [RFC PATCH] debugfs: add tools to printk 32-bit registers
Message-ID: <20111115213734.GA5094@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20111115212012.GA5467@suse.de>
References: <20111115212012.GA5467@suse.de>
  <20111115130230.GA23584@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg. Thanks for looking.

>> +/*
>> + * The regset32 stuff is used to print 32-bit registers using the
>> + * seq_file utilities. We offer printing a register set in an already-opened
>> + * sequential file or create a debugfs file that only prints a regset32.
>> + */
> 
> Can this be part of the kerneldoc below somehow so that people are more
> aware of it?

Ok. There's also a file by Jon in Documentation that needs updating, as it
has all the other debugfs file types.
 
> +int debugfs_print_regs32(struct seq_file *s, struct debugfs_reg32 *regs,
>> +			   int nregs, void __iomem *base, char *prefix)

> This function also needs to be part of debugfs.h in the "debugfs is not
> enabled" section of the file, right?

Not really. The other one makes a regiters-only file, and it's good
to register it withouth ifdef.

This one is used to embed a register block in a file with more
stuff, so it shouldn't be used if debugfs is not selected (btw,
I compiled my internal stuff with and without CONFIG_DEBUG_FS
before rebasing to next).

Example:

   static int pl08x_debugfs_show(struct seq_file *s, void *data)
   {  
	[...]
        list_for_each_entry(chan, &pl08x->slave.channels, chan.device_node) {
                seq_printf(s, "%s\t\t%s\n", chan->name,
                           pl08x_state_str(chan->state));
        }

        /* dump registers */
        seq_printf(s, "\nPL08x registers\n");
        debugfs_print_regs32(s, pl08x_regs, ARRAY_SIZE(pl08x_regs),
                               pl08x->base, "");

        seq_printf(s, "\nPL08x registers channel\n");
        for (i = 0; i < pl08x->vd->channels; i++) {
	[...]
   }

So, I'll post a V2 shortly, unless you refuse it in reply to this.

thanks
/alessandro
