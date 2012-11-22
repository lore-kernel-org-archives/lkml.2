Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2KVWsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:48:17 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43453 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2KVSda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:30 -0500
Message-ID: <50AE2842.3060509@gmail.com>
Date: Thu, 22 Nov 2012 21:27:30 +0800
From: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Maxim Patlasov <mpatlasov@parallels.com>
CC: miklos@szeredi.hu, dev@parallels.com, xemul@parallels.com,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, linux-mm@kvack.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/14] mm: Account for WRITEBACK_TEMP in balance_dirty_pages
References: <20121116171039.3196.92186.stgit@maximpc.sw.ru> <20121121115314.20471.52148.stgit@maximpc.sw.ru>
In-Reply-To: <20121121115314.20471.52148.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 08:01 PM, Maxim Patlasov wrote:
> Added linux-mm@ to cc:. The patch can stand on it's own.
>
>> Make balance_dirty_pages start the throttling when the WRITEBACK_TEMP
>> counter is high enough. This prevents us from having too many dirty
>> pages on fuse, thus giving the userspace part of it a chance to write
>> stuff properly.
>>
>> Note, that the existing balance logic is per-bdi, i.e. if the fuse
>> user task gets stuck in the function this means, that it either
>> writes to the mountpoint it serves (but it can deadlock even without
>> the writeback) or it is writing to some _other_ dirty bdi and in the
>> latter case someone else will free the memory for it.
> Signed-off-by: Maxim V. Patlasov <MPatlasov@parallels.com>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> ---
>   mm/page-writeback.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 830893b..499a606 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1220,7 +1220,8 @@ static void balance_dirty_pages(struct address_space *mapping,
>   		 */
>   		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
>   					global_page_state(NR_UNSTABLE_NFS);
> -		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK);
> +		nr_dirty = nr_reclaimable + global_page_state(NR_WRITEBACK) +
> +			global_page_state(NR_WRITEBACK_TEMP);
>   

Could you explain NR_WRITEBACK_TEMP is used for accounting what? And 
when it will increase?

>   		global_dirty_limits(&background_thresh, &dirty_thresh);
>   
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

