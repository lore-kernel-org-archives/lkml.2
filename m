Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab1ELCmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:42:04 -0400
Received: from mail4.comsite.net ([205.238.176.238]:6649 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1ELClx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:41:53 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [04/16] add support for C64x+ debugger based console
To: Mark Salter <msalter@redhat.com>
In-Reply-To: <1305144843-5058-5-git-send-email-msalter@redhat.com>
References: <1305144843-5058-5-git-send-email-msalter@redhat.com>
Message-Id: <c64-hvc-reply@mdm.bga.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 11 May 2011 21:41:51 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 about 20:13:51 -0000, Mark Salter wrote:
> Texas Instruments debugger support for the C64X+ family of DSPs includes a
> console for the unit under test. This patch adds write-only console support
> to send kernel output to the debugger. It is safe to have this driver in
> place even if the system is not being run under the debugger.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> 
> ---
> drivers/tty/hvc/Makefile  |    1 +
>  drivers/tty/hvc/hvc_c6x.c |  125 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 126 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/tty/hvc/hvc_c6x.c


Hmm, no Kconfig?   Oh, I see, you have a very minimal entry in
arch/c6x/Kconfig via "[07/16] C6X: add toplevel configury and makefile".

Except that is too minimal.  It should give the user guidance
like the changelog: it provides a hook for a that the debuger
can set a breakpoint to know when to pick up the data, is safe
when the debugger is not enabled, etc.  Answer "why would a
user want this?".

Also, I prefer it to be local with the driver and makefile even
if it depends on your architecture.  There is nothing processor
architeture specific about this driver, even the asm is 2 nops
and a label; so some other arch may want to reuse this driver.

> +/*
> + * TI C6X Host Port hypervisor console
> + */

Nothing is really hypervisor, other than the name of the framework.
More like debugger driver?

> +
> +#include <linux/console.h>
> +#include <linux/delay.h>

Not sure you use anything from delay.h

> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/moduleparam.h>
> +#include <linux/types.h>
> +
> +#include "hvc_console.h"
> +
> +#define PARAMSIZE	8
> +#define MSGSIZE		256
> +
> +#define CIO_READ	0xF2
> +#define CIO_WRITE	0xF3
> +
> +#define CIO_STDIN	0
> +#define CIO_STDOUT	1
> +#define CIO_STDERR	2
> +

So you probably have some method to read characters that could be added.
No pressure, but that could be useful.  Your raw transport also has
multiple channels which could be used.

> +struct c6x_msg {
> +	unsigned int	length;
> +	unsigned char	command;
> +	unsigned char	params[PARAMSIZE];
> +	unsigned char	msg[MSGSIZE];
> +};
> +
> +union c6x_msgparam {
> +	unsigned char	params[PARAMSIZE];
> +	struct {
> +		unsigned short fd;
> +		unsigned short count;
> +	} host_write;
> +};
> +
> +/*
> + * __CIOBUF__ and C$$IO$$ are special symbols for debugger.
> + *
> + * If debugger is running kernel, it will set a breakpoint
> + * at C$$IO$$ which is hit when the kernel wants attention
> + * from the debugger. __CIOBUF__ is used to pass messages
> + * between debugger and kernel when the breakpoint is hit.
> + */
> +struct c6x_msg _CIOBUF_;
> +
> +static noinline void notify_debugger(void)
> +{
> +	asm volatile (".global C$$IO$$\n"
> +		      "nop\n"
> +		      "C$$IO$$: nop\n");
> +}
> +
> +static int hvc_c6x_put_chars(uint32_t vt, const char *buf, int count)
> +{
> +	union c6x_msgparam params;
> +	int to_write, remaining;
> +
> +	remaining = count;
> +	while (remaining > 0) {
> +		to_write = (remaining > MSGSIZE) ? MSGSIZE : remaining;
> +
> +		_CIOBUF_.length = to_write;
> +		_CIOBUF_.command = CIO_WRITE;
> +
> +		params.host_write.fd = cpu_to_le16(CIO_STDOUT);
> +		params.host_write.count = cpu_to_le16(to_write);
> +		memcpy(_CIOBUF_.params, &params, PARAMSIZE);
> +
> +		memcpy(_CIOBUF_.msg, buf, to_write);
> +
> +		notify_debugger();
> +
> +		remaining -= to_write;
> +	}
> +	return count;
> +}
> +
> +#ifdef CONFIG_EARLY_PRINTK
> +void hvc_c6x_early_puts(const char *buf, unsigned count)
> +{
> +	hvc_c6x_put_chars(0, buf, count);
> +}
> +#endif

Hmm, so you have

(1) early_printk only avail if CONFIG_EARLY_PRINTK (no #else nop),
and this hook is protyped in include/early_printk under ifdef.

(2) arch/c6x/kernel/early_console.c implements a hook, with an
explict ifdef for this driver to fill in the hook

So both files ifdef the config used to build the other file.

Do you have other hook implementations for your early_puts?

(3) the effect of doing the above gets a console that gets called
with upto 512 characters per buffer (which would require 2 messages,
but you handle that), instead of the hvc_console N_OUTBUF = 16
per loop.


The hvc console is supposed to auto-register the console either when
the hvc_console console_initcall is made or when some sub driver calls
hvc_instantiate.  While its not as clear as it used to be that calling
it early is safe, I think it stll is.

I can see how the early-printk console could be about 16x faster;
maybe we should create a static buffer for console output.  Its
always filled under the console locks and drained under the same
call.  (The n_outbuf code was added to hvc later).  Some drivers
need the aligned to long of that buffer and we dont' want to
grow the stack too much.   ... but I digress.   I won't hold
the driver up for that, but could you take a look?

> +
> +static int hvc_c6x_get_chars(uint32_t vt, char *buf, int count)
> +{
> +	return 0;
> +}
> +
> +static const struct hv_ops hvc_c6x_get_put_ops = {
> +	.get_chars = hvc_c6x_get_chars,
> +	.put_chars = hvc_c6x_put_chars,
> +};
> +
> +static int __init hvc_c6x_console_init(void)
> +{
> +	hvc_instantiate(0, 0, &hvc_c6x_get_put_ops);
> +	add_preferred_console("hvc", 0, NULL);

This (calling add_preferred_console from the drivers console_initcall)
is bad if you ever get an alternative console.   It seems convinient
until then.

> +	return 0;
> +}
> +console_initcall(hvc_c6x_console_init);
> +
> +static int __init hvc_c6x_init(void)
> +{
> +	struct hvc_struct *s;
> +	s = hvc_alloc(0, 0, &hvc_c6x_get_put_ops, 128);

So you tell the hvc layer you want upto 128 bytes at a time, but
your driver can handle MSGSIZE = 256 ?   Why would you not request
MSGSIZE at a time?


> +	return IS_ERR(s) ? PTR_ERR(s) : 0;
> +}
> +device_initcall(hvc_c6x_init);

milton
