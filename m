Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab1EXBOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:14:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47374 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab1EXBOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:14:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB0669.6040409@jp.fujitsu.com>
Date: Tue, 24 May 2011 10:14:17 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram
 internally
References: <4DD61F80.1020505@jp.fujitsu.com>	<4DD6204D.5020109@jp.fujitsu.com> <BANLkTim2-uncnzoHwdG+4+uCv+Ht4YH3Qw@mail.gmail.com>
In-Reply-To: <BANLkTim2-uncnzoHwdG+4+uCv+Ht4YH3Qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


>> @@ -476,14 +476,17 @@ static const struct file_operations proc_lstats_operations = {
>>
>>   static int proc_oom_score(struct task_struct *task, char *buffer)
>>   {
>> -       unsigned long points = 0;
>> +       unsigned long points;
>> +       unsigned long ratio = 0;
>> +       unsigned long totalpages = totalram_pages + total_swap_pages + 1;
>
> Does we need +1?
> oom_badness does have the check.

"ratio = points * 1000 / totalpages;" need to avoid zero divide.

>>         /*
>>          * Root processes get 3% bonus, just like the __vm_enough_memory()
>>          * implementation used by LSMs.
>> +        *
>> +        * XXX: Too large bonus, example, if the system have tera-bytes memory..
>>          */
>> -       if (has_capability_noaudit(p, CAP_SYS_ADMIN))
>> -               points -= 30;
>> +       if (has_capability_noaudit(p, CAP_SYS_ADMIN)) {
>> +               if (points>= totalpages / 32)
>> +                       points -= totalpages / 32;
>> +               else
>> +                       points = 0;
>
> Odd. Why do we initialize points with 0?
>
> I think the idea is good.

The points is unsigned. It's common technique to avoid underflow.


