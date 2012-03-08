Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2CHDnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 22:43:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:8806 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab2CHDnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 22:43:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116198969"
Message-ID: <4F582AC1.6040300@linux.intel.com>
Date: Wed, 07 Mar 2012 19:42:57 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: jon@jonshouse.co.uk
CC: Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Random process lockup on ARM board: alsa-lib-1.0.25, FUTEX_WAIT_PRIVATE
References: <1329393691.6830.20.camel@jonspc>  <1329512682.29051.1.camel@jonspc> <1329570128.6670.0.camel@jonspc>  <4F400BBF.9020707@ladisch.de> <1329603022.1089.57.camel@jonspc>  <4F41FC28.1070605@ladisch.de> <1329926198.22918.10.camel@jonspc>  <4F45167A.6080706@ladisch.de> <1330043397.4669.44.camel@jonspc>  <CAMiH66EdB9KN1gw_hG=34zab56RxcPKB7G2MyJALfD_5z1yeVQ@mail.gmail.com>  <4F57C007.5050006@linux.intel.com> <1331155368.14407.109.camel@jonspc>
In-Reply-To: <1331155368.14407.109.camel@jonspc>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/07/2012 01:22 PM, Jonathan Andrews wrote:
> On Wed, 2012-03-07 at 12:07 -0800, Darren Hart wrote:
>>
>> On 02/29/2012 01:12 AM, Huang Shijie wrote:
>>> Hi ,
>>>
>>> I meet a similar problem with the latest futex code.
>>>
>>> I play the video and the processes will hang at the futex.
>>
>> Are either of you able to bisect the kernel?
> I'm not a kernel hacker what do you mean ?

Google for "git bisect". It's a way to divide-and-conquer and find
exactly where the kernel stops working for you. You would need a known
working kernel though. If you don't have a known working kernel, then
this is either a long standing bug (not a regression) or, I suspect more
likely, a locking bug or race in the userspace code.

When you see your thread stuck in FUTEX_WAIT_PRIVATE, that in and of
itself is not indication of a problem. It's waiting there to be woken
(FUTEX_WAKE_PRIVATE) by another thread in your application. So the
questions you should be asking are:

Why is it blocked?
	pthread_cond_wait()?
	pthread_mutex_lock()?

Why isn't it being woken up?
	Did you call pthread_cond_broadcast() without taking the mutex
	first?

There are other API that use futexes under the covers. You should be
able to sort out where in your application your threads are blocked and
thus determine which API you are using - and from there how you were
expecting that to get woken up. These calls may be being made from
within ALSA, in which case you may need to elicit the help of the ALSA
developers.

--
Darren

> 
>>  At the very least can you
>> find two kernels where it works and where it does not?
>>
>> Hanging on FUTEX_WAIT_PRIVATE can be the symptom for higher level
>> problems including userspace locking issues and race conditions.
> 
> 
> My workload is UDP network audio.  I have compiled my code with and
> without ALSA support. The version without ALSA seems to run forever, the
> version with ALSA works on ARM for between a few minutes and a few
> hours. On Intel the same futex stall problem occurs, but it may take
> runtime of days.
> 
> I have two processes running. One RX process that takes UDP packets from
> the network mixes them and presents them to ALSA as an audio stream, the
> second process takes audio from the sound device and transmits it as a
> UDP audio stream.  The two processes are independent. 
> 
> My workload is atypical as I need to both transmit and receive audio via
> UDP on a 27/7 basis.
> 
> So far I have experienced the problem on 3 kernels, but I have tried
> only 3 kernels it may be all 2.6 kernels that suffer.
> 
> My development PC is "Linux jonspc 2.6.32.26-175.fc12.i686 #1 SMP Wed
> Dec 1 21:52:04 UTC 2010 i686 athlon i386 GNU/Linux"
> 
> My ARM board target:
> ARM / # uname -a
> Linux (none) 3.2.5 #2 Wed Feb 22 17:11:52 GMT 2012 armv4tl GNU/Linux
> 
> And my ARM target running its older kernel was (2.6.36).
>  
> I have an strace of the process running and stalling on the PC.
> The file is 2GB, its not a fast link sorry.
>  
> http://www.jonshouse.co.uk/download/a_stop.txt
> 
> 
> Many thanks,
> Jon
> 
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
