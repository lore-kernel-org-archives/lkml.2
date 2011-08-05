Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1HEBaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 21:30:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab1HEBap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 21:30:45 -0400
Message-ID: <4E3B47D6.6070707@cn.fujitsu.com>
Date: Fri, 05 Aug 2011 09:31:02 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Shaohua Li <shli@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: fio posixaio performance problem
References: <CANejiEViuKky1A7Xh0MQKBVNMj_fgzwayWyON7hFGfP3wa62SQ@mail.gmail.com> <4E3902C7.9050907@cn.fujitsu.com> <CANejiEVqFt4j1-qTVnxEAe75z0y010s=ST2XtCDDTqDEQT=EcQ@mail.gmail.com> <4E391986.90108@cn.fujitsu.com> <20110803154533.GB32385@redhat.com> <20110803175101.GC32385@redhat.com> <CANejiEXAtzExExqmTXA=hmpGh8DVVo9ncbRMdkB+avq+G3LuqQ@mail.gmail.com> <4E39FD41.4090103@cn.fujitsu.com> <CANejiEVh4hvi5S18H7XHihxZt+JcRU7W5MGpQwQc_ZtiFCa2jw@mail.gmail.com> <4E3A4DF7.3020605@cn.fujitsu.com> <20110804141210.GA429@redhat.com> <4E3B3FB5.6050607@cn.fujitsu.com>
In-Reply-To: <4E3B3FB5.6050607@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-05 09:29:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-05 09:29:43,
	Serialize complete at 2011-08-05 09:29:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-8-5 8:56, Gui Jianfeng wrote:
> On 2011-8-4 22:12, Vivek Goyal wrote:
>> On Thu, Aug 04, 2011 at 03:44:55PM +0800, Gui Jianfeng wrote:
>>
>> [..]
>>>> oh, not related per your blktrace. so we have two problems here:
>>>> 1. fio doesn't dispatch request in 8ms.
>>>> 2. no close request preempt.
>>>
>>> Yes, these're actual factors why performance is so bad.
>>>
>>>> both looks quite wield. can you post a longer blktrace output, like
>>>> for one second? the piece is too short.
>>>
>>> Attached.
>>
>> Gui, few observations from you log file.
>>
>> - preemption happened 1631 times and did not happen 527 times and idle
>>   timer fired.
>>
>> - In some cases where preemption did not happen, next request seems to
>>   be too far away (more than CFQQ_CLOSE_THR=8K sectors).
>>
>> - I noticed couple of cases where next request was with-in 8K distanace
>>   still preemption did not happen. This makes me curious. Can you please
> 
> Yes, I also noticed such case...
> 
>>   put some trace messages in should_preempt() and rq_close() call and see
>>   what's going on?
> 
> Will dig into it.
> 
>>
>> For example, following trace shows that next request is 5176 sector behind
>> the previous one completed. I am wondering why did preemption not take
>> place.
>>
>>   8,0    0      606     2.751892651 16420  D   W 512146800 + 8 [fio]
>>   8,0    2      579     2.752127950     0  C   W 512146800 + 8 [0]
>>
>>   8,0    0      609     2.752235995 16421  Q  WS 512141624 + 8 [fio]
>>   8,0    0      610     2.752238859 16421  G  WS 512141624 + 8 [fio]
>>   8,0    0      612     2.752243818 16421  I   W 512141624 + 8 [fio]
>>   8,0    0        0     2.752246262     0  m   N cfq16421S / insert_request
>>   8,0    0        0     2.752247729     0  m   N cfq16421S / add_to_rr
>>   8,0    2        0     2.759710295     0  m   N cfq idle timer fired
>>
>> Putting some extra trace messages in CFQ might help here. BTW, which 
>> kernel version are you using? 3.0?
> 
> Yes, latest upstream kernel.

Vivek,

BTW, do you have any idea why fio doesn't issue any io in 8ms?

Thanks,
Gui

> 
> Thanks,
> Gui
> 
>>
>> Thanks
>> Vivek
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


