Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1AZCaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 21:30:35 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:34998 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751940Ab1AZCae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 21:30:34 -0500
Date: Tue, 25 Jan 2011 21:30:31 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH 15/20] ufs: remove the BKL
Message-ID: <20110126023031.GA3160@elliptictech.com>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
 <1295993854-4971-16-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295993854-4971-16-git-send-email-arnd@arndb.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-25 23:17 +0100, Arnd Bergmann wrote:
> This introduces a new per-superblock mutex in UFS to replace
> the big kernel lock. I have been careful to avoid nested
> calls to lock_ufs and to get the lock order right with
> respect to other mutexes, in particular lock_super.
> 
> The code is still only compile-tested, but it should
> at least be harmless on non-SMP systems, since the
> new mutex is not taken on those.
[...]
> +void lock_ufs(struct super_block *sb)
> +{
> +#if defined(CONFIG_SMP) || defined (CONFIG_PREEMPT)
> +	struct ufs_sb_info *sbi = UFS_SB(sb);
> +
> +	mutex_lock(&sbi->mutex);
> +	sbi->mutex_owner = current;
> +#endif
> +}
> +
> +void unlock_ufs(struct super_block *sb)
> +{
> +#if defined(CONFIG_SMP) || defined (CONFIG_PREEMPT)
> +	struct ufs_sb_info *sbi = UFS_SB(sb);
> +
> +	sbi->mutex_owner = NULL;
> +	mutex_unlock(&sbi->mutex);
> +#endif
> +}

The sbi->mutex lock used by these functions is never initialized, which
causes an insta-crash on mount.  With a mutex_init call added to
ufs_fill_super, there are no obvious problems with my read-only
mounts after some (very light) testing.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
