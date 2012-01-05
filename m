Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab2AEDFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 22:05:46 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:48416 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770Ab2AEDFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 22:05:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Sysfs attributes racing with unregistration
References: <Pine.LNX.4.44L0.1201041431160.1505-100000@iolanthe.rowland.org>
Date: Wed, 04 Jan 2012 19:07:52 -0800
In-Reply-To: <Pine.LNX.4.44L0.1201041431160.1505-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Wed, 4 Jan 2012 14:41:12 -0500 (EST)")
Message-ID: <m1boqietiv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ZrUDoeugCeI934q9GIjZj52BmRw/B4Lk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Wed, 4 Jan 2012, Eric W. Biederman wrote:
>
>> > Someone (I think Eric, right?) was trying to generalize the semantics
>> > to vfs layer so that severance/revocation capability is generally
>> > available.  IIRC, it didn't get through tho.
>> 
>> Unfortunately I didn't have time to complete the effort of those
>> patches.  The approach was not fundamentally rejected but it needed a
>> clear and convincing use case as well as some strong scrutiny.  But
>> fundamentally finding a way to do that was seen as an interesting,
>> if it could be solved without slowing down the existing cases.
>
> Ted Ts'o has been talking about something similar but not the same -- a
> way to revoke an entire filesystem.  For example, see commit
> 7c2e70879fc0949b4220ee61b7c4553f6976a94d (ext4: add ext4-specific
> kludge to avoid an oops after the disk disappears).
>
> The use case for that is obvious and widespread: Somebody yanks out a
> USB drive without unmounting it first.

Agreed.  The best I have at the moment is a library that can wrap
filesystem methods to implement the hotplug bits.

Do you know how hard it is to remove event up to the filesystem that
sits on top of a block device?

Do you know how hard it is to detect at mount time if a block device
might be hot-plugable?  We can always use a mount option here and
make userspace figure it out, but being to have a good default would
be nice.

If it isn't too hard to get the event up from the block device to the
filesystem when the block device is uncermoniously removed I might just
make the time to have hotunplug trigger a filesystem wide revoke on a
filesystem like ext4.

In addition to sysfs we need the same logic in proc, sysctl, and uio.
So it makes sense to move towards a common library that can do all of
the hard bits.

I just notice that sysctl is currently sysctl is broken in design if not
in practice by having poll methods that will break if you unregister
the sysctls.  Fortunately for the time being we don't have any sysctls
where that case comes up.

Eric
