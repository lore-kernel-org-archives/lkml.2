Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0IPJSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:18:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46922 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0IPJSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=OENBR9Hn88VAfvRxu/NQIUz22MfBZDk8jjmBPln7hcJ8iCirR+E/ROwBGJprtLJp8t
         lOlDlmxCwEve2uVEXnbD1QS0bZu0K5dFcbpTohNvqNuDJMgJMwHRilghvPhSNEUNOLjG
         zjjJi2eRC/lazQAhvFuF5jXaIPgrS42+TVBew=
Message-ID: <4C91E0DE.4080507@suse.cz>
Date: Thu, 16 Sep 2010 11:18:22 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, jmorris@namei.org, stable@kernel.org
Subject: Re: [PATCH RFC] pid: make setpgid() system call use RCU read-side
 critical section
References: <20100830172631.GA11868@linux.vnet.ibm.com> <4C7C0BAB.3000709@suse.cz> <20100909221555.GB6273@redhat.com>
In-Reply-To: <20100909221555.GB6273@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 12:15 AM, Oleg Nesterov wrote:
> On 08/30, Jiri Slaby wrote:
>>> --- a/kernel/sys.c
>>> +++ b/kernel/sys.c
>>> @@ -938,6 +938,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
>>>  	write_lock_irq(&tasklist_lock);
>>>
>>>  	err = -ESRCH;
>>> +	rcu_read_lock();
>>>  	p = find_task_by_vpid(pid);
>>
>> AFAICT the missing lock doesn't harm due to the write_lock of tasklist
>> above. But is probably a good thing to do anyway.
> 
> The problem is, find_task_by_vpid() is not safe without RCU. It is not
> that the returned task_struct can't go away, find_pid_ns() itself is
> not safe. This is because the failing copy_process() calls free_pid()
> without tasklist_lock and modifies pid_hash[] list.

That said, it (950eaaca681c4) should probably go into stable. (Apply to
all 32-35 whichever are maintained currently.)

thanks,
-- 
js
suse labs
