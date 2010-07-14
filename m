Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab0GNNXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:23:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57363 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756541Ab0GNNXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:23:07 -0400
Message-ID: <4C3DB942.3010709@cn.fujitsu.com>
Date: Wed, 14 Jul 2010 21:18:58 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/4] KVM: MMU: track dirty page in speculative path properly
References: <4C3C3518.7080505@cn.fujitsu.com> <4C3C35B7.50101@cn.fujitsu.com> <20100713220551.GB6370@amt.cnet> <4C3D11C6.4000101@cn.fujitsu.com> <20100714110926.GA26033@amt.cnet>
In-Reply-To: <20100714110926.GA26033@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:
> On Wed, Jul 14, 2010 at 09:24:22AM +0800, Xiao Guangrong wrote:
>>
>> Marcelo Tosatti wrote:
>>> On Tue, Jul 13, 2010 at 05:45:27PM +0800, Xiao Guangrong wrote:
>>>> In speculative path, the page is not real write-access, no need mark it
>>>> dirty, so clear dirty bit in this path and later examine this bit when
>>>> we release the page
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>>>> ---
>>>>  arch/x86/kvm/mmu.c |   24 +++++++++++-------------
>>>>  1 files changed, 11 insertions(+), 13 deletions(-)
>>> Unfortunately all pages that kvm creates translations for are marked
>>> dirty due to get_user_pages(w=1), except KSM which makes them read-only
>>> later.
>> Marcelo, i have looked into get_user_pages() function, but not catch where
>> to make page dirty, could you point it out for me? :-)
> 
> See set_page_dirty call in mm/memory.c::follow_page.

Yeah, you are right, and i want to use another way to do it since track dirty bit
is too heavy, also it's dangerous if we miss to set page dirty.

How about just track access bit for speculative path, we set page both accessed and
dirty(if it's writable) only if the access bit is set?
