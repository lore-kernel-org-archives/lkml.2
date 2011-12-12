Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1LLUcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:32:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870Ab1LLUcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:32:19 -0500
Date: Mon, 12 Dec 2011 15:32:14 -0500
From: Josef Bacik <josef@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: trace_printk is doing weird things with my arguments
Message-ID: <20111212203214.GB3603@localhost.localdomain>
References: <20111212185947.GA3603@localhost.localdomain>
 <1323719838.1377.5.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323719838.1377.5.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 02:57:18PM -0500, Steven Rostedt wrote:
> On Mon, 2011-12-12 at 13:59 -0500, Josef Bacik wrote:
> > Hello,
> > 
> > I've been using trace_printk() to hash out where I want to put trace points so I
> > can do leak detection in the btrfs space accounting code.  This has worked out
> > wonderfully, except in the case where I have trace_printk()'s towards the end of
> > umount() which is where everything gets freed up.  After a lot of screwing
> > around I ended up with this in one of the functions
> > 
> > trace_printk("%pU is being released, fsinfo=%p\n", fs_info->fsid, fs_info);
> > printk(KERN_ERR "%pU is releaseing global_rsv\n", fs_info->fsid);
> > 
> > and then in my trace output I got this (I've cut the unnecessary line beginning)
> > 
> > 0080880d-0488-ffff-0a0a-0a0a0a0a0a0a is being released, fsinfo=ffff88040d88b000
> > 
> > and in dmesg I got this
> > 
> > 4e78b2a8-707a-4eef-97d5-11c0aa1b8f29 is releaseing global_rsv
> > 
> > The dmesg has the right fsid, and I have a ton of trace_printk()'s in
> > close_ctree() which is the function that we call from ->put_super, and all of
> > them will either randomly have the right fsid, they will all have the wrong
> > fsid, or some mixture, like half will have the right one but the last half will
> > not.  The '0a' repeating thing is because i put a memset(fs_info, 0xa,
> > sizeof(*fsinfo)) in our freeing function because I thought we were screwing up,
> > but it looks like trace_printk is somehow not trying to fill in the arguments
> > until after the arguments have been freed, which seems wrong and is screwing me
> > up ;).  Any thoughts?  Thanks,
> 
> Yes, that's the way trace_printk defaults to work. It really is a
> trace_bprintk(). In order for trace_printk to be as little impact as
> possible on recording, it only records as little as possible.
> 
> Although, I thought it would at least save the arguments at the point of
> time that they are recorded, this looks like it doesn't even do that.
> 
> Can you try this:
> 
> In your code after all the includes add:
> 
> #undef trace_printk
> #define trace_printk(fmt, args...) __trace_printk(_THIS_IP_, fmt, ##args)
> 
> This will process the format and arguments and place the final string
> right into the buffer. Normal printk will post process things if it can.
> Please let me know if the above works.
> 

That worked perfectly.  So will I have this problem when I got to turn these
things into tracepoints or will those work out right?  Thanks,

Josef
