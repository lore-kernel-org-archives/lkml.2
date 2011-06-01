Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab1FATo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:44:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33821 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759533Ab1FATox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:44:53 -0400
Date: Wed, 1 Jun 2011 20:46:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
Message-ID: <20110601204618.32190be9@lxorguk.ukuu.org.uk>
In-Reply-To: <1306953337-15698-1-git-send-email-timur@freescale.com>
References: <1306953337-15698-1-git-send-email-timur@freescale.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> +	/* One partition must be local, the other must be remote.  In other
> +	   words, if source and target are both -1, or are both not -1, then
> +	   return an error. */
> +	if ((param.source == -1) == (param.target == -1))
> +		return -EINVAL;

Excess brackets (I just mention that one in passing)

> +	/* pages is an array of struct page pointers that's initialized by
> +	   get_user_pages() */
> +	pages = kzalloc(nr_pages * sizeof(struct page *), GFP_KERNEL);
> +	if (!pages) {
> +		pr_debug("fsl-hv: could not allocate page list\n");
> +		return -ENOMEM;
> +	}

pages allocated

> +
> +	/* sg_list is the list of fh_sg_list objects that we pass to the
> +	   hypervisor */
> +	sg_list_unaligned = kmalloc(nr_pages * sizeof(struct fh_sg_list) +
> +		sizeof(struct fh_sg_list) - 1, GFP_KERNEL);
> +	if (!sg_list_unaligned) {
> +		pr_debug("fsl-hv: could not allocate S/G list\n");

but not freed on this path

Although the other paths look fine.

> +exit:
> +	if (pages) {
> +		for (i = 0; i < nr_pages; i++)
> +			if (pages[i])
> +				page_cache_release(pages[i]);
> +	}
> +
> +	kfree(sg_list_unaligned);
> +	kfree(pages);

> +static char *strdup_from_user(const char __user *ustr, size_t max)
> +{
> +	size_t len;
> +	char *str;
> +
> +	len = strnlen_user(ustr, max);
> +	if (len > max)
> +		return ERR_PTR(-ENAMETOOLONG);
> +
> +	str = kmalloc(len, GFP_KERNEL);
> +	if (!str)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (copy_from_user(str, ustr, len))
> +		return ERR_PTR(-EFAULT);
> +
> +	return str;
> +}

This belongs on lib/ if its of general use which I think it perhaps is
and if we don't have one already.


> +	default:
> +		pr_debug("fsl-hv: unknown ioctl %u\n", cmd);
> +		ret = -ENOIOCTLCMD;

-ENOTTY

(-ENOIOCTLCMD is an internal indicator designed so driver layers can say
'dunno, try the next layer up')

> +/* Linked list of processes that have us open */
> +struct list_head db_list;

static ?


> + * We use the same interrupt handler for all doorbells.  Whenever a doorbell
> + * is rung, and we receive an interrupt, we just put the handle for that
> + * doorbell (passed to us as *data) into all of the queues.

I wonder if these should be presented as IRQs or whether that makes no
sense ?


> +static irqreturn_t fsl_hv_state_change_isr(int irq, void *data)
> +{
> +	unsigned int status;
> +	struct doorbell_isr *dbisr = data;
> +	int ret;
> +
> +	/* Determine the new state, and if it's stopped, notify the clients. */
> +	ret = fh_partition_get_status(dbisr->partition, &status);
> +	if (!ret && (status == FH_PARTITION_STOPPED))
> +		schedule_work(&dbisr->work);
> +
> +	/* Call the normal handler */
> +	return fsl_hv_isr(irq, (void *) (uintptr_t) dbisr->doorbell);
> +}

Would a threaded IRQ clean this up by avoiding the queue/work stuff ?


> +static irqreturn_t fsl_hv_shutdown_isr(int irq, void *data)
> +{
> +	schedule_work(&power_off);
> +
> +	/* We should never get here */

Probably worth printing something if you do (panic(...) ?)

