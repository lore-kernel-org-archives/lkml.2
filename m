Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2F1QjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2F1QjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:39:12 -0400
Message-ID: <4FEC88A2.5040103@redhat.com>
Date: Thu, 28 Jun 2012 19:38:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 18/18] x86: request TLB flush to slave CPU using NMI
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <20120628060853.19298.32233.stgit@localhost.localdomain>
In-Reply-To: <20120628060853.19298.32233.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 09:08 AM, Tomoki Sekiyama wrote:
> For slave CPUs, it is inapropriate to request TLB flush using IPI.
> because the IPI may be sent to a KVM guest when the slave CPU is running
> the guest with direct interrupt routing.
> 
> Instead, it registers a TLB flush request in per-cpu bitmask and send a NMI
> to interrupt execution of the guest. Then, NMI handler will check the
> requests and handles the requests.


Currently x86's get_user_pages_fast() depends on TLB flushes being held
up by local_irq_disable().  With this patch, this is no longer true and
get_user_pages_fast() can race with page table freeing.  There are
patches from Peter Zijlstra to remove this dependency though.  NMIs are
still slow and fragile when compared to normal interrupts, so this patch
is somewhat problematic.


-- 
error compiling committee.c: too many arguments to function


