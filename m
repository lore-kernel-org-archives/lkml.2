Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab1IMLHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:07:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab1IMLHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:07:11 -0400
Message-ID: <4E6F395A.5030609@redhat.com>
Date: Tue, 13 Sep 2011 14:07:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 11/11] KVM: MMU: improve write flooding detected
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4D17.2080700@cn.fujitsu.com>
In-Reply-To: <4E5C4D17.2080700@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2011 05:38 AM, Xiao Guangrong wrote:
> Detecting write-flooding does not work well, when we handle page written, if
> the last speculative spte is not accessed, we treat the page is
> write-flooding, however, we can speculative spte on many path, such as pte
> prefetch, page synced, that means the last speculative spte may be not point
> to the written page and the written page can be accessed via other sptes, so
> depends on the Accessed bit of the last speculative spte is not enough
>
> Instead of detected page accessed, we can detect whether the spte is accessed
> after it is written, if the spte is not accessed but it is written frequently,
> we treat is not a page table or it not used for a long time
>
>

The spte may not be accessed, but other sptes in the same page can be 
accessed.  An example is the fixmap area for kmap_atomic(), there will 
be a lot of pte writes but other sptes will be accessed without going 
through soft-mmu at all.

I think you have to read the parent_ptes->spte.accessed bits to be sure.

-- 
error compiling committee.c: too many arguments to function

