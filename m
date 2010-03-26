Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab0CZHx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 03:53:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51587 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0CZHxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 03:53:54 -0400
To: Neil Brown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sysfs: simplify handling for s_active refcount
References: <20100324031829.2136.66489.stgit@notabene.brown>
	<20100324032008.2136.52640.stgit@notabene.brown>
	<m139znogl0.fsf@fess.ebiederm.org>
	<20100326163236.1ffb2c2b@notabene.brown>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 26 Mar 2010 00:53:48 -0700
In-Reply-To: <20100326163236.1ffb2c2b@notabene.brown> (Neil Brown's message of "Fri\, 26 Mar 2010 16\:32\:36 +1100")
Message-ID: <m1bpebfrhv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: neilb@suse.de, linux-kernel@vger.kernel.org, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> writes:

> On Thu, 25 Mar 2010 21:24:43 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> NeilBrown <neilb@suse.de> writes:
>> 
>> > s_active counts the number of active references to a 'sysfs_direct'.
>> > When we wish to deactivate a sysfs_direct, we subtract a large
>> > number for the refcount so it will always appear negative.  When
>> > it is negative, new references will not be taken.
>> > After that subtraction, we wait for all the active references to
>> > drain away.
>> >
>> > The subtraction of the large number contains exactly the same
>> > information as the setting of the flag SYSFS_FLAG_REMOVED.
>> > (We know this as we already assert that SYSFS_FLAG_REMOVED is set
>> > before adding the large-negative-bias).
>> > So doing both is pointless.
>> >
>> > By starting s_active with a value of 1, not 0 (as is typical of
>> > reference counts) and using atomic_inc_not_zero, we can significantly
>> > simplify the code while keeping exactly the same functionality.
>> 
>> Overall your logic appears correct but in detail this patch scares me.
>> 
>> sd->s_flags is protected by the sysfs_mutex, and you aren't
>> taking it when you read it.  So in general I don't see the new check
>> if (sd->s_flags & SYSFS_FLAG_REMOVED) == 0 providing any guarantee of
>> progress whatsoever with user space applications repeated reading from
>> a sysfs file when that sysfs file is being removed.  They could easily
>> have the sd->s_flags value cached and never see the new value, given a
>> crazy enough cache architecture.
>
> As you say, this is only a liveness issue.  The atomic_inc_not_zero
> guarantees that we don't take a new reference after the last one is gone.
> The test on SYSFS_FLAG_REMOVED is only there to ensure that the count does
> eventually get to zero.
> There could only be a problem here if the change to s_flags was not
> propagated to all CPUs in some reasonably small time.

Having this handled correctly is a key part of the abstraction
implemented with sysfs_get_active sysfs_put_active and
sysfs_deactivate.  It is a requirement that userspace can not cuause
denial of service attacks on the rest of the kernel.

> I'm not expert on these things but it was my understanding that interesting
> cache architectures could arbitrarily re-order accesses, but does not delay
> them indefinitely.
> Inserting barriers could possibly make this more predictable, but that would
> just delay certain loads/stores until a known state was reached - it would
> not make the data visible at another CPU any faster (or would it?).

> So unless there is no cache-coherency protocol at all, I think that
> SYSFS_FLAG_REMOVED will be seen promptly and that s_active will drop to zero
> and quickly as it does today.

This is my problem with your patch.  You have replaced something that
used an existing abstraction properly, with something that does not
use any abstraction at all and we are reduced to talking about cpu
memory ordering requirements.

Furthermore this code you are changing is not used raw but it is the
building blocks for a well defined abstraction.  The users of
sysfs_get_active sysfs_put_active and sysfs_deactivate don't have to
know the details of how they are implemented to think about and
reason about it accurately.

I am very much in favor of a general primitive that we can use for
blocking ref counts.  We have them in sysfs, proc, sysctl, and a few
other places with similar requirements.  Each location has a different
implementation, but essentially the same semantics.

What is really needed is something with the semantics of:
read_trylock
read_unlock
write_lock() perhaps synchronize?

With multiple reads in side the read side critical section, and 
biased so that the read side is very cheap, and the data structure
size is very cheap.  We have an ugly but otherwise near optimal
implementation in sysfs.  srcu is close the data structure
costs too much to use on every sysfs dirent.

Improving and getting it right is very attractive.  The code that
exists today is correct and signals that something fishy is going
on so there is no point in doing something less than right.

Eric

