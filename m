Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab0F1LN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 07:13:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab0F1LN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 07:13:27 -0400
Message-ID: <4C2883D3.2050606@redhat.com>
Date: Mon, 28 Jun 2010 14:13:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 3/10] KVM: MMU: fix direct sp's access corruptted
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BAD.6000609@cn.fujitsu.com> <4C287081.40300@redhat.com> <4C287332.5080803@cn.fujitsu.com>
In-Reply-To: <4C287332.5080803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 01:02 PM, Xiao Guangrong wrote:
>
> Avi Kivity wrote:
>
>    
>> Instead of adding a new bit, can you encode the protection in the direct
>> sp's access bits?  So we'll have one sp for read-only or
>> writeable-but-not-dirty small pages, and another sp for
>> writeable-and-dirty small pages.
>>
>>      
> It looks like it can't solve all problems, it fix the access corrupted,
> but will cause D bit losed:
>
> mapping A and mapping B both are writable-and-dirty, when mapping A write
> #PF occurs, the mapping is writable, then we can't set B's D bit anymore.
>    

If B is writeable-and-dirty, then it's D bit is already set, and we 
don't need to do anything.

If B is writeable-and-clean, then we'll have an spte pointing to a 
read-only sp, so we'll get a write fault on access and an opportunity to 
set the D bit.

> Anyway, i think we should re-intall the mapping when the state is changed. :-(
>    

When the gpte is changed from read-only to writeable or from clean to 
dirty, we need to update the spte, yes.  But that's true for other sptes 
as well, not just large gptes.

-- 
error compiling committee.c: too many arguments to function

