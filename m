Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139Ab0FFQMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 12:12:46 -0400
Received: from daytona.panasas.com ([67.152.220.89]:22300 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932198Ab0FFQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 12:12:45 -0400
Message-ID: <4C0BC8F9.2050306@panasas.com>
Date: Sun, 06 Jun 2010 19:12:41 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind1@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCHv5 10/16] exofs: fix race condition in marking SB dirty
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com> <1275835829-1478-11-git-send-email-dedekind1@gmail.com>
In-Reply-To: <1275835829-1478-11-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2010 16:12:44.0280 (UTC) FILETIME=[18B15F80:01CB0593]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2010 05:50 PM, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> When synchronizing the superblock, exofs first initiates the SB write
> (a) and then marks the superblock as clean (b). However, meanwhile
> (between (a) and (b)) someone else can modify the superblock and
> mark it as dirty. This would be a race condition, and the result
> would be that we'd end up with a modified superblock which would
> nevertheless be marked as clean (because of (b)). This means that
> 'sync_supers()' would never call our '->write_super()', at least
> not until yet another SB change happens.
> 
> This patch fixes this race condition by marking the superblock as
> clean before initiating the write operation.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>

Ack-by: Boaz Harrosh <bharrosh@panasas.com>

Grate fix thanks
Boaz

> ---
>  fs/exofs/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/exofs/super.c b/fs/exofs/super.c
> index 74ccbdc..0b432b9 100644
> --- a/fs/exofs/super.c
> +++ b/fs/exofs/super.c
> @@ -219,6 +219,7 @@ int exofs_sync_fs(struct super_block *sb, int wait)
>  	 *       the fscb->s_dev_table_oid member. There is no read-modify-write
>  	 *       here.
>  	 */
> +	sb_mark_clean(sb);
>  	ios->length = offsetof(struct exofs_fscb, s_dev_table_oid);
>  	memset(fscb, 0, ios->length);
>  	fscb->s_nextid = cpu_to_le64(sbi->s_nextid);
> @@ -237,7 +238,6 @@ int exofs_sync_fs(struct super_block *sb, int wait)
>  		EXOFS_ERR("%s: exofs_sbi_write failed.\n", __func__);
>  		goto out;
>  	}
> -	sb_mark_clean(sb);
>  
>  out:
>  	EXOFS_DBGMSG("s_nextid=0x%llx ret=%d\n", _LLU(sbi->s_nextid), ret);

