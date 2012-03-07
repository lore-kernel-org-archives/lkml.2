Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab2CGP3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:29:16 -0500
Received: from mail.us.es ([193.147.175.20]:37071 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab2CGP3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:29:13 -0500
Date: Wed, 7 Mar 2012 16:29:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Richard Weinberger <richard@nod.at>
Cc: jengelh@medozas.de, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [PATCH 6/6] Netfilter: xt_LOG: Add timestamp support
Message-ID: <20120307152910.GA7044@1984>
References: <1330989588-26833-1-git-send-email-richard@nod.at>
 <1330989588-26833-7-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1330989588-26833-7-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 12:19:48AM +0100, Richard Weinberger wrote:
> Using XT_LOG_ADD_TIMESTAMP it is possible to have a timestamp
> directly in the log message.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  include/linux/netfilter/xt_LOG.h |    3 ++-
>  net/netfilter/xt_LOG.c           |    8 ++++++++
>  2 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/netfilter/xt_LOG.h b/include/linux/netfilter/xt_LOG.h
> index 8ac25e0..9361374 100644
> --- a/include/linux/netfilter/xt_LOG.h
> +++ b/include/linux/netfilter/xt_LOG.h
> @@ -8,7 +8,8 @@
>  #define XT_LOG_UID		0x08	/* Log UID owning local socket */
>  #define XT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
>  #define XT_LOG_MACDECODE	0x20	/* Decode MAC header */
> -#define XT_LOG_MASK		0x2f
> +#define XT_LOG_ADD_TIMESTAMP	0x40    /* Add a timestamp */
> +#define XT_LOG_MASK		0x6f
>  
>  struct xt_log_info {
>          unsigned char level;
> diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
> index f75f2d7..23db206 100644
> --- a/net/netfilter/xt_LOG.c
> +++ b/net/netfilter/xt_LOG.c
> @@ -499,6 +499,14 @@ log_packet_common(struct sbuff *m,
>  	if (loginfo->type == NF_LOG_TYPE_LOG)
>  		sb_add(m, "<%d>", loginfo->u.log.level);
>  
> +	if (loginfo->u.log.logflags & XT_LOG_ADD_TIMESTAMP) {
> +		struct timespec tv;
> +
> +		getnstimeofday(&tv);
> +		sb_add(m, "TIMESTAMP=%li.%03u ", tv.tv_sec,
> +			(unsigned int)tv.tv_nsec / NSEC_PER_MSEC);

net/netfilter/xt_LOG.c: In function ‘log_packet_common’:
net/netfilter/xt_LOG.c:507:4: warning: format ‘%u’ expects argument of
type ‘unsigned int’, but argument 4 has type ‘long int’ [-Wformat]

It has to be:

                sb_add(m, "TIMESTAMP=%li.%03u ", tv.tv_sec,
                        (unsigned int)(tv.tv_nsec / NSEC_PER_MSEC));
                                      ^                          ^
I've fixed, no need to resend this patch.
