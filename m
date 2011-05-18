Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab1ERAxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:53:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37369 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1ERAxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:53:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD3187C.3050408@jp.fujitsu.com>
Date: Wed, 18 May 2011 09:53:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl
CC: mingo@elte.hu, john.stultz@linaro.org, linux-kernel@vger.kernel.org,
        joe@perches.com, mina86@mina86.com, apw@canonical.com,
        jirislaby@gmail.com, rientjes@google.com, dave@linux.vnet.ibm.com,
        akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] comm: Introduce comm_lock spinlock to protect task->comm
 access
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org>	 <1305665263-20933-2-git-send-email-john.stultz@linaro.org>	 <20110517212734.GB28054@elte.hu> <1305669256.2466.6286.camel@twins>
In-Reply-To: <1305669256.2466.6286.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/18 6:54), Peter Zijlstra wrote:
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
>>
>> Why does this matter so much? A NULL string is not a big deal.
>>
>> Note, since task->comm is 16 bytes there's the CMPXCHG16B instruction on x86
>> which could be used to update it atomically, should atomicity really be
>> desired.
>
> The changelog also fails to mention _WHY_ this is no longer true. Nor
> does it treat why making it true again isn't an option.
>
> Who is changing another task's comm? That's just silly.

I'm not sure it's silly or not. But the fact is, comm override was introduced
following patch. Personally I'd like to mark it to "depend on EXPERT". but John
seems to dislike the idea.



commit 4614a696bd1c3a9af3a08f0e5874830a85b889d4
Author: john stultz <johnstul@us.ibm.com>
Date:   Mon Dec 14 18:00:05 2009 -0800

     procfs: allow threads to rename siblings via /proc/pid/tasks/tid/comm


