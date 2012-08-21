Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2HUBse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 21:48:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35762 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab2HUBsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 21:48:31 -0400
Date: Mon, 20 Aug 2012 18:46:05 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3] pstore/ftrace: Convert to its own enable/disable
 debugfs knob
Message-ID: <20120821014605.GA32342@lizard>
References: <20120710001004.GA22744@lizard>
 <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
 <1342553898.10332.9.camel@gandalf.stny.rr.com>
 <20120717200130.GA31678@lizard>
 <1342561102.10332.18.camel@gandalf.stny.rr.com>
 <20120718034722.GA18081@lizard>
 <5006EE8C.20304@codeaurora.org>
 <20120718185029.GA4184@lizard>
 <50070789.7040601@codeaurora.org>
 <20120718193052.GA10220@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120718193052.GA10220@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 12:30:52PM -0700, Anton Vorontsov wrote:
> With this patch we no longer reuse function tracer infrastructure, now
> we register our own tracer back-end via a debugfs knob.
> 
> It's a bit more code, but that is the only downside. On the bright side we
> have:
> 
> - Ability to make persistent_ram module removable (when needed, we can
>   move ftrace_ops struct into a module). Note that persistent_ram is still
>   not removable for other reasons, but with this patch it's just one
>   thing less to worry about;
> 
> - Pstore part is more isolated from the generic function tracer. We tried
>   it already by registering our own tracer in available_tracers, but that
>   way we're loosing ability to see the traces while we record them to
>   pstore. This solution is somewhere in the middle: we only register
>   "internal ftracer" back-end, but not the "front-end";
> 
> - When there is only pstore tracing enabled, the kernel will only write
>   to the pstore buffer, omitting function tracer buffer (which, of course,
>   still can be enabled via 'echo function > current_tracer').
> 
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---

Hi Steven,

Unless there are any issues, may I take the patch via linux-pstore.git
tree?

Thanks!

