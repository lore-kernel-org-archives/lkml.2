Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0HSOXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:23:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:49579 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0HSOXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:23:38 -0400
Message-ID: <4C6D3D5C.7010504@kernel.org>
Date: Thu, 19 Aug 2010 16:19:08 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Luis Rodriguez <lrodriguez@atheros.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Regression, 2.6.36-rc1] ath9k resume problem on Acer Ferrari
 One
References: <201008190001.11342.rjw@sisk.pl> <4C6CE715.4010203@kernel.org> <201008191605.08053.rjw@sisk.pl>
In-Reply-To: <201008191605.08053.rjw@sisk.pl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 19 Aug 2010 14:22:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/19/2010 04:05 PM, Rafael J. Wysocki wrote:
> On Thursday, August 19, 2010, Tejun Heo wrote:
>> Hello, Rafael.
>>
>> On 08/19/2010 12:01 AM, Rafael J. Wysocki wrote:
>>> While testing 2.6.36-rc1 (with a couple of fixes on top) I noticed
>>> that the ath9k driver didn't work after resume from suspend to RAM.
>>> An attempt to unload the driver using rmmod caused the BUG_ON() in
>>> kernel/workqueue.c:2844 to trigger.
>>
>> That BUG_ON() triggers if destroy_workqueue() is called while work
>> items are still pending on the workqueue.  Can you please trigger
>> stack traces after resume and post it?
> 
> Do you mean sysrq-t?

Yeah, I'm a bit confused regarding what's going on.  I thought the
most likely cause is thawing failing to kick a frozen workqueue into
working state but then flush_workqueue() which is called from
destroy_workqueue() should have hung too, that is, unless
flush_workqueue() is broken too.  If flush_workqueue() is not broken,
then it could be that workqueue itself isn't at fault and works are
being scheduled and executed fine for the workqueue ath9k is using but
the driver doesn't work for another reason.

Also, the BUG_ON() being triggered means either flush_workqueue() is
broken or the driver is failing to stop works on the workqueue from
being requeued before calling destroy_workqueue().  So, finding out
the followings would be great,

* While the driver isn't working, do a sysrq-t and see whether any
  worker is executing a work for ath9k.

* Repeat it several times and see whether the work is stuck or making
  progress and/or executing on different workers.

Thanks.

-- 
tejun
