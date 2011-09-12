Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1ILVuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 17:50:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58722 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab1ILVui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 17:50:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/5] PM / Runtime: Do not run callbacks under lock for power.irq_safe set
Date: Mon, 12 Sep 2011 23:52:39 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com
References: <201108310017.03103.rjw@sisk.pl> <201108310020.26104.rjw@sisk.pl> <CACVXFVPshpc-aVHGMYWkthffMRYLFh4BadnEAhf+eQ47CwWLZw@mail.gmail.com>
In-Reply-To: <CACVXFVPshpc-aVHGMYWkthffMRYLFh4BadnEAhf+eQ47CwWLZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109122352.39848.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 12, 2011, Ming Lei wrote:
> Hi,
> 
> On Wed, Aug 31, 2011 at 6:20 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > The rpm_suspend() and rpm_resume() routines execute subsystem or PM
> > domain callbacks under power.lock if power.irq_safe is set for the
> > given device.  This is inconsistent with that rpm_idle() does after
> > commit 02b2677 (PM / Runtime: Allow _put_sync() from
> > interrupts-disabled context) and is problematic for subsystems and PM
> > domains wanting to use power.lock for synchronization in their
> > runtime PM callbacks.  For this reason, make runtime PM core functions
> > always release power.lock before invoking subsystem or PM domain
> 
> If power.lock is released, the transition states(resuming or suspending)
> may be observed in rpm_suspend or rpm_resume, then tasks schedule
> will be produced in these two functions,

I don't think so, because the interrupts are still off.

> so the functions below can't be
> 
>       pm_runtime_suspend()
>       pm_runtime_autosuspend()
>       pm_runtime_resume()
>       pm_runtime_put_sync_suspend()
>       pm_runtime_put_sync_autosuspend()
> 
> called in irq-off contexts safely even though irq_safe flag is set.

The patch doesn't cause rpm_suspend() and rpm_resume() to turn interrupts
on if irq_safe is set, it only causes them to release the lock (temporarily).

Thanks,
Rafael
