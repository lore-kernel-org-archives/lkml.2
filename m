Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0C3XEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:04:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55722 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0C3XEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:04:50 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] tagged sysfs support
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
	<ac3eb2511003301153i43a60720hb015071e2c992199@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 30 Mar 2010 16:04:36 -0700
In-Reply-To: <ac3eb2511003301153i43a60720hb015071e2c992199@mail.gmail.com> (Kay Sievers's message of "Tue\, 30 Mar 2010 20\:53\:25 +0200")
Message-ID: <m14ojxh0mz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, netdev@vger.kernel.org, serue@us.ibm.com, bcrl@lhnet.ca, eric.dumazet@gmail.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Tue, Mar 30, 2010 at 20:30, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> The main short coming of using multiple network namespaces today
>> is that only network devices for the primary network namespaces
>> can be put in the kobject layer and sysfs.
>>
>> This is essentially the earlier version of this patchset that was
>> reviewed before, just now on top of a version of sysfs that doesn't
>> need cleanup patches to support it.
>
> Just to check if we are not in conflict with planned changes, and how
> to possibly handle them:
>
> There is the plan and ongoing work to unify classes and buses, export
> them at /sys/subsystem in the same layout of the current /sys/bus/.
> The decision to export buses and classes as two different things
> (which they aren't) is the last major piece in the sysfs layout which
> needs to be fixed.

Interesting.  We will symlinks ie:
/sys/class -> /sys/subsystem
/sys/bus -> /sys/subsystem
to keep from breaking userspace.

> It would mean that /sys/subsystem/net/devices/* would look like
> /sys/class/net/* today. But at the /sys/subsystem/net/ directory could
> be global network-subsystem-wide control files which would need to be
> namespaced too. (The network subsystem does not use subsytem-global
> files today, but a bunch of other classes do.)
>
> This could be modeled into the current way of doing sysfs namespaces?
> A /sys/bus/<subsystem>/ directory hierarchy would need to be
> namespaced, not just a single plain directory with symlinks. Would
> that work?

I'm not entirely clear on what you are doing but it all sounds like it
will fit within what I am doing.  Right now I have /sys/class/net,
/sys/devices/virtual/net and a bunch of other net directories becoming
tagged and only showing up in the appropriately mounted sysfs.  We
track them all in the class kset and as long as we extend that capability
when the subsystem change happens in sysfs all should be well.

Today we have /sys/class/net/bonding_master.  For now I have that as
an untagged but the implementation is aware of which network namespace
your current process is in.  Thinking about that a little more it
would be better to make that file tagged so that userspace can see
different versions for the different network namespaces.  Joy.

I expect other control files will be the same.

In general it doesn't make sense to add control files for networking.
as they easily conflict with legal network device names and thus create
the possibility of breaking someones userspace.

Eric
