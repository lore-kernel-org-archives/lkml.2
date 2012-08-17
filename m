Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab2HQQo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:44:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39883 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493Ab2HQQoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:44:18 -0400
Message-ID: <502E74B9.8010300@linaro.org>
Date: Fri, 17 Aug 2012 09:43:37 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>, Willy Tarreau <w@1wt.eu>,
        Richard Cochran <richardcochran@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [v2.6.34-stable 109/165] ntp: Fix leap-second hrtimer livelock
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com> <1345060109-9187-110-git-send-email-paul.gortmaker@windriver.com> <20120817161711.GE4039@herton-Z68MA-D2H-B3>
In-Reply-To: <20120817161711.GE4039@herton-Z68MA-D2H-B3>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081716-6148-0000-0000-000008B8CF16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 09:17 AM, Herton Ronaldo Krzesinski wrote:
> On Wed, Aug 15, 2012 at 03:47:33PM -0400, Paul Gortmaker wrote:
>> From: John Stultz <john.stultz@linaro.org>
>>
>>                     -------------------
>>      This is a commit scheduled for the next v2.6.34 longterm release.
>>      http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>>      If you see a problem with using this for longterm, please comment.
>>                     -------------------
>>
>> commit 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d upstream.
>>
>> This should have been backported when it was commited, but I
>> mistook the problem as requiring the ntp_lock changes
>> that landed in 3.4 in order for it to occur.
>>
>> Unfortunately the same issue can happen (with only one cpu)
>> as follows:
>> do_adjtimex()
>>   write_seqlock_irq(&xtime_lock);
>>    process_adjtimex_modes()
>>     process_adj_status()
>>      ntp_start_leap_timer()
>>       hrtimer_start()
>>        hrtimer_reprogram()
>>         tick_program_event()
>>          clockevents_program_event()
>>           ktime_get()
>>            seq = req_seqbegin(xtime_lock); [DEADLOCK]
>>
>> This deadlock will no always occur, as it requires the
>> leap_timer to force a hrtimer_reprogram which only happens
>> if its set and there's no sooner timer to expire.
> [...]
>
> I remember this came through the leapsecond deadlock & hrtimer/futex
> issue fixes. But I noted now commit 6b1859dba01c7d512b72d77e3fd7da8354235189
> ("ntp: Fix STA_INS/DEL clearing bug") was not included, and its changelog
> says it fixes a problem introduced with this. Wouldn't it be worth/right to
> also include it in 2.6.34? I didn't test etc., just detected through the
> changelog/description but would expect it would be affected too. I also
> noted it is missing from 3.2.y and 2.6.32.y stables, and perhaps should be
> scheduled for inclusion in their cases too.

Yes. I also have another change pending in -tip that I've marked for 
stable. Once that lands I'm planning on reviewing the current stable 
trees to check that they have all the needed changes.

thanks
-john

