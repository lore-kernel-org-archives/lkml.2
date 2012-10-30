Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873Ab2J3P4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:56:49 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:33794 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932350Ab2J3P4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:56:48 -0400
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Zhang <georgezhang@vmware.com>, pv-drivers@vmware.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 01/12] VMCI: context implementation.
Date: Tue, 30 Oct 2012 08:56:47 -0700
Message-ID: <6866362.eNDmFOn8qX@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.2 (Linux/3.6.0+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121030154652.GB14167@kroah.com>
References: <20121030005923.17788.21797.stgit@promb-2n-dhcp175.eng.vmware.com> <20121030040139.GA32055@dtor-ws.eng.vmware.com> <20121030154652.GB14167@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 30, 2012 08:46:52 AM Greg KH wrote:
> On Mon, Oct 29, 2012 at 09:01:40PM -0700, Dmitry Torokhov wrote:
> > Hi Greg,
> > 
> > On Mon, Oct 29, 2012 at 07:10:58PM -0700, Greg KH wrote:
> > > On Mon, Oct 29, 2012 at 06:03:42PM -0700, George Zhang wrote:
> > > > +/*
> > > > + * Releases the VMCI context. If this is the last reference to
> > > > + * the context it will be deallocated. A context is created with
> > > > + * a reference count of one, and on destroy, it is removed from
> > > > + * the context list before its reference count is
> > > > + * decremented. Thus, if we reach zero, we are sure that nobody
> > > > + * else are about to increment it (they need the entry in the
> > > > + * context list for that). This function musn't be called with a
> > > > + * lock held.
> > > > + */
> > > > +void vmci_ctx_release(struct vmci_ctx *context)
> > > > +{
> > > > +	ASSERT(context);
> > > > +	kref_put(&context->kref, ctx_free_ctx);
> > > > +}
> > > > +
> > > 
> > > Hm, are you _sure_ you should be calling this without a lock held?
> > > That's usually kref-101, you MUST hold a lock when calling put,
> > > otherwise you can race a kref_get() call, and all hell can break loose.
> > > 
> > > Because of this, some saner people (like Al Viro), have suggested that I
> > > force the kref_put() and kref_get() calls pass in a spinlock just to
> > > enforce this.
> > > 
> > > So, tell me what I'm missing here, and why you put the comment here
> > > saying that it really is supposed to be called without a lock held?  How
> > > is that safe?
> > 
> > Contexts are created/registered in vmci_ctx_init_ctx() and unregistered in
> > vmci_ctx_release_ctx() and these operations are protected by
> > ctx_list.lock spinlock. Context lookup (vmci_ctx_get) also uses spinlock
> > to traverse list of registered contexts and then grabs reference to the
> > [valid] context. The use of kref_put() without additional locking in
> > vmci_ctx_release() is fine as there is no chance of another thread
> > bumping count from 0 to 1.
> 
> As I didn't see all callers of this holding that spinlock, it was
> confusing.  You should put this type of description somewhere so that
> other reviewers don't have the same questions.

Fair enough, we'll add better comments to this code.

Thanks,
Dmitry

