Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab0FBLSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:18:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699Ab0FBLS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:18:29 -0400
Message-ID: <4C063E01.7040206@redhat.com>
Date: Wed, 02 Jun 2010 14:18:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: rework remove-write-access for a slot
References: <4C061C16.9040208@cn.fujitsu.com>
In-Reply-To: <4C061C16.9040208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 11:53 AM, Lai Jiangshan wrote:
> Current code uses slot_bitmap to find ptes who map a page
> from the memory slot, it is not precise: some ptes in the shadow page
> are not map any page from the memory slot.
>
> This patch uses rmap to find the ptes precisely, and remove
> the unused slot_bitmap.
>
>    

Patch looks good; a couple of comments:

- We might see a slowdown with !tdp, since we no longer have locality.  
Each page will map to an spte in a different page.  However, it's still 
worth it in my opinion.
- I thought of a different approach to write protection: write protect 
the L4 sptes, on write fault add write permission to the L4 spte and 
write protect the L3 sptes that it points to, etc.  This method can use 
the slot bitmap to reduce the number of write faults.  However we can 
reintroduce the slot bitmap if/when we use the method, this shouldn't 
block the patch.

>
> +static void rmapp_remove_write_access(struct kvm *kvm, unsigned long 
> *rmapp)
> +{
> +    u64 *spte = rmap_next(kvm, rmapp, NULL);
> +
> +    while (spte) {
> +        /* avoid RMW */
> +        if (is_writable_pte(*spte))
> +            *spte &= ~PT_WRITABLE_MASK;

Must use an atomic operation here to avoid losing dirty or accessed bit.

> +        spte = rmap_next(kvm, rmapp, spte);
> +    }
> +}


-- 
error compiling committee.c: too many arguments to function

