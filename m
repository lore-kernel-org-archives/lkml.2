Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2EJU0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:26:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54787 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2EJU0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:26:42 -0400
MIME-Version: 1.0
In-Reply-To: <4FAC2304.7050705@wwwdotorg.org>
References: <4FAAB815.5040001@wwwdotorg.org> <4FAC1D09.1070004@wwwdotorg.org>
 <CAPXgP11UqAZgfWXUrxi7VsYr_hoDgi=cP4yn5UJ5rdPU8i5_sA@mail.gmail.com>
 <4FAC2085.7030002@wwwdotorg.org> <4FAC2150.2060804@wwwdotorg.org>
 <CAPXgP10510MCgro77-sOVjvvooa5J5=0c_FR1-QbuN9smLdBPw@mail.gmail.com> <4FAC2304.7050705@wwwdotorg.org>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 10 May 2012 22:26:21 +0200
Message-ID: <CAPXgP12V08MJ3Ja3i10eiTp-QboJozgvY9ah7=NPpmusALq=6A@mail.gmail.com>
Subject: Re: Regression due to 7ff9554 "printk: convert byte-buffer to
 variable-length record buffer"
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        William Douglas <william.douglas@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:20 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/10/2012 02:15 PM, Kay Sievers wrote:
>> On Thu, May 10, 2012 at 10:13 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 05/10/2012 02:09 PM, Stephen Warren wrote:
>>>> On 05/10/2012 02:06 PM, Kay Sievers wrote:
>>>>> On Thu, May 10, 2012 at 9:54 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>>>> On 05/09/2012 12:31 PM, Stephen Warren wrote:
>>>>>>> For me, next-20120508 prints nothing when booted, and I think also
>>>>>>> hangs. To solve this, I reverted:
>>>>>>>
>>>>>>> 7ff9554 printk: convert byte-buffer to variable-length record buffer
>>>>>>>
>>>>>>> In order to build, I also had to revert:
>>>>>>>
>>>>>>> c4e00da driver-core: extend dev_printk() to pass structured data
>>>>>>>
>>>>>>> Note: I'm running on an ARM system using a serial console, with
>>>>>>> earlyprintk enabled.
>>>>>>
>>>>>> This issue still occurs in next-20120510.
>>>>>>
>>>>>> I've tracked it down to the assignment of msg->ts_nsec near the end of
>>>>>> log_store(). If I comment this out, everything works. The problem is the
>>>>>> assignment, not the call to local_clock():
>>>>>>
>>>>>> fails:
>>>>>>        msg->ts_nsec = local_clock();
>>>>>> fails:
>>>>>>        msg->ts_nsec = 0;//local_clock();
>>>>>> works:
>>>>>>        //msg->ts_nsec = local_clock();
>>>>>
>>>>> Weird.
>>>>>
>>>>> What happens if you change it to:
>>>>>   cpu_clock(logbuf_cpu);
>>>>> ?
>>>>>
>>>>> If it works, the timestamps look ok?
>>>>
>>>> I doubt that would work - after all, assigning 0 fails, but not
>>>> performing the assignment at all works. But, I'll go try it...
>>>
>>> Calling cpu_clock() instead of local_clock() fails in the same way.
>>
>> Ok, didn't really see the assign to 0 you tried, sorry. :)
>>
>> And 'dmesg' works when you run the box with the line commented out?
>>
>> And 'cat /dev/kmsg'?
>
> Yes, both work and produce reasonable output.

Really weird. I have zero ideas at what this could be. The messages in
/dev/kmsg have seqnums, you see the 0 as the first?

5,0,0;Linux version 3.4.0-rc6+ ...
6,1,0;Command line: root=/dev/sda1 ...

> "cat /dev/kmsg" does hang
> at the end of the log until I CTRL-C it - is that expected?

Yeah, 'cat' is a blocking read(), tools would use poll().

Kay
