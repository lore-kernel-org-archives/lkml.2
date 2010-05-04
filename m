Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0EDEVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 00:21:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40450 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0EDEVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 00:21:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ff3nqS947vdYRGsIYBICvEru1jt8Dt9POqBwabSbZVLwnVDlYGS1B01GdZSk9NJZKp
         Nncvso0sL9kk9RJKHXZaSBwHdkF1X43btivhBkfwgVvrbbQ5doW1bu0Ao+wlcYWNHHst
         wgWVhwhwYOwJMeufVSqtDUTG/FztI8XMCCAyM=
MIME-Version: 1.0
In-Reply-To: <1272878032.2226.27.camel@edumazet-laptop>
References: <viro@zeniv.linux.org.uk> <1272818776-7729-1-git-send-email-xiaosuo@gmail.com> 
	<4BDDB6E9.4060703@redhat.com> <201005030915.FCD09385.FFHVOMJtSLOFQO@I-love.SAKURA.ne.jp> 
	<4BDE67DA.4080004@redhat.com> <y2z412e6f7f1005030005vc3be4977z3add08bfc72d1c44@mail.gmail.com> 
	<4BDE7E66.8030509@redhat.com> <m2l412e6f7f1005030052ka39a33ceke8c6b61553ba007f@mail.gmail.com> 
	<4BDE8E24.5050200@redhat.com> <1272878032.2226.27.camel@edumazet-laptop>
From: Changli Gao <xiaosuo@gmail.com>
Date: Tue, 4 May 2010 12:20:43 +0800
Message-ID: <h2n412e6f7f1005032120t546ecd99w4e56146c54e5b6ad@mail.gmail.com>
Subject: Re: [PATCH] fs: use kmalloc() to allocate fdmem if possible
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, jslaby@suse.cz,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       adobriyan@gmail.com, mingo@elte.hu, peterz@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 3, 2010 at 5:13 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> /*
>  * Warning: if size is not a power of two, kmalloc() might
>  * waste memory because of its requirements.
>  */
> void *kvmalloc(size_t size)
> {
>        void *ptr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
>
>        if (ptr)
>                return ptr;
>        return vmalloc(size);
> }

we can use alloc_pages_exact()/free_pages_exact() when size is larger
than PAGE_SIZE, then size isn't needed to be a power of two.

void *kvmalloc(size_t size)
{
      void *ptr;

      if (size < PAGE_SIZE)
          return kmalloc(size, GFP_KERNEL);
      ptr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
      if (ptr)
          return ptr;
      return vmalloc(size);
}

void *kvfree(void *ptr, size_t size)
{
       BUG_ON(in_interrupt());
       if (size < PAGE_SIZE)
            kfree(ptr);
       else if (is_vmalloc_addr(ptr))
            vfree(ptr);
       else
            free_pages_exact(ptr, size);
}

>
> void kvfree(void *ptr)
> {
>        BUG_ON(in_interrupt());
>        if (is_vmalloc_addr(ptr))
>                vfree(ptr);
>        else
>                kfree(ptr);
> }
>
