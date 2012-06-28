Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2F1Q6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:58:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2F1Q6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:58:30 -0400
Message-ID: <4FEC8D31.3070406@redhat.com>
Date: Thu, 28 Jun 2012 19:58:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 00/18] KVM: x86: CPU isolation and direct interrupts
 handling by guests
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 09:07 AM, Tomoki Sekiyama wrote:
> Hello,
> 
> This RFC patch series provides facility to dedicate CPUs to KVM guests
> and enable the guests to handle interrupts from passed-through PCI devices
> directly (without VM exit and relay by the host).
> 
> With this feature, we can improve throughput and response time of the device
> and the host's CPU usage by reducing the overhead of interrupt handling.
> This is good for the application using very high throughput/frequent
> interrupt device (e.g. 10GbE NIC).
> CPU-intensive high performance applications and real-time applicatoins
> also gets benefit from CPU isolation feature, which reduces VM exit and
> scheduling delay.
> 
> Current implementation is still just PoC and have many limitations, but
> submitted for RFC. Any comments are appreciated.
> 
> * Overview
> Intel and AMD CPUs have a feature to handle interrupts by guests without
> VM Exit. However, because it cannot switch VM Exit based on IRQ vectors,
> interrupts to both the host and the guest will be routed to guests.
> 
> To avoid mixture of host and guest interrupts, in this patch, some of CPUs
> are cut off from the host and dedicated to the guests. In addition, IRQ
> affinity of the passed-through devices are set to the guest CPUs only.
> 
> For IPI from the host to the guest, we use NMIs, that is an only interrupts
> having another VM Exit flag.
> 
> * Benefits
> This feature provides benefits of virtualization to areas where high
> performance and low latency are required, such as HPC and trading,
> and so on. It also useful for consolidation in large scale systems with
> many CPU cores and PCI devices passed-through or with SR-IOV.
> For the future, it may be used to keep the guests running even if the host
> is crashed (but that would need additional features like memory isolation).
> 
> * Limitations
> Current implementation is experimental, unstable, and has a lot of limitations.
>  - SMP guests don't work correctly
>  - Only Linux guest is supported
>  - Only Intel VT-x is supported
>  - Only MSI and MSI-X pass-through; no ISA interrupts support
>  - Non passed-through PCI devices (including virtio) are slower
>  - Kernel space PIT emulation does not work
>  - Needs a lot of cleanups
> 

This is both impressive and scary.  What is the target scenario here?
Partitioning?  I don't see this working for generic consolidation.


-- 
error compiling committee.c: too many arguments to function


