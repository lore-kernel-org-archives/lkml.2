Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab2DIOZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 10:25:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab2DIOZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 10:25:23 -0400
Message-ID: <4F82F14F.9040009@redhat.com>
Date: Mon, 09 Apr 2012 17:25:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com> <4F82EA4C.1020507@linux.vnet.ibm.com>
In-Reply-To: <4F82EA4C.1020507@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 04:55 PM, Xiao Guangrong wrote:
>
> Okay, let's simplify it as possible:
>
> - let it only fix the page fault with PFEC.P == 1 && PFEC.W = 0, that means
>   unlock set_spte path can be dropped
>
> - let it just fixes the page fault caused by dirty-log that means we always
>   skip the spte which write-protected by shadow page protection.
>
> Then, things should be fair simper:
>
> In set_spte path, if the spte can be writable, we set ALLOW_WRITE bit
> In rmap_write_protect:
>   if (spte.PT_WRITABLE_MASK) {
> 	WARN_ON(!(spte & ALLOW_WRITE));
> 	spte &= ~PT_WRITABLE_MASK;
> 	spte |= WRITE_PROTECT;
>   }
>
> in fast page fault:
>
> if (spte & PT_WRITABLE_MASK)
> 	return_go_guest;
>
> if ((spte & ALLOW_WRITE) && !(spte & WRITE_PROTECT))
> 	cmpxchg spte + PT_WRITABLE_MASK
>
> The information all we needed comes from spte it is independence from other path,
> and no barriers.
>
>
> Hmm, how about this one?
>

I like it. WRITE_PROTECT is better than my ALLOW_WRITES, the meaning is
clearer.

-- 
error compiling committee.c: too many arguments to function

