Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2D0VJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:09:43 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50898 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2D0VJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:09:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <87haw55eed.fsf@xmission.com>
	<Pine.LNX.4.44L0.1204271410470.1690-100000@iolanthe.rowland.org>
	<20120427201704.GK26595@google.com>
Date: Fri, 27 Apr 2012 14:09:22 -0700
In-Reply-To: <20120427201704.GK26595@google.com> (Tejun Heo's message of "Fri,
	27 Apr 2012 13:17:04 -0700")
Message-ID: <878vhg3mrh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+0u4jhAERQoo2oC4giX3MtOU+uN0iXVow=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0018]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: **
Subject: Re: Lockdep false positive in sysfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> On Fri, Apr 27, 2012 at 02:27:26PM -0400, Alan Stern wrote:
>> Which do you prefer: temporarily dropping the lockdep annotation, or
>> deferring the work to the per-task work queue?  Note that these "flush
>> before returning to userspace" things aren't in the kernel yet.
>
> It's about lockdep.  Let's not spill out to other areas unnecessarily.
> I'd much prefer just working around lockdep annotation.

It is also about a locking scheme that makes analysis hard.

Doing something so we don't have false lockdep warnings is good
so people can concentrate on things that are clearly problems.

However it would be nice if we could sort out the locking so that it
isn't so tricky that neither lockdep nor sparse can figure it out.

I have the sneaking suspicion that idioms that tangle up our automatic
tools are also idioms that are likely to result in maintenance problems
at some point.

Another possibility to to look at the situation and realize that pci has
a maxium depth of 256 (bus numbers). And that usb also has a maxium
depth of I believe 256 ( If I read it right usb hubs are transparent to
usb enumeration so the maximum depth is the maximum number of usb ids
and I think the usb id is a 8 bit number).  I don't think anything else
even nests so deeply.  So it may be reasonable to declare an array of
256 or perhaps 1024 lockdep keys and limit the device tree when lockdep
is enabled to 1024 layers deep.

At which point we are at a point where lockdep can actually analyze the
behavior.

I don't mind the attitude we are clever careful programmers we can
handle the complexity and we can get away without the tool help us, but
I would much rather see the attitude that we are clever careful
programmers and we can figure out how to make the tool help us instead
of just ignoring it.

Eric
