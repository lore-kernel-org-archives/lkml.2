Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab0EOOPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 10:15:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab0EOOPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 10:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VbzMzOMo1ifyavT3QwlcUztAcdusVzxetPqrY4MDuuAa7exc0wWyAyg7i2L823j/qy
         kmrW6dV9HgjrQFZhgOTIhMsP96oKaCJPcHY97bbZAjXDo3YMGOx+Turu2px1094Laovj
         rwStcuj2D6rMtyO7T8kMWJSDj0o85RFFgY/Ec=
Message-ID: <4BEEACED.8030004@gmail.com>
Date: Sat, 15 May 2010 18:17:17 +0400
From: Andrew Vagin <avagin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>, Andrey Vagin <avagin@openvz.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 2/2] posix_timer: clean up properly if anything fails
 after *_timer_create
References: <1273843731-12595-1-git-send-email-avagin@openvz.org> <1273843731-12595-2-git-send-email-avagin@openvz.org> <20100514160357.GB3727@redhat.com> <20100514191800.3e3b6655@dhcp-lab-109.englab.brq.redhat.com> <20100514184850.GA11352@redhat.com>
In-Reply-To: <20100514184850.GA11352@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 10:48 PM, Oleg Nesterov wrote:
> On 05/14, Stanislaw Gruszka wrote:
>    
>> On Fri, 14 May 2010 18:03:57 +0200
>> Oleg Nesterov<oleg@redhat.com>  wrote:
>>
>>      
>>> On 05/14, Andrey Vagin wrote:
>>>        
>>>> @@ -613,6 +613,8 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
>>>>   	 * and may cease to exist at any time.  Don't use or modify
>>>>   	 * new_timer after the unlock call.
>>>>   	 */
>>>> +out_cleanup:
>>>> +	CLOCK_DISPATCH(new_timer->it_clock, timer_cleanup, (new_timer));
>>>>          
>>> But at first glance you are right, posix_cpu_timer_create() does
>>> get_task_struct(it.cpu.task).
>>>        
>> If I understand problem correctly, seems to be fine to move
>> CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
>> after all possible EFAULT errors and solve leak without creating
>> new timer_cleanup() callback.
>>      
> I thought about this too, we are doing copy_to_user(created_timer_id)
> "in advance" anyway. Probably we can move all this code block
>
> 	new_timer->it_id = (timer_t) new_timer_id;
> 	new_timer->it_clock = which_clock;
> 	new_timer->it_overrun = -1;
> 	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
> 	if (error)
> 		goto out;
>
> down, right before we take ->siglock.
>    
You are right. I will send a new patch sooner. Thanks for your comments.
> But I don't understand the change in posix_cpu_timer_del() from 1/2.
>    
timer_cleanup doesn't do the disarm timer. In case fail in timer_create 
it's enough to call timer_cleanup. This changes are not necessary in new 
version.
>
> Otoh, currently "The next step is hard to back out if there is an error"
> comment is not right, release_posix_timer() does put_pid(). We can
> move copy_to_user(created_timer_id) down after "if (timer_event_spec)"
> block too. (but before CLOCK_DISPATCH(), of course).
>
> Andrey, what do you think?
>    
I've look at code again and think that you are right. At first I created 
patches for 2.6.18 kernel, more complex code in this place and the 
comment "the next step is ..." induced me to make callback timer_cleanup.
> Oleg.
>
>    

