Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2LVCzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 21:55:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2LVCzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 21:55:21 -0500
Message-ID: <50D51E56.4080200@redhat.com>
Date: Fri, 21 Dec 2012 21:43:34 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
References: <20121221184940.103c31ad@annuminas.surriel.com>  <20121221185147.4ae48ab5@annuminas.surriel.com>  <20121221185613.1f4c9523@annuminas.surriel.com> <1356135536.21834.8114.camel@edumazet-glaptop>
In-Reply-To: <1356135536.21834.8114.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 07:18 PM, Eric Dumazet wrote:
> On Fri, 2012-12-21 at 18:56 -0500, Rik van Riel wrote:
>> Argh, the first one had a typo in it that did not influence
>> performance with fewer threads running, but that made things
>> worse with more than a dozen threads...
>
>> +
>> +		/*
>> +		 * The lock is still busy, the delay was not long enough.
>> +		 * Going through here 2.7 times will, on average, cancel
>> +		 * out the decrement above. Using a non-integer number
>> +		 * gets rid of performance artifacts and reduces oversleeping.
>> +		 */
>> +		if (delay < MAX_SPINLOCK_DELAY &&
>> +				((inc.head & 3) == 0 || (inc.head & 7) == 1))
>> +			delay++;
>
> ((inc.head & 3) == 0 || (inc.head & 7) == 1)) seems a strange condition
> to me...

It is. It turned out that doing the increment
every 4 times (just the first check) resulted
in odd performance artifacts when running with
4, 8, 12 or 16 CPUs.

Moving to the above got rid of the performance
artifact.

It also results in aiming for a sleep period
that is not an exact multiple of the lock
acquiring period, which results in less
"oversleeping", and measurably better
performance.

