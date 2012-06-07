Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2FGUHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:07:44 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63223 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846Ab2FGUHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120607180156.GX9472@phenom.dumpdata.com>
References: <CAOvdn6VWdOy1nNM+x3ogCCFXy8FExZjTJaV-s6SR7kbGu+REOA@mail.gmail.com>
	<20120607164034.GQ9472@phenom.dumpdata.com>
	<CAOvdn6WJ+Ub+LbhHKKQJi3AzsbCqX6-ksWhoxnZS5_OH=hkghQ@mail.gmail.com>
	<20120607174815.GU9472@phenom.dumpdata.com>
	<CAOvdn6VtmWyMo4SEAWT+ipJTHBTwPm+DZ1TXZT4q3UobFv=2DA@mail.gmail.com>
	<20120607180156.GX9472@phenom.dumpdata.com>
Date: Thu, 7 Jun 2012 16:07:40 -0400
X-Google-Sender-Auth: 6eKwEFY6I49uWbZtHCmQaxMIwxQ
Message-ID: <CAOvdn6UV1b89+wp4cfyj7ofU6T0=sdhNEoMZinPW=-AZWBOmSA@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] xen/hvc: Fix polling mode to work with kdb/kgdb
From: Ben Guthro <ben@guthro.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 2:01 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
<snip>
>> I'll try to dig in a bit, and report back.
>
> OK. Thanks!


OK, after throwing a bit of trace in, I remember now, the issue I was
working around.

The tty layer does not seem keep the console open.
It opens, and closes the tty based on whether there is data to print.

However, the CONFIG_CONSOLE_POLL code goes around all of this, and
uses the polling capabilities of the driver.
Most of the drivers that implement this mechanism are serial devices
where they are actually polling the UART.

When Alt+SysRq+g is pressed, the output is flushed, all references to
the hvc are released, and then hvc_close() is called.

However, since this code fully bypasses the tty layer, no reference is
grabbed - and so, when we come into hvc_poll_put_char, and the
necessary structures aren't available.

Below is an updated version of this patch that will use the
tty->driver_data, if available - but will fall back to using cons_ops.

This will guarantee that any existing users of hvc where the above
claim is not true will see no change in behavior.

However...The part of this that I don't really understand why we need
is in kernel/debug/debug_core.c
I don't like having to put the ifdef in there. I was hoping to be able
to remove it, with the upstreaming of the xen IPI code... but in
testing, it seems to still be necessary.



diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 2d691eb..7f965e1 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -767,11 +767,14 @@ int hvc_poll_init(struct tty_driver *driver, int
line, char *options)
 static int hvc_poll_get_char(struct tty_driver *driver, int line)
 {
        struct tty_struct *tty = driver->ttys[0];
-       struct hvc_struct *hp = tty->driver_data;
+       struct hvc_struct *hp = tty ? tty->driver_data : NULL;
+       struct hv_ops *ops = (hp && hp->ops) ? hp->ops : cons_ops[last_hvc];
+       uint32_t vtno = hp ? hp->vtermno : vtermnos[last_hvc];
+
        int n;
        char ch;

-       n = hp->ops->get_chars(hp->vtermno, &ch, 1);
+       n = ops->get_chars(vtno, &ch, 1);

        if (n == 0)
                return NO_POLL_CHAR;
@@ -782,11 +785,14 @@ static int hvc_poll_get_char(struct tty_driver
*driver, int line)
 static void hvc_poll_put_char(struct tty_driver *driver, int line, char ch)
 {
        struct tty_struct *tty = driver->ttys[0];
-       struct hvc_struct *hp = tty->driver_data;
+       struct hvc_struct *hp = tty ? tty->driver_data : NULL;
+       struct hv_ops *ops = (hp && hp->ops) ? hp->ops : cons_ops[last_hvc];
+       uint32_t vtno = hp ? hp->vtermno : vtermnos[last_hvc];
+
        int n;

        do {
-               n = hp->ops->put_chars(hp->vtermno, &ch, 1);
+               n = ops->put_chars(vtno, &ch, 1);
        } while (n <= 0);
 }
 #endif
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0557f24..853b1d7 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -579,12 +579,14 @@ return_normal:
                kgdb_roundup_cpus(flags);
 #endif

+#ifndef CONFIG_XEN
        /*
         * Wait for the other CPUs to be notified and be waiting for us:
         */
        while (kgdb_do_roundup && (atomic_read(&masters_in_kgdb) +
                                atomic_read(&slaves_in_kgdb)) != online_cpus)
                cpu_relax();
+#endif

        /*
         * At this point the primary processor is completely
