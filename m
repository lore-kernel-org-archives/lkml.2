Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab2HFQU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:20:28 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35546 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab2HFQU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:20:27 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Zach Brown <zab@redhat.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fuse: verify all ioctl retry iov elements
References: <10c600c845bf89db85c5126c49e78cfee8909b1d.1343157011.git.zab@zabbo.net>
Date: Mon, 06 Aug 2012 18:21:42 +0200
In-Reply-To: <10c600c845bf89db85c5126c49e78cfee8909b1d.1343157011.git.zab@zabbo.net>
	(Zach Brown's message of "Tue, 24 Jul 2012 12:10:11 -0700")
Message-ID: <87wr1crnxl.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown <zab@redhat.com> writes:

> Commit 7572777eef78ebdee1ecb7c258c0ef94d35bad16 attempted to verify that
> the total iovec from the client doesn't overflow iov_length() but it
> only checked the first element.  The iovec could still overflow by
> starting with a small element.  The obvious fix is to check all the
> elements.
>
> The overflow case doesn't look dangerous to the kernel as the copy is
> limited by the length after the overflow.  This fix restores the
> intention of returning an error instead of successfully copying less
> than the iovec represented.
>
> I found this by code inspection.  I built it but don't have a test case.
> I'm cc:ing stable because the initial commit did as well.

Thanks!  Applied.

Miklos


>
> Signed-off-by: Zach Brown <zab@redhat.com>
> CC: <stable@kernel.org>         [2.6.37+]
> ---
>  fs/fuse/file.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index b321a68..514f12a 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1700,7 +1700,7 @@ static int fuse_verify_ioctl_iov(struct iovec *iov, size_t count)
>  	size_t n;
>  	u32 max = FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT;
>  
> -	for (n = 0; n < count; n++) {
> +	for (n = 0; n < count; n++, iov++) {
>  		if (iov->iov_len > (size_t) max)
>  			return -ENOMEM;
>  		max -= iov->iov_len;
