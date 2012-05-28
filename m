Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2E1OUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 10:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab2E1OU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 10:20:29 -0400
Message-ID: <4FC38992.8070408@redhat.com>
Date: Mon, 28 May 2012 17:20:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] KVM: MMU: fix huge page adapted on non-PAE host
References: <4FC316E3.6080607@linux.vnet.ibm.com> <4FC35A15.6080000@redhat.com> <4FC363EE.6060204@linux.vnet.ibm.com> <4FC36E85.4010909@redhat.com> <4FC37600.1060301@linux.vnet.ibm.com> <4FC37A18.10809@redhat.com> <4FC38084.40409@linux.vnet.ibm.com> <4FC38362.6010802@redhat.com> <4FC3863F.5020902@linux.vnet.ibm.com>
In-Reply-To: <4FC3863F.5020902@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 05:05 PM, Xiao Guangrong wrote:
>>>
>>>
>>> I think the reason we move refcount in current code is, we should increase the
>>> refcount of the page we will mapped into shadow page table, since we always
>>> decrease its refcount after it is mapped. (That is this patch does.)
>>>
>> 
>> 
>> As far as I can tell __get_user_pages_fast() will take the reference
>> count in the page head in the first place.
> 
> 
> IIUC, the refcount used in the Compound Page is like this:
> 
> get_user_pages / get_page(page):
> 	head_page = page->first_page;
> 	if (page is not the head page)
> 		page->__mapcount++
> 	head_page->_count++
> 
> 	
> put_page(page):
> 	head_page = page->first_page;
> 	if (page is not the head page)
> 		page->__mapcount--
> 	head_page->_count--
> 

Aha.

The "right thing" we should be doing is running get_page() on every
small page within the frame (we asked for a small page but are
opportunistrically using the pages around it, without a proper ref).
That's a bit slow though, so we cheat.

Maybe we should do it anyway.  Large page maps/unmaps should be rare.

But I guess we can start with your fix.  But what about shifting mask by
one bit?  Isn't it sufficient?

-		mask = KVM_PAGES_PER_HPAGE(level) - 1;
+		mask = KVM_PAGES_PER_HPAGE(level);
+		mask *= KVM_HOST_HPAGES_PER_HPAGE;
+		mask -= 1;

This should move the reference to the right place.

-- 
error compiling committee.c: too many arguments to function
