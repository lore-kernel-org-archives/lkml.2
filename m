Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2DZIML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:12:11 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49364 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab2DZIMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:12:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1204251436140.1206-100000@iolanthe.rowland.org>
	<20120425215936.GC8989@google.com>
Date: Thu, 26 Apr 2012 01:16:05 -0700
In-Reply-To: <20120425215936.GC8989@google.com> (Tejun Heo's message of "Wed,
	25 Apr 2012 14:59:36 -0700")
Message-ID: <m162cmewmy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19gq/qSg+J2J16CdApN/ecs16Z8rOkRfRk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: **
Subject: Re: Lockdep false positive in sysfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Alan.
>
> On Wed, Apr 25, 2012 at 02:58:28PM -0400, Alan Stern wrote:
>> Peter and Tejun:
>> 
>> Here's my problem, which affects several sysfs attribute methods in the 
>> USB subsystem:
>> 
>> Sysfs attribute A is attached to a USB device D.  When the user writes
>> to A, the corresponding store method unregisters D's children (it does
>> not unregister D, though).
>> 
>> Now, some of these children may also be USB devices (i.e., if D is a
>> hub), and therefore may have the same set of sysfs attributes.  As a
>> result, A's store method for D will end up removing the A attribute for
>> device E, where E is a child of D.

Before we get too far getting lockdep to shut up let me ask.  Is this
really safe?  The code looks like it tries to be safe but in the case
of recursion I don't buy it.  You should be having this same problem
with other locks and I don't see the use of mutex_lock_nested anywhere.

I looked into this a couple years ago with regards to pci devices, and
my conclusion at the time was that the device core nor the pci
code was multi-thread hotplug safe, and that the easiest fix was
to use a single threaded workqueue.

What I see right now with the device_lock and usb looks better but
I'm not at all certain I believe that if you attempt to remove different
levels of the hierarchy at the same time from different processes
that this code is really safe.  Could you explain to me how the
locking works in the usb layer to prevent problems with different
processes removing different layers of the same hierarchy?

Especially having it work without having having to do something
interesting with lockdep.

>> This causes lockdep to complain.  When A's method is called, sysfs
>> tells lockdep that it holds a readlock for the s_active "rwsem"
>> associated with the A attribute for D.  However the sysfs routine that
>> removes attributes tells lockdep that it is going to get a writelock
>> for the s_active associated with the A attribute for E, which is in the
>> same lockdep class since it belongs to the same attribute.
>
> Hmmm.... This happens because, by default, sysfs_dirents for the same
> attr share the same lockdep key.  This happens from
> sysfs_dirent_init_lockdep().  Hmm.... we can,
>
> * Somehow assign different keys to sysfs_dirents for the specific
>   attr.  Use array of attrs indexed by bus depth?

Possible with sysfs_attr_init but pretty ugly.  Especially since it
sounds like this is a situation that does not presuppose a maximum
depth.  I do remember that the lockdep keys must be statically allocated
which makes this a challenge.

Or it might be a remote possibility to adapt things a little bit.
What makes this different from most of the recursing lock strategies
that I know of is that we are actually in fact taking the same
"lock" in the same place, and performing the same action.

> * Add a flag / whatever to attr indicating that the files of the
>   attribute may be removed recursively (lockdep-wise) and update
>   either read or write path to use subclass.
>
> Any better ideas?

I'm not going to worry about it too much until someone explains to me
how usb hotplug is really safe and how of all the locks taken to
make it happen somehow only the sysfs lock triggers a lockdep warning
because we are recursing.  We should be seeing the same issue with
the device lock if the device lock actually provides sufficient
protection to be useful.

Eric
