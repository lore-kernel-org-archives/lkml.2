Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2KRCuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 21:50:35 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42415 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2KRCud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 21:50:33 -0500
Date: Sat, 17 Nov 2012 18:47:23 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: dragos.tatulea@intel.com
Cc: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        octavian.purdila@intel.com
Subject: Re: [PATCH v3 3/9] pstore: add support for external writers
Message-ID: <20121118024723.GC5556@lizard.sbx05977.paloaca.wayport.net>
References: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
 <1350558367-31801-4-git-send-email-dragos.tatulea@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350558367-31801-4-git-send-email-dragos.tatulea@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:06:01PM +0300, dragos.tatulea@intel.com wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
> 
> Other modules that may wish to write to persistent storage
> are supported by adding a notifier and write function.
> 
> The notifier has 3 events: PSTORE_BEGIN, PSTORE_DUMP and
> PSTORE_END.  External writers use the PSTORE_DUMP event
> whereas the PSTORE_BEGIN and PSTORE_END can be used by
> platform code to ensure the back end is powered up.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  fs/pstore/platform.c   |   88 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pstore.h |   43 +++++++++++++++++++----
>  2 files changed, 124 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 9d65723..63ff377 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
[...]
> +/* pstore_write must only be called from PSTORE_DUMP notifier callbacks */
> +int pstore_write(enum pstore_type_id type, const char *buf, size_t size)
> +{
> +	size_t len;
> +	int err = 0, err2;

I guess there is no need for err2 here, you can place it in the while
loop, in the if block.

> +
> +	if (!psinfo)
> +		return -ENODEV;
> +
> +	/*
> +	 * No locking is needed because pstore_write is called only from
> +	 * PSTORE_DUMP notifier callbacks.
> +	 */
> +
> +	if (type != psinfo->ext_type) {
> +		err = pstore_ext_flush();
> +		psinfo->ext_type = type;
> +		psinfo->ext_part = 1;
> +	}
> +
> +	while (size) {
> +		len = min(size, psinfo->bufsize - psinfo->ext_len);
> +		memcpy(psinfo->buf + psinfo->ext_len, buf, len);
> +		psinfo->ext_len += len;
> +		buf += len;
> +		size -= len;
> +		if (psinfo->ext_len == psinfo->bufsize) {
> +			err2 = pstore_ext_flush();
> +			if (err2 && !err)
> +				err = err2;
> +		}
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(pstore_write);
> +
>  module_param(backend, charp, 0444);
>  MODULE_PARM_DESC(backend, "Pstore backend to use");
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> index 55ab23f..1bf7f4b 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -40,17 +40,27 @@ enum pstore_type_id {
>  
>  struct module;
>  
> +/* Notifier events */
> +#define PSTORE_BEGIN		1
> +#define PSTORE_DUMP		2
> +#define PSTORE_END		3
> +
>  #define PSTORE_NO_HEADINGS	BIT(0)
>  #define PSTORE_MAX_KMSG_BYTES	BIT(1)
>  
>  struct pstore_info {
> -	struct module	*owner;
> -	char		*name;
> -	unsigned int	flags;
> -	spinlock_t	buf_lock;	/* serialize access to 'buf' */
> -	char		*buf;
> -	size_t		bufsize;
> -	struct mutex	read_mutex;	/* serialize open/read/close */

That's why I don't like "pretty" formatting for structs. :) The change is
unrelated, so please don't do this.

> +	struct module		*owner;
> +	char			*name;
> +	unsigned int		flags;
> +	spinlock_t		buf_lock;	/* serialize access to 'buf' */
> +	char			*buf;
> +	size_t			bufsize;
> +	struct mutex		read_mutex;	/* serialize open/read/close */
> +	u64			ext_id;
> +	size_t			ext_len;
> +	unsigned int		ext_part;
> +	enum pstore_type_id	ext_type;
> +	enum kmsg_dump_reason	ext_reason;
>  	int		(*open)(struct pstore_info *psi);
>  	int		(*close)(struct pstore_info *psi);
>  	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
> @@ -70,12 +80,31 @@ struct pstore_info {
>  
>  #ifdef CONFIG_PSTORE
>  extern int pstore_register(struct pstore_info *);
> +extern int pstore_notifier_register(struct notifier_block *n);
> +extern int pstore_notifier_unregister(struct notifier_block *n);
> +/* pstore_write must only be called from PSTORE_DUMP notifier callbacks */
> +extern int pstore_write(enum pstore_type_id type, const char *buf, size_t size);
>  #else
>  static inline int
>  pstore_register(struct pstore_info *psi)
>  {
>  	return -ENODEV;
>  }
> +static inline int
> +pstore_notifier_register(struct notifier_block *n)
> +{
> +	return 0;
> +}
> +static inline int
> +pstore_notifier_unregister(struct notifier_block *n)
> +{
> +	return 0;
> +}
> +static inline int
> +pstore_write(enum pstore_type_id type, const char *buf, size_t size)
> +{
> +	return 0;
> +}
>  #endif
>  
>  #endif /*_LINUX_PSTORE_H*/
> -- 
> 1.7.9.5
