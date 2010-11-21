Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab0KUI1E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 03:27:04 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:60173 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab0KUI1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 03:27:03 -0500
Date: Sun, 21 Nov 2010 09:26:58 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Message-ID: <20101121082658.GL13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <57dad12253191b67a6a08bb9c464bd54e70e52a3.1290087479.git.lasaine@lvk.cs.msu.su>
 <20101120154416.GX13356@enneenne.com>
 <20101121013327.01bc9a86@apollo.gnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121013327.01bc9a86@apollo.gnet>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 05/17] pps: access pps device by direct pointer
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 01:33:27AM +0300, Alexander Gordeev wrote:
> > > -	if (ret < 0) {
> > > +	if (pps == NULL) {
> > >  		pr_err("cannot register PPS source \"%s\"\n", info.path);
> > > -		return ret;
> > > +		return -ENOMEM;
> > >  	}
> > > -	tty->disc_data = (void *)(long)ret;
> > > +
> > > +	spin_lock_irq(&pps_ldisc_lock);
> > > +	tty->disc_data = pps;
> > > +	spin_unlock_irq(&pps_ldisc_lock);
> > 
> > Maybe this lock is useless... however, are we sure that before setting
> > tty->disc_data to pps its value is null? Otherwise the dcd_change may
> > be called with an oops! We cannot control serial port IRQ
> > generation... :-/
> 
> No, locking here is necessary.
> There is only one problem this spinlock protects us from: current tty
> code neither disables interrupts nor doesn't ensure there are no
> references to PPS ldisc from uart_handle_dcd_change() before closing it
> (and removing PPS source). It relies on flushing workqueue and disabling
> input. It worked good this way until dcd_change() was added which
> doesn't use workqueues and is called in atomic context so can't lock
> on mutex.
> 
> Imagine that (on SMP system) uart_handle_dcd_change() could obtain a
> reference to ldisc and call dcd_change() until actually calling
> pps_event(); then on another processor all the path from
> tty_ldisc_halt() until tty_ldisc_stop() is executed. And then
> pps_event() is called with illegal pps pointer.
> 
> I just thought you are right that disc_data can be set not NULL by
> another ldisc and it's a problem. But actually I just realised how to
> fix it completely. :)
> 
> I just have to add a spinlock to tty_struct, lock all the
> uart_handle_dcd_change() with it and add a "barrier" between
> tty_ldisc_halt() and tty_ldisc_close() i.e. just that:
> 
> ...
> spin_lock_irq();
> spin_unlock_irq();
> ...
> 
> This "barrier" will ensure that there is no references to ldisc from
> uart_handle_dcd_change(). It won't be able to obtain a new reference
> after tty_ldisc_halt() so will become completely sane. Not disabling
> interrupts won't be a problem because it won't be able to obtain an
> ldisc reference until tty_ldisc_enable() which is called only after the
> new ldisc is fully functional. If it's our ldisc than it will have both
> dcd_change defined and a valid pps pointer. If it's not our ldisc it
> won't have both so uart_handle_dcd_change() won't call dcd_change() at
> all.
> 
> I think I'll do that as a separate patch.

Excuse me but IMHO you should solve all your problems if you do the lock into
pps_tty_init/cleanup instead of into pps_tty_open/close.

   spin_lock_irq();
           err = tty_register_ldisc(N_PPS, &pps_ldisc_ops);
           if (err)
                   pr_err("can't register PPS line discipline\n");
           else
                   pr_info("PPS line discipline registered\n");
   spin_unlock_irq();

And the same into cleanup.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
