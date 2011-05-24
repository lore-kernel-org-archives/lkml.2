Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab1EXCDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 22:03:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39995 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1EXCDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 22:03:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB11F4.2070903@jp.fujitsu.com>
Date: Tue, 24 May 2011 11:03:32 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: rientjes@google.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6207E.1070300@jp.fujitsu.com> <alpine.DEB.2.00.1105231529340.17840@chino.kir.corp.google.com> <4DDB0B45.2080507@jp.fujitsu.com> <alpine.DEB.2.00.1105231838420.17729@chino.kir.corp.google.com> <4DDB1028.7000600@jp.fujitsu.com> <alpine.DEB.2.00.1105231856210.18353@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105231856210.18353@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/24 10:58), David Rientjes wrote:
> On Tue, 24 May 2011, KOSAKI Motohiro wrote:
>
>>>>> This is unnecessary and just makes the oom killer egregiously long.  We
>>>>> are already diagnosing problems here at Google where the oom killer
>>>>> holds
>>>>> tasklist_lock on the readside for far too long, causing other cpus
>>>>> waiting
>>>>> for a write_lock_irq(&tasklist_lock) to encounter issues when irqs are
>>>>> disabled and it is spinning.  A second tasklist scan is simply a
>>>>> non-starter.
>>>>>
>>>>>     [ This is also one of the reasons why we needed to introduce
>>>>>       mm->oom_disable_count to prevent a second, expensive tasklist scan.
>>>>> ]
>>>>
>>>> You misunderstand the code. Both select_bad_process() and
>>>> oom_kill_process()
>>>> are under tasklist_lock(). IOW, no change lock holding time.
>>>>
>>>
>>> A second iteration through the tasklist in select_bad_process() will
>>> extend the time that tasklist_lock is held, which is what your patch does.
>>
>> It never happen usual case. Plz think when happen all process score = 1.
>>
>
> I don't care if it happens in the usual case or extremely rare case.  It
> significantly increases the amount of time that tasklist_lock is held
> which causes writelock starvation on other cpus and causes issues,
> especially if the cpu being starved is updating the timer because it has
> irqs disabled, i.e. write_lock_irq(&tasklist_lock) usually in the clone or
> exit path.  We can do better than that, and that's why I proposed my patch
> to CAI that increases the resolution of the scoring and makes the root
> process bonus proportional to the amount of used memory.

Do I need to say the same word? Please read the code at first.



