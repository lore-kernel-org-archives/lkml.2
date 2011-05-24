Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab1EXBcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:32:45 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38109 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1EXBco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:32:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GNxkcmI/WgRkEDePV4V8CjlSAtoel1BiaPhVgTpHKEqmVialVzCesy94VDALXtr/fe
         aDmPiWjwtgkfNhB2XhWi7cDskJQGEzIOYHgqFm8P6armxNw7x/Xvoh3vkBrIG3jcE6HU
         2FJyLw7PWcn1qTNLVVwifoBG4DJTdRXEGvRBw=
MIME-Version: 1.0
In-Reply-To: <4DDB0669.6040409@jp.fujitsu.com>
References: <4DD61F80.1020505@jp.fujitsu.com>
	<4DD6204D.5020109@jp.fujitsu.com>
	<BANLkTim2-uncnzoHwdG+4+uCv+Ht4YH3Qw@mail.gmail.com>
	<4DDB0669.6040409@jp.fujitsu.com>
Date: Tue, 24 May 2011 10:32:43 +0900
Message-ID: <BANLkTinb3Yuvrz5b-dyGYv0_HMB9+ax3yA@mail.gmail.com>
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram internally
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:14 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>
>>> @@ -476,14 +476,17 @@ static const struct file_operations
>>> proc_lstats_operations = {
>>>
>>>  static int proc_oom_score(struct task_struct *task, char *buffer)
>>>  {
>>> -       unsigned long points = 0;
>>> +       unsigned long points;
>>> +       unsigned long ratio = 0;
>>> +       unsigned long totalpages = totalram_pages + total_swap_pages + 1;
>>
>> Does we need +1?
>> oom_badness does have the check.
>
> "ratio = points * 1000 / totalpages;" need to avoid zero divide.
>
>>>        /*
>>>         * Root processes get 3% bonus, just like the __vm_enough_memory()
>>>         * implementation used by LSMs.
>>> +        *
>>> +        * XXX: Too large bonus, example, if the system have tera-bytes
>>> memory..
>>>         */
>>> -       if (has_capability_noaudit(p, CAP_SYS_ADMIN))
>>> -               points -= 30;
>>> +       if (has_capability_noaudit(p, CAP_SYS_ADMIN)) {
>>> +               if (points>= totalpages / 32)
>>> +                       points -= totalpages / 32;
>>> +               else
>>> +                       points = 0;
>>
>> Odd. Why do we initialize points with 0?
>>
>> I think the idea is good.
>
> The points is unsigned. It's common technique to avoid underflow.
>

Thanks for explanation, KOSAKI.
I need sleeping. :(



-- 
Kind regards,
Minchan Kim
