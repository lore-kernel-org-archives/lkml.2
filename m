Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab0GLRo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:44:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65125 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0GLRoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xCMEQE32vW4mktrXC8T9ZKYt+VcLI0ocKdZ94U0zbNYZAXMpLrcoO+gZ1MJmYpFtCJ
         yP0pyplS0jCOdDTfm4KBnzwOwxo1pgevY6uuA2U+dkhOtIAxRv+4zpLRyPF8/mjEScZj
         9WxTNmk10HJYxTs8i/dDHBGuVURmfVxY0XTIg=
Date: Mon, 12 Jul 2010 21:44:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Yinghai Lu <yinghai.lu@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
Message-ID: <20100712174420.GC5687@lenovo>
References: <4C3A3B27.7020009@oracle.com> <4C3AD94C.7070807@cs.helsinki.fi> <4C3B38F7.1050400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3B38F7.1050400@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 08:47:03AM -0700, H. Peter Anvin wrote:
> On 07/12/2010 01:58 AM, Pekka Enberg wrote:
> > Hi Yinghai,
> > 
> > Yinghai Lu wrote:
> >> Analyze "console=uart8250,io,0x3f8,115200n8" in
> >> i386_start_kernel/x86_64_start_kernel,
> >> and call setup_early_serial8250_console() to init early serial console.
> >>
> >> only can handle io port kind of 8250. because mmio need ioremap.
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > What's the purpose of this patch? Does it make my early boot I/O patch
> > obsolete?
> > 
> >             Pekka
> 
> No, they're complementary.  Your patch serial-port enables the RM
> kernel, whereas Yinghai pushes the initialization earlier in the PM kernel.
> 
> Incidentally, Yinghai: it would be possible to push even an MMIO
> reference earlier by reserving a fixmap slot for the early console.  I'm
> not sure if it's worth it, though.
> 
> 	-hpa
>

Peter, while reviewing this patch I found another nit in
context of early_param usage, so the patch is below. It's
completely trivial. Actually I thought I've already fixed
all early_param cases long ago but this one somehow sneaked ;)

Anyway, Yinghai, Peter,

I'm not sure but can't we use some boot_param "pad" field for
"being copied" flag instead of new variable? There is a case
when boot_param is used as __initdata and I'm not sure we clear
this section explicitly.

	-- Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] early console: Prevent early_param null dereference

In case if user passes "earlycon" without args there will
be null dereference.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 drivers/serial/8250_early.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.git/drivers/serial/8250_early.c
=====================================================================
--- linux-2.6.git.orig/drivers/serial/8250_early.c
+++ linux-2.6.git/drivers/serial/8250_early.c
@@ -217,6 +217,9 @@ int __init setup_early_serial8250_consol
 	char *options;
 	int err;
 
+	if (!cmdline)
+		return 0;
+
 	options = strstr(cmdline, "uart8250,");
 	if (!options) {
 		options = strstr(cmdline, "uart,");
