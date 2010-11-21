Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab0KUSdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 13:33:43 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:62270 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0KUSdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 13:33:42 -0500
Subject: Re: 
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: "Dan J. Rosenberg" <drosenberg@vsecurity.com>
In-Reply-To: <3E0D78C2-CEAF-42C3-9840-20B01AA4EFC7@vsecurity.com>
Date: Sun, 21 Nov 2010 13:33:38 -0500
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9A449BDC-E014-406A-84BD-D0C1F2DFD928@vsecurity.com>
References: <3E0D78C2-CEAF-42C3-9840-20B01AA4EFC7@vsecurity.com>
To: segoon@openwall.com
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this case, count can never be -1, since it's limited by various checks in vfs_write() and rw_verify_area(), etc.  Even if a very large count is passed (LONG_MAX, for example), the allocation will just fail and the OOM killer won't be involved.

Still, it's probably not a bad idea to limit this value anyway.

> count is not checked before kmalloc() call, if it is -1 then
> kmalloc() returns ZERO_SIZE_PTR. This pointer is then dereferenced.
> Also one may pass too big count to generate OOM condition.
> To prevent this limit 'count' maximum value.  PAGE_SIZE looks OK.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
> Compile tested only.
> drivers/gpu/vga/vgaarb.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
> diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
> index c380c65..09e3090 100644
> --- a/drivers/gpu/vga/vgaarb.c
> +++ b/drivers/gpu/vga/vgaarb.c
> @@ -836,6 +836,8 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
> 	int ret_val;
> 	int i;
> 
> +	if (count > PAGE_SIZE)
> +		count = PAGE_SIZE;
> 
> 	kbuf = kmalloc(count + 1, GFP_KERNEL);
> 	if (!kbuf)

