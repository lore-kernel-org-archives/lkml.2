Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab2IDU71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 16:59:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab2IDU7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 16:59:25 -0400
Date: Tue, 4 Sep 2012 13:59:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Subject: Re: [PATCH] mm: fix mmap overflow checking
Message-Id: <20120904135924.b61e04e0.akpm@linux-foundation.org>
In-Reply-To: <1346750580-11352-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1346750580-11352-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012 17:23:00 +0800
Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:

> POSIX said that if the file is a regular file and the value of "off"
> plus "len" exceeds the offset maximum established in the open file
> description associated with fildes, mmap should return EOVERFLOW.

That's what POSIX says, but what does Linux do?  It is important that
we precisely describe and understand the behaviour change, as there is
potential here to break existing applications.

I'm assuming that Linux presently permits the mmap() and then generates
SIGBUS if an access is attempted beyond the max file size?

> 	/* offset overflow? */
> -	if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
> -               return -EOVERFLOW;
> +	if (off + len < off)
> +		return -EOVERFLOW;

Well, this treats sizeof(off_t) as the "offset maximum established in
the open file".  But from my reading of the above excerpt, we should in
fact be checking against the underlying fs's s_maxbytes?

