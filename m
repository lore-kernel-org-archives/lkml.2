Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab0I3Ewa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:52:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753010Ab0I3EwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:52:25 -0400
Date: Wed, 29 Sep 2010 21:53:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17] fs: Clean up inode reference counting
Message-Id: <20100929215328.69eb5096.akpm@linux-foundation.org>
In-Reply-To: <1285762729-17928-18-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-18-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 22:18:49 +1000 Dave Chinner <david@fromorbit.com> wrote:

> -static inline void __iget(struct inode *inode)
> +static inline void iget_ilock(struct inode *inode)
>  {
>  	assert_spin_locked(&inode->i_lock);
> +	BUG_ON(inode->i_state & (I_FREEING|I_CLEAR|I_WILL_FREE));
>  	inode->i_count++;
>  }
>  
> +static inline void iget(struct inode *inode)
> +{
> +	spin_lock(&inode->i_lock);
> +	iget_ilock(inode);
> +	spin_unlock(&inode->i_lock);
> +}

I suspect that for typical configs, these functions will generate amazing
amounts of code.

Please measure this.  We may decide to uninline both.

