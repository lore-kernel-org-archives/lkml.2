Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab2IZVmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 17:42:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2IZVmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 17:42:20 -0400
Date: Wed, 26 Sep 2012 14:42:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 05/10] mm, util: Use dup_user to duplicate user memory
Message-Id: <20120926144219.bf4bfb9d.akpm@linux-foundation.org>
In-Reply-To: <CALF0-+WcXLR_akn8mL8u-QigHU9Bk5RotA3tbodZ8rhZsxpFLg@mail.gmail.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
	<1347137279-17568-5-git-send-email-elezegarcia@gmail.com>
	<20120925142948.6b062cb6.akpm@linux-foundation.org>
	<CALF0-+WcXLR_akn8mL8u-QigHU9Bk5RotA3tbodZ8rhZsxpFLg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012 22:15:38 -0300
Ezequiel Garcia <elezegarcia@gmail.com> wrote:

> > This patch increases util.o's text size by 238 bytes.  A larger kernel
> > with a worsened cache footprint.
> >
> > And we did this to get marginally improved tracing output?  This sounds
> > like a bad tradeoff to me.
> >
> 
> Mmm, that's bad tradeoff indeed.
> It's certainly odd since the patch shouldn't increase the text size
> *that* much.
> Is it too much to ask that you send your kernel config and gcc version.

x86_64 allmodconfig with CONFIG_DEBUG_INFO=n,
CONFIG_ENABLE_MUST_CHECK=n. gcc-4.4.4.

> My compilation (x86 kernel in gcc 4.7.1) shows a kernel less bloated:
> 
> $ readelf -s util-dup-user.o | grep dup_user
>    161: 00001c10   108 FUNC    GLOBAL DEFAULT    1 memdup_user
>    169: 00001df0   159 FUNC    GLOBAL DEFAULT    1 strndup_user
> $ readelf -s util.o | grep dup_user
>    161: 00001c10   108 FUNC    GLOBAL DEFAULT    1 memdup_user
>    169: 00001df0    98 FUNC    GLOBAL DEFAULT    1 strndup_user
> 
> $ size util.o
>    text	   data	    bss	    dec	    hex	filename
>   18319	   2077	      0	  20396	   4fac	util.o
> $ size util-dup-user.o
>    text	   data	    bss	    dec	    hex	filename
>   18367	   2077	      0	  20444	   4fdc	util-dup-user.o
> 
> Am I doing anything wrong?

Dunno - it could be a config thing.

> If you still feel this is unnecessary bloatness, perhaps I could think of
> something depending on CONFIG_TRACING (though I know
> we all hate those nasty ifdefs).

hm.  Perhaps we could add an __always_inline_for_tracing.  But that
wouldn't help a lot - a CONFIG_TRACING_SUPPORT=y kernel would still be
impacted even if the user is never using tracing.

