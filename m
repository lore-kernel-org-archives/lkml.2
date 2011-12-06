Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab1LFGVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 01:21:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48341 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932887Ab1LFGVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 01:21:41 -0500
Date: Tue, 6 Dec 2011 07:19:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Drake <dsd@laptop.org>
Cc: akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, pgf@laptop.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH v2] x86, olpc: add debugfs interface for EC commands
Message-ID: <20111206061949.GA29152@elte.hu>
References: <20111205190023.498DE9D401E@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205190023.498DE9D401E@zog.reactivated.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Drake <dsd@laptop.org> wrote:

> Add a debugfs interface for sending commands to the OLPC Embedded Controller
> (EC) and reading the responses. The EC provides functionality for machine
> identification, battery and AC control, wakeup control, etc.
> 
> Having a debugfs interface available is useful for EC development and
> debugging.
> 
> Based on code by Paul Fox.
> 
> Signed-off-by: Paul Fox <pgf@laptop.org>
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  Documentation/ABI/testing/debugfs-olpc |   16 ++++++
>  arch/x86/platform/olpc/olpc.c          |   86 ++++++++++++++++++++++++++++++++
>  2 files changed, 102 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/debugfs-olpc

Looks rather useful.

Some bugs and nitpicks i noticed:

> v2: incorporate feedback from Andrew Morton (thanks!): documentation in
> Documentation/, fixed input checking, more correct command bytes construction
> 
> diff --git a/Documentation/ABI/testing/debugfs-olpc b/Documentation/ABI/testing/debugfs-olpc
> new file mode 100644
> index 0000000..49b9a4e
> --- /dev/null
> +++ b/Documentation/ABI/testing/debugfs-olpc
> @@ -0,0 +1,16 @@
> +What:		/sys/kernel/debug/olpc-ec/generic
> +Date:		Dec 2011
> +KernelVersion:	3.3
> +Contact:	devel@lists.laptop.org
> +Description:
> +
> +A generic interface for executing OLPC Embedded Controller commands and
> +reading their responses.
> +
> +To execute a command, write data with the format: CC:N A A A A
> +CC is the (hex) command, N is the count of expected reply bytes, and A A A A
> +are optional (hex) arguments.
> +
> +To read the response (if any), read from the generic node after executing
> +a command. Hex reply bytes will be returned, *whether or not* they came from
> +the immediately previous command.
> diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
> index 7cce722..8260747 100644
> --- a/arch/x86/platform/olpc/olpc.c
> +++ b/arch/x86/platform/olpc/olpc.c
> @@ -20,6 +20,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/of.h>
>  #include <linux/syscore_ops.h>
> +#include <linux/debugfs.h>
>  
>  #include <asm/geode.h>
>  #include <asm/setup.h>
> @@ -31,6 +32,13 @@ EXPORT_SYMBOL_GPL(olpc_platform_info);
>  
>  static DEFINE_SPINLOCK(ec_lock);
>  
> +/* debugfs interface to EC commands */
> +#define EC_MAX_CMD_ARGS (5 + 1)	/* cmd byte + 5 args */
> +#define EC_MAX_CMD_REPLY (8)
> +static struct dentry *ec_debugfs_dir;
> +static unsigned char ec_debugfs_resp[EC_MAX_CMD_REPLY];
> +static unsigned int ec_debugfs_resp_bytes;

Please put a newline between blocks of defines and variable 
definitions, for increased readability.

