Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2ADSKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:10:54 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44637 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2ADSKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:10:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Sysfs attributes racing with unregistration
References: <Pine.LNX.4.44L0.1201041142220.1505-100000@iolanthe.rowland.org>
	<20120104171842.GN31746@google.com>
Date: Wed, 04 Jan 2012 10:13:00 -0800
In-Reply-To: <20120104171842.GN31746@google.com> (Tejun Heo's message of "Wed,
	4 Jan 2012 09:18:42 -0800")
Message-ID: <m1d3azfiab.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19g/w9UI5tnG1k19+cb2yzkUXU6Ic5Ch5Y=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Alan.
>
> On Wed, Jan 04, 2012 at 11:52:20AM -0500, Alan Stern wrote:
>> Can you explain the current situation regarding access to sysfs
>> attributes and possible races with kobject removal?  I have two
>> questions in particular:
>
> Heh, I haven't looked at sysfs code seriously for years now and my
> memory sucks to begin with, so please take whatever I say with a
> gigantic grain of salt.  Eric has been looking at sysfs a lot lately
> so he probably can answer these best.  Adding him, Greg and Kay - hi!
> guys.
>
>> 	What happens if one thread calls an attribute's show or
>> 	store method concurrently with another thread unregistering
>> 	the underlying kobject?

>
> sysfs nodes have two reference counts - one for object lifespan and
> the other for active usage.  The latter is called active and acquired
> and released using sysfs_get/put_active().  Any callback invocation
> should be performed while holding an active reference.  On removal,
> sysfs_deactivate() marks the active reference count for deactivation
> so that no new active reference is given out and waits for the
> in-flight ones to drain.  IOW, removal makes sure new invocations of
> callbacks fail and waits for in-progress ones to finish before
> proceeding with removal.

Or in simple terms.

If the unregister call happens first the we do not call the show method.

If the show method happens first the unregister waits until the show
method is complete before letting the unregistration proceed.

Furthermore lockdep models this wait as a reader/writer lock so lockdep
should be able to warn you about deadlocks triggered by waiting for the
unregistration to complete.

>> 	What happens if a thread continues to hold an open fd 
>> 	reference to a sysfs attribute file after the kobject is
>> 	unregistered, and then tries to read or write that fd?
>
> Active reference is held only for the duration of each callback
> invocation.  Userland can't prolong the existence of active reference.
> The duration of callback execution is the only deciding factor.

The fd only pins core sysfs data structures in memory.

The fd remains usable (in the -EIO -EBADF sense of usable) even

> Someone (I think Eric, right?) was trying to generalize the semantics
> to vfs layer so that severance/revocation capability is generally
> available.  IIRC, it didn't get through tho.

Unfortunately I didn't have time to complete the effort of those
patches.  The approach was not fundamentally rejected but it needed a
clear and convincing use case as well as some strong scrutiny.  But
fundamentally finding a way to do that was seen as an interesting,
if it could be solved without slowing down the existing cases.

Eric

