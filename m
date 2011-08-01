Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1HAQPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:15:19 -0400
Received: from relay.parallels.com ([195.214.232.42]:45211 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1HAQPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:15:14 -0400
Message-ID: <4E36D110.30407@openvz.org>
Date: Mon, 1 Aug 2011 20:15:12 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.18) Gecko/20110416 SeaMonkey/2.0.13
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] mm: reverse lru scanning order
References: <20110727111002.9985.94938.stgit@localhost6>
In-Reply-To: <20110727111002.9985.94938.stgit@localhost6>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry, this patch is broken.

Konstantin Khlebnikov wrote:
> LRU scanning order was accidentially changed in commit v2.6.27-5584-gb69408e:
> "vmscan: Use an indexed array for LRU variables".
> Before that commit reclaimer always scan active lists first.
>
> This patch just reverse it back.
> This is just notice and question: "Does it affect something?"
>
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> ---
>   include/linux/mmzone.h |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index be1ac8d..88fb49c 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -141,7 +141,8 @@ enum lru_list {
>
>   #define for_each_lru(l) for (l = 0; l<  NR_LRU_LISTS; l++)
>
> -#define for_each_evictable_lru(l) for (l = 0; l<= LRU_ACTIVE_FILE; l++)
> +#define for_each_evictable_lru(l) \
> +	for (l = LRU_ACTIVE_FILE; l>= LRU_INACTIVE_ANON; l--)

there must be some thing like this:

+#define for_each_evictable_lru(l) \
+	for (l = LRU_ACTIVE_FILE; (int)l>= LRU_INACTIVE_ANON; l--)

otherwise gcc silently generates there infinite loop =)

>
>   static inline int is_file_lru(enum lru_list l)
>   {
>

