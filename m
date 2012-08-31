Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab2HaUrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 16:47:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26947 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2HaUrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 16:47:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6821"; a="231838834"
Message-ID: <504122BE.8080706@codeaurora.org>
Date: Fri, 31 Aug 2012 13:46:54 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
CC: linaro-mm-sig@lists.linaro.org,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: CMA page migration failure due to buffers on bh_lru
References: <503EBBD6.5080504@codeaurora.org>
In-Reply-To: <503EBBD6.5080504@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/2012 6:03 PM, Laura Abbott wrote:

> My quick and dirty workaround for testing is to remove the GFP_MOVABLE
> flag from find_or_create_page but this seems significantly less than
> optimal. Ideally, it seems like the buffers should be evicted from the
> LRU when trying to drop (expand on invalid_bh_lru?) but I'm not familiar
> enough with the code path to know if this is a good approach.
>
> Any suggestions/feedback is appreciated. Thanks.
>
> Laura

I came up with what I think is a reasonable fix to this. Feedback is 
appreciated. Thanks.

Laura


8<---

diff --git a/fs/buffer.c b/fs/buffer.c
index ad5938c..daa0c3d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1399,12 +1399,49 @@ static bool has_bh_in_lru(int cpu, void *dummy)
  	return 0;
  }

+static void __evict_bh_lru(void *arg)
+{
+	struct bh_lru *b = &get_cpu_var(bh_lrus);
+	struct buffer_head *bh = arg;
+	int i;
+
+	for (i = 0; i < BH_LRU_SIZE; i++) {
+		if (b->bhs[i] == bh) {
+			brelse(b->bhs[i]);
+			b->bhs[i] = NULL;
+			goto out;
+		}
+	}
+out:
+	put_cpu_var(bh_lrus);
+}
+
+static bool bh_exists_in_lru(int cpu, void *arg)
+{
+	struct bh_lru *b = per_cpu_ptr(&bh_lrus, cpu);
+	struct buffer_head *bh = arg;
+	int i;
+
+	for (i = 0; i < BH_LRU_SIZE; i++) {
+		if (b->bhs[i] == bh)
+			return 1;
+	}
+
+	return 0;
+
+}
  void invalidate_bh_lrus(void)
  {
  	on_each_cpu_cond(has_bh_in_lru, invalidate_bh_lru, NULL, 1, GFP_KERNEL);
  }
  EXPORT_SYMBOL_GPL(invalidate_bh_lrus);

+void evict_bh_lrus(struct buffer_head *bh)
+{
+	on_each_cpu_cond(bh_exists_in_lru, __evict_bh_lru, bh, 1, GFP_ATOMIC);
+}
+EXPORT_SYMBOL_GPL(evict_bh_lrus);
+
  void set_bh_page(struct buffer_head *bh,
  		struct page *page, unsigned long offset)
  {
@@ -3052,6 +3089,7 @@ drop_buffers(struct page *page, struct buffer_head 
**buffers_to_free)

  	bh = head;
  	do {
+		evict_bh_lrus(bh);
  		if (buffer_write_io_error(bh) && page->mapping)
  			set_bit(AS_EIO, &page->mapping->flags);
  		if (buffer_busy(bh))
-- 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
