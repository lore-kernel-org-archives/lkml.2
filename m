Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757719Ab0GWRBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 13:01:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33380 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0GWRBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 13:01:50 -0400
Message-ID: <4C49CAED.6020304@cs.helsinki.fi>
Date: Fri, 23 Jul 2010 20:01:33 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Patrick Pannuto <ppannuto@codeaurora.org>
CC: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <joel.becker@oracle.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        David Teigland <teigland@redhat.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 5/6] ocfs2: Fix memory leak on mlog_sys_init error path
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org> <1279836546-26913-6-git-send-email-ppannuto@codeaurora.org>
In-Reply-To: <1279836546-26913-6-git-send-email-ppannuto@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Pannuto wrote:
> This leak is the same as the bus path; mlog_kset.kobj.name is
> set, but kset_register fails, thus nothing will ever call
> kset_unregister and name will be leaked
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
> ---
>  fs/ocfs2/cluster/masklog.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
> index c7fba39..de715d4 100644
> --- a/fs/ocfs2/cluster/masklog.c
> +++ b/fs/ocfs2/cluster/masklog.c
> @@ -154,6 +154,7 @@ static struct kset mlog_kset = {
>  int mlog_sys_init(struct kset *o2cb_kset)
>  {
>  	int i = 0;
> +	int ret;
>  
>  	while (mlog_attrs[i].attr.mode) {
>  		mlog_attr_ptrs[i] = &mlog_attrs[i].attr;
> @@ -163,7 +164,11 @@ int mlog_sys_init(struct kset *o2cb_kset)
>  
>  	kobject_set_name(&mlog_kset.kobj, "logmask");
>  	mlog_kset.kobj.kset = o2cb_kset;
> -	return kset_register(&mlog_kset);
> +
> +	ret = kset_register(&mlog_kset);
> +	if (ret)
> +		kfree(mlog_kset.kobj.name);

Aren't we supposed to use kobject_cleanup() here?

> +	return ret;
>  }
>  
>  void mlog_sys_shutdown(void)

