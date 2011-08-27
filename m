Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab1H0LCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 07:02:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51903 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1H0LC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 07:02:29 -0400
Date: Sat, 27 Aug 2011 13:02:24 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@redhat.com>, menage@google.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110827110224.GL2632@htj.dyndns.org>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <201108262309.38652.rjw@sisk.pl>
 <20110827103534.GK2632@htj.dyndns.org>
 <201108271251.22719.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108271251.22719.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 27, 2011 at 12:51:22PM +0200, Rafael J. Wysocki wrote:
> It seems that you are confusing two things - the interactions between the
> drivers and kernel subsystems that can happen at any time, even during suspend
> and resume, which can be taken care of with the help of various synchronization
> mechanisms _inside_ of the kernel, and the interactions between the drivers
> and user space resulting from user space using sysfs, ioctls, mmap,
> proc, debugfs, sysv IPC, open/close, read/write and so on and so on.
> The freezer's job is to take the second type of interactions out of the
> picture for suspend/resume.

So, there are two layers - user <-> driver and driver <-> hardware.
Quiescing the first layer (user <-> driver) in most cases would
effectively quiesce the second layer (driver <-> hardware) too and
some drivers depend on that.  What I'm trying to say is that that
cascading of quiescing can be unreliable.  Operations can propagate
via asynchronous mechanisms.  So, I think it's better to quiesce the
kernel <-> device layer like SCSI/ATA drivers do.

For things like direct access to hardware from ioctl, freezing does
make sense but there were some drivers (I don't remember which
exactly) which depended on freezing for block IO quiescing (nobody is
issuing no new IO so it should be safe!), which is quite scary given
the async nature of block IO processing.

For block IOs, for example, I think the best way would be put most of
quiescing logic and responsibilities to block layer directly.

> _Some_ drivers may want to use the freezer for their own purposes (e.g.
> by using a freezable workqueue to avoid their own work items from being
> executed in parallel with suspend/resume routines), but obviously they
> have to know what they are doing.

One such driver was thinkpad_acpi.  It used the fact that the kthread
entered freezer as a que to intiate hardware reset.  Maybe it's okay
but I think that really should hang off proper suspend/resume hook.

Thanks.

-- 
tejun
