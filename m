Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0EXGl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 02:41:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0EXGl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 02:41:28 -0400
Message-ID: <4BFA1F92.2080802@redhat.com>
Date: Mon, 24 May 2010 09:41:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.net>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: Swap checksum
References: <4BF81D87.6010506@cesarb.net> <1274551731-4534-3-git-send-email-cesarb@cesarb.net> <4BF94792.5030405@redhat.com> <4BF97AC2.1040505@cesarb.net>
In-Reply-To: <4BF97AC2.1040505@cesarb.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2010 09:58 PM, Cesar Eduardo Barros wrote:
> Em 23-05-2010 12:19, Avi Kivity escreveu:
>> On 64-bit, we may be able to store the checksum in the pte, if the swap
>> device is small enough.
>
> Which pte? 

All of them.

> Correct me if I am wrong, but I do not think all pages written to the 
> swap have exactly one pte pointing to them. And I have not looked at 
> the shmem.c code yet, but does it even use ptes?

Well, the ptes need the swap address written into them, so they are 
already found and updated somehow.  All that's needed is to update the 
value written to also include the checksum.

> It might be possible (find all ptes and write the 32-bit checksum to 
> them, do something else for shmem, have two different code paths for 
> small/large swapfiles), but I do not know if the memory savings are 
> worth the extra complexity (especially the need for two separate code 
> paths).

Certainly not at first, but later it may be worthwhile.

>
>> If we take the trouble to touch the page, we may as well compare it
>> against zero, and if so drop it instead of swapping it out.
>
> The problem with this is that the page is touched deep inside the 
> crc32c code, which might even be using hardware instructions 
> (crc32c-intel). So we would need to read it two times to compare 
> against zero.

The second read is very cheap since the page is already in cache.  Also, 
we fail early when any word is nonzero, so usually the compare exits 
quickly.

>
> One possibility could be to compare the full page against zero only if 
> its crc is a specific value (the crc32c of a page full of zeros). This 
> would not be too slow (we would be wasting time only when we have a 
> very high probability of saving much more time), and not need to touch 
> the crc32c code at all. I would only have to look at how this messes 
> up the state tracking (i.e. how to make it track the fact that, 
> instead of getting written out, this is now a zeroed page).

Instead of returning a swap pte to be written to the page tables, return 
a zeroed pte.


> Other than that, it seems a good idea.
>


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

