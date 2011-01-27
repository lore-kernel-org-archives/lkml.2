Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1A0S1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 13:27:33 -0500
Received: from claw.goop.org ([74.207.240.146]:50711 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1A0S1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 13:27:32 -0500
Message-ID: <4D41B90D.5000305@goop.org>
Date: Thu, 27 Jan 2011 10:27:25 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Xiaowei Yang <xiaowei.yang@huawei.com>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fanhenglong@huawei.com,
        Kaushik Barde <kbarde@huawei.com>, Kenneth Lee <liguozhu@huawei.com>,
        linqaingmin <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        Wu Fengguang <fengguang.wu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: One (possible) x86 get_user_pages bug
References: <4D416D9A.9010603@huawei.com> <4D419416020000780002ECB7@vpn.id2.novell.com>
In-Reply-To: <4D419416020000780002ECB7@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 06:49 AM, Jan Beulich wrote:
> However, going through all the comments in gup.c again I wonder
> whether pv Xen guests don't violate the major assumption: There
> is talk about interrupts being off preventing (or sufficiently
> deferring) remote CPUs doing TLB flushes. In pv Xen guests,
> however, non-local TLB flushes do not happen by sending IPIs -
> the hypercall interface gets used instead

Yes, I was aware of that synchronization mechanism, and I think I'd
convinced myself we were OK.  But I can't think was that reasoning was -
perhaps it was something as simple as "gupf isn't used under Xen" (which
may have been true at the time, but isn't now).

As clever as it is, the whole "disable interrupts -> hold off IPI ->
prevent TLB flush -> delay freeing" chain seems pretty fragile.  I guess
its OK if we assume that x86 will forever have IPI-based cross-cpu TLB
flushes, but one could imagine some kind of "remote tlb shootdown using
bus transaction" appearing in the architecture.

And even just considering virtualization, having non-IPI-based tlb
shootdown is a measurable performance win, since a hypervisor can
optimise away a cross-VCPU shootdown if it knows no physical TLB
contains the target VCPU's entries.  I can imagine the KVM folks could
get some benefit from that as well.

So is there some way we can preserve the current scheme's benefits while
making it a bit more general?  (If anyone else has non-IPI-based
shootdown, it would be s390; is there some inspiration there?  An
instruction perhaps?)

    J
