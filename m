Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032973Ab2CQBl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 21:41:59 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43296 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031441Ab2CQBl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 21:41:57 -0400
Message-ID: <4F63EBC9.6010208@us.ibm.com>
Date: Fri, 16 Mar 2012 18:41:29 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jose Luis Salas <josacar@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: System freezes with high network activity
References: <CAJPugqsJgN9ZL3jQAZ+eGKfzxH0PAZonj-36H6PB1cHSpQHqSw@mail.gmail.com> <1322855029.21423.170.camel@work-vm> <CAJPugqs6wDcEM-5p5vRxHNVZd92ozgk0sw7g3=F6pvYyCA-CEw@mail.gmail.com> <1322864926.21423.184.camel@work-vm> <CAJPugqur-7=s2ujsy+XhAZ3TucD_R_Wcdat2NA9TdFNrhSA2ww@mail.gmail.com>
In-Reply-To: <CAJPugqur-7=s2ujsy+XhAZ3TucD_R_Wcdat2NA9TdFNrhSA2ww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031701-1976-0000-0000-00000B875D4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 02:04 PM, Jose Luis Salas wrote:
> Hi,
>
> attached is the output of the timer_list.
>
> With the nohz option the system is stable too.
>
> Other symptom of the problem is network drops performance to 50% ( 50 Mbps ).
>

Hey Jose,
     Just following up on this old email. Looking at the timer_list.txt 
that you sent, I'm not seeing anything that sticks out as problematic. 
Are you still seeing issues with recent kernels (3.1, 3.2) ?    Is nohz 
still working for you?

I suspect the problem is that the lapic on your machine goes out to 
lunch after longish idle times w/ nohz.  That's why the key-press or 
network traffic wakes the system back up.

Does booting with the following patch (without nohz or any clocksource= 
boot args) fix the issue?

If it does, can you increase the time returned in the patch from 20ms by 
powers of ten until it gets to 2 seconds or you see the problem? If the 
patch below doesn't help, can you drop the value down to 1ms and let me 
know if that affects anything?

thanks
-john

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 95bebaa..8fd2bfa 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -546,6 +546,9 @@ u64 timekeeping_max_deferment(void)
  {
  	unsigned long seq;
  	u64 ret;
+
+	return 20000000ULL; /* 20ms */
+
  	do {
  		seq = read_seqbegin(&timekeeper.lock);


