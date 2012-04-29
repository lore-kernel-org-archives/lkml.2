Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab2D2Cb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 22:31:27 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48792 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab2D2Cb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 22:31:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1204282153520.6752-100000@netrider.rowland.org>
Date: Sat, 28 Apr 2012 19:35:32 -0700
In-Reply-To: <Pine.LNX.4.44L0.1204282153520.6752-100000@netrider.rowland.org>
	(Alan Stern's message of "Sat, 28 Apr 2012 22:00:01 -0400 (EDT)")
Message-ID: <m1obqb8du3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18d5Uuy1+eohAS04Tr2mMlyz8W4OtzrNEk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0469]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Stern <stern@rowland.harvard.edu>
X-Spam-Relay-Country: 
Subject: Re: Lockdep false positive in sysfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Fri, 27 Apr 2012, Eric W. Biederman wrote:
>
>> However it would be nice if we could sort out the locking so that it
>> isn't so tricky that neither lockdep nor sparse can figure it out.
>> 
>> I have the sneaking suspicion that idioms that tangle up our automatic
>> tools are also idioms that are likely to result in maintenance problems
>> at some point.
>
> That may well be true, but it won't be easy to avoid them.  At the
> least, it would require a careful analysis of the device tree usage.
>
>> Another possibility to to look at the situation and realize that pci has
>> a maxium depth of 256 (bus numbers). And that usb also has a maxium
>> depth of I believe 256 ( If I read it right usb hubs are transparent to
>> usb enumeration so the maximum depth is the maximum number of usb ids
>> and I think the usb id is a 8 bit number).
>
> USB has a maximum depth of 7 or so.  It's limited by the number of hubs 
> allowed on the path between the host and a device.
>
>>  I don't think anything else
>> even nests so deeply.  So it may be reasonable to declare an array of
>> 256 or perhaps 1024 lockdep keys and limit the device tree when lockdep
>> is enabled to 1024 layers deep.
>> 
>> At which point we are at a point where lockdep can actually analyze the
>> behavior.
>
> Unfortunately, we are not.  As I mentioned earlier, the device "tree" 
> is really a forest.  Locks are sometimes acquired in orders that are 
> not strictly downward.

Then it sounds like for the device tree in general this is a limitation.
For sysfs with your problem usb attribute this looks like a real
solution.

>> I don't mind the attitude we are clever careful programmers we can
>> handle the complexity and we can get away without the tool help us, but
>> I would much rather see the attitude that we are clever careful
>> programmers and we can figure out how to make the tool help us instead
>> of just ignoring it.
>
> I'm certainly open to suggestions as to how to improve the situation, 
> but the simple-minded "keep track of the depth in the tree" approach 
> doesn't work.

For the general device tree perhaps.  For the problem of your removal
of your sysfs attribute the solution should be sufficient.  I don't
particularly like it because it will take a lot of testing to find any
bugs that lockdep might reveal but at least you will have a fighting
chance.

I would like to look at the general problem of the device tree locking.
Unfortunately I am tilting at enough other windmills right now that I
can't do that problem justice.

Eric
