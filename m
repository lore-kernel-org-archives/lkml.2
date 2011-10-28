Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab1J1PfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 11:35:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41909 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932447Ab1J1PfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 11:35:24 -0400
Message-ID: <1319770558.2529.20.camel@Joe-Laptop>
Subject: Re: [PATCH] VirtioConsole support.
From: Joe Perches <joe@perches.com>
To: Miche Baker-Harvey <miche@google.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Amit Shah <amit.shah@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org
In-Reply-To: <1319751802-27013-1-git-send-email-miche@google.com>
References: <20111027173527.GA23839@phenom.dumpdata.com>
	 <1319751802-27013-1-git-send-email-miche@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 05:55:58 +0300
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 14:43 -0700, Miche Baker-Harvey wrote:
> Multiple HVC console terminals enabled.

Just a note on allocation.

> diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
[]
> @@ -845,6 +857,19 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int data,
>  	kref_init(&hp->kref);
>  
>  	INIT_WORK(&hp->tty_resize, hvc_set_winsz);
> +	/*
> +	 * make each console its own struct console.
> +	 * No need to do allocation and copy under lock.
> +	 */
> +	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
> +	if (!cp) {
> +		kfree(hp);
> +		mutex_unlock(&hvc_ports_mutex);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	memcpy(cp, &hvc_console, sizeof(*cp));

The kzalloc should be kmalloc as the allocated
memory is immediately overwritten.

