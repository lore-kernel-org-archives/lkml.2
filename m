Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab1ITGoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 02:44:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40546 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab1ITGoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 02:44:01 -0400
Subject: Re: [PATCH V3] mtd: Add DiskOnChip G3 support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 20 Sep 2011 09:46:37 +0300
In-Reply-To: <1316454213-22559-1-git-send-email-robert.jarzmik@free.fr>
References: <1316454213-22559-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1316501205.4849.36.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really feel unsure about merging this driver because no one reviewed
it. On the surface it does look neat, though. Could you please CC lkml
on next submission?

On Mon, 2011-09-19 at 19:43 +0200, Robert Jarzmik wrote:
> +static void doc_delay(struct docg3 *docg3, int nbNOPs)
> +{
> +	int i;
> +
> +	doc_dbg("NOP x %d\n", nbNOPs);
> +	for (i = 0; i < nbNOPs; i++)
> +		doc_writeb(0, DoC_NOP);
> +}

Why you implement dalaying this way, instead of using udelay/mdelay?

> +static int doc_wait_ready(struct docg3 *docg3)
> +{
> +	int maxWaitCycles = 100;
> +
> +	do {
> +		doc_delay(docg3, 4);
> +	} while (!doc_is_ready(docg3) && maxWaitCycles--);
> +	doc_delay(docg3, 2);
> +	if (maxWaitCycles > 0)
> +		return 0;
> +	else
> +		return -EIO;
> +}

There are things like cpu_relax() which are used in busy-loops - did you
look at those?


> +/*
> + * Debug sysfs entries
> + */
> +#ifdef CONFIG_DEBUG_FS

You do not need to use CONFIG_DEBUG_FS - debugfs makes all calls to be
noop if it is not present.

Either remove all macros or use DEBUG

> +#define DEBUGFS_RO_ATTR(name, show_fct) \
> +	static int name##_open(struct inode *inode, struct file *file) \
> +	{ return single_open(file, show_fct, inode->i_private); }      \
> +	static const struct file_operations name##_fops = { \
> +		.owner = THIS_MODULE, \
> +		.open = name##_open, \
> +		.llseek = seq_lseek, \
> +		.read = seq_read, \
> +		.release = single_release \
> +	};

Hmm, looks like something which should be generic, not DoC-specific.

-- 
Best Regards,
Artem Bityutskiy

