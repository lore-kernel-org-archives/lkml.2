Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab1DZAme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 20:42:34 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55111 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1DZAmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 20:42:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z4zQLrqdoUU1016Jn7+QYnl9eze9E6wgDg4aZdkmKIY7oC6duhwnZulEx7/nd79vk+
         Mdgn+m4ngsrR7TDN7daOguYPBBJyhw85z0s9XCtcY8qyqulUpXbrNwx+NEF5nuZAvto8
         Us7q9u98bBwT88uB5bUadmcbvTaNfXR8or3jE=
MIME-Version: 1.0
In-Reply-To: <20110425084508.dda5ec8f.randy.dunlap@oracle.com>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
	<1303728272-11408-4-git-send-email-leemgs1@gmail.com>
	<20110425084508.dda5ec8f.randy.dunlap@oracle.com>
Date: Tue, 26 Apr 2011 09:42:32 +0900
Message-ID: <BANLkTi=psQRm9W9uXBgCEyYp-oEA0d0GVA@mail.gmail.com>
Subject: Re: [PATCH 3/4] munmap: kbuild menu for munmap interface
From: Geunsik Lim <leemgs1@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 12:45 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 25 Apr 2011 19:44:31 +0900 Geunsik Lim wrote:
>
>> From: Geunsik Lim <geunsik.lim@samsung.com>
>>
>> Support kbuild menu to select memory unmap operation size
>> at build time.
>>
>> Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
>> Acked-by: Hyunjin Choi <hj89.choi@samsung.com>
>> ---
>>  init/Kconfig |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  mm/memory.c  |   21 +++++++++++-----
>>  2 files changed, 84 insertions(+), 7 deletions(-)
>>
>> diff --git a/init/Kconfig b/init/Kconfig
>> index 56240e7..0983961 100644
>> --- a/init/Kconfig
>> +++ b/init/Kconfig
>> @@ -557,6 +557,76 @@ config LOG_BUF_SHIFT
>>                    13 =>  8 KB
>>                    12 =>  4 KB
>>
>> +config PREEMPT_OK_MUNMAP_RANGE
>> +     int "Memory unmap unit on preemption mode (8 => 32KB)"
>> +     depends on !PREEMPT_NONE
>> +     range 8 2048
>> +     default 8
>> +     help
>> +       unmap_vmas(=unmap a range of memory covered by a list of vma) is treading
>
>          unmap_vmas (= unmap a range ...
>
>> +       a delicate and uncomfortable line between hi-performance and low-latency.
>
>                                                    high performane and low latency.
>
>> +       We've chosen to improve performance at the expense of latency.
>
>          This option improves performance at the expense of latency.
>
>> +
>> +       So although there may be no need to resched right now,
>
>                                              reschedule
>
>> +       if we keep on gathering more and more without flushing,
>
>                        gathering more and more <what> ?
>
>> +       we'll be very unresponsive when a resched is needed later on.
>
>                                            reschedule
>
>> +
>> +       Consider the best suitable result between high performance and low latency
>> +       on preemption mode.
>> +       Select optimal munmap size to return memory space that is allocated by mmap system call.
>> +
>> +       For example, For recording mass files, if we try to unmap memory that we allocated
>
>                       for
>
>> +       with 100MB for recording in embedded devices, we have to wait for more than 3seconds to
>
>                                                                                      3 seconds
>
> (but try not to put text over 80 columns, please)
>
>> +       change mode from play mode to recording mode. This results from the unit of memory
>> +       unmapped size when we are recording mass files like camcorder particularly.
>> +
>> +          This value can be changed after boot using the
>> +          /proc/sys/vm/munmap_unit_size tunable.
>
> Indent above with tab + 2 spaces.
>
>> +
>> +       Examples:
>> +                  2048 => 8,388,608bytes : for straight-line efficiency
>> +                  1024 => 4,194,304bytes
>> +                   512 => 2,097,152bytes
>> +                   256 => 1,048,576bytes
>> +                   128 =>   524,288bytes
>> +                    64 =>   262,144bytes
>> +                    32 =>   131,072bytes
>> +                    16 =>    65,536bytes
>> +                     8 =>    32,768bytes : for low-latency (*default)
>
> All of above would be better with added space before "bytes", as, e.g.:
>                        8 =>    32,768 bytes
>
>> +
>> +config PREEMPT_NO_MUNMAP_RANGE
>> +     int "Memory unmap unit on non-preemption mode (1024 => 4MB)"
>> +     depends on PREEMPT_NONE
>> +     range 8 2048
>> +     default 1024
>> +     help
>> +
>> +       unmap_vmas(=unmap a range of memory covered by a list of vma) is treading
>
>          unmap_vmas (= unmap
>
>> +       a delicate and uncomfortable line between hi-performance and low-latency.
>
>                                                    high performance and low latency.
>
>> +       We've chosen to improve performance at the expense of latency.
>
>          This option improves performance at the expense of latency.
>
>> +
>> +       So although there may be no need to resched right now,
>
>                                              reschedule
>
>> +       if we keep on gathering more and more without flushing,
>
>                                  more and more what?
>
>> +       we'll be very unresponsive when a resched is needed later on.
>
>                                            reschedule
>
>> +
>> +       Consider the best suitable result between high performance and low latency
>> +       on preemption mode.
>
> but this option is for non-preempt mode... so should that text above be modified?
>
>> +       Select optimal munmap size to return memory space that is allocated by mmap system call.
>> +
>> +          This value can be changed after boot using the
>> +          /proc/sys/vm/munmap_unit_size tunable.
>
> Indent above with tab + 2 spaces.
>
>> +
>> +       Examples:
>> +                  2048 => 8,388,608bytes : for straight-line efficiency
>> +                  1024 => 4,194,304bytes (*default)
>> +                   512 => 2,097,152bytes
>> +                   256 => 1,048,576bytes
>> +                   128 =>   524,288bytes
>> +                    64 =>   262,144bytes
>> +                    32 =>   131,072bytes
>> +                    16 =>    65,536bytes
>> +                     8 =>    32,768bytes : for low-latency
>
>                Use space before "bytes" in table above, please.
>
>> +
>>  #
>>  # Architectures with an unreliable sched_clock() should select this:
>>  #
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
Randy Dunlap. Thanks a lot.
I will modify contents that you commented.
>



-- 
Regards,
Geunsik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
