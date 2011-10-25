Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1JYOdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:33:08 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:52565 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab1JYOdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:33:06 -0400
X-Greylist: delayed 1191 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Oct 2011 10:33:06 EDT
X-ASG-Debug-ID: 1319551994-03d6a50f2b1ffe80001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4EA6C3F7.20604@fusionio.com>
Date: Tue, 25 Oct 2011 16:13:11 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] blk-throttle: Take blkcg->lock while traversing blkcg->policy_list
References: <1319144906-5066-1-git-send-email-vgoyal@redhat.com> <1319144906-5066-2-git-send-email-vgoyal@redhat.com> <20111020211140.GY25124@google.com> <20111020212021.GA2841@redhat.com> <20111020212958.GA25124@google.com> <20111021121043.GB6474@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 2/2] blk-throttle: Take blkcg->lock while traversing blkcg->policy_list
In-Reply-To: <20111021121043.GB6474@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1319551994
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.78360
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-21 14:10, Vivek Goyal wrote:
> On Thu, Oct 20, 2011 at 02:29:58PM -0700, Tejun Heo wrote:
>> Hello,
>>
>> On Thu, Oct 20, 2011 at 05:20:21PM -0400, Vivek Goyal wrote:
>>> The only problem with this approach is that it will cleanup per device
>>> weight rules also at elevator_exit() time which is not same as device
>>> removal and one might device to bring CFQ back on device and we will
>>> need the rules again.
>>
>> I actually think removoing those rules on elevator detach would be the
>> right thing to do.  We don't try to keep cfq setting across elevator
>> switch.  When we're switching from cfq, we're detaching iocg policy
>> too.  The settings going away is perfectly fine.  I actually think
>> it's a pretty bad idea to implement ad-hoc setting persistence in
>> kernel.  Just making sure that userland is notified is far better
>> approach.  Userland has all the facilities to deal with this type of
>> situations.
>>
>> When switching from cfq to deadline, we lose the whole proportional io
>> control.  It's way more confusing to have lingering settings which
>> don't do anything.
> 
> I am not so sure about this. Suppose tomorrow another IO sheduler starts
> taking into account the cgroup gloabl weight or cgroup per device weight
> to do some kind of IO prioritization, then removing the rules upon
> changing the IO schduler will not make sense.
> 
> IOW, rules are per cgroup per device and not per cgroup per IO scheduler
> and more than one IO scheduler should be able to share the rules.

FWIW, I agree with Tejun here. A switch operation is a reset, start from
scratch. We don't preserve other per IO-scheduler settings on a switch,
preserving _some_ settings is just confusing.

-- 
Jens Axboe

