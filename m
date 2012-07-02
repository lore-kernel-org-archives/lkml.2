Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab2GBWMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:12:32 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53782 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386Ab2GBWMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:12:30 -0400
Message-ID: <4FF21C88.3060801@us.ibm.com>
Date: Mon, 02 Jul 2012 15:11:20 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] [RFC] Fix clock_was_set so it is safe to call from
 atomic
References: <1341167401-31342-1-git-send-email-johnstul@us.ibm.com> <1341167401-31342-2-git-send-email-johnstul@us.ibm.com> <alpine.LFD.2.02.1207021050500.2793@ionos>
In-Reply-To: <alpine.LFD.2.02.1207021050500.2793@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070222-5806-0000-0000-000016E761DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 01:53 AM, Thomas Gleixner wrote:
> On Sun, 1 Jul 2012, John Stultz wrote:
>
>> NOTE:This is a prerequisite patch that's required to
>> address the widely observed leap-second related futex/hrtimer
>> issues.
>>
>> Currently clock_was_set() is unsafe to be called from atomic
>> context, as it calls on_each_cpu(). This causes problems when
>> we need to adjust the time from update_wall_time().
>>
>> To fix this, introduce a work_struct so if we're in_atomic,
>> we can schedule work to do the necessary update after we're
>> out of the atomic section.
> Shouldn't we queue a timer_list timer with expiry time jiffies + 0
> instead. We can call on_each_cpu() from softirq context. And that
> ensures that the update happens right away, while a scheduled work
> might be delayed arbitrary long.
Thanks for the feedback.
I've implemented this, but before I send it out, I'm trying to see if 
there's not a way to change hrtimers so it doesn't keep its own per-cpu 
sense of time.  If I don't sort that out shortly, I'll go ahead and send 
your suggestion out for inclusion so the fix is committed and I can try 
to further improve it afterwards.

thanks
-john

