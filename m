Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab2LOUib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 15:38:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56752 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab2LOUia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 15:38:30 -0500
Date: Sat, 15 Dec 2012 20:38:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] omap_vout: find_vma() needs ->mmap_sem held
Message-ID: <20121215203828.GX4939@ZenIV.linux.org.uk>
References: <20121215201237.GW4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121215201237.GW4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 08:12:37PM +0000, Al Viro wrote:
> 	Walking rbtree while it's modified is a Bad Idea(tm); besides,
> the result of find_vma() can be freed just as it's getting returned
> to caller.  Fortunately, it's easy to fix - just take ->mmap_sem a bit
> earlier (and don't bother with find_vma() at all if virtp >= PAGE_OFFSET -
> in that case we don't even look at its result).

	While we are at it, what prevents VIDIOC_PREPARE_BUF calling
v4l_prepare_buf() -> (e.g) vb2_ioctl_prepare_buf() -> vb2_prepare_buf() ->
__buf_prepare() -> __qbuf_userptr() -> vb2_vmalloc_get_userptr() -> find_vma(),
AFAICS without having taken ->mmap_sem anywhere in process?  The code flow
is bloody convoluted and depends on a bunch of things done by initialization,
so I certainly might've missed something...
