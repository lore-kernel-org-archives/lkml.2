Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab1LBHCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 02:02:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1LBHCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 02:02:44 -0500
Date: Thu, 1 Dec 2011 23:03:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] writeback: permit through good bdi even when global
 dirty exceeded
Message-Id: <20111201230359.306c4c17.akpm@linux-foundation.org>
In-Reply-To: <20111202063603.GA10095@localhost>
References: <1322735278-17420-1-git-send-email-jack@suse.cz>
	<20111201122425.GA16274@localhost>
	<20111201142704.GT4387@parisc-linux.org>
	<20111202063603.GA10095@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011 14:36:03 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> --- linux-next.orig/mm/page-writeback.c	2011-12-02 10:16:21.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2011-12-02 14:28:44.000000000 +0800
> @@ -1182,6 +1182,14 @@ pause:
>  		if (task_ratelimit)
>  			break;
>  
> +		/*
> +		 * In the case of an unresponding NFS server and the NFS dirty
> +		 * pages exceeds dirty_thresh, give the other good bdi's a pipe
> +		 * to go through, so that tasks on them still remain responsive.
> +		 */
> +		if (bdi_dirty < 8)
> +			break;

What happens if the local disk has nine dirty pages?

Also: please, no more magic numbers.  We have too many in there already.

What to do instead?  Perhaps arrange for devices which can block in
this fashion to be identified as such in their backing_device and then
prevent the kernel from ever permitting such devices to fully consume
the dirty-page pool.

If someone later comes along and decreases the dirty limits mid-flight,
I guess the same problem occurs.  This can perhaps be handled by not
permitting to limit to be set that low at that time.
