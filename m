Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035Ab0EMDSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 23:18:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753967Ab0EMDSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 23:18:44 -0400
Date: Wed, 12 May 2010 20:16:31 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] inotify: race use after free/double free in inotify
 inode marks
Message-Id: <20100512201631.a6955325.akpm@linux-foundation.org>
In-Reply-To: <1273680480-2550-1-git-send-email-eparis@redhat.com>
References: <1273680480-2550-1-git-send-email-eparis@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 12:08:00 -0400 Eric Paris <eparis@redhat.com> wrote:

> From: root <root@tyan-gt24-04.rhts.eng.bos.redhat.com>

hm.

> There is a race in the inotify add/rm watch code.  A task can find and
> remove a mark which doesn't have all of it's references.  This can
> result in a use after free/double free situation.
> 
> Task A					Task B
> ------------				-----------
> inotify_new_watch()
>  allocate a mark (refcnt == 1)
>  add it to the idr
> 					inotify_rm_watch()
> 					 inotify_remove_from_idr()
> 					  fsnotify_put_mark()
> 					      refcnt hits 0, free
>  take reference because we are on idr
>  [at this point it is a use after free]
>  [time goes on]
>  refcnt may hit 0 again, double free
> 
> The fix is to take the reference BEFORE the object can be found in the
> idr.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

The changelog has no "Cc: <stable@kernel.org>".  I suspect it should
have that?

