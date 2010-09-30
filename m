Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0I3SFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:05:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35389 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab0I3SFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qZcLXBGAFSDnkYKlYeuY+PMk49uiIMZ+6O6Ocugr8hYwIfOGgq20F1fj02Vv1vSBBX
         wD+xY88EVQWJwu+LuNgC8qxJq8PKm8gxS+rgptkY7mFGoT1qdf1LKEsojDDaETA3wfrK
         +jXGuntbLR054RulgQT+rVZQGPzSv7BBboh7k=
Subject: Re: [PATCH] fs: inode per-cpu last_ino allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100930103926.e60f3099.akpm@linux-foundation.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-16-git-send-email-david@fromorbit.com>
	 <20100929215312.5fcb6976.akpm@linux-foundation.org>
	 <1285824982.5211.675.camel@edumazet-laptop>
	 <1285833189.2615.31.camel@edumazet-laptop>
	 <20100930011417.6ca16ed7.akpm@linux-foundation.org>
	 <1285842136.2615.251.camel@edumazet-laptop>
	 <20100930094558.97c9afa2.akpm@linux-foundation.org>
	 <1285867685.2615.865.camel@edumazet-laptop>
	 <20100930103926.e60f3099.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 20:05:10 +0200
Message-ID: <1285869910.2615.925.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 10:39 -0700, Andrew Morton a écrit :
> On Thu, 30 Sep 2010 19:28:05 +0200 Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Le jeudi 30 septembre 2010 __ 09:45 -0700, Andrew Morton a __crit :
> > 
> > > Could eliminate `p' I guess, but that would involve using
> > > __get_cpu_var() as an lval, which looks vile and might generate worse
> > > code.
> > > 
> > 
> > Hmm, I see, please check this new patch, using the most modern stuff ;)
> > 
> > > Readers of this code won't know why last_ino_get() was marked noinline.
> > > It looks wrong, really.
> > 
> > Oops sorry, this was a temporary hack of mine to ease disassembly
> > analysis. Good catch !
> > 
> > Here is the new generated code on i686 (with the noinline) : 
> > pretty good ;)
> > 
> > c02e5930 <last_ino_get>:
> > c02e5930:	55                   	push   %ebp
> > c02e5931:	89 e5                	mov    %esp,%ebp
> > c02e5933:	64 a1 44 29 7d c0    	mov    %fs:0xc07d2944,%eax
> > c02e5939:	a9 ff 03 00 00       	test   $0x3ff,%eax
> > c02e593e:	74 09                	je     c02e5949 <last_ino_get+0x19>
> > c02e5940:	40                   	inc    %eax
> > c02e5941:	64 a3 44 29 7d c0    	mov    %eax,%fs:0xc07d2944
> > c02e5947:	c9                   	leave  
> > c02e5948:	c3                   	ret    
> > c02e5949:	b8 00 04 00 00       	mov    $0x400,%eax
> > c02e594e:	f0 0f c1 05 80 c8 92 c0	lock xadd %eax,0xc092c880
> > c02e5956:	eb e8                	jmp    c02e5940 <last_ino_get+0x10>
> > 
> 
> That uniprocessor, PREEMPT=n I guess.
> 

It is SMP. PREEMPT=n

On UP, you would not have the %fs suffixes, and no "lock" before the
xadd.



