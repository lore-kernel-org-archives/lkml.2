Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2A3Frv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 00:47:51 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:59350 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab2A3Frt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 00:47:49 -0500
Message-ID: <4F262ED9.7040003@linux.vnet.ibm.com>
Date: Mon, 30 Jan 2012 13:47:05 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Xiaotian Feng <xtfeng@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Accelerate "pick_next_entity" under special
 condition
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com> <CAJn8CcHhaSA5kF9KVjMorzt_2NM-dTPc5mTr3-A9GvR54VRo=A@mail.gmail.com> <4F14E54E.80904@linux.vnet.ibm.com> <1327506934.2614.87.camel@laptop> <20120126100429.GA3853@elte.hu> <4F21FC69.6040402@linux.vnet.ibm.com> <4F222B2B.6010602@gmail.com> <4F24E804.5090808@linux.vnet.ibm.com> <20120129163328.GC23408@elte.hu> <4F260BFE.2070503@linux.vnet.ibm.com> <4F260DAE.4000008@gmail.com>
In-Reply-To: <4F260DAE.4000008@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12013005-4790-0000-0000-00000115715A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 11:25 AM, Cong Wang wrote:

> On 01/30/2012 11:18 AM, Michael Wang wrote:
>> But the sched.o under ./arch/x86/kernel/cpu/ still not change...
>> I think I may checking the wrong file, because this patch is for fair.c.
>>
>> And the fair.o changed after apply the patch, the size is a little
>> bigger, and the gcc generated code changed.
>>
>> But I still don't know what can we get from this result? Bigger size is
>> caused by additional code, but these additional code will help to step
>> over some unnecessary code under special condition, looks like some
>> balance between size and performance...
> 
> As your patch reduces the conditionals from 24 to 14, so it is possible
> that it also reduces the size of the code too. This is Ingo's point.
> 


I think the number reduce because we can ignore some condition in
special case after applied the patch, but all the old code are still
needed, the compiled code should like:

old:

check condition 1
	process condition 1
check condition 2
	process condition 2
check condition 3
	process condition 3
return

new:

check condition 3
	process condition 3
	jump to label		//we can step over some code here
check condition 2
	process condition 2
	jump to label
check condition 1
	process condition 1
label:return

We can do this change because the priority is 3 > 2 > 1.

So while the code is running and the condition 3 matched, the cpu don't
need to run the code "check condition 2" and "check condition 1".

But those code is still needed, and we can see the "jump to label" will
be the additional code which is the reason of bigger size.

Regards,
Michael Wang

> You need to check the diff to see why gcc actually generates bigger code.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


