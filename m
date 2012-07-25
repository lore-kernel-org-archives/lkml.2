Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab2GYHzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:55:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40791 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab2GYHzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:55:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6782"; a="211891302"
Message-ID: <500FA66F.7090202@codeaurora.org>
Date: Wed, 25 Jul 2012 00:55:27 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 06/13] driver core: firmware loader: always let firmware_buf
 own the pages buffer
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com> <1343149213-10160-7-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1343149213-10160-7-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly trivia.

On 7/24/2012 10:00 AM, Ming Lei wrote:
> +
> +static int fw_lookup_and_alloate_buf(const char *fw_name,

allocate?

> +		struct firmware_cache *fwc,
> +		struct firmware_buf **buf)
> +{
> +	struct firmware_buf *tmp;
> +
> +	spin_lock(&fwc->lock);
> +	list_for_each_entry(tmp, &fwc->head, list)
> +		if (!strcmp(tmp->fw_id, fw_name)) {
> +			kref_get(&tmp->ref);
> +			spin_unlock(&fwc->lock);
> +			*buf = tmp;
> +			return 1;
> +		}
> +
> +	tmp = __allocate_fw_buf(fw_name, fwc);
> +	if (tmp)
> +		list_add(&tmp->list, &fwc->head);
> +	spin_unlock(&fwc->lock);
> +
> +	*buf = tmp;
> +
> +	return tmp ? 0 : -1;

-ENOMEM instead of -1?

> +
> +static void fw_cache_init(void)

__init?

> +{
> +	spin_lock_init(&fw_cache.lock);
> +	INIT_LIST_HEAD(&fw_cache.head);
> +}
> +
[...]
> uevent, nowait);
>  
> -/* transfer the ownership of pages to firmware */
> -static void fw_set_page_data(struct firmware_buf *buf)
> -{
> -	struct firmware *fw = buf->fw;
> +	if (IS_ERR(fw_priv) || ret == -1) {
> +		kfree(firmware);
> +		*firmware_p = NULL;
> +		return ERR_PTR(-ENOMEM);

This would have to check for < 0 and return ERR_PTR(ret) instead.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

