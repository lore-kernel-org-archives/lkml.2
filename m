Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab0KXUfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 15:35:23 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:58920 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab0KXUfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 15:35:22 -0500
Subject: Re: [RFC] persistent store
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=MM-GVGcswHfLXE-6JFHiXUT4k-wt61rqwkjAf@mail.gmail.com>
References: <1290470763.3008.252.camel@localhost>
	 <AANLkTi=MM-GVGcswHfLXE-6JFHiXUT4k-wt61rqwkjAf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 12:35:20 -0800
Message-ID: <1290630920.3058.205.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 17:37 -0800, Tony Luck wrote: 
> On Mon, Nov 22, 2010 at 4:06 PM, Jim Keniston
> <jkenisto@linux.vnet.ibm.com> wrote:
> >> + /* Don't dump oopses to persistent store */
> >
> > Why not?  In our case, we capture every oops and panic report, but keep
> > only the most recent.  Seems like catching the last oops could be useful
> > if your system hangs thereafter and can't be made to panic.  I suggest
> > you pass along the reason (KMSG_DUMP_OOPS or whatever) and let the
> > callback decide.
> 
> My thoughts were that Oops were non-fatal and ended up in /var/log/messages,
> so this would be unneeded (this bit of code was copied from one of mtdoops
> or ramoops - which does almost the same ... they do have an option to
> allow the copy - perhaps I should have copied that bit too?).

Yes, I'd still vote for that, because:
1) it provides flexibility at very low cost;
2) it could be useful if syslogd and/or klogd and/or the filesystem
holding /var/log are in trouble; and
3) it's helpful because I want to be sure -- even in the face of limited
NVRAM -- to capture the start of an oops that causes a panic.

(3) requires a little more explanation: As far as I can tell, by the
time you're in panic(), there's no way to know that you're panicking
because of an oops.  (The oops_in_progress flag doesn't seem to be
intended for this.)  But if I get notified at the time of the oops, I
can check the panic_on_oops flag and know that we're GOING to panic, and
set a panicking_on_oops flag for use when I get called back again during
the panic.  (No, my patch set doesn't do that yet, because I didn't
figure it out 'til recently.)  There's perhaps a more generic solution
to this particular problem, but I may be your only client with such
space constraints.

> 
> > You'd have to serialize the oops handling, I guess, in case multiple
> > CPUs oops simultaneously.  (Gotta fix that in my code.)
> Yup - I need to do this too (I only allocate one buffer).
> 
> >> + psinfo->writer(PSTORE_DMESG, pstore_buf, l1_cpy + l2_cpy);
> >
> > This assumes that you always want to capture the last psinfo->data_size
> > bytes of the printk buffer.  Given the small capacity of our NVRAM
> > partition, I handle the case where the whole oops report doesn't fit.
> > In that case, I sacrifice the end of the oops report to capture the
> > beginning.  Patch #3 in my set is about this.
> 
> Yes - I assume here that the last "data_size" bytes will be enough
> to be useful. But in your case it most likely won't be.  You could
> lie about how much space you allow and then include some oops
> parsing code to get the vital bits out of what is passed to you. Not
> pretty - but it would work.

Yeah, in the case of powerpc, a psinfo->data_size value of (say) 8K
would almost certainly include the start of the oops.  And then I could
simplify my code quite a bit.

> 
> >> + new_pstore->attr.attr.mode = 0444;
> >
> > /var/log/messages is typically not readable by everybody.  This
> > appears to circumvent that.
> 
> But "dmesg(8)" typically *does* allow any user to see the most recent
> part of the console log - so we are not consistent about this.

You're right, of course.  It's the user-mode syslog messages that are
being hidden.

> 
> -Tony

Jim

