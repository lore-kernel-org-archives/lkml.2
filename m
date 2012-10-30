Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2J3CKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 22:10:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43874 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab2J3CKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 22:10:03 -0400
Date: Mon, 29 Oct 2012 19:10:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: George Zhang <georgezhang@vmware.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        pv-drivers@vmware.com
Subject: Re: [PATCH 01/12] VMCI: context implementation.
Message-ID: <20121030021058.GB1920@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010333.17788.94988.stgit@promb-2n-dhcp175.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030010333.17788.94988.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 06:03:42PM -0700, George Zhang wrote:
> +/*
> + * Releases the VMCI context. If this is the last reference to
> + * the context it will be deallocated. A context is created with
> + * a reference count of one, and on destroy, it is removed from
> + * the context list before its reference count is
> + * decremented. Thus, if we reach zero, we are sure that nobody
> + * else are about to increment it (they need the entry in the
> + * context list for that). This function musn't be called with a
> + * lock held.
> + */
> +void vmci_ctx_release(struct vmci_ctx *context)
> +{
> +	ASSERT(context);
> +	kref_put(&context->kref, ctx_free_ctx);
> +}
> +

Hm, are you _sure_ you should be calling this without a lock held?
That's usually kref-101, you MUST hold a lock when calling put,
otherwise you can race a kref_get() call, and all hell can break loose.

Because of this, some saner people (like Al Viro), have suggested that I
force the kref_put() and kref_get() calls pass in a spinlock just to
enforce this.

So, tell me what I'm missing here, and why you put the comment here
saying that it really is supposed to be called without a lock held?  How
is that safe?

confused,

greg k-h
