Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab1I2RGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:06:45 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2060 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab1I2RGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:06:43 -0400
Message-ID: <4E84A5A0.5010703@cavium.com>
Date: Thu, 29 Sep 2011 10:06:40 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Jump Label initialization
References: <4E83D49C.9080809@goop.org> <1317297894.23938.9.camel@localhost.localdomain> <4E84A09A.2030909@goop.org>
In-Reply-To: <4E84A09A.2030909@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2011 17:06:42.0874 (UTC) FILETIME=[295399A0:01CC7ECA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2011 09:45 AM, Jeremy Fitzhardinge wrote:
> On 09/29/2011 05:04 AM, Jan Glauber wrote:
>>
>> s390 does not have the early() variant since it didn't need it. On
>> pre-SMP we probably don't need stop_machine() so creating
>> arch_jump_label_transform_early() by leaving out stop_machine()
>> and patching the code directly should be fine.
>
> Well, it occurs to me that if you're using jump_label_enable() very
> early, then it will be using the full arch_jump_label_transform()
> anyway.  While the stop_machine(), locking, etc that the full version
> does is redundant in a pre-SMP environment, it shouldn't hurt, so
> perhaps there's no need for an _early variant at all.
>

You need a way to guarantee that the code you are modifying is not in 
the instruction cache of the off-line CPUs.

On our (Cavium) SMP MIPS systems, these off-line CPUs are most likely 
spinning in architecture specific smp startup code somewhere in the 
kernel image.  If this code happened to be adjacent to something the 
arch_jump_label_transform_early() would touch, we could have a problem.

The solution is fairly simple, just invalidate the instruction cache 
immediately upon leaving the spinning loop.

David Daney
