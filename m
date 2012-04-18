Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab2DRXxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:53:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43966 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2DRXxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:53:35 -0400
Date: Wed, 18 Apr 2012 16:53:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-kernel@vger.kernel.org, davidel@xmailserver.org, avi@redhat.com,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH V2] eventfd: change int to __u64 in eventfd_signal()
Message-Id: <20120418165332.3561032d.akpm@linux-foundation.org>
In-Reply-To: <1334634276-5186-1-git-send-email-handai.szj@taobao.com>
References: <1334634276-5186-1-git-send-email-handai.szj@taobao.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 11:44:36 +0800
Sha Zhengju <handai.szj@gmail.com> wrote:

> From: Sha Zhengju <handai.szj@taobao.com>
> 
> eventfd_ctx->count is an __u64 counter which is allowed to reach ULLONG_MAX.
> Now eventfd_write() add an __u64 value to "count", but kernel side 
> eventfd_signal() only add an int value to it. So make them consistent.  
> 
> ...
>
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -51,15 +51,13 @@ struct eventfd_ctx {
>   *
>   * -EINVAL    : The value of @n is negative.
>   */
> -int eventfd_signal(struct eventfd_ctx *ctx, int n)
> +__u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
>  {
>  	unsigned long flags;
>  
> -	if (n < 0)
> -		return -EINVAL;
>  	spin_lock_irqsave(&ctx->wqh.lock, flags);
>  	if (ULLONG_MAX - ctx->count < n)
> -		n = (int) (ULLONG_MAX - ctx->count);
> +		n = ULLONG_MAX - ctx->count;
>  	ctx->count += n;
>  	if (waitqueue_active(&ctx->wqh))
>  		wake_up_locked_poll(&ctx->wqh, POLLIN);

The comment needs updating:

--- a/fs/eventfd.c~eventfd-change-int-to-__u64-in-eventfd_signal-fix
+++ a/fs/eventfd.c
@@ -46,10 +46,8 @@ struct eventfd_ctx {
  * value, and we signal this as overflow condition by returining a POLLERR
  * to poll(2).
  *
- * Returns @n in case of success, a non-negative number lower than @n in case
- * of overflow, or the following error codes:
- *
- * -EINVAL    : The value of @n is negative.
+ * Returns the amount by which the counter was incrememnted.  This will be less
+ * than @n if the counter has overflowed.
  */
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {

This doesn't seem a very useful return value.  Shouldn't it inform the
user about overflow?  I guess the caller compares the return value to
`n'.  Of course, no callers bother doing this :(

What happens if the counter overflows?  It stops being updated.  What
is the user-visible effect of that?

(It's presumably not an issue at present with a 64-bit counter, but
might be a problem with your unexplained proposal of permitting
userspace to add to the counter)
