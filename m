Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab1DNKr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:47:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50766 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab1DNKr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=fDP+sSB1b1QQG7WgXlLslGWQhjDzJ2JTrDxsh/pK8WiGZ6xylq7DLvSoaGlo6KR/+F
         VuNBu3x2+n+NEVmgH7UIqseDHZ8+1ahgSGvI6O3kyS9Z3tyKWOVtGS3mWXZo9QuTp/xM
         fS/NY3KuKHYCNOCPI9n/Q78jx1PIbAocZu9jA=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: =?utf-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        "Pintu Agarwal" <pintu_agarwal@yahoo.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Changli Gao" <xiaosuo@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>,
        azurIt <azurit@pobox.sk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Regarding memory fragmentation using malloc....
References: <475805.23113.qm@web162014.mail.bf1.yahoo.com>
Date: Thu, 14 Apr 2011 12:47:53 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtxb92f73l0zgt@mnazarewicz-glaptop>
In-Reply-To: <475805.23113.qm@web162014.mail.bf1.yahoo.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 08:44:50 +0200, Pintu Agarwal  
<pintu_agarwal@yahoo.com> wrote:
> As I can understand from your comments that, malloc from user space will  
> not have much impact on memory fragmentation.

It has an impact, just like any kind of allocation, it just don't care  
about
fragmentation of physical memory.  You can have only 0-order pages and
successfully allocate megabytes of memory with malloc().

> Will the memory fragmentation be visible if I do kmalloc from
> the kernel module????

It will be more visible in the sense that if you allocate 8 KiB, kernel  
will
have to find 8 KiB contiguous physical memory (ie. 1-order page).

>> No.  When you call malloc() only virtual address space is allocated.
>> The actual allocation of physical space occurs when user space accesses
>> the memory (either reads or writes) and it happens page at a time.
>
> Here, if I do memset then I am accessing the memory...right? That I am  
> doing already in my sample program.

Yes.  But note that even though it's a single memset() call, you are
accessing page at a time and kernel is allocating page at a time.

On some architectures (not ARM) you could access two pages with a single
instructions but I think that would result in two page faults anyway.  I
might be wrong though, the details are not important though.

>> what really happens is that kernel allocates the 0-order
>> pages and when
>> it runs out of those, splits a 1-order page into two
>> 0-order pages and
>> takes one of those.
>
> Actually, if I understand buddy allocator, it allocates pages from top  
> to bottom.

No.  If you want to allocate a single 0-order page, buddy looks for a
a free 0-order page.  If one is not found, it will look for 1-order page
and split it.  This goes up till buddy reaches (MAX_ORDER-1)-page.

> Is the memory fragmentation is always a cause of the kernel space  
> program and not user space at all?

Well, no.  If you allocate memory in user space, kernel will have to
allocate physical memory and *every* allocation may contribute to
fragmentation.  The point is, that all allocations from user-space are
single-page allocations even if you malloc() MiBs of memory.

> Can you provide me with some references for migitating memory  
> fragmentation in linux?

I'm not sure what you mean by that.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
