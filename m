Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab2CCMLE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 07:11:04 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:28990
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291Ab2CCMLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 07:11:03 -0500
X-IronPort-AV: E=Sophos;i="4.73,525,1325458800"; 
   d="scan'208";a="134151254"
Date: Sat, 3 Mar 2012 13:10:59 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Stephen Boyd <sboyd@codeaurora.org>
cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [PATCH 2/2] coccinelle: semantic patch for simple_open()
In-Reply-To: <1330769180-22354-3-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1203031307080.1780@hadrien>
References: <1330769180-22354-1-git-send-email-sboyd@codeaurora.org> <1330769180-22354-3-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 Mar 2012, Stephen Boyd wrote:

> Find instances of an open-coded simple_open() and replace them
> with calls to simple_open().
>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> This seems to eat the definition of simple_open() as well. Is there
> a way to say only remove both the function and the reference to
> the function so that libfs survives?

Try identifier open_f != simple_open;

Is there a header file that should be present?

Your transformation rules should include depends on patch in the very 
first line, after the rule name.

Can you make a report rule?  If not, I will do it.  Someone asked for that 
to always be present.

thanks,
julia

> scripts/coccinelle/api/simple_open.cocci |   34 ++++++++++++++++++++++++++++++
> 1 file changed, 34 insertions(+)
> create mode 100644 scripts/coccinelle/api/simple_open.cocci
>
> diff --git a/scripts/coccinelle/api/simple_open.cocci b/scripts/coccinelle/api/simple_open.cocci
> new file mode 100644
> index 0000000..956d04d
> --- /dev/null
> +++ b/scripts/coccinelle/api/simple_open.cocci
> @@ -0,0 +1,34 @@
> +// This removes an open coded simple_open() function
> +// and replaces file operations references to the function
> +// with simple_open() instead.
> +//
> +
> +virtual patch
> +virtual context
> +
> +@ open @
> +identifier open_f;
> +identifier i, f;
> +@@
> +-int open_f(struct inode *i, struct file *f)
> +-{
> +(
> +-if (i->i_private)
> +-f->private_data = i->i_private;
> +|
> +-f->private_data = i->i_private;
> +)
> +-return 0;
> +-}
> +
> +@ has_open depends on open @
> +identifier fops;
> +identifier open.open_f;
> +@@
> +struct file_operations fops = {
> +...
> +-.open = open_f,
> ++.open = simple_open,
> +...
> +};
> +
> -- 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
>
