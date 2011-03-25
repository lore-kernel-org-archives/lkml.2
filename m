Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1CYV06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:26:58 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57402 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1CYV05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:26:57 -0400
Message-ID: <4D8D089D.8020207@linux.vnet.ibm.com>
Date: Fri, 25 Mar 2011 14:26:53 -0700
From: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 5/5] 9p: Fix sparse error
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1301052651-21440-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1301052651-21440-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2011 04:30 AM, Aneesh Kumar K.V wrote:
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by : Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>
> ---
>   net/9p/protocol.c     |    3 ++-
>   net/9p/trans_common.c |    2 +-
>   net/9p/trans_virtio.c |   15 +++++++++++----
>   3 files changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/net/9p/protocol.c b/net/9p/protocol.c
> index 8a4084f..a7e8997 100644
> --- a/net/9p/protocol.c
> +++ b/net/9p/protocol.c
> @@ -468,7 +468,8 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
>   		case 'E':{
>   				 int32_t cnt = va_arg(ap, int32_t);
>   				 const char *k = va_arg(ap, const void *);
> -				 const char *u = va_arg(ap, const void *);
> +				 const char __user *u = va_arg(ap,
> +							const void __user *);
>   				 errcode = p9pdu_writef(pdu, proto_version, "d",
>   						 cnt);
>   				 if (!errcode&&  pdu_write_urw(pdu, k, u, cnt))
> diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
> index 9172ab7..14265e8 100644
> --- a/net/9p/trans_common.c
> +++ b/net/9p/trans_common.c
> @@ -66,7 +66,7 @@ p9_payload_gup(struct p9_req_t *req, size_t *pdata_off, int *pdata_len,
>   	uint32_t pdata_mapped_pages;
>   	struct trans_rpage_info  *rpinfo;
>
> -	*pdata_off = (size_t)req->tc->pubuf&  (PAGE_SIZE-1);
> +	*pdata_off = (__force size_t)req->tc->pubuf&  (PAGE_SIZE-1);
>
>   	if (*pdata_off)
>   		first_page_bytes = min(((size_t)PAGE_SIZE - *pdata_off),
> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> index e8f046b..244e707 100644
> --- a/net/9p/trans_virtio.c
> +++ b/net/9p/trans_virtio.c
> @@ -326,8 +326,11 @@ req_retry_pinned:
>   			outp = pack_sg_list_p(chan->sg, out, VIRTQUEUE_NUM,
>   					pdata_off, rpinfo->rp_data, pdata_len);
>   		} else {
> -			char *pbuf = req->tc->pubuf ? req->tc->pubuf :
> -								req->tc->pkbuf;
> +			char *pbuf;
> +			if (req->tc->pubuf)
> +				pbuf = (__force char *) req->tc->pubuf;
> +			else
> +				pbuf = req->tc->pkbuf;
>   			outp = pack_sg_list(chan->sg, out, VIRTQUEUE_NUM, pbuf,
>   					req->tc->pbuf_size);
>   		}
> @@ -352,8 +355,12 @@ req_retry_pinned:
>   			in = pack_sg_list_p(chan->sg, out+inp, VIRTQUEUE_NUM,
>   					pdata_off, rpinfo->rp_data, pdata_len);
>   		} else {
> -			char *pbuf = req->tc->pubuf ? req->tc->pubuf :
> -								req->tc->pkbuf;
> +			char *pbuf;
> +			if (req->tc->pubuf)
> +				pbuf = (__force char *) req->tc->pubuf;
> +			else
> +				pbuf = req->tc->pkbuf;
> +
>   			in = pack_sg_list(chan->sg, out+inp, VIRTQUEUE_NUM,
>   					pbuf, req->tc->pbuf_size);
>   		}

