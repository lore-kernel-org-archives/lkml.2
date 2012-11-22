Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab2KVVZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:25:25 -0500
Received: from gate.alliedtelesyn.co.nz ([202.49.72.33]:60133 "HELO
	gate.alliedtelesyn.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755183Ab2KVVZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:25:22 -0500
Message-Id: <50AE6E050200003600026BD7@gwia.alliedtelesyn.co.nz>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 22 Nov 2012 18:25:09 +1300
From: "andrew mcgregor" <andrew.mcgregor@alliedtelesis.co.nz>
To: "Ilya Zykov" <ilya@ilyx.ru>
Cc: "Alan Cox" <alan@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: Add driver unthrottle in
 ioctl(...,TCFLSH,..).
References: <50AD43DB.4030800@ilyx.ru>
 <20121121213037.154306da@pyramind.ukuu.org.uk> <50AD4A01.7060500@ilyx.ru>
 <50AE2CE30200003600026B9A@gwia.alliedtelesyn.co.nz>
 <50ADAA26.7080103@ilyx.ru>
In-Reply-To: <50ADAA26.7080103@ilyx.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>> On 11/22/2012 at 05:29 PM, in message <50ADAA26.7080103@ilyx.ru>, Ilya Zykov
<ilya@ilyx.ru> wrote: 
> On 22.11.2012 4:47, andrew mcgregor wrote:
> >
> >
> >>>> On 11/22/2012 at 10:39 AM, in message <50AD4A01.7060500@ilyx.ru>, Ilya Zykov
> > <ilya@ilyx.ru> wrote:
> >> On 22.11.2012 1:30, Alan Cox wrote:
> >>>> Function reset_buffer_flags() also invoked during the
> >>>> ioctl(...,TCFLSH,..). At the time of request we can have full buffers
> >>>> and throttled driver too. If we don't unthrottle driver, we can get
> >>>> forever throttled driver, because after request, we will have
> >>>> empty buffers and throttled driver and there is no place to unthrottle
> >> driver.
> >>>> It simple reproduce with "pty" pair then one side sleep on tty->write_wait,
> >>>> and other side do ioctl(...,TCFLSH,..). Then there is no place to do
> >> writers wake up.
> >>>
> >>>
> >>> So instead of revertng it why not just fix it ? Just add an argument to
> >>> the reset_buffer_flags function to indicate if unthrottling is permitted.
> >>>
> >>> Alan
> >>>
> >> Because in my opinion, unthrottling permitted always, except release
> >> last filp (tty->count == 0)
> >
> > Maybe so, but the patch was there in the first place to resolve an actual 
> observed bug, where a driver would lock up.  So the behaviour needs 
> preserved.
> >
> > Andrew
> >
> 
> Maybe it was wrong driver, unfortunately, I didn't find full information 
> about this bug. As an example, if driver indirectly call 
> reset_buffer_flags() in driver's close() function it will be before 
> decrement last (tty->count).

Well, the driver in question was just 8250.c, so you should be able to see that the original condition can exist.

Here's the commit message again:

tty: fix "IRQ45: nobody cared"

Unthrottling the TTY during close ends up enabling interrupts
on a device not on the active list, which will never have the
interrupts cleared.  Doctor, it hurts when I do this.

>>> On 6/2/2011 at 01:56 AM, in message <20110601145608.3e586e16@bob.linux.org.uk>, Alan Cox <alan@linux.intel.com> wrote:
> On Wed, 01 Jun 2011 10:34:07 +1200
> "andrew mcgregor" <andrew.mcgregor@alliedtelesis.co.nz> wrote:
> > The LKML message
> > http://kerneltrap.org/mailarchive/linux-kernel/2010/2/25/4541847from
> > February doesn't seem to have been resolved since.  We struck the
> > issue, and the patch below (against 2.6.32) fixes it.  Should I
> > supply a patch against 3.0.0rc?
>
> I think that would be sensible. I don't actually see how you hit it as
> the IRQ ought to be masked by then but it's certainly wrong for n_tty
> to be calling into check_unthrottle at that point.
>
> So yes please send a patch with a suitable Signed-off-by: line to
> linux-serial and cc GregKH <greg@kroah.com> as well.
>
> Alan

Signed-off-by: Andrew McGregor <andrew.mcgregor@alliedtelesis.co.nz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

What part of this no longer applies?  I'm happy enough if you can prove that this can't happen any more, but otherwise the fix should remain.

Andrew

