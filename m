Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab0F2BVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 21:21:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0F2BVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 21:21:11 -0400
Message-ID: <4C2949A5.1070303@cn.fujitsu.com>
Date: Tue, 29 Jun 2010 09:17:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com> <4C287081.40300@redhat.com> <4C287332.5080803@cn.fujitsu.com> <4C2883D3.2050606@redhat.com>
In-Reply-To: <4C2883D3.2050606@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Avi Kivity wrote:
> On 06/28/2010 01:02 PM, Xiao Guangrong wrote:
>>
>> Avi Kivity wrote:
>>
>>   
>>> Instead of adding a new bit, can you encode the protection in the direct
>>> sp's access bits?  So we'll have one sp for read-only or
>>> writeable-but-not-dirty small pages, and another sp for
>>> writeable-and-dirty small pages.
>>>
>>>      
>> It looks like it can't solve all problems, it fix the access corrupted,
>> but will cause D bit losed:
>>
>> mapping A and mapping B both are writable-and-dirty, when mapping A write
>> #PF occurs, the mapping is writable, then we can't set B's D bit anymore.
>>    
> 
> If B is writeable-and-dirty, then it's D bit is already set, and we
> don't need to do anything.
> 
> If B is writeable-and-clean, then we'll have an spte pointing to a
> read-only sp, so we'll get a write fault on access and an opportunity to
> set the D bit.
> 

Sorry, a typo in my reply, i mean mapping A and B both are writable-and-clean,
while A occurs write-#PF, we should change A's spte map to writable sp, if we
only update the spte in writable-and-clean sp(form readonly to writable), the B's
D bit will miss set.

>> Anyway, i think we should re-intall the mapping when the state is
>> changed. :-(
>>    
> 
> When the gpte is changed from read-only to writeable or from clean to
> dirty, we need to update the spte, yes.  But that's true for other sptes
> as well, not just large gptes.
> 

I think the indirect sp is not hurt by this bug since for the indirect sp, the access
just form its upper-level, and the D bit is only in the last level, when we change the
pte's access, is not affect its sp's access.

But for direct sp, the sp's access is form all level. and different mapping that not share
the last mapping page will have the same last sp.





