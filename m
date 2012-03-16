Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185Ab2CPI5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:57:38 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:60568 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2CPI5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:57:35 -0400
Message-ID: <4F62F9C8.6090803@linux.vnet.ibm.com>
Date: Fri, 16 Mar 2012 16:28:56 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp> <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp> <4F62C9B4.7060804@linux.vnet.ibm.com> <20120316155511.70455b4a.yoshikawa.takuya@oss.ntt.co.jp> <4F62EC25.5060306@linux.vnet.ibm.com> <20120316165547.4df2abe4.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120316165547.4df2abe4.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12031608-5816-0000-0000-000001C20910
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 03:55 PM, Takuya Yoshikawa wrote:

> On Fri, 16 Mar 2012 15:30:45 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>>>> There is a example:
>>>>
>>>>              CPU A                                   CPU  B
>>>> guest page is written by write-emulation
>>>>
>>>>                                                   hold mmu-lock and see dirty-bitmap
>>>>                                                   is not be changed, then migration is
>>>>                                                   completed.
>>>
>>> We do not allow this break.
>>>
>>
>>
>> Hmm? what can avoid this? Could you please point it out?
> 
> Stopping the guest before actualy migrating the guest means VCPU threads
> must be back in the userspace at the moment, no?
> 
> So when the final GET_DIRTY_LOG is being executed, thread A cannot be
> in KVM.
> 
>> The problem is the guest page is written before dirty-bitmap is set,
>> we may log the dirty page in this window like above case...
> 
> Exactly, but the next GET_DIRTY_LOG call can take that because, as I
> wrote above, at this time the GET_DIRTY_LOG must not be the final one.
> 


Thanks for your explanation, maybe you are right, i do not know migration
much.

What i worried about is, you have changed the behaviour of GET_DIRTY_LOG,
in the current one, it can get all the dirty pages when it is called; after
your change, GET_DIRTY_LOG can get a empty dirty bitmap but dirty page exists.

Migration may work correctly depends on the final GET_DIRTY_LOG, in that time,
guest is stopped. But i am not sure whether other components using GET_DIRTY_LOG
are happy, e.g. frame-buffer.


