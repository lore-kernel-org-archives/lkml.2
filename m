Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab1GZH3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:29:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59646 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1GZH3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:29:44 -0400
MIME-Version: 1.0
In-Reply-To: <4E2E6102.3060600@jp.fujitsu.com>
References: <1311599418-1915-1-git-send-email-yong.zhang0@gmail.com>
	<4E2E507F.7030607@jp.fujitsu.com>
	<CAM2zO=CGkVCMNZS8F6LxFi-NdYXf0fDLB_AEc00xrPvO_D02qw@mail.gmail.com>
	<4E2E6102.3060600@jp.fujitsu.com>
Date: Tue, 26 Jul 2011 15:29:43 +0800
Message-ID: <CAM2zO=CxriXK4bqGbwhfkfdgSpGwe1mAJE=6cYpDAf0Hxji0sQ@mail.gmail.com>
Subject: Re: [PATCH] proc/softirqs: only show state for online cpus
From: Yong Zhang <yong.zhang0@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kobayashi.kk@ncos.nec.co.jp
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 2:38 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> (2011/07/26 15:14), Yong Zhang wrote:
>> 2011/7/26 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>>>> Like /proc/interrupts, no need to output data for nobody.
>>>>
>>>> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
>>>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>>
>>> If the cpu never be onlined, its statistics always 0. Then, it definitely
>>
>> Yeah, so your screen may contain noise.
>
> One question. Is this big matter?

Actually it doesn't :)

> Who see /proc/softirqs and /proc/interrupts directly? (i.e. by 'cat' command).

By accident I noticed it by accident when running rt kernel. My screen
is full of '0'.
You know my usage is just for testing, maybe the real user is script-like.

>
>
>>> no value. In the other hand, if the cpu was offlined dynamically, we don't
>>> know the user want to know the cpus's statistics or not.
>>
>> Same to /proc/interrupts :)
>>
>> IMHO, if user want to check the value of offline-cpu, maybe that means
>> he want to check the state of the whole system, /proc/stat should be the
>> right choice. /proc/{softirqs,interrupts} is just for immediate state.
>>
>>> Anyway, it's incompatibility change.
>>
>> Yup, I should have marked the patch with RFC :)
>
> And I should have remarked I don't dislike this patch so strongly, so
> if kobayashi-san who original /proc/softirqs author ack you, I'm going
> to second him.

Hmmm, so let kobayashi-san decide it.

>
>
> Offtopic, /proc/interrupt should be protected by get_online_cpus().
> Otherwise the header (i.e. cpu number) and the actual statistics fields
> can be mismatched likes following. Am I missing something?

I think you are right. The reader could be preempted by cpu hotplug.

After searching the whole tree, only s390 take cpu_hotplug.lock,
but its usage is not currect:

arch/s390/kernel/irq.c:
int show_interrupts(struct seq_file *p, void *v)
{
          get_online_cpus();
          .........
          put_online_cpus();
}

Because the reader will call show_interrupts nr_irqs times.
So get_online_cpus()/put_online_cpus() should be put upper,
maybe interrupts_open(). How do you think about it?

Thanks,
Yong


-- 
Only stand for myself
