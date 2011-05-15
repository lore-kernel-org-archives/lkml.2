Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab1EOJf7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 05:35:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52519 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1EOJf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 05:35:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [RFC][PATCH] PM / Hibernate: Add sysfs knob to control size of memory for drivers
Date: Sun, 15 May 2011 11:36:22 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <201105100059.25372.rjw@sisk.pl> <201105150056.55601.rjw@sisk.pl> <201105151051.38934.Martin@lichtvoll.de>
In-Reply-To: <201105151051.38934.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105151136.22169.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 15, 2011, Martin Steigerwald wrote:
> Am Sonntag, 15. Mai 2011 schrieb Rafael J. Wysocki:
> > Hi,
> 
> Hi Rafael,

Hi,

> > On Tuesday, May 10, 2011, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Martin reports that on his system hibernation occasionally fails due
> > > to the lack of memory, because the radeon driver apparently allocates
> > > too much of it during the device freeze stage.  It turns out that the
> > > amount of memory allocated by radeon during hibernation (and
> > > presumably during system suspend too) depends on the utilization of
> > > the GPU (e.g. hibernating while there are two KDE 4 sessions with
> > > compositing enabled causes radeon to allocate more memory than for
> > > one KDE 4 session).
> > > 
> > > In principle it should be possible to use image_size to make the
> > > memory preallocation mechanism free enough memory for the radeon
> > > driver, but in practice it is not easy to guess the right value
> > > because of the way the preallocation code uses image_size.  For this
> > > reason, it seems reasonable to allow users to control the amount of
> > > memory reserved for driver allocations made after the preallocation,
> > > which currently is constant and amounts to 1 MB.
> > > 
> > > Introduce a new sysfs file, /sys/power/reserved_size, whose value
> > > will be used as the amount of memory to reserve for the
> > > post-preallocation reservations made by device drivers, in bytes.
> > > For backwards compatibility, set its default (and initial) value to
> > > the currently used number (1 MB).
> > > 
> > > References: https://bugzilla.kernel.org/show_bug.cgi?id=34102
> > > Reported-by: Martin Steigerwald <Martin@Lichtvoll.de>
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > OK, there are no comments, so my understanding is that everyone is fine
> > with this patch and I can add it to my linux-next branch.
> 
> Extensively
> 
> Tested-by: Martin Steigerwald <Martin@Lichtvoll.de>
> 
> This patch makes a complete difference for me. Instead of not knowing 
> whether my ThinkPad T42 will hibernate with lots of applications open and 
> thus closing applications prior to hibernation preventively now it simply 
> will. *Always*.
> 
> I even tested it with two KDE 4 sessions with running desktop search 
> indexing on one. It took ages, cause KDE 4.6 desktop search / nepomuk stuff 
> seems to I/O load the machine beyond anything (bugs reported there), but 
> it worked.
> 
> 16 MiB reserved_size has been enough for one KDE session. With 128 MiB the 
> linux kernel hibernated two KDE sessions.
> 
> Drivers allocating their memory via suspend/hibernate notifiers according 
> to Rafael should fix the root cause, but until that is done, this will do. 
> Adjusting imagesize instead never gave me such a reliable result.

In fact, if drivers allocated their memory from suspend/hibernate notifiers,
that would be practically equivalent to setting reserved_size to the total
amount of memory reserved by the drivers.  However, it may be difficult
for drivers to predict how much memory they will need at the time the
notifiers are called (they are called before freezing user space).

Thus I'm considering a change that will cause device drivers' ->prepare()
callbacks to be executed before the preallocation of memory takes place.
In that case the drivers may allocate memory from their ->prepare()
callbacks _after_ user space has been frozen and that will make more
sense overall.

For now, however, I think that exposing reserved_size is the right choice.

Thanks,
Rafael
