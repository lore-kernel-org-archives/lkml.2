Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab0KQI5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:57:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759877Ab0KQI5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:57:21 -0500
Message-ID: <4CE398BD.7080708@redhat.com>
Date: Wed, 17 Nov 2010 10:56:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 00/14] PV ticket locks without expanding spinlock
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 11:08 PM, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
>
> Hi all,
>
> This is a revised version of the pvticket lock series.
>
> The early part of the series is mostly unchanged: it converts the bulk
> of the ticket lock code into C and makes the "small" and "large"
> ticket code common.  The only changes are the incorporation of various
> review comments.
>
> The latter part of the series converts from pv spinlocks to pv ticket
> locks (ie, using the ticket lock fastpath as-is, but adding pv ops for
> the ticketlock slowpaths).
>
> The significant difference here is that rather than adding a new
> ticket_t-sized element to arch_spinlock_t - effectively doubling the
> size - I steal the LSB of the tickets themselves to store a bit.  This
> allows the structure to remain the same size, but at the cost of
> halving the max number of CPUs (127 for a 8-bit ticket, and a hard max
> of 32767 overall).
>
> The extra bit (well, two, but one is unused) in indicates whether the
> lock has gone into "slowpath state", which means one of its lockers
> has entered its slowpath and has blocked in the hypervisor.  This
> means the current lock-holder needs to make sure it gets kicked out of
> the hypervisor on unlock.
>
> The spinlock remains in slowpath state until the last unlock happens
> (ie there are no more queued lockers).
>
> This code survives for a while with moderate testing, (make -j 100 on
> 8 VCPUs on a 4 PCPU system), but locks up after about 20 iterations,
> so there's still some race/deadlock in there (probably something
> misordered), but I think the basic approach is sound.

This is going to be very useful for kvm; I'd like to see the fixed 
version gets merged.

-- 
error compiling committee.c: too many arguments to function

