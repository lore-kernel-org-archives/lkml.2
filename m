Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2FWLrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 07:47:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41221 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2FWLro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 07:47:44 -0400
Message-ID: <1340452052.1784.40.camel@mop>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Kay Sievers <kay@vrfy.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Sat, 23 Jun 2012 13:47:32 +0200
In-Reply-To: <20120623061313.GA21895@gmail.com>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
	 <20120622145402.8047a669.akpm@linux-foundation.org>
	 <20120623061313.GA21895@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.5.2 (3.5.2-2.fc18)
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-23 at 08:13 +0200, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 21 Jun 2012 19:52:03 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > But with the new printk() changes, text without a newline 
> > > gets buffered and does not print out to the console at the 
> > > location of the printk.
> > 
> > uh, how about we fix that?  The old behaviour was good, the 
> > new behaviour is noxious.
> 
> Absolutely.
> 
> pr_flush() really seems to be a workaround.
> 
> > Please idenfity these "new printk() changes".  Was the new 
> > noxiousness an unavoidable effect of them?
> 
> Fundamentally:
> 
> e2ae715d66bf kmsg - kmsg_dump() use iterator to receive log buffer content
> c313af145b9b printk() - isolate KERN_CONT users from ordinary complete lines
> 3ce9a7c0ac28 printk() - restore prefix/timestamp printing for multi-newline strings
> 649e6ee33f73 printk() - restore timestamp printing at console output
> 5c5d5ca51abd printk() - do not merge continuation lines of different threads
> 7f3a781d6fd8 printk - fix compilation for CONFIG_PRINTK=n
> 5fc3249068c1 kmsg: use do_div() to divide 64bit integer
> e11fea92e13f kmsg: export printk records to the /dev/kmsg interface
> 7ff9554bb578 printk: convert byte-buffer to variable-length record buffer
> 
> Should we revert them or can they be fixed sanely? Kay seems to 
> be busy with other things so I guess a revert is the best we can 
> do. Greg, Kay?

I just don't have a better idea than Joe or Steven.

The conversion from the unreliable byte-buffer to records changes the
behavior a little in some areas. We are atomic at the line level now and
not at an sometimes unpredictable byte stream position which can just be
moved forward by adding another few bytes.

The usual continuation line user should all be buffered to make things
generally more reliable and less racy. And we really had these problems
in the past, and substantially improved the common use-cases now.

But yes, it seems to come into our way with the current output format of
the kernel self-tests, and we need to do something about it. But I don't
think it should be going back to the much-too-simple and unreliable
byte-stream buffer.

We need make some sort of a compromise for the self-tests here, I guess.
I think the trade of using one of these options for the self-tests to
cope with the new model is justified:
- flush explicitly when it is needed, by a global flag or with a
  message prefix
- printing a second full line that says: test foo OK, instead
  of appending the OK to the former line
- printing one full line, and suppress the later OK entirely. The OK
  might not be needed at all; we will find out that the machine
  has not crashed at that point and a message in case of an error
  could be sufficient in most cases.

Reverting the changes now would remove:
- proper device identifiers attached to a message, which allows
  tools for the first time to know the contexts of the kernel messages
- 100% message integrity of structured messages, and single line
  prints, and if only one continuation line user prints at a time.
  We never mix continuation users with full line users, like the
  old buffer did.
- very reliable continuation line prints, because of the buffering.
  The only race that can still happen is several cont users racing
  against each other, which is not too likely
- 100% granularity at line level during userspace buffer access,
  crash dumping; we never copy around half or overwritten lines,
  like the old buffer
- the ring buffer prunes only entire messages not just the half
  of a line like the old byte buffer
- sequence numbers allow us to track the state of the read and write
  position in the buffer, so we never copy in-the-meantime already
  overwritten messages around
- sequence numbers which allow userspace to reconnect to the old reading
  position and process only new messages, and find if messages got
  overwritten
- support for multiple concurrent readers with live update of the kernel
  log stream

This seems like a trade of a rather cosmetic output-format issue for
kernel self-tests, against general reliability, integrity and usefulness
of the rest of the kernel message users.

The record buffer is a huge step forward for the system logging, and it
allows us for the first time to make the kernel log useful to consumers
other than humans, and is key part of providing important information to
the system management.

An explicit flush for the self-test like users is unfortunate, and
inconvenient, and surely not nice, but I think it's still the better
overall deal.

Thanks,
Kay

