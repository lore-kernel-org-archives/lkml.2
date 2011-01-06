Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab1AFSuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:50:12 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:58831 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1AFSuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:50:10 -0500
Message-ID: <4D260ED8.5030807@linux.vnet.ibm.com>
Date: Thu, 06 Jan 2011 10:50:00 -0800
From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "M. Mohan Kumar" <mohan@in.ibm.com>
CC: v9fs-developer <v9fs-developer@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [V2] net/9p: Use proper data types
References: <1294305894-15951-1-git-send-email-mohan@in.ibm.com>
In-Reply-To: <1294305894-15951-1-git-send-email-mohan@in.ibm.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/6/2011 1:24 AM, M. Mohan Kumar wrote:
> Use proper data types for storing the count of the binary blob and
> length of a string. Without this patch length calculation of string will
> always result in -1 because of comparision between signed and unsigned

nit pick .. typo   - comparison

Otherwise looks good.

Reviewed by: Venkateswararao Jujjuri <jvrao@linux.vnet.ibm.com>

> integer.
> 
> Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
> ---
> Changes from previous version:
> * Use uint32_t inside va_arg
> * In function p9pdu_vreadf length of string can not be a signed int,
>   change the data type to unsigned int and remove the max_t expression
>   that becomes unnecessary with data type change
> 
> Commit 33551d7be66cec324c47990ed526b7fe327b011f net/9p/protocol.c:
> Remove duplicated macros from Thiago Farina <tfransosi@gmail.com> exposed this
> issue
> 
>  net/9p/protocol.c |   21 +++++++++------------
>  1 files changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/net/9p/protocol.c b/net/9p/protocol.c
> index c5180fd..1e308f2 100644
> --- a/net/9p/protocol.c
> +++ b/net/9p/protocol.c
> @@ -178,27 +178,24 @@ p9pdu_vreadf(struct p9_fcall *pdu, int proto_version, const char *fmt,
>  			break;
>  		case 's':{
>  				char **sptr = va_arg(ap, char **);
> -				int16_t len;
> -				int size;
> +				uint16_t len;
> 
>  				errcode = p9pdu_readf(pdu, proto_version,
>  								"w", &len);
>  				if (errcode)
>  					break;
> 
> -				size = max_t(int16_t, len, 0);
> -
> -				*sptr = kmalloc(size + 1, GFP_KERNEL);
> +				*sptr = kmalloc(len + 1, GFP_KERNEL);
>  				if (*sptr == NULL) {
>  					errcode = -EFAULT;
>  					break;
>  				}
> -				if (pdu_read(pdu, *sptr, size)) {
> +				if (pdu_read(pdu, *sptr, len)) {
>  					errcode = -EFAULT;
>  					kfree(*sptr);
>  					*sptr = NULL;
>  				} else
> -					(*sptr)[size] = 0;
> +					(*sptr)[len] = 0;
>  			}
>  			break;
>  		case 'Q':{
> @@ -234,14 +231,14 @@ p9pdu_vreadf(struct p9_fcall *pdu, int proto_version, const char *fmt,
>  			}
>  			break;
>  		case 'D':{
> -				int32_t *count = va_arg(ap, int32_t *);
> +				uint32_t *count = va_arg(ap, uint32_t *);
>  				void **data = va_arg(ap, void **);
> 
>  				errcode =
>  				    p9pdu_readf(pdu, proto_version, "d", count);
>  				if (!errcode) {
>  					*count =
> -					    min_t(int32_t, *count,
> +					    min_t(uint32_t, *count,
>  						  pdu->size - pdu->offset);
>  					*data = &pdu->sdata[pdu->offset];
>  				}
> @@ -404,9 +401,9 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
>  			break;
>  		case 's':{
>  				const char *sptr = va_arg(ap, const char *);
> -				int16_t len = 0;
> +				uint16_t len = 0;
>  				if (sptr)
> -					len = min_t(int16_t, strlen(sptr),
> +					len = min_t(uint16_t, strlen(sptr),
>  								USHRT_MAX);
> 
>  				errcode = p9pdu_writef(pdu, proto_version,
> @@ -439,7 +436,7 @@ p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
>  						 stbuf->n_gid, stbuf->n_muid);
>  			} break;
>  		case 'D':{
> -				int32_t count = va_arg(ap, int32_t);
> +				uint32_t count = va_arg(ap, uint32_t);
>  				const void *data = va_arg(ap, const void *);
> 
>  				errcode = p9pdu_writef(pdu, proto_version, "d",


