Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab0FOBgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:36:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55541 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab0FOBgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:36:01 -0400
Message-ID: <4C16D829.6020500@cn.fujitsu.com>
Date: Tue, 15 Jun 2010 09:32:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 7/7] KVM: MMU: don't walk every parent pages while mark
 unsync
References: <4C1239EE.3090904@cn.fujitsu.com> <4C123B93.7060803@cn.fujitsu.com> <20100614220708.GA8658@amt.cnet>
In-Reply-To: <20100614220708.GA8658@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:

>> -	if (!sp->multimapped) {
>> -		kvm_mmu_update_unsync_bitmap(sp->parent_pte);
>> +	if (sp->unsync_children++)
>>  		return;
> 
> This looks wrong. If the sp has an unrelated children marked as 
> unsync (which increased sp->unsync_children), you stop the walk? 
> 

Marcelo,

I think it's right :-), we only walk the parents only when
sp->unsync_children is 0, since sp->unsync_children is the number bit
set in sp->unsync_child_bitmap, if sp->unsync_children > 0, we can sure
its parents already have mark unsync-child-exist, assume, for example,
have this mapping:

         / SP1
P1 -> P2
         \ SP2

[ P2 = P1.pte[0] SP1 = P2.pte[0] SP2 = P2.pte[1] ]

First, we mark SP1 unsyc, it will set:
P2.unsync_child_bitmap[0] = 1, P2.unsync_children = 1
and
P1.unsync_child_bitmap[0] = 1, P1.unsync_children = 1

Then, we mark SP2 unsync, we only need do:
P2.unsync_child_bitmap[1] = 1, P2.unsync_children = 2
no need touch P1, since the P1 is already mark pte[0] unsync-child-exist.
