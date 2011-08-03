Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab1HCEfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 00:35:54 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49278 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1HCEft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 00:35:49 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Alex Ray <alexjray.ncsu@gmail.com>, Eric Van Hensbergen <ericvh@gmail.com>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex Ray <ajray@ncsu.edu>
Subject: Re: [PATCH] 9p: remove CONFIG_NET_9P_DEBUG option
In-Reply-To: <1312200884-20110-1-git-send-email-ajray@ncsu.edu>
References: <1312200884-20110-1-git-send-email-ajray@ncsu.edu>
User-Agent: Notmuch/0.5-318-g52e4ded (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Wed, 03 Aug 2011 10:04:43 +0530
Message-ID: <87sjpj3yfw.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Aug 2011 07:14:44 -0500, Alex Ray <alexjray.ncsu@gmail.com> wrote:
> Remove the CONFIG_NET_9P_DEBUG option, used to completely remove logging
> functionality from v9fs.  Logging is (already) controlled with the
> run-time debug= option, this gets rid of the compile-time option (which
> was being misunderstood and misused).


It would be nice to get those converted to trace points, that will help
us to enable/disable them easily, have low overhead when disabled. 

> 
> Signed-off-by: Alex Ray <ajray@ncsu.edu>
> ---
>  fs/9p/v9fs.c        |    2 --
>  include/net/9p/9p.h |    6 ------
>  net/9p/Kconfig      |    5 -----
>  net/9p/mod.c        |    2 --
>  net/9p/protocol.c   |    7 -------
>  5 files changed, 0 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
> index ef96618..f1cb2e2 100644
> --- a/fs/9p/v9fs.c
> +++ b/fs/9p/v9fs.c
> @@ -148,9 +148,7 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
>  		switch (token) {
>  		case Opt_debug:
>  			v9ses->debug = option;
> -#ifdef CONFIG_NET_9P_DEBUG
>  			p9_debug_level = option;
> -#endif
>  			break;
> 
>  		case Opt_dfltuid:
> diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
> index 342dcf1..17cc437 100644
> --- a/include/net/9p/9p.h
> +++ b/include/net/9p/9p.h
> @@ -61,7 +61,6 @@ enum p9_debug_flags {
>  	P9_DEBUG_VPKT =		(1<<12),
>  };
> 
> -#ifdef CONFIG_NET_9P_DEBUG
>  extern unsigned int p9_debug_level;
> 
>  #define P9_DPRINTK(level, format, arg...) \
> @@ -78,11 +77,6 @@ do {  \
> 
>  #define P9_DUMP_PKT(way, pdu) p9pdu_dump(way, pdu)
> 
> -#else
> -#define P9_DPRINTK(level, format, arg...)  do { } while (0)
> -#define P9_DUMP_PKT(way, pdu) do { } while (0)
> -#endif
> -
> 
>  #define P9_EPRINTK(level, format, arg...) \
>  do { \
> diff --git a/net/9p/Kconfig b/net/9p/Kconfig
> index d9ea09b..e1335e5 100644
> --- a/net/9p/Kconfig
> +++ b/net/9p/Kconfig
> @@ -28,9 +28,4 @@ config NET_9P_RDMA
>  	help
>  	  This builds support for an RDMA transport.
> 
> -config NET_9P_DEBUG
> -	bool "Debug information"
> -	help
> -	  Say Y if you want the 9P subsystem to log debug information.
> -
>  endif
> diff --git a/net/9p/mod.c b/net/9p/mod.c
> index 2664d12..4a3a303 100644
> --- a/net/9p/mod.c
> +++ b/net/9p/mod.c
> @@ -34,12 +34,10 @@
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
> 
> -#ifdef CONFIG_NET_9P_DEBUG
>  unsigned int p9_debug_level = 0;	/* feature-rific global debug level  */
>  EXPORT_SYMBOL(p9_debug_level);
>  module_param_named(debug, p9_debug_level, uint, 0);
>  MODULE_PARM_DESC(debug, "9P debugging level");
> -#endif
> 
>  /*
>   * Dynamic Transport Registration Routines
> diff --git a/net/9p/protocol.c b/net/9p/protocol.c
> index df58375..04b0585 100644
> --- a/net/9p/protocol.c
> +++ b/net/9p/protocol.c
> @@ -40,7 +40,6 @@
>  static int
>  p9pdu_writef(struct p9_fcall *pdu, int proto_version, const char *fmt, ...);
> 
> -#ifdef CONFIG_NET_9P_DEBUG
>  void
>  p9pdu_dump(int way, struct p9_fcall *pdu)
>  {
> @@ -63,12 +62,6 @@ p9pdu_dump(int way, struct p9_fcall *pdu)
>  		print_hex_dump_bytes("]9P[ ", DUMP_PREFIX_OFFSET, pdu->sdata,
>  									len);
>  }
> -#else
> -void
> -p9pdu_dump(int way, struct p9_fcall *pdu)
> -{
> -}
> -#endif
>  EXPORT_SYMBOL(p9pdu_dump);
> 
>  void p9stat_free(struct p9_wstat *stbuf)
> -- 

-aneesh
