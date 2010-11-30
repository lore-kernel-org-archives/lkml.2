Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab0K3Tne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:43:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:40338 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab0K3Tnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:43:33 -0500
Message-ID: <4CF553A3.8030000@kernel.org>
Date: Tue, 30 Nov 2010 20:42:27 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, penberg@kernel.org
Subject: Re: [PATCH UPDATED#2 04/16] x86: Use local variable to cache	smp_processor_id()
 in setup_local_APIC()
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-5-git-send-email-tj@kernel.org> <4CF53E61.1030307@kernel.org> <20101130182251.GC20818@lenovo>
In-Reply-To: <20101130182251.GC20818@lenovo>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Nov 2010 19:42:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2010 07:22 PM, Cyrill Gorcunov wrote:
> On Tue, Nov 30, 2010 at 07:11:45PM +0100, Tejun Heo wrote:
>> This is a trivial clean up.
>>
>> * Move initialization of @cpu inside preemption disabled region as
>>   suggested by Cyrill Gorcunov.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
>> ---
>> Alright, updated yet again, but I frankly don't see the point in these
> 
> code structure, if we would be referring variable taken inside preempt
> off this always look suspicious, i think you agree with me :)

Not really.  smp_processor_id() outside of preemption/irq disabled
area is suspicious exactly the same and having @cpu initialized at the
head of the function has the advantage of making it clear that the
function as a whole is special w.r.t. which cpu it runs on.  In fact,
I think it's actually worse to put it inside preemption disabled area
as it gives the wrong impression that the function isn't special and
might be able to handle being called from another cpu.  In fact,
caching smp_processor_id() in @cpu is better than calling it every
time as it makes it clear that the function is bound to that cpu.

That said, I really don't think this matters one way or the other.
This function is called during smp bring up to initialize the CPU.
Things don't get much more arch/cpu dependent than this and the code
is thoroughly tested on each and every boot and power management
operations.  How @cpu is cached and used just doesn't matter, which is
why I didn't really care about it and changed as suggested.  So, let's
just let it go.

Thanks.

-- 
tejun
