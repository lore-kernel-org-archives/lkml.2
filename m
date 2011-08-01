Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1HARnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:43:16 -0400
Received: from service87.mimecast.com ([94.185.240.25]:32834 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753598Ab1HARnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:43:10 -0400
Message-ID: <4E36E5AB.5000509@arm.com>
Date: Mon, 01 Aug 2011 18:43:07 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: Richard Weinberger <richard@nod.at>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "toralf.foerster@gmx.de" <toralf.foerster@gmx.de>
Subject: Re: shm updates broke UML
References: <201108011541.59640.richard@nod.at> <20110801134911.GA11705@albatros> <43e4e9e98b32d3d3eb06ab837a019ad8@localhost> <20110801171042.GA25954@albatros> <08cf4697685ecd9bcb7e4eefe516f2ee@localhost> <20110801172452.GA26190@albatros> <20110801173206.GA26440@albatros>
In-Reply-To: <20110801173206.GA26440@albatros>
X-Enigmail-Version: 1.1.2
X-OriginalArrivalTime: 01 Aug 2011 17:43:02.0575 (UTC) FILETIME=[762853F0:01CC5072]
X-MC-Unique: 111080118430500701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/11 18:32, Vasiliy Kulikov wrote:
> Marc,
> 
> On Mon, Aug 01, 2011 at 21:24 +0400, Vasiliy Kulikov wrote:
>> On Mon, Aug 01, 2011 at 19:19 +0200, Marc Zyngier wrote:
>>> Here you go (sorry about the line wrapping, damned webmail...):
>>
>> Thank you!  Now I see that the problem is rw_mutex is not initialized:
>>
>> 	down_write(&shm_ids(ns).rw_mutex);
>>
>> void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
>> {
>>     ...
>> 	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
>>                                          ^^^^^^^^^^^^^^^ is NULL
>>
>> Wtf - ipc namespace should be fully initialized for the moment of
>> threads run...
> 
> Does ARM try to run _any_ threads before do_initcalls()?  IPC
> initialization is initcall, so any thread before do_initcalls() is a
> dependency bug.

I don't think it does anything different from other architectures.
The crash I'm observing seem to be from kworker, which is created from
an early_initcall (kernel/workqueue.c).

This looks very much like a generic problem to me.

	M.
-- 
Jazz is not dead. It just smells funny...

