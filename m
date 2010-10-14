Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0JNXUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:20:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab0JNXUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:20:39 -0400
Date: Thu, 14 Oct 2010 16:20:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        lmcilroy@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] vfs: fix overflow in direct-io subsystem
Message-Id: <20101014162021.ce03ab66.akpm@linux-foundation.org>
In-Reply-To: <201010132245.57467.edward.shishkin@gmail.com>
References: <201010132245.57467.edward.shishkin@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 22:45:57 +0200
Edward Shishkin <edward.shishkin@gmail.com> wrote:

> Fix up overflow (ssize_t->int) in the direct-io subsystem.
> 
> Signed-off-by: Edward Shishkin <edward@redhat.com>
> ---
>  fs/direct-io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.36-rc7.orig/fs/direct-io.c
> +++ linux-2.6.36-rc7/fs/direct-io.c
> @@ -218,7 +218,7 @@ static struct page *dio_get_page(struct 
>   * filesystems can use it to hold additional state between get_block calls and
>   * dio_complete.
>   */
> -static int dio_complete(struct dio *dio, loff_t offset, int ret, bool is_async)
> +static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async)
>  {
>  	ssize_t transferred = 0;
>  

I'd call this a truncation error, not an overflow.  Semantics.

So what's the runtime effect?  The subsystem will go stupid when doing
a single transfer of over 2G on a 64-bit machine?

Can this actually happen in practice?  Has nobody ever done this before
now?

<goes to test it>

<discovers that ubuntu 8.04's dd doesn't support conv=direct>

<stupid thing>
