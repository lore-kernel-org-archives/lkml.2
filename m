Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0KASwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:52:39 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20370 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab0KASwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:52:37 -0400
Date: Mon, 1 Nov 2010 19:42:04 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Yaniv Kamay <yaniv@qumranet.com>, Amit Shah <amit.shah@qumranet.com>,
        Ben-Ami Yassour <benami@il.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM x86: remove memset, use vzalloc and don't assign
 the same value to a variable twice
In-Reply-To: <4CCE0EB2.9070302@oss.ntt.co.jp>
Message-ID: <alpine.LNX.2.00.1011011924440.9616@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302020150.1572@swampdragon.chaosbits.net> <4CCE0EB2.9070302@oss.ntt.co.jp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Nov 2010, Takuya Yoshikawa wrote:

> (2010/10/31 3:28), Jesper Juhl wrote:
> > Hi,
> > 
> > We can improve kvm_vm_ioctl_get_dirty_log() slightly by using vzalloc()
> > rather than first allocating and then manually zero the memory with
> > memset(). Also, while I was looking at this I noticed that we assign
> 
> I personally prefer this new vzalloc() to vmalloc() + memset().
> 
> Just from my interest, is there real performance difference not just
> the cleanup effect?  If so, we'd better do this for other places too.
> 
There's definately a positive size impact for the generated object code 
and we save having to do the call to memset() and the cost of a vzalloc() 
call looks more or less the same as a call to vmalloc() to me.


<snip>
> 
> This patch is not based on kvm.git, I guess.
> 
Nope. It was generated against mainline git as of a couple of days ago. I 
can generate a version against kvm.git if you prefer.


> >   		r = -ENOMEM;
> > -		dirty_bitmap = vmalloc(n);
> > +		dirty_bitmap = vzalloc(n);
> >   		if (!dirty_bitmap)
> >   			goto out;
> > -		memset(dirty_bitmap, 0, n);
> > 
> > -		r = -ENOMEM;
> 
> This one is here because this belongs to a different code block from the
> previous one.  This keeps it easy to insert another codes in between these
> two blocks.  The optimization will be done at compile time.
> IIRC, I did like this based on Avi's advise.
> 
Fair enough, I've dropped that bit from the patch. Updated version below 
(against current mainline git).


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 x86.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2288ad8..624d4da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3174,10 +3174,9 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		spin_unlock(&kvm->mmu_lock);
 
 		r = -ENOMEM;
-		dirty_bitmap = vmalloc(n);
+		dirty_bitmap = vzalloc(n);
 		if (!dirty_bitmap)
 			goto out;
-		memset(dirty_bitmap, 0, n);
 
 		r = -ENOMEM;
 		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

