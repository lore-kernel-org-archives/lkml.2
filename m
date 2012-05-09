Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2EIARx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 20:17:53 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:49863 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751926Ab2EIARv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 20:17:51 -0400
Message-ID: <4FA9B7BF.90502@xenotime.net>
Date: Tue, 08 May 2012 17:18:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: linux-next: Tree for May 8 (printk)
References: <20120508181531.072fdc5fefa60d852e784587@canb.auug.org.au>		 <4FA948B9.20600@xenotime.net> <1336518821.728.1.camel@mop>	 <4FA9ABD6.6030006@xenotime.net> <1336520271.728.4.camel@mop>
In-Reply-To: <1336520271.728.4.camel@mop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 04:37 PM, Kay Sievers wrote:

> On Tue, 2012-05-08 at 16:27 -0700, Randy Dunlap wrote:
>> On 05/08/2012 04:13 PM, Kay Sievers wrote:
>>
>>> On Tue, 2012-05-08 at 09:24 -0700, Randy Dunlap wrote:
>>>> On 05/08/2012 01:15 AM, Stephen Rothwell wrote:
>>>
>>>> Build errors on i386 and x86_64 when CONFIG_PRINTK is not enabled:
>>>
>>> This seems to work for me.
>>
>> It still has one build error which was in the initial report:
> 
> Ah sorry, missed to add a hunk.

Still not fixed.

drivers/char/mem.c:858:2: error: implicit declaration of function 'printk_emit'

	printk_emit(facility, level, NULL, 0, "%s", line);



> Thanks,
> Kay
> 
> 
> From: Kay Sievers <kay@vrfy.org>
> Subject: printk - fix compilation for CONFIG_PRINTK=n
> 
> Signed-off-by: Kay Sievers <kay@vrfy.org>
> ---
>  drivers/char/mem.c |    2 ++
>  kernel/printk.c    |   41 ++++++++++++++++++++++-------------------
>  2 files changed, 24 insertions(+), 19 deletions(-)
> 
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -825,7 +825,9 @@ static const struct memdev {
>  	 [7] = { "full", 0666, &full_fops, NULL },
>  	 [8] = { "random", 0666, &random_fops, NULL },
>  	 [9] = { "urandom", 0666, &urandom_fops, NULL },
> +#ifdef CONFIG_PRINTK
>  	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
> +#endif
>  #ifdef CONFIG_CRASH_DUMP
>  	[12] = { "oldmem", 0, &oldmem_fops, NULL },
>  #endif
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -126,7 +126,6 @@ EXPORT_SYMBOL(console_set_on_cmdline);
>  /* Flag: console code may call schedule() */
>  static int console_may_schedule;
>  
> -#ifdef CONFIG_PRINTK
>  /*
>   * The printk log buffer consists of a chain of concatenated variable
>   * length records. Every record starts with a record header, containing
> @@ -208,16 +207,9 @@ struct log {
>   */
>  static DEFINE_RAW_SPINLOCK(logbuf_lock);
>  
> -/* cpu currently holding logbuf_lock */
> -static volatile unsigned int logbuf_cpu = UINT_MAX;
> -
> -#define LOG_LINE_MAX 1024
> -
> -/* record buffer */
> -#define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
> -static char __log_buf[__LOG_BUF_LEN];
> -static char *log_buf = __log_buf;
> -static u32 log_buf_len = __LOG_BUF_LEN;
> +/* the next printk record to read by syslog(READ) or /proc/kmsg */
> +static u64 syslog_seq;
> +static u32 syslog_idx;
>  
>  /* index and sequence number of the first record stored in the buffer */
>  static u64 log_first_seq;
> @@ -225,15 +217,23 @@ static u32 log_first_idx;
>  
>  /* index and sequence number of the next record to store in the buffer */
>  static u64 log_next_seq;
> +#ifdef CONFIG_PRINTK
>  static u32 log_next_idx;
>  
>  /* the next printk record to read after the last 'clear' command */
>  static u64 clear_seq;
>  static u32 clear_idx;
>  
> -/* the next printk record to read by syslog(READ) or /proc/kmsg */
> -static u64 syslog_seq;
> -static u32 syslog_idx;
> +#define LOG_LINE_MAX 1024
> +
> +/* record buffer */
> +#define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
> +static char __log_buf[__LOG_BUF_LEN];
> +static char *log_buf = __log_buf;
> +static u32 log_buf_len = __LOG_BUF_LEN;
> +
> +/* cpu currently holding logbuf_lock */
> +static volatile unsigned int logbuf_cpu = UINT_MAX;
>  
>  /* human readable text of the record */
>  static char *log_text(const struct log *msg)
> @@ -1425,13 +1425,16 @@ asmlinkage int printk(const char *fmt, .
>  	return r;
>  }
>  EXPORT_SYMBOL(printk);
> +
>  #else
>  
> -static void call_console_drivers(int level, const char *text, size_t len)
> -{
> -}
> +#define LOG_LINE_MAX 0
> +static struct log *log_from_idx(u32 idx) { return NULL; }
> +static u32 log_next(u32 idx) { return 0; }
> +static char *log_text(const struct log *msg) { return NULL; }
> +static void call_console_drivers(int level, const char *text, size_t len) {}
>  
> -#endif
> +#endif /* CONFIG_PRINTK */
>  
>  static int __add_preferred_console(char *name, int idx, char *options,
>  				   char *brl_options)
> @@ -1715,7 +1718,7 @@ static u32 console_idx;
>   * by printk().  If this is the case, console_unlock(); emits
>   * the output prior to releasing the lock.
>   *
> - * If there is output waiting, we wake it /dev/kmsg and syslog() users.
> + * If there is output waiting, we wake /dev/kmsg and syslog() users.
>   *
>   * console_unlock(); may be called from any context.
>   */
> 
> 



-- 
~Randy
