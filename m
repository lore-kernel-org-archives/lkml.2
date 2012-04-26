Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab2DZGwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 02:52:05 -0400
Received: from mx1.b1-systems.de ([217.11.58.35]:46478 "EHLO mx1.b1-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab2DZGwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 02:52:03 -0400
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2012 02:52:03 EDT
Message-ID: <4F98EDB1.5090702@b1-systems.de>
Date: Thu, 26 Apr 2012 08:39:45 +0200
From: Karsten Keil <keil@b1-systems.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>,
        Hansjoerg Lipp <hjlipp@web.de>, i4ldeveloper@listserv.isdn4linux.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] isdn/gigaset: ratelimit CAPI message dumps
References: <20120425-patch-gigaset-00.tilman@imap.cc> <20120425-patch-gigaset-01.tilman@imap.cc>
In-Reply-To: <20120425-patch-gigaset-01.tilman@imap.cc>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.04.2012 01:02, schrieb Tilman Schmidt:
> Introduce a global ratelimit for CAPI message dumps to protect
> against possible log flood.
> Drop the ratelimit for ignored messages which is now covered by the
> global one.
> 

Hmm, I think the only CAPI messages which would need a ratelimit are
related to the DATA_B3 messages. If you need CAPI debug messages in most
cases you do not need all of the DATA_B3, but you do not want to miss
any other message related to the call control. With a general rate limit
you do not have the control, which messages are logged and which are not.
And here maybe some cases, when even the DATA_B3 are important (e.g.
searching bugs in flow control), so I would make it still conditional
to allow to print all messages.
And I'm not sure, if this is really something for stable.

> Signed-off-by: Tilman Schmidt <tilman@imap.cc>
> CC: stable <stable@kernel.org>
> ---
>  drivers/isdn/gigaset/capi.c |   22 +++++++++-------------
>  1 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
> index 343b5c8..292ca2f 100644
> --- a/drivers/isdn/gigaset/capi.c
> +++ b/drivers/isdn/gigaset/capi.c
> @@ -14,6 +14,7 @@
>  #include "gigaset.h"
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
> +#include <linux/ratelimit.h>
>  #include <linux/isdn/capilli.h>
>  #include <linux/isdn/capicmd.h>
>  #include <linux/isdn/capiutil.h>
> @@ -223,10 +224,14 @@ get_appl(struct gigaset_capi_ctr *iif, u16 appl)
>  static inline void dump_cmsg(enum debuglevel level, const char *tag, _cmsg *p)
>  {
>  #ifdef CONFIG_GIGASET_DEBUG
> +	/* dump at most 20 messages in 20 secs */
> +	static DEFINE_RATELIMIT_STATE(msg_dump_ratelimit, 20 * HZ, 20);
>  	_cdebbuf *cdb;
>  
>  	if (!(gigaset_debuglevel & level))
>  		return;
> +	if (!___ratelimit(&msg_dump_ratelimit, tag))
> +		return;
>  
>  	cdb = capi_cmsg2str(p);
>  	if (cdb) {
> @@ -2059,12 +2064,6 @@ static void do_reset_b3_req(struct gigaset_capi_ctr *iif,
>  }
>  
>  /*
> - * dump unsupported/ignored messages at most twice per minute,
> - * some apps send those very frequently
> - */
> -static unsigned long ignored_msg_dump_time;
> -
> -/*
>   * unsupported CAPI message handler
>   */
>  static void do_unsupported(struct gigaset_capi_ctr *iif,
> @@ -2073,8 +2072,7 @@ static void do_unsupported(struct gigaset_capi_ctr *iif,
>  {
>  	/* decode message */
>  	capi_message2cmsg(&iif->acmsg, skb->data);
> -	if (printk_timed_ratelimit(&ignored_msg_dump_time, 30 * 1000))
> -		dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
> +	dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
>  	send_conf(iif, ap, skb, CapiMessageNotSupportedInCurrentState);
>  }
>  
> @@ -2085,11 +2083,9 @@ static void do_nothing(struct gigaset_capi_ctr *iif,
>  		       struct gigaset_capi_appl *ap,
>  		       struct sk_buff *skb)
>  {
> -	if (printk_timed_ratelimit(&ignored_msg_dump_time, 30 * 1000)) {
> -		/* decode message */
> -		capi_message2cmsg(&iif->acmsg, skb->data);
> -		dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
> -	}
> +	/* decode message */
> +	capi_message2cmsg(&iif->acmsg, skb->data);
> +	dump_cmsg(DEBUG_CMD, __func__, &iif->acmsg);
>  	dev_kfree_skb_any(skb);
>  }
>  


-- 
Karsten Keil
Linux Kernel Development
Tel: +49 175 7249132
Mail: keil@b1-systems.de

B1 Systems GmbH
Osterfeldstraﬂe 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
