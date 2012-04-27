Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734Ab2D0Q1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:27:20 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42920 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760629Ab2D0Q1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:27:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1204271147330.1690-100000@iolanthe.rowland.org>
Date: Fri, 27 Apr 2012 09:27:06 -0700
In-Reply-To: <Pine.LNX.4.44L0.1204271147330.1690-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Fri, 27 Apr 2012 11:57:02 -0400 (EDT)")
Message-ID: <87haw55eed.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+hGqpcxutJRsRZkf1vQcJiLoQbc/GGSlc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0213]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Stern <stern@rowland.harvard.edu>
X-Spam-Relay-Country: **
Subject: Re: Lockdep false positive in sysfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Thu, 26 Apr 2012, Tejun Heo wrote:
>
>> On Thu, Apr 26, 2012 at 02:14:30PM -0400, Alan Stern wrote:
>> > > > Hmmm.... This happens because, by default, sysfs_dirents for the same
>> > > > attr share the same lockdep key.  This happens from
>> > > > sysfs_dirent_init_lockdep().  Hmm.... we can,
>> > > >
>> > > > * Somehow assign different keys to sysfs_dirents for the specific
>> > > >   attr.  Use array of attrs indexed by bus depth?
>> > > 
>> > > Possible with sysfs_attr_init but pretty ugly.  Especially since it
>> > > sounds like this is a situation that does not presuppose a maximum
>> > > depth.  I do remember that the lockdep keys must be statically allocated
>> > > which makes this a challenge.
>> 
>> The depth is limited by USB spec.
>> 
>> > I agree; this doesn't seem like a good approach.
>> 
>> It sure isn't pretty but probably best matches the situation in the
>> sense that lockdep would actually be able to know about the nesting
>> going on.
>
> By the way, do you know why attribute structures allow for dynamic keys 
> as well as static keys?  I see dynamic keys are used by attribute 
> containers, but I don't understand why.

Some attributes are allocated dynamically, but they need static keys.
It is a lockdep requirement.  So for dynamically allocated attributes
we have to smack them so they have static keys.

Almost all sysfs attributes are declared statically so the optimization
of taking the key from the attribute structure saves modifying a lot of
code and makes the code that exists easy to get correct.

Dynamically allocated attributes break in a pretty obvious way when you
try to use them with lockdep enabled so I think we have a reasonable
solution.

>> > Another idea is to have A's method temporarily drop the sysfs readlock.  
>> > Of course that would put the onus on the USB core of guaranteeing that
>> > A cannot be removed while this happens, but we can handle that.
>> 
>> Yeah, that's an easier way out.  Please make it a proper sysfs API
>> call tho so that people working on sysfs later can know of the special
>> case.
>
> I will.
>
> Would it be better to release just the lockdep annotation while
> continuing to hold the actual lock, or to really drop the lock?

We can't really drop the ``lock''.  That would imply not waiting for
all of the methods using a sysfs attributes not to finish before we
remove a sysfs attribute.  Kaboom!

Probably what would be better would figure out how to sneak in something
that for this file we tell lockdep to ignore it like you do the device
locks.  As you do for the device layer locking.

I don't like the choices available at this junction.  I have seen some
nasty ABBA deadlocks with sysfs, and anything that makes those easier to
see.

One thing that looks promising after reading lwn yesterday is what Al
and Oleg are doing with fput and a per task work queue that runs before
we return to user space.  If you could use that we could have our
cake and eat it too.   You could schedule the work in a work queue but
you could also be guaranteed that there are not any locking problems.

Do you think you could investigate that possibility?

Eric

