Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab0KAAsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 20:48:09 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:37410 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab0KAAsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 20:48:08 -0400
Message-ID: <4CCE0EB2.9070302@oss.ntt.co.jp>
Date: Mon, 01 Nov 2010 09:49:54 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Yaniv Kamay <yaniv@qumranet.com>, Amit Shah <amit.shah@qumranet.com>,
        Ben-Ami Yassour <benami@il.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM x86: remove memset, use vzalloc and don't assign
 the same value to a variable twice
References: <alpine.LNX.2.00.1010302020150.1572@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1010302020150.1572@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/31 3:28), Jesper Juhl wrote:
> Hi,
>
> We can improve kvm_vm_ioctl_get_dirty_log() slightly by using vzalloc()
> rather than first allocating and then manually zero the memory with
> memset(). Also, while I was looking at this I noticed that we assign

I personally prefer this new vzalloc() to vmalloc() + memset().

Just from my interest, is there real performance difference not just
the cleanup effect?  If so, we'd better do this for other places too.


> -ENOMEM to the 'r' variable twice even though none of the code inbetween
> the two assignments can change 'r', so I removed the second assignment.
>
> Patch has been compile tested only.
>
> Please consider merging and please CC me on all replies as I'm not
> subscribed to the kvm mailing list.
>
>
> Signed-off-by: Jesper Juhl<jj@chaosbits.net>
> ---
>   x86.c |    4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2288ad8..29f9c0a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3174,12 +3174,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>   		spin_unlock(&kvm->mmu_lock);

This patch is not based on kvm.git, I guess.

>
>   		r = -ENOMEM;
> -		dirty_bitmap = vmalloc(n);
> +		dirty_bitmap = vzalloc(n);
>   		if (!dirty_bitmap)
>   			goto out;
> -		memset(dirty_bitmap, 0, n);
>
> -		r = -ENOMEM;

This one is here because this belongs to a different code block from the
previous one.  This keeps it easy to insert another codes in between these
two blocks.  The optimization will be done at compile time.
IIRC, I did like this based on Avi's advise.

   Takuya

>   		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
>   		if (!slots) {
>   			vfree(dirty_bitmap);
>
>

