Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab2AZBcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 20:32:17 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:50277 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2AZBcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 20:32:16 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jan 2012 20:32:16 EST
Message-id: <4F209EFA.7020003@verizon.net>
Date: Wed, 25 Jan 2012 19:31:54 -0500
From: "David H. Durgee" <dhdurgee@verizon.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0.1) Gecko/20111221
 Firefox/9.0.1 SeaMonkey/2.6.1
MIME-version: 1.0
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Request for assistance - excessive kworker CPU wakeups
References: <4EE27D28.4040909@verizon.net>
 <CACBanvpV7pWp07jzuYqzRkbkShvvKvpcu6yFsLfEL+UhT8kp_g@mail.gmail.com>
 <4F205056.2020002@verizon.net> <20120125234424.GL4656@google.com>
In-reply-to: <20120125234424.GL4656@google.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines wrote:
> David H. Durgee (dhdurgee@verizon.net) wrote:
>> Mandeep Singh Baines wrote:
>>> On Fri, Dec 9, 2011 at 1:27 PM, David H. Durgee<dhdurgee@verizon.net>   wrote:
>>>> I recently purchased a Lenovo IdeaPad Z560, model 09143YU, and as I am not a
>>>> Windows fan I installed Linux Mint 11 Katya x64 to use instead of the
>>>> supplied W7.  I was encountering a known hang and had to upgrade to a later
>>>> kernel, so I am now using the 2.6.38-11-generic #50-Ubuntu SMP Mon Sep 12
>>>> 21:17:25 UTC 2011 x86_64 kernel.
>>>>
>>>> I had my first occasion to use the laptop for an extended period for the
>>>> first time over the Thanksgiving holiday and I found it needed to be tuned.
>>>>   I downloaded powertop and used it to discover where my problems were.
>>>>   After addressing excessive i915 interrupts due to DRI the next most
>>>> frequent cause of CPU wakeups is a kworker on the system.  A search lead to
>>>> a post by Tejun, indicating the need to trace such issues. Running the trace
>>>> showed that 1933 of 2748 events were of the form:
>>>>
>>>> <idle>-0     [000] 22005.355346: workqueue_queue_work: work
>>>> struct=ffff8800bb411188 function=do_dbs_timer workqueue=ffff88012b5d2c00
>>>> req_cpu=0 cpu=0
>>>>
>>>> Tejun indicated that this is a workitem used by cpufreq and likely caused by
>>>> something else hitting the CPU frequently.  So how do I diagnose this
>>>> further and isolate the cause for correction?
>>>>
>>>> If you would like a summary of this, download this spreadsheet:
>>>>
>>>> http://home.comcast.net/%7Eddurgee/Tracelog.ods
>>>>
>>>> If you would like to inspect the trace log itself:
>>>>
>>>> http://home.comcast.net/%7Eddurgee/tracelog.zip
>>>>
>>> Hi Dave,
>>>
>>> I don't know the cpufreq code that well, but it seem that this
>>> workqueue is schedule periodically. You
>>> can examine the sampling rate via /sys:
>>>
>>> $ grep "" /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate*
>>>
>>> Just curious, are you running nohz:
>>>
>>> $ dmesg | grep -i nohz
>>>
>>> Regards,
>>> Mandeep
>> dhdurgee@DHD-Z560 ~/Downloads $ grep ""
>> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate*
>> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate:10000
>> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate_max:4294967295
>> /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate_min:10000
>> dhdurgee@DHD-Z560 ~/Downloads $ dmesg | grep -i nohz
>> dhdurgee@DHD-Z560 ~/Downloads $
>>
>> Does this explain what I am seeing?  Does this square with the
>> observations in my spreadsheet?  Does this suggest a means of
>> reducing these excessive wakeups?  Is there more information I can
>> provide to suggest a course of action?
>>
> IIUC, you should be seeing 100 such events per second * number of CPUs.
> Is that what you are seeing? You could reduce this by changing HZ. Maybe
> change to CONFIG_HZ_100 in your .config from CONFIG_HZ_1000. That
> should reduce the number of events by a factor of 10.
>
> Regards,
> Mandeep
Looking at /boot/config-2.6.38-11-generic I see the following:

CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100

So it appears that this is already set.  Looking at the raw data I 
collected and summarized I see 22005.355346 in the first record and 
22031.110816 in the last record.  Am I correct in interpreting this to 
mean that 25.76 seconds elapsed while data was collected?  During the 
collection I saw 1,993 total idle do_dbs_timer calls.  I saw a total of 
2,754 wakeups for all events.  You can get the details from the files I 
referenced.

Dave
