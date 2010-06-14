Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab0FNHro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:47:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab0FNHrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:47:42 -0400
Message-ID: <4C15DE87.3080202@redhat.com>
Date: Mon, 14 Jun 2010 10:47:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Really lazy fpu
References: <1276441427-31514-1-git-send-email-avi@redhat.com> <39727.1276461922@localhost>
In-Reply-To: <39727.1276461922@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2010 11:45 PM, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 13 Jun 2010 18:03:43 +0300, Avi Kivity said:
>    
>> Currently fpu management is only lazy in one direction.  When we switch into
>> a task, we may avoid loading the fpu state in the hope that the task will
>> never use it.  If we guess right we save an fpu load/save cycle; if not,
>> a Device not Available exception will remind us to load the fpu.
>>
>> However, in the other direction, fpu management is eager.  When we switch out
>> of an fpu-using task, we always save its fpu state.
>>      
> Does anybody have numbers on how many clocks it takes a modern CPU design
> to do a FPU state save or restore?

320 cycles for a back-to-back round trip.  Presumably less on more 
modern hardware, more if uncached, more on even more modern hardware 
that has the xsave header (8 bytes) and ymm state (256 bytes) in addition.

> I know it must have been painful in the
> days before cache memory, having to make added trips out to RAM for 128-bit
> registers.  But what's the impact today?

I'd estimate between 300 and 600 cycles depending on the factors above.

> (Yes, I see there's the potential
> for a painful IPI call - anything else?)
>    

The IPI is only taken after a task migration, hopefully a rare event.  
The patchset also adds the overhead of irq save/restore.  I think I can 
remove that at the cost of some complexity, but prefer to start with a 
simple approach.

> Do we have any numbers on how many saves/restores this will save us when
> running the hypothetical "standard Gnome desktop" environment?

The potential is in the number of context switches per second.  On a 
desktop environment, I don't see much potential for a throughput 
improvement, rather latency reduction from making the crypto threads 
preemptible and reducing context switch times.

Servers with high context switch rates, esp. with real-time preemptible 
kernels (due to threaded interrupts), will see throughput gains.  And, 
of course, kvm will benefit from not needing to switch the fpu when 
going from guest to host userspace or to a host kernel thread (vhost-net).

> How common
> is the "we went all the way around to the original single FPU-using task" case?
>    

When your context switch is due to an oversubscribed cpu, not very 
common.  When it is due to the need to service an event and go back to 
sleep, very common.

-- 
error compiling committee.c: too many arguments to function

