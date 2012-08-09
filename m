Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2HISyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 14:54:41 -0400
Received: from natasha.panasas.com ([67.152.220.90]:52550 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758992Ab2HISyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 14:54:39 -0400
Message-ID: <5024075B.4090804@panasas.com>
Date: Thu, 9 Aug 2012 11:54:19 -0700
From: Sachin Bhamare <sbhamare@panasas.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        <osd-dev@open-osd.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@ispras.ru>
Subject: Re: [PATCH] exofs: check for allocation failure in uri_store()
References: <1344445357-986-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1344445357-986-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/12 10:02 AM, Alexey Khoroshilov wrote:
> There is no memory allocation failure check in uri_store().
> That can lead to NULL pointer dereference.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  fs/exofs/sys.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/exofs/sys.c b/fs/exofs/sys.c
> index 5a7b691..1b4f2f9 100644
> --- a/fs/exofs/sys.c
> +++ b/fs/exofs/sys.c
> @@ -80,8 +80,13 @@ static ssize_t uri_show(struct exofs_dev *edp, char *buf)
>  
>  static ssize_t uri_store(struct exofs_dev *edp, const char *buf, size_t len)
>  {
> +	uint8_t *new_uri;
> +
>  	edp->urilen = strlen(buf) + 1;
> -	edp->uri = krealloc(edp->uri, edp->urilen, GFP_KERNEL);
> +	new_uri = krealloc(edp->uri, edp->urilen, GFP_KERNEL);
> +	if (new_uri == NULL)
> +		return -ENOMEM;
> +	edp->uri = new_uri;
>  	strncpy(edp->uri, buf, edp->urilen);
>  	return edp->urilen;
>  }
Ack-by : Sachin Bhamare <sbhamare@panasas.com>
