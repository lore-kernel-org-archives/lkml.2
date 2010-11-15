Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab0KOFVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 00:21:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63746 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0KOFVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 00:21:33 -0500
Message-ID: <4CE0C45C.809@cn.fujitsu.com>
Date: Mon, 15 Nov 2010 13:25:48 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: retry #PF for softmmu
References: <4CDCE2B0.7000601@cn.fujitsu.com> <4CDCE3C2.9030107@cn.fujitsu.com> <4CDFBE00.2000802@redhat.com>
In-Reply-To: <4CDFBE00.2000802@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 13:21:55,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-15 13:21:56,
	Serialize complete at 2010-11-15 13:21:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 06:46 PM, Avi Kivity wrote:
> On 11/12/2010 08:50 AM, Xiao Guangrong wrote:
>> Retry #PF for softmmu only when the current vcpu has the same
>> root shadow page as the time when #PF occurs. it means they
>> have same paging environment
>>
> 

Hi Avi,

Thanks for your review.

> The process could have been killed and replaced by another using the
> same cr3.  

Yeah, this 'retry' is unnecessary if the process is killed, but this
case is infrequent, the most case is the process keeps running and try
to access the fault address later. 

And, we can get few advantages even if the process have been killed,
since we can fix the page mapping for the other processes which have
the same CR3, if other process accessed the fault address, the #PF
can be avoid. (of course we can't speculate other process can access
the fault address later)

After all, this is a speculate path, i thinks it can work well in most
case. :-)

> Or we may be running a guest that uses the same cr3 for all
> processes.  

We can allow to retry #PF in the same CR3 even if there are the different
processes, since these processes have the same page mapping, the later #PF
can avoid if the page mapping have been fixed.

> Or another thread may have mmap()ed something else over the
> same address. 

The mmap virtual address is also visible for other threads since the threads
have the same page table, so i think this case is the same as above?




