Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab2KMCvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 21:51:18 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:34321 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2KMCvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 21:51:17 -0500
Message-ID: <50A1B59D.1020106@linux.vnet.ibm.com>
Date: Tue, 13 Nov 2012 10:51:09 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pawel.sikora@agmk.net>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, arekm@pld-linux.org,
        baggins@pld-linux.org
Subject: Re: [3.6.6] panic on reboot / khungtaskd blocked? (WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule)
References: <56378024.A3Kec8xZj0@pawels> <50A0A7EF.3050706@linux.vnet.ibm.com> <1539324.MIArxLN8tE@pawels> <3023364.Bjpo0brdul@pawels>
In-Reply-To: <3023364.Bjpo0brdul@pawels>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12111302-2000-0000-0000-000009D88C1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 08:33 PM, Paweł Sikora wrote:
> On Monday 12 of November 2012 11:22:47 Paweł Sikora wrote:
>> On Monday 12 of November 2012 15:40:31 Michael Wang wrote:
>>> On 11/12/2012 03:16 PM, Paweł Sikora wrote:
>>>> On Monday 12 of November 2012 11:04:12 Michael Wang wrote:
>>>>> On 11/09/2012 09:48 PM, Paweł Sikora wrote:
>>>>>> Hi,
>>>>>>
>>>>>> during playing with new ups i've caught an nice oops on reboot:
>>>>>>
>>>>>> http://imgbin.org/index.php?page=image&id=10253
>>>>>>
>>>>>> probably the upstream is also affected.
>>>>>
>>>>> Hi, Paweł
>>>>>
>>>>> Are you using a clean 3.6.6 without any modify?
>>>>
>>>> yes, pure 3.6.6 form git tree with modular config.
>>>>
>>>>> Looks like some threads has set itself to be UNINTERRUPTIBLE with out
>>>>> any design on switch itself back later(or the time is too long), are you
>>>>> accidentally using some bad designed module?
>>>>
>>>> hmm, hard to say. mostly all modules are loaded automatically by kernel.
>>>
>>> Could you please provide the whole dmesg in text? your picture lost the
>>> print info of the hung task.
>>
>> i've grabbed the console via rs232 but there's no more info (see attached txt).
> 
> hmm, i have one observation.
> 
> during rc.shutdown there're messages on console like this: Cannot stat file /proc/$pid/fd/1: Connection timed out
> afaics this file descriptor points to vnc log file on a remote machine, e.g.:
> 
> # ps aux|grep xfwm4
> eda       1748  0.0  0.0 320220 11224 ?        S    13:08   0:00 xfwm4 
> 
> # readlink -m /proc/1748/fd/1
> /remote/dragon/ahome/eda/.vnc/odra:11.log
> 
> # mount|grep ahome
> dragon:/home/users/ on /remote/dragon/ahome type nfs (rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,soft,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.0.2.121,mountvers=3,mountport=45251,mountproto=udp,local_lock=none,addr=10.0.2.121)
> 

We can report the bug to driver folks, but have to make sure whether
the hung thread is belong to it firstly, so we need the hung task info
(at least the name).

I'm not sure what's the environment we faced, but setup debug method is
necessary, 'script' may help you to record the dmesg even when remote
console hung.

If it's really hard to get dmesg, please try below modify and
see whether the info print out on console.

Regards,
Michael Wang



diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c2e077c..2f1b718 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4504,7 +4504,7 @@ void sched_show_task(struct task_struct *p)
        unsigned state;
 
        state = p->state ? __ffs(p->state) + 1 : 0;
-       printk(KERN_INFO "%-15.15s %c", p->comm,
+       printk(KERN_EMERG "%-15.15s %c", p->comm,
                state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
        if (state == TASK_RUNNING)


> 
> so, probably during `killall5 -TERM/-KILL` on shutdown stage something sometimes go wrong
> and these processes (xfce4/vncserver) survive the signal and hang on the nfs i/o.
> 
> BR,
> Paweł.
> 

