Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2LMQPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:15:15 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:12213 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab2LMQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:15:14 -0500
Message-ID: <50C9FF11.2030303@tilera.com>
Date: Thu, 13 Dec 2012 11:15:13 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: provide PT_FLAGS_COMPAT value in pt_regs
References: <201212122227.qBCMRiNg000851@farm-0002.internal.tilera.com> <20121212234307.GA7694@redhat.com> <50C9ECFF.6070708@tilera.com> <20121213154929.GA17421@redhat.com>
In-Reply-To: <20121213154929.GA17421@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 10:49 AM, Oleg Nesterov wrote:
> On 12/13, Chris Metcalf wrote:
>> On 12/12/2012 6:43 PM, Oleg Nesterov wrote:
>>> And. arch/tile/kernel/ptrace.c:arch_ptrace() does
>>>
>>> 	case PTRACE_SETOPTIONS:
>>> 		/* Support TILE-specific ptrace options. */
>>> 		child->ptrace &= ~PT_TRACE_MASK_TILE;
>>> 		tmp = data & PTRACE_O_MASK_TILE;
>>> 		data &= ~PTRACE_O_MASK_TILE;
>>>
>>> AFAICS we need something like BUILD_BUG_ON(PTRACE_O_MASK_TILE & PTRACE_O_MASK),
>> I don't think so.  These are disjoint namespaces anyway.
>> PTRACE_O_MASK_TILE is for the actual PTRACE_SETOPTIONS ABI values.
> Yes, and thus it should not intersect with the generic PTRACE_O_MASK, no?

Yes, I misunderstood your original suggestion (I read PTRACE_O_MASK as PT_TRACE_MASK_TILE - oops).  You're quite right that it's a good build bug; I'll add it to the cleanup patch that will also move the task->ptrace bit clear.

>>> 		ret = ptrace_request(child, request, addr, data);
>>> 		if (tmp & PTRACE_O_TRACEMIGRATE)
>>> 			child->ptrace |= PT_TRACE_MIGRATE;
>>>
>>> this also needs "ret == 0" check
>> The question is, what happens if we pass some illegal bit to the generic
>> ptrace_request(), and also pass a valid PTRACE_O_MASK_TILE bit?
>> Currently we set the tile-specific bit, then report the error.
>> This is consistent with how ptrace_setoptions() handles a mix of legal and
>> illegal bits.
> But ptrace_setoptions() returns EINVAL? it doesn't accept illegal bits.

It does return EINVAL - but if it gets both legal and illegal bits, it honors all the legal bits first.  So we honor the PT_TRACE_MIGRATE bit in this code, even if ptrace_request() returns EINVAL.

> So I'd say it looks fine to me.

Thanks!  Should I convert that to a Reviewed-by or Acked-by on the patch?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

