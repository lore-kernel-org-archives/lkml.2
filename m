Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2BPA4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:56:16 -0500
Received: from mail.betterlinux.com ([199.58.199.50]:59586 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab2BPA4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:56:13 -0500
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 5C693821A8
Date: Thu, 16 Feb 2012 01:56:08 +0100
From: Andrea Righi <andrea@betterlinux.com>
To: Arun Sharma <asharma@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        John Stultz <john.stultz@linaro.org>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] fadvise: implement POSIX_FADV_NOREUSE
Message-ID: <20120216005608.GC21685@thinkpad>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
 <1329006098-5454-4-git-send-email-andrea@betterlinux.com>
 <20120215233537.GA20724@dev3310.snc6.facebook.com>
 <20120215234724.GA21685@thinkpad>
 <4F3C467B.1@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F3C467B.1@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 03:57:47PM -0800, Arun Sharma wrote:
> 
> 
> On 2/15/12 3:47 PM, Andrea Righi wrote:
> >>index 74b6a97..b4e45e6 100644
> >>--- a/include/linux/fs.h
> >>+++ b/include/linux/fs.h
> >>@@ -9,7 +9,6 @@
> >>  #include<linux/limits.h>
> >>  #include<linux/ioctl.h>
> >>  #include<linux/blk_types.h>
> >>-#include<linux/kinterval.h>
> >>  #include<linux/types.h>
> >>
> >>  /*
> >>@@ -656,7 +655,7 @@ struct address_space {
> >>  	spinlock_t		private_lock;	/* for use by the address_space */
> >>  	struct list_head	private_list;	/* ditto */
> >>  	struct address_space	*assoc_mapping;	/* ditto */
> >>-	struct rb_root		nocache_tree;	/* noreuse cache range tree */
> >>+	void			*nocache_tree;	/* noreuse cache range tree */
> >>  	rwlock_t		nocache_lock;	/* protect the nocache_tree */
> >>  } __attribute__((aligned(sizeof(long))));
> >>  	/*
> >
> >mmh.. a forward declaration of rb_root in fs.h shouldn't be better than
> >this?
> >
> 
> Forward declaration works if the type was struct rb_root *. But the
> type in your patch was a struct and the compiler can't figure out
> its size.
> 
> include/linux/fs.h:659:17: error: field ‘nocache_tree’ has incomplete type
> 
> Did you mean forward declaring struct rb_node instead of rb_root?
> 
> If we go down this path, a few more places need fixups (I ignored
> the compiler warnings about casting void * to struct rb_root *).
> 
>  -Arun

Oh sorry, you're right! nocache_tree is not a pointer inside
address_space, so the compiler must know the size.

mmh... move the definition of the rb_root struct in linux/types.h? or
simply use a rb_root pointer. The (void *) looks a bit scary and too bug
prone.

-Andrea
