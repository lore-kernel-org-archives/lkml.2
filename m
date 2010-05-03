Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0ECAP2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 20:15:28 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:52172 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab0ECAP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 20:15:27 -0400
To: avi@redhat.com, xiaosuo@gmail.com
Cc: jslaby@suse.cz, akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <viro@zeniv.linux.org.uk>
	<1272818776-7729-1-git-send-email-xiaosuo@gmail.com>
	<4BDDB6E9.4060703@redhat.com>
In-Reply-To: <4BDDB6E9.4060703@redhat.com>
Message-Id: <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 3 May 2010 09:15:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 05/02/2010 07:46 PM, Changli Gao wrote:
> > use kmalloc() to allocate fdmem if possible.
> >
> > vmalloc() is used as a fallback solution for fdmem allocation. Two members are
> > added into the hole of the structure fdtable to indicate if vmalloc() is used
> > or not.
> >
> >
> > diff --git a/fs/file.c b/fs/file.c
> > index 34bb7f7..f71dd85 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -39,28 +39,34 @@ int sysctl_nr_open_max = 1024 * 1024; /* raised later */
> >    */
> >   static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
> >
> > -static inline void * alloc_fdmem(unsigned int size)
> > +static inline void *alloc_fdmem(unsigned int size, unsigned short *use_vmalloc)
> >   {
> > -	if (size<= PAGE_SIZE)
> > -		return kmalloc(size, GFP_KERNEL);
> > -	else
> > -		return vmalloc(size);
> > +	void *data;
> > +
> > +	data = kmalloc(size, GFP_KERNEL);
> > +	if (data != NULL) {
> > +		*use_vmalloc = 0;
> > +		return data;
> > +	}
> > +	*use_vmalloc = 1;
> > +
> > +	return vmalloc(size);
> >   }
> >    
> 
> Perhaps vmalloc() should do this by itself?  vfree() can examine the 
> pointer and call kfree() if it isn't within the vmalloc address range.

You can use is_vmalloc_addr().

	if (is_vmalloc_addr(p))
		vfree(p);
	else
		kfree(p);
