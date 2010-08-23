Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0HWQVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:21:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0HWQVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:21:07 -0400
Date: Mon, 23 Aug 2010 12:21:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 RESEND] ptrace: cleanup address space conversion on
 ptrace_request()
Message-ID: <20100823162105.GA19164@infradead.org>
References: <201008222206.18523.arnd@arndb.de>
 <1282579575-9189-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282579575-9189-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 01:06:15AM +0900, Namhyung Kim wrote:
> In some cases 'data' should be considered as a user pointer but it requires
> cast with additional __force markup which was missing. Rather than add the
> markups wherever needed, make use of a temporary variable of user pointer.
> This patch is based on compat_ptrace_request() implementation.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  kernel/ptrace.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 4afd9b8..7547b1c 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -564,6 +564,7 @@ int ptrace_request(struct task_struct *child, long request,
>  {
>  	int ret = -EIO;
>  	siginfo_t siginfo;
> +	unsigned long __user *datap = (unsigned long __user __force *) data;

Just make this a

	void __user *datap = (void __user *)data;

and you can pass it around withjout additional casts.  Also no need
for the force here I think.

You'll still need a cast for the put_user calls, or you could just
convert them to copy_to_user which is fine with a void pointer.
