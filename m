Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0ECJ3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:29:46 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62185 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab0ECJ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tQ2HSzPKWTbSb7QiB95FDPbt5KxXElihdx6YEOR/G00B6fc1uYAYY1/jzucOp6EBH5
         LUWcQwWyq7MAxWi9vFNXaSvuDSBfnrNmzbBeJ77jpqi531WPWVWi2XHPbWZFQ81HX0WQ
         kcAanMHtVmlug8+grsKS6z1la/oslifeuAVWg=
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Avi Kivity <avi@redhat.com>, Changli Gao <xiaosuo@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4BDE9504.8030401@suse.cz>
References: <viro@zeniv.linux.org.uk>
	 <1272818776-7729-1-git-send-email-xiaosuo@gmail.com>
	 <4BDDB6E9.4060703@redhat.com>
	 <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp>
	 <4BDE67DA.4080004@redhat.com>
	 <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com>
	 <4BDE7E66.8030509@redhat.com>
	 <m2l412e6f7f1005030052ka39a33ceke8c6b61553ba007f@mail.gmail.com>
	 <4BDE8E24.5050200@redhat.com> <1272878032.2226.27.camel@edumazet-laptop>
	 <4BDE9504.8030401@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 11:29:39 +0200
Message-ID: <1272878979.2226.33.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 mai 2010 à 11:19 +0200, Jiri Slaby a écrit :
> On 05/03/2010 11:13 AM, Eric Dumazet wrote:
> > /*
> >  * Warning: if size is not a power of two, kmalloc() might
> >  * waste memory because of its requirements.
> >  */
> > void *kvmalloc(size_t size)
> > {
> > 	void *ptr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
> 
> This is kind of waste of high-order pages, isn't it? Wouldn't it be
> better to have a watermark where we skip kmalloc completely?

> 
> 

There are many drawbacks using kmalloc() instead of vmalloc().

(NUMA comes to mind, if you want a zone spreaded on all available nodes)

So this kvmalloc() is not meant to be a generic replacement of all
vmalloc() users, only selected ones.

In some spots, allocating 8192 bytes in a driver setup for example, it
should be fine. Using a high order page for this is perfect, as long as
we can have a fallback to vmalloc()

grep bnx2_alloc_mem /proc/vmallocinfo
0xf8690000-0xf8692000    8192 bnx2_alloc_mem+0x111/0x6d0 pages=1 vmalloc


