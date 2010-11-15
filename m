Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab0KOQBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:01:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44067 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865Ab0KOQBh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 15 Nov 2010 11:01:37 -0500
Date: Mon, 15 Nov 2010 10:59:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/3] xen: add CPU microcode update driver
Message-ID: <20101115155928.GC345@dumpdata.com>
References: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>
 <37a80bdde5957ffa81c2ecdffc4ccc2e874e34cb.1289519130.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37a80bdde5957ffa81c2ecdffc4ccc2e874e34cb.1289519130.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static enum ucode_state xen_request_microcode_user(int cpu,
> +						   const void __user *buf, size_t size)
> +{
> +	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
> +	struct xen_microcode *uc;
> +	enum ucode_state ret;
> +	size_t unread;
> +
> +	if (cpu != 0) {
> +		/* No real firmware for non-zero cpus; just store a
> +		   placeholder */
> +		size = 0;
> +	}
> +
> +	if (uci->mc != NULL) {
> +		vfree(uci->mc);
> +		uci->mc = NULL;
> +	}
> +
> +	ret = UCODE_ERROR;
> +	uc = vmalloc(sizeof(*uc) + size);
> +	if (uc == NULL)
> +		goto out;
> +
> +	uc->len = size;
> +
> +	ret = UCODE_NFOUND;
> +
> +	/* XXX This sporadically returns uncopied bytes, so we return
> +	   EFAULT.  As far as I can see, the usermode code
           ^^^^^ UCODE_NFOUND.
> +	   (microcode_ctl) isn't doing anything wrong... */

Is this still valid? Looking at AMD it checks for a magic key and the Intel
just copies without checks.
