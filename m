Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895Ab2L0OgC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:36:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab2L0OgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:36:00 -0500
Message-ID: <50DC5CC0.6010003@redhat.com>
Date: Thu, 27 Dec 2012 09:35:44 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Michel Lespinasse <walken@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        aquini@redhat.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Herbert <therbert@google.com>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
References: <20121221184940.103c31ad@annuminas.surriel.com>  <20121221185147.4ae48ab5@annuminas.surriel.com>  <20121221185613.1f4c9523@annuminas.surriel.com>  <20121222033339.GF27621@home.goodmis.org> <50D52E0C.6000103@redhat.com>  <1356549008.20133.20856.camel@edumazet-glaptop> <50DB5531.90500@redhat.com>  <CANN689HeTk0jNJb4sF_0t714MvFnU0vLw0=JeXYRUwMx8GDnXQ@mail.gmail.com> <1356618448.30414.948.camel@edumazet-glaptop>
In-Reply-To: <1356618448.30414.948.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 09:27 AM, Eric Dumazet wrote:
> On Wed, 2012-12-26 at 22:07 -0800, Michel Lespinasse wrote:
>
>> If we go with per-spinlock tunings, I feel we'll most likely want to
>> add an associative cache in order to avoid the 1/16 chance (~6%) of
>> getting 595Mbit/s instead of 982Mbit/s when there is a hash collision.
>>
>> I would still prefer if we could make up something that didn't require
>> per-spinlock tunings, but it's not clear if that'll work. At least we
>> now know of a simple enough workload to figure it out :)
>
> Even with a per spinlock tuning, we can find workloads where holding
> time depends on the context.
>
> For example, complex qdisc hierarchy typically use different times on
> enqueue and dequeue operations.
 >
> So the hash sounds good to me, because the hash key could mix both lock
> address and caller IP ( __builtin_return_address(1) in
> ticket_spin_lock_wait())

The lock acquisition time depends on the holder of the lock,
and what the CPUs ahead of us in line will do with the lock,
not on the caller IP of the spinner.

Therefore, I am not convinced that hashing on the caller IP
will add much, if anything, except increasing the chance
that we end up not backing off when we should...

IMHO it would be good to try keeping this solution as simple
as we can get away with.

-- 
All rights reversed
