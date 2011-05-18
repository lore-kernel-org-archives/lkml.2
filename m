Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab1ERBDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:03:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35113 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1ERBDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:03:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD31AB4.4050007@jp.fujitsu.com>
Date: Wed, 18 May 2011 10:02:44 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: john.stultz@linaro.org
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, joe@perches.com,
        mina86@mina86.com, apw@canonical.com, jirislaby@gmail.com,
        rientjes@google.com, dave@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-mm@kvack.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock spinlock to protect task->comm
 access
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org>	 <1305665263-20933-2-git-send-email-john.stultz@linaro.org>	 <20110517212734.GB28054@elte.hu> <1305671225.2915.133.camel@work-vm>
In-Reply-To: <1305671225.2915.133.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/18 7:27), John Stultz wrote:
> On Tue, 2011-05-17 at 23:27 +0200, Ingo Molnar wrote:
>> * John Stultz<john.stultz@linaro.org>  wrote:
>>
>>> The implicit rules for current->comm access being safe without locking are no
>>> longer true. Accessing current->comm without holding the task lock may result
>>> in null or incomplete strings (however, access won't run off the end of the
>>> string).
>>
>> This is rather unfortunate - task->comm is used in a number of performance
>> critical codepaths such as tracing.

Right.


>> Why does this matter so much? A NULL string is not a big deal.
>
> I'll defer to KOSAKI Motohiro and David on this bit. :)

Heh, I did ask you current locking rule of task->comm after you introduced
writable /proc/<pid>/comm.


>> Note, since task->comm is 16 bytes there's the CMPXCHG16B instruction on x86
>> which could be used to update it atomically, should atomicity really be
>> desired.
>
> Could we use this where cmpxchg16b is available and fall back to locking
> if not? Or does that put too much of a penalty on arches that don't have
> cmpxchg16b support?
>
> Alternatively, we can have locked accessors that are safe in the
> majority of slow-path warning printks, and provide unlocked accessors
> for cases where the performance is critical and the code can properly
> handle possibly incomplete comms.

Probably, this is safer choice.

