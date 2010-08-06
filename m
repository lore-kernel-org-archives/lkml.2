Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761493Ab0HFPJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 11:09:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:64360 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760524Ab0HFPJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 11:09:55 -0400
Message-ID: <4C5C25B7.4020902@windriver.com>
Date: Fri, 06 Aug 2010 10:09:43 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] timekeeping: Fix overflow in rawtime tv_nsec on 32 bit
 archs
References: <1281011312-23499-1-git-send-email-jason.wessel@windriver.com> <1281046640.3405.18.camel@localhost.localdomain>
In-Reply-To: <1281046640.3405.18.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2010 15:09:45.0185 (UTC) FILETIME=[675FFD10:01CB3579]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 05:17 PM, john stultz wrote:
> On Thu, 2010-08-05 at 07:28 -0500, Jason Wessel wrote:
>> The tv_nsec is a long and when added to the shift value it can wrap
>> and become negative which later causes looping problems in the
>> getrawmonotonic().  The edge case occurs when the system has slept for
>> a short period of time of ~2 seconds.
> 
> Ah, good catch!
> 
> I reworked some of the variable names to make a little more sense and
> simplified the accumulation. Do you mind giving this a test in your
> environment that triggered the issue to make sure nothing else slipped
> in?
> 


No problem.


This looks good to me.  I even increased the delay and I can see it recovers properly.

The instrumentation shows raw_nsecs would have otherwise been negative going from 90.* to 97.* in the log.

           <...>-4801  [000]    90.105084: update_wall_time: raw_nsecs: 37283ea1
           <...>-4801  [000]    90.109078: update_wall_time: raw_nsecs: 376547b4
           <...>-4801  [000]    97.694264: update_wall_time: raw_nsecs: b1776db4
           <...>-4801  [000]    97.694270: update_wall_time: raw_nsecs: b453ffb4
           <...>-4801  [000]    97.694272: update_wall_time: raw_nsecs: 7b95c7b4

Note that I had instrumented it just after:

raw_nsecs += raw_time.tv_nsec;

We should send this over to -stable when it is considered baked because this was found in the 2.6.35 and may be a problem elsewhere as well.

Thanks,
Jason.


