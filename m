Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1I0ROW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:14:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59447 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab1I0ROU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:14:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH 2/3] PM / Runtime: Don't run callbacks under lock for power.irq_safe set
Date: Tue, 27 Sep 2011 19:16:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, jean.pihet@newoldbits.com,
        Ming Lei <tom.leiming@gmail.com>
References: <201108310017.03103.rjw@sisk.pl> <201109242325.53563.rjw@sisk.pl> <87oby66ejr.fsf@ti.com>
In-Reply-To: <87oby66ejr.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271916.33616.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 27, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > The rpm_suspend() and rpm_resume() routines execute subsystem or PM
> > domain callbacks under power.lock if power.irq_safe is set for the
> > given device.  This is inconsistent with that rpm_idle() does after
> > commit 02b2677 (PM / Runtime: Allow _put_sync() from
> > interrupts-disabled context) and is problematic for subsystems and PM
> > domains wanting to use power.lock for synchronization in their
> > runtime PM callbacks.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The part described here looks right, and is much better for consistency.
> 
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> 
> but...
> 
> [...]
> 
> > @@ -347,6 +353,15 @@ static int rpm_suspend(struct device *de
> >  			goto out;
> >  		}
> >  
> > +		if (dev->power.irq_safe) {
> > +			spin_unlock(&dev->power.lock);
> > +
> > +			cpu_relax();
> > +
> > +			spin_lock(&dev->power.lock);
> > +			goto repeat;
> > +		}
> > +
> 
> 
> ... AFAICT, this isn't directly related to the problem described in the
> changelog (or at least I didn't find it obvious),

It is related.  Whether or not it's obvious, I'm not sure. :-)

The problem is that after the changes in __rpm_callback() another CPU may start
executing the same routine for the same device if dev->power.irq_safe is set
(previously, it would block on the dev's power.lock) and it may see
dev->power.runtime_status == RPM_RESUMING or
dev->power.runtime_status == RPM_SUSPENDING, while previously, it wouldn't
reach the relevant code.  Thus we have to modify that code to take
the dev->power.irq_safe case into account.

> and probably deserves a comment in the code as well.

Well, the comment in the code would explain why the commit did what it did,
but it wouldn't be very useful afterwards IMHO.

Perhaps I'll simply add some explanation to the changelog.

Thanks,
Rafael
