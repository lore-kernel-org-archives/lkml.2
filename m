Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049Ab2J3EBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 00:01:42 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:59206 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711Ab2J3EBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 00:01:40 -0400
Date: Mon, 29 Oct 2012 21:01:40 -0700
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 01/12] VMCI: context implementation.
Message-ID: <20121030040139.GA32055@dtor-ws.eng.vmware.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030010333.17788.94988.stgit@promb-2n-dhcp175.eng.vmware.com>
 <20121030021058.GB1920@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030021058.GB1920@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Oct 29, 2012 at 07:10:58PM -0700, Greg KH wrote:
> On Mon, Oct 29, 2012 at 06:03:42PM -0700, George Zhang wrote:
> > +/*
> > + * Releases the VMCI context. If this is the last reference to
> > + * the context it will be deallocated. A context is created with
> > + * a reference count of one, and on destroy, it is removed from
> > + * the context list before its reference count is
> > + * decremented. Thus, if we reach zero, we are sure that nobody
> > + * else are about to increment it (they need the entry in the
> > + * context list for that). This function musn't be called with a
> > + * lock held.
> > + */
> > +void vmci_ctx_release(struct vmci_ctx *context)
> > +{
> > +	ASSERT(context);
> > +	kref_put(&context->kref, ctx_free_ctx);
> > +}
> > +
> 
> Hm, are you _sure_ you should be calling this without a lock held?
> That's usually kref-101, you MUST hold a lock when calling put,
> otherwise you can race a kref_get() call, and all hell can break loose.
> 
> Because of this, some saner people (like Al Viro), have suggested that I
> force the kref_put() and kref_get() calls pass in a spinlock just to
> enforce this.
> 
> So, tell me what I'm missing here, and why you put the comment here
> saying that it really is supposed to be called without a lock held?  How
> is that safe?
> 

Contexts are created/registered in vmci_ctx_init_ctx() and unregistered in
vmci_ctx_release_ctx() and these operations are protected by
ctx_list.lock spinlock. Context lookup (vmci_ctx_get) also uses spinlock
to traverse list of registered contexts and then grabs reference to the
[valid] context. The use of kref_put() without additional locking in
vmci_ctx_release() is fine as there is no chance of another thread
bumping count from 0 to 1.

I believe the comment should actually read that the function should not
be called from atomic contexts.

Thanks,
Dmitry
