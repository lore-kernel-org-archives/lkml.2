Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1ELAI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 20:08:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab1ELAI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 20:08:57 -0400
Date: Wed, 11 May 2011 17:08:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] block: Remove extra discard_alignment from hd_struct.
Message-Id: <20110511170818.6506bb9d.akpm@linux-foundation.org>
In-Reply-To: <1303287455-3796-1-git-send-email-tm@tao.ma>
References: <1303287455-3796-1-git-send-email-tm@tao.ma>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011 16:17:35 +0800
Tao Ma <tm@tao.ma> wrote:

> --- a/fs/partitions/check.c
> +++ b/fs/partitions/check.c
> @@ -255,7 +255,12 @@ ssize_t part_discard_alignment_show(struct device *dev,
>  				   struct device_attribute *attr, char *buf)
>  {
>  	struct hd_struct *p = dev_to_part(dev);
> -	return sprintf(buf, "%u\n", p->discard_alignment);
> +	struct gendisk *disk = dev_to_disk(dev);
> +
> +	return sprintf(buf, "%u\n",
> +		       (unsigned long long)queue_limit_discard_alignment(
> +							&disk->queue->limits,
> +							p->start_sect));

fs/partitions/check.c: In function 'part_discard_alignment_show':
fs/partitions/check.c:263: warning: format '%u' expects type 'unsigned int', but argument 3 has type 'long long unsigned int'

um, that should have been apparent from cursory review, let alone
compile testing.  And it will fail runtime testing on little-endian
machines if the third arg is passed on the stack.

