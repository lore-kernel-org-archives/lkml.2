Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2FSB2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:28:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11982 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab2FSB2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:28:48 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FlAZEPfbBygA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=CjxXgO3LAAAA:8 a=GiJvo5EekGVZ82Dr2gwA:9 a=PUjeQqilurYA:10 a=Efwj4qSePvMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340069326.25903.177.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 18 Jun 2012 21:28:46 -0400
In-Reply-To: <20120618230337.GB23627@kroah.com>
References: <1339649173.13377.191.camel@gandalf.stny.rr.com>
	 <20120614045930.GA10508@kroah.com>
	 <1339671715.13377.209.camel@gandalf.stny.rr.com>
	 <20120614154153.GD17140@kroah.com>
	 <1339693625.13377.242.camel@gandalf.stny.rr.com>
	 <20120615042233.GA10973@localhost> <20120615043017.GA9587@kroah.com>
	 <20120615120430.GB23681@gmail.com> <20120615231318.GD8205@kroah.com>
	 <1339804415.25903.63.camel@gandalf.stny.rr.com>
	 <20120618230337.GB23627@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 16:03 -0700, Greg Kroah-Hartman wrote:

> > Actually, I think that patch really should go mainline, and give others
> > some of the luxury that us -rt folks enjoy.
> 
> That would be good.

Maybe I'll package that up if Ingo has no objections.


> > If other printks were interleaved and it didn't crash, we wouldn't care
> > (or even notice). But if it did crash, I'll even argue seeing the
> > interleaved printks would provide a hint to why it crashed.
> 
> Ok, so what do you want to do here?  Fix up your RFC patch to not have
> the printk stamps?  Or something like the above rt patch?
> 

I'm fine with adding a printk_flush() or even as Joe suggested, making a
pr_flush(), or printk(KERN_FLUSH "..." that will just do it. Maybe make
that default with a switch.

As to get rid of the time stamp issue, that may take a bit, as the code
goes through layers where this information needs to be passed down. I
ran 'trace-cmd record -p function_graph -g printk' to see how the flow
works, mounted an NFS filesystem (to force a printk) and this is what I
got:

  printk() {
    vprintk_emit() {
      _raw_spin_lock();
      log_store();
      console_trylock() {
        down_trylock() {
          _raw_spin_lock_irqsave();
          _raw_spin_unlock_irqrestore();
        }
      }
      console_unlock() {
        _raw_spin_lock_irqsave();
        log_from_idx();
        msg_print_text() {
          print_prefix();
          print_prefix();
        }
        log_next();
        serial8250_console_write() {

What's missing (as are all lib/ functions are from function tracing) is
the first call to vscnprintf() to get the string and all its args
together.

Then the '\n' is checked as well as the '<X>' notations. The prefix is
set for everything but '<c>' which makes sense, as you don't want to add
a prefix to a KERN_CONT line. But this 'prefix' variable just changes
the logic, it doesn't really prevent the prefix from appearing as we
will see.

Now things are a bit different if there's a newline or not. In this
trace, the newline was there, but first lets look at what happens when
there's no newline.

It checks this static variable called 'cont_len' which is set if we
buffered the last line. cont_task is set to the task it buffered too. If
cont_len is set but cont_task does not equal the current task, we call
this log_store() thingy. Which is the next thing that would have
happened if we did have a newline.

Now if cont_len is zero, it updates the current cont_level and
cont_task. Now it copies the printk into the cont_buf, which too is
static.

Finally, console_trylock() followed by console_unlock() which is done
regardless if there was a newline or not.

The console_unlock() is where the magic happens. Remember that
log_store() thingy, that's what is going to be printed. But remember, it
only was called if we had a newline, or we had buffered data and the
current task is different. But the current printk line is still located
in that cont_buf variable which happens to be static for vprintk_emit()
and not available elsewhere.

Once data is sent to the log_store() it always prints this prefix. This
is why my printk_flush() caused the next (<c>) line to have a timestamp
too. Because when that got flushed out, it got a timestamp on it, as all
data that goes to the console gets a timestamp. The only reason it
doesn't in the current method, is that it buffers it locally in the
cont_buf[] array, before it sends it out to the console. When it does
send it out to the console, it sends the entire buffer.

I forgot to mention what happens when the line has a newline, and
there's content in cont_buf[]. If the cont_task is the same as current,
it appends the cont_buf to the new data that is about to be printed, and
then sends that out to the log_store() which will get a timestamp at the
beginning of the line before the buffered data.

Oh, and one more thing. The vprintk_emit() strips the newline from the
text even if it had one. The msg_print_text() called by console_unlock()
and a bunch of syslog callers, adds the '\n' back. This is to all text
going out. My patch added a msg flag to say "don't do that!"  We also
need a flag to skip adding the timestamp, but that looks even more
complex, as the timestamp is added by print_prefix() also called by
msg_print_text() (three callers) and there's no comments to what the
frick it's doing or why. We need a way to stop that from happening.


-- Steve


