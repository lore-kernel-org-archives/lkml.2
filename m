Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0EDFdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 01:33:09 -0400
Received: from mail-bw0-f217.google.com ([209.85.218.217]:58008 "EHLO
	mail-bw0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0EDFdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 01:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kvFGGmkbsFHcuZK6y2cugnRQ5y5iJ8tkUTD4C3d0u99kTRMtt++nm4SRPwjiuVVqrS
         /4lQWYIU4oF0mZ0Y8W95IfQDjbQOw0gtoB1rKGoZkz44m6i4KAU5+EEkL6lLGUG1pyVZ
         qkRPAYbixAJzNNN4XA5Ou2tyZp51F4ZydmQ+U=
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, jslaby@suse.cz,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <h2n412e6f7f1005032120t546ecd99w4e56146c54e5b6ad@mail.gmail.com>
References: <viro@zeniv.linux.org.uk>
	 <1272818776-7729-1-git-send-email-xiaosuo@gmail.com>
	 <4BDDB6E9.4060703@redhat.com>
	 <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp>
	 <4BDE67DA.4080004@redhat.com>
	 <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com>
	 <4BDE7E66.8030509@redhat.com>
	 <m2l412e6f7f1005030052ka39a33ceke8c6b61553ba007f@mail.gmail.com>
	 <4BDE8E24.5050200@redhat.com> <1272878032.2226.27.camel@edumazet-laptop>
	 <h2n412e6f7f1005032120t546ecd99w4e56146c54e5b6ad@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 07:33:00 +0200
Message-ID: <1272951180.2407.188.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 04 mai 2010 à 12:20 +0800, Changli Gao a écrit :

> we can use alloc_pages_exact()/free_pages_exact() when size is larger
> than PAGE_SIZE, then size isn't needed to be a power of two.
> 
> void *kvmalloc(size_t size)
> {
>       void *ptr;
> 
>       if (size < PAGE_SIZE)
>           return kmalloc(size, GFP_KERNEL);
>       ptr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
>       if (ptr)
>           return ptr;
>       return vmalloc(size);
> }
> 
> void *kvfree(void *ptr, size_t size)
> {
>        BUG_ON(in_interrupt());
>        if (size < PAGE_SIZE)
>             kfree(ptr);
>        else if (is_vmalloc_addr(ptr))
>             vfree(ptr);
>        else
>             free_pages_exact(ptr, size);
> }

Yes, this has the drawback to need 'size' in kvfree(), but it should not
be a problem for users of this code.

alloc_pages_exact() also fragments high order page, but I guess it's not
worse than kmalloc() in this context.



