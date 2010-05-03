Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0ECJOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:14:00 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48930 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0ECJN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CTX6tox1dLxQtlsYgYwJNyDfqCQS8XtUy0Cf95d3a9C7eR6JnJmSva+eut4vvwzOEC
         89JOUCr02zFzxK0hFTbzz47/ENcxG9YiZR4MfydQgy9dN0T7Ta3j31DoC7ayMvyy0Z/8
         qdOEJqeumEnDwjxKPDa3Yq7PG2lq6hqYcaPlY=
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Avi Kivity <avi@redhat.com>, Changli Gao <xiaosuo@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, jslaby@suse.cz,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4BDE8E24.5050200@redhat.com>
References: <viro@zeniv.linux.org.uk>
	 <1272818776-7729-1-git-send-email-xiaosuo@gmail.com>
	 <4BDDB6E9.4060703@redhat.com>
	 <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp>
	 <4BDE67DA.4080004@redhat.com>
	 <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com>
	 <4BDE7E66.8030509@redhat.com>
	 <m2l412e6f7f1005030052ka39a33ceke8c6b61553ba007f@mail.gmail.com>
	 <4BDE8E24.5050200@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 11:13:52 +0200
Message-ID: <1272878032.2226.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 mai 2010 à 11:49 +0300, Avi Kivity a écrit :

> A kmalloc()ed page is virtually contiguous, satisfying your requirement.
> 

Still, a different function pair is needed, at least for documentation
reasons.

Changli, _many_ patches like yours were suggested and refused in the
past for the reason it should be generic. Maybe its time...

So first introduce a pair of funtions, then we can use them.

At free time we can use is_vmalloc_addr() so that no extra bit is needed
to tell if a zone was vmalloced() or kmalloced()


One remark :

+       data = kmalloc(size, GFP_KERNEL);

If allocation fails (because of fragmentation), we would have a kernel
log.
Still, vmalloc() might be OK.
So you should add a __GFP_NOWARN flag.




/*
 * Warning: if size is not a power of two, kmalloc() might
 * waste memory because of its requirements.
 */
void *kvmalloc(size_t size)
{
	void *ptr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);

	if (ptr)
		return ptr;
	return vmalloc(size);
}

void kvfree(void *ptr)
{
	BUG_ON(in_interrupt());
	if (is_vmalloc_addr(ptr))
		vfree(ptr);
	else
		kfree(ptr);
}


