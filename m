Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab1IMTQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 15:16:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58781 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab1IMTQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 15:16:56 -0400
Message-ID: <4E6FACBD.1020801@cn.fujitsu.com>
Date: Wed, 14 Sep 2011 03:19:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 11/11] KVM: MMU: improve write flooding detected
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4D17.2080700@cn.fujitsu.com> <4E6F395A.5030609@redhat.com>
In-Reply-To: <4E6F395A.5030609@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-14 03:15:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-14 03:15:43,
	Serialize complete at 2011-09-14 03:15:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 07:07 PM, Avi Kivity wrote:
> On 08/30/2011 05:38 AM, Xiao Guangrong wrote:
>> Detecting write-flooding does not work well, when we handle page written, if
>> the last speculative spte is not accessed, we treat the page is
>> write-flooding, however, we can speculative spte on many path, such as pte
>> prefetch, page synced, that means the last speculative spte may be not point
>> to the written page and the written page can be accessed via other sptes, so
>> depends on the Accessed bit of the last speculative spte is not enough
>>
>> Instead of detected page accessed, we can detect whether the spte is accessed
>> after it is written, if the spte is not accessed but it is written frequently,
>> we treat is not a page table or it not used for a long time
>>
>>
> 
> The spte may not be accessed, but other sptes in the same page can be accessed.  An example is the fixmap area for kmap_atomic(), there will be a lot of pte writes but other sptes will be accessed without going through soft-mmu at all.

I think this kind of shadow pae is mostly the last page table(level=1), maybe
we can skip the write-flooding for the last shadow page, because the last shadow
page can become unsync and it can not let page table write-protected.
 
> I think you have to read the parent_ptes->spte.accessed bits to be sure.
> 

I guess the overload of this way is little high:
- it needs to walk parent ptes for every shadow pages
- we need to clear the parent_ptes->spte.accessed bit when the page is written, and
  the tlb flush is needed.
no?