> +
>  /* EC event mask to be applied during suspend (defining wakeup sources). */
>  static u16 ec_wakeup_mask;
>  
> @@ -269,6 +277,83 @@ int olpc_ec_sci_query(u16 *sci_value)
>  }
>  EXPORT_SYMBOL_GPL(olpc_ec_sci_query);
>  
> +static ssize_t ec_gen_write(struct file *file, const char __user *buf,
> +			    size_t size, loff_t *ppos)
> +{
> +	int i, m;
> +	unsigned char ec_cmd[EC_MAX_CMD_ARGS];
> +	unsigned int ec_cmd_int[EC_MAX_CMD_ARGS];
> +	char cmdbuf[64];
> +	int ec_cmd_bytes;
> +
> +	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
> +
> +	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
> +		   &ec_debugfs_resp_bytes,
> +		   &ec_cmd_int[1], &ec_cmd_int[2], &ec_cmd_int[3],
> +		   &ec_cmd_int[4], &ec_cmd_int[5]);
> +	if (m < 2 || ec_debugfs_resp_bytes > EC_MAX_CMD_REPLY) {
> +		printk(KERN_DEBUG "olpc-ec: bad ec cmd:  "
> +		       "cmd:response-count [arg1 [arg2 ...]]\n");
> +		return -EINVAL;

Hm, this looks like a potential overflow. If this sscanf() fails 
because of a bug in user-space which sets ec_debugfs_resp_bytes 
to say 1000, then despite the -EINVAL the ec_debugfs_res_bytes 
lingers and any subsequent read() will over-read and over-write 
buffers.

> +	}
> +
> +	/* convert scanf'd ints to char */
> +	ec_cmd_bytes = m - 2;
> +	for (i = 0; i <= ec_cmd_bytes; i++)
> +		ec_cmd[i] = ec_cmd_int[i];
> +
> +	printk(KERN_DEBUG "olpc-ec: debugfs cmd 0x%02x with %d args "
> +	       "%02x %02x %02x %02x %02x, want %d returns\n",
> +	       ec_cmd[0], ec_cmd_bytes, ec_cmd[1], ec_cmd[2], ec_cmd[3],
> +	       ec_cmd[4], ec_cmd[5], ec_debugfs_resp_bytes);
> +
> +	olpc_ec_cmd((unsigned char) ec_cmd[0],
> +		(ec_cmd_bytes == 0) ? NULL : &ec_cmd[1],
> +		ec_cmd_bytes, ec_debugfs_resp, ec_debugfs_resp_bytes);

Why the cast? ec_cmd[] is unsigned char already.

> +static ssize_t ec_gen_read(struct file *file, char __user *buf,
> +			   size_t size, loff_t *ppos)
> +{
> +	unsigned int i, r;
> +	char *rp;
> +	char respbuf[64];
> +
> +	rp = respbuf;
> +	rp += sprintf(rp, "%02x", ec_debugfs_resp[0]);
> +	for (i = 1; i < ec_debugfs_resp_bytes; i++)
> +		rp += sprintf(rp, ", %02x", ec_debugfs_resp[i]);

Is the first byte of the response packet uninteresting? 

Also, ec_debugfs_resp_bytes is not checked against the limit of 
64 of the on-kernel-stack buffer - see the write() comment 
above.

> +	rp += sprintf(rp, "\n");
> +
> +	r = rp - respbuf;
> +
> +	return simple_read_from_buffer(buf, size, ppos, respbuf, r);
> +}
> +
> +static const struct file_operations ec_debugfs_genops = {
> +	.write	 = ec_gen_write,
> +	.read	 = ec_gen_read,

Hm, what protects the ec_debugfs_resp[] buffer against 
concurrent read()s/write()s?

I realize that this is just a hack for you to feed olpc_ec_cmd() 
and see the results, and that ec_lock protects the hardware 
itself, but still - a mutex would seem in order. That would also 
protect ec_debugfs_resp_bytes.

> +static void setup_debugfs(void)
> +{
> +	ec_debugfs_dir = debugfs_create_dir("olpc-ec", 0);
> +	if (ec_debugfs_dir == ERR_PTR(-ENODEV))
> +		return;
> +
> +	debugfs_create_file("generic", 0600, ec_debugfs_dir, NULL,
> +			    &ec_debugfs_genops);
> +}

So a debug hack is named 'generic'? Shouldnt this be named 
something like "cmds" or such?

Thanks,

	Ingo
