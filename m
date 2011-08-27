Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab1H0MUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 08:20:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1H0MUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 08:20:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Date: Sat, 27 Aug 2011 14:22:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, menage@google.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <201108271251.22719.rjw@sisk.pl> <20110827110224.GL2632@htj.dyndns.org>
In-Reply-To: <20110827110224.GL2632@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108271422.33754.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday, August 27, 2011, Tejun Heo wrote:
> Hello,
> 
> On Sat, Aug 27, 2011 at 12:51:22PM +0200, Rafael J. Wysocki wrote:
> > It seems that you are confusing two things - the interactions between the
> > drivers and kernel subsystems that can happen at any time, even during suspend
> > and resume, which can be taken care of with the help of various synchronization
> > mechanisms _inside_ of the kernel, and the interactions between the drivers
> > and user space resulting from user space using sysfs, ioctls, mmap,
> > proc, debugfs, sysv IPC, open/close, read/write and so on and so on.
> > The freezer's job is to take the second type of interactions out of the
> > picture for suspend/resume.
> 
> So, there are two layers - user <-> driver and driver <-> hardware.
> Quiescing the first layer (user <-> driver) in most cases would
> effectively quiesce the second layer (driver <-> hardware) too and
> some drivers depend on that.  What I'm trying to say is that that
> cascading of quiescing can be unreliable.  Operations can propagate
> via asynchronous mechanisms.

I agree.

> So, I think it's better to quiesce the kernel <-> device layer like
> SCSI/ATA drivers do.

Well, in general that _should_ be done in addition to the
user <-> driver quiescing. :-)
 
> For things like direct access to hardware from ioctl, freezing does
> make sense but there were some drivers (I don't remember which
> exactly) which depended on freezing for block IO quiescing (nobody is
> issuing no new IO so it should be safe!), which is quite scary given
> the async nature of block IO processing.

Those are bugs in the majority of cases.

> For block IOs, for example, I think the best way would be put most of
> quiescing logic and responsibilities to block layer directly.

Perhaps.

> > _Some_ drivers may want to use the freezer for their own purposes (e.g.
> > by using a freezable workqueue to avoid their own work items from being
> > executed in parallel with suspend/resume routines), but obviously they
> > have to know what they are doing.
> 
> One such driver was thinkpad_acpi.  It used the fact that the kthread
> entered freezer as a que to intiate hardware reset.  Maybe it's okay
> but I think that really should hang off proper suspend/resume hook.

It's difficult to comment being unfamiliar with the driver's internals,
but definitely using a proper suspend/resume sounds like a good idea.

Thanks,
Rafael
