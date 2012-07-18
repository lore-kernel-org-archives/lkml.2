Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab2GRNK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:10:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10471 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab2GRNKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:10:24 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=11o5cHuf_k4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=T9rXZiLMIHvDNuXt5lMA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342617021.11900.3.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] pstore/ftrace: Convert to its own enable/disable
 debugfs knob
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Date: Wed, 18 Jul 2012 09:10:21 -0400
In-Reply-To: <20120718034722.GA18081@lizard>
References: <20120710001004.GA22744@lizard>
	 <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
	 <1342553898.10332.9.camel@gandalf.stny.rr.com>
	 <20120717200130.GA31678@lizard>
	 <1342561102.10332.18.camel@gandalf.stny.rr.com>
	 <20120718034722.GA18081@lizard>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 20:47 -0700, Anton Vorontsov wrote:

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
> index a130d48..824be81 100644
> --- a/fs/pstore/ftrace.c
> +++ b/fs/pstore/ftrace.c
> @@ -17,19 +17,111 @@
>  #include <linux/percpu.h>
>  #include <linux/smp.h>
>  #include <linux/atomic.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/ftrace.h>
> +#include <linux/fs.h>
> +#include <linux/debugfs.h>
> +#include <linux/err.h>
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
> +	if (unlikely(!ftrace_enabled))
> +		return;

You don't need this check. The ftrace_enabled is internal to ftrace and
the users shouldn't care. If we disable ftrace, the callback shouldn't
be executed. If it is, that's our fault ;-)


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
> +	int err;
> +
> +	err = kstrtou8_from_user(buf, count, 2, &on);
> +	if (err)
> +		return err;
> +
> +	mutex_lock(&pstore_ftrace_lock);
> +
> +	if (!on ^ pstore_ftrace_enabled)
> +		goto out;
> +	pstore_ftrace_enabled = on;
> +
> +	if (on)
> +		register_ftrace_function(&pstore_ftrace_ops);

You might want to check the return value of this.

-- Steve

> +	else
> +		unregister_ftrace_function(&pstore_ftrace_ops);
> +out:
> +	mutex_unlock(&pstore_ftrace_lock);
> +
> +	return count;
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
> +	int err;
> +
> +	if (!psinfo->write_buf)
> +		return;
> +
> +	dir = debugfs_create_dir("pstore", NULL);
> +	if (IS_ERR_OR_NULL(dir)) {
> +		err = PTR_ERR(dir);
> +		pr_err("%s: unable to create pstore debugfs: %d\n",
> +		       __func__, err);
> +		return;
> +	}
> +
> +	file = debugfs_create_file("record_ftrace", 0600, dir, NULL,
> +				   &pstore_knob_fops);
> +	if (IS_ERR_OR_NULL(file)) {
> +		err = PTR_ERR(file);
> +		pr_err("%s: unable to create pstore/ftrace file: %d\n",
> +		       __func__, err);
> +		goto err_file;
> +	}
> +
> +	return;
> +err_file:
> +	debugfs_remove(dir);
>  }