>  Documentation/ramoops.txt      |    4 +-
>  fs/pstore/Kconfig              |    1 +
>  fs/pstore/ftrace.c             |   96 +++++++++++++++++++++++++++++++++++++++-
>  fs/pstore/internal.h           |    6 +++
>  fs/pstore/platform.c           |    1 +
>  include/linux/pstore.h         |    8 ----
>  kernel/trace/trace_functions.c |   15 +------
>  7 files changed, 105 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
> index 197ad59..69b3cac 100644
> --- a/Documentation/ramoops.txt
> +++ b/Documentation/ramoops.txt
> @@ -102,9 +102,7 @@ related hangs. The functions call chain log is stored in a "ftrace-ramoops"
>  file. Here is an example of usage:
>  
>   # mount -t debugfs debugfs /sys/kernel/debug/
> - # cd /sys/kernel/debug/tracing
> - # echo function > current_tracer
> - # echo 1 > options/func_pstore
> + # echo 1 > /sys/kernel/debug/pstore/record_ftrace
>   # reboot -f
>   [...]
>   # mount -t pstore pstore /mnt/
> diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
> index d39bb5c..ca71db6 100644
> --- a/fs/pstore/Kconfig
> +++ b/fs/pstore/Kconfig
> @@ -23,6 +23,7 @@ config PSTORE_FTRACE
>  	bool "Persistent function tracer"
>  	depends on PSTORE
>  	depends on FUNCTION_TRACER
> +	depends on DEBUG_FS
>  	help
>  	  With this option kernel traces function calls into a persistent
>  	  ram buffer that can be decoded and dumped after reboot through
> diff --git a/fs/pstore/ftrace.c b/fs/pstore/ftrace.c
> index a130d48..2d57e1a 100644
> --- a/fs/pstore/ftrace.c
> +++ b/fs/pstore/ftrace.c
> @@ -17,19 +17,113 @@
>  #include <linux/percpu.h>
>  #include <linux/smp.h>
>  #include <linux/atomic.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/ftrace.h>
> +#include <linux/fs.h>
> +#include <linux/debugfs.h>
> +#include <linux/err.h>
> +#include <linux/cache.h>
>  #include <asm/barrier.h>
>  #include "internal.h"
>  
> -void notrace pstore_ftrace_call(unsigned long ip, unsigned long parent_ip)
> +static void notrace pstore_ftrace_call(unsigned long ip,
> +				       unsigned long parent_ip)
>  {
> +	unsigned long flags;
>  	struct pstore_ftrace_record rec = {};
>  
>  	if (unlikely(oops_in_progress))
>  		return;
>  
> +	local_irq_save(flags);
> +
>  	rec.ip = ip;
>  	rec.parent_ip = parent_ip;
>  	pstore_ftrace_encode_cpu(&rec, raw_smp_processor_id());
>  	psinfo->write_buf(PSTORE_TYPE_FTRACE, 0, NULL, 0, (void *)&rec,
>  			  sizeof(rec), psinfo);
> +
> +	local_irq_restore(flags);
> +}
> +
> +static struct ftrace_ops pstore_ftrace_ops __read_mostly = {
> +	.func	= pstore_ftrace_call,
> +};
> +
> +static DEFINE_MUTEX(pstore_ftrace_lock);
> +static bool pstore_ftrace_enabled;
> +
> +static ssize_t pstore_ftrace_knob_write(struct file *f, const char __user *buf,
> +					size_t count, loff_t *ppos)
> +{
> +	u8 on;
> +	ssize_t ret;
> +
> +	ret = kstrtou8_from_user(buf, count, 2, &on);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&pstore_ftrace_lock);
> +
> +	if (!on ^ pstore_ftrace_enabled)
> +		goto out;
> +
> +	if (on)
> +		ret = register_ftrace_function(&pstore_ftrace_ops);
> +	else
> +		ret = unregister_ftrace_function(&pstore_ftrace_ops);
> +	if (ret) {
> +		pr_err("%s: unable to %sregister ftrace ops: %zd\n",
> +		       __func__, on ? "" : "un", ret);
> +		goto err;
> +	}
> +
> +	pstore_ftrace_enabled = on;
> +out:
> +	ret = count;
> +err:
> +	mutex_unlock(&pstore_ftrace_lock);
> +
> +	return ret;
> +}
> +
> +static ssize_t pstore_ftrace_knob_read(struct file *f, char __user *buf,
> +				       size_t count, loff_t *ppos)
> +{
> +	char val[] = { '0' + pstore_ftrace_enabled, '\n' };
> +
> +	return simple_read_from_buffer(buf, count, ppos, val, sizeof(val));
> +}
> +
> +static const struct file_operations pstore_knob_fops = {
> +	.open	= simple_open,
> +	.read	= pstore_ftrace_knob_read,
> +	.write	= pstore_ftrace_knob_write,
> +};
> +
> +void pstore_register_ftrace(void)
> +{
> +	struct dentry *dir;
> +	struct dentry *file;
> +
> +	if (!psinfo->write_buf)
> +		return;
> +
> +	dir = debugfs_create_dir("pstore", NULL);
> +	if (!dir) {
> +		pr_err("%s: unable to create pstore directory\n", __func__);
> +		return;
> +	}
> +
> +	file = debugfs_create_file("record_ftrace", 0600, dir, NULL,
> +				   &pstore_knob_fops);
> +	if (!file) {
> +		pr_err("%s: unable to create record_ftrace file\n", __func__);
> +		goto err_file;
> +	}
> +
> +	return;
> +err_file:
> +	debugfs_remove(dir);
>  }
> diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
> index 0d0d3b7..4847f58 100644
> --- a/fs/pstore/internal.h
> +++ b/fs/pstore/internal.h
> @@ -39,6 +39,12 @@ pstore_ftrace_decode_cpu(struct pstore_ftrace_record *rec)
>  #endif
>  }
>  
> +#ifdef CONFIG_PSTORE_FTRACE
> +extern void pstore_register_ftrace(void);
> +#else
> +static inline void pstore_register_ftrace(void) {}
> +#endif
> +
>  extern struct pstore_info *psinfo;
>  
>  extern void	pstore_set_kmsg_bytes(int);
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 29996e8..6c23eab 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -236,6 +236,7 @@ int pstore_register(struct pstore_info *psi)
>  
>  	kmsg_dump_register(&pstore_dumper);
>  	pstore_register_console();
> +	pstore_register_ftrace();
>  
>  	if (pstore_update_ms >= 0) {
>  		pstore_timer.expires = jiffies +
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> index c892587..ee3034a 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -64,14 +64,6 @@ struct pstore_info {
>  	void		*data;
>  };
>  
> -
> -#ifdef CONFIG_PSTORE_FTRACE
> -extern void pstore_ftrace_call(unsigned long ip, unsigned long parent_ip);
> -#else
> -static inline void pstore_ftrace_call(unsigned long ip, unsigned long parent_ip)
> -{ }
> -#endif
> -
>  #ifdef CONFIG_PSTORE
>  extern int pstore_register(struct pstore_info *);
>  #else
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index a426f41..0ad83e3 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -13,7 +13,6 @@
>  #include <linux/debugfs.h>
>  #include <linux/uaccess.h>
>  #include <linux/ftrace.h>
> -#include <linux/pstore.h>
>  #include <linux/fs.h>
>  
>  #include "trace.h"
> @@ -75,10 +74,9 @@ function_trace_call_preempt_only(unsigned long ip, unsigned long parent_ip)
>  	preempt_enable_notrace();
>  }
>  
> -/* Our two options */
> +/* Our option */
>  enum {
>  	TRACE_FUNC_OPT_STACK	= 0x1,
> -	TRACE_FUNC_OPT_PSTORE	= 0x2,
>  };
>  
>  static struct tracer_flags func_flags;
> @@ -106,12 +104,6 @@ function_trace_call(unsigned long ip, unsigned long parent_ip)
>  	disabled = atomic_inc_return(&data->disabled);
>  
>  	if (likely(disabled == 1)) {
> -		/*
> -		 * So far tracing doesn't support multiple buffers, so
> -		 * we make an explicit call for now.
> -		 */
> -		if (unlikely(func_flags.val & TRACE_FUNC_OPT_PSTORE))
> -			pstore_ftrace_call(ip, parent_ip);
>  		pc = preempt_count();
>  		trace_function(tr, ip, parent_ip, flags, pc);
>  	}
> @@ -177,9 +169,6 @@ static struct tracer_opt func_opts[] = {
>  #ifdef CONFIG_STACKTRACE
>  	{ TRACER_OPT(func_stack_trace, TRACE_FUNC_OPT_STACK) },
>  #endif
> -#ifdef CONFIG_PSTORE_FTRACE
> -	{ TRACER_OPT(func_pstore, TRACE_FUNC_OPT_PSTORE) },
> -#endif
>  	{ } /* Always set a last empty entry */
>  };
>  
> @@ -232,8 +221,6 @@ static int func_set_flag(u32 old_flags, u32 bit, int set)
>  		}
>  
>  		break;
> -	case TRACE_FUNC_OPT_PSTORE:
> -		break;
>  	default:
>  		return -EINVAL;
>  	}
> -- 
> 1.7.10.4
> 
