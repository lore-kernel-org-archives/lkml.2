Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1DOOxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:53:30 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:46455 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1DOOx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:53:29 -0400
Message-ID: <4DA85BDC.5030407@linux.vnet.ibm.com>
Date: Fri, 15 Apr 2011 07:53:16 -0700
From: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "M. Mohan Kumar" <mohan@in.ibm.com>
CC: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH] net/9p: Handle get_user_pages_fast return
 properly
References: <1302856173-10566-1-git-send-email-mohan@in.ibm.com>
In-Reply-To: <1302856173-10566-1-git-send-email-mohan@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 01:29 AM, M. Mohan Kumar wrote:
> Use proper data type to handle get_user_pages_fast error condition. Also
> do not treat EFAULT error as fatal.
>
> Signed-off-by: M. Mohan Kumar<mohan@in.ibm.com>
> ---
>   net/9p/client.c       |    2 +-
>   net/9p/trans_common.c |   11 +++--------
>   2 files changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 691a04a..1612142 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -614,7 +614,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
>
>   	err = c->trans_mod->request(c, req);
>   	if (err<  0) {
> -		if (err != -ERESTARTSYS)
> +		if (err != -ERESTARTSYS&&  err != -EFAULT)
Please analyze other errors that could be returned by 
c->trans_mod->request()
if they need any handling here.

>   			c->status = Disconnected;
>   		goto reterr;
>   	}
> diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
> index 14265e8..f020da9 100644
> --- a/net/9p/trans_common.c
> +++ b/net/9p/trans_common.c
> @@ -63,7 +63,7 @@ p9_payload_gup(struct p9_req_t *req, size_t *pdata_off, int *pdata_len,
>   		int nr_pages, u8 rw)
>   {
>   	uint32_t first_page_bytes = 0;
> -	uint32_t pdata_mapped_pages;
> +	int32_t pdata_mapped_pages;
>   	struct trans_rpage_info  *rpinfo;
>
>   	*pdata_off = (__force size_t)req->tc->pubuf&  (PAGE_SIZE-1);
> @@ -75,14 +75,9 @@ p9_payload_gup(struct p9_req_t *req, size_t *pdata_off, int *pdata_len,
>   	rpinfo = req->tc->private;
>   	pdata_mapped_pages = get_user_pages_fast((unsigned long)req->tc->pubuf,
>   			nr_pages, rw,&rpinfo->rp_data[0]);
> +	if (pdata_mapped_pages<= 0)
> +		return pdata_mapped_pages;
>
> -	if (pdata_mapped_pages<  0) {
> -		printk(KERN_ERR "get_user_pages_fast failed:%d udata:%p"
> -				"nr_pages:%d\n", pdata_mapped_pages,
> -				req->tc->pubuf, nr_pages);
> -		pdata_mapped_pages = 0;
> -		return -EIO;
> -	}
I would keep the printk and return  the pdata_mapped_pages inside the if 
condition.

Thanks,
JV

>   	rpinfo->rp_nr_pages = pdata_mapped_pages;
>   	if (*pdata_off) {
>   		*pdata_len = first_page_bytes;

