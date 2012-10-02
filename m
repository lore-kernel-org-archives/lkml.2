Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2JBRlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:41:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab2JBRlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:41:35 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com
Subject: Re: [RFC, PATCH] Extensible AIO interface
References: <20121001222341.GF26488@google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 02 Oct 2012 13:41:17 -0400
In-Reply-To: <20121001222341.GF26488@google.com> (Kent Overstreet's message of
	"Mon, 1 Oct 2012 15:23:41 -0700")
Message-ID: <x49zk44ojpe.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> So, I and other people keep running into things where we really need to
> add an interface to pass some auxiliary... stuff along with a pread() or
> pwrite().
>
> A few examples:
>
> * IO scheduler hints. Some userspace program wants to, per IO, specify
> either priorities or a cgroup - by specifying a cgroup you can have a
> fileserver in userspace that makes use of cfq's per cgroup bandwidth
> quotas.

You can do this today by splitting I/O between processes and placing
those processes in different cgroups.  For io priority, there is
ioprio_set, which incurs an extra system call, but can be used.  Not
elegant, but possible.

> * Cache hints. For bcache and other things, userspace may want to specify
> "this data should be cached", "this data should bypass the cache", etc.

Please explain how you will differentiate this from posix_fadvise.

> * Passing checksums out to userspace. We've got bio integrity, which is
> a (somewhat) generic interface for passing data checksums between the
> filesystem and the hardware. There are various circumstances under which
> you may want to pass these checksums out to userspace, and if so we
> ought to have a generic way of doing it.

Yes, that needs a new interface.

> Hence, AIO attributes.

*No.*  Start with the non-AIO case first.

> * FUTURE STUFF:
>
> Return values:
>
> Some attributes are probably going to want to return something to
> userspace.
>
> If nothing else, we want this so that userspace can tell if anything
> handled the attributes it specified - as dynamic as the io stack can be,
> with something extensible like this there really isn't any generic way
> of knowing ahead of time if something is going to interpret any
> attribute - we want to return at least an error code.

Seems odd to me.  Why not expose supported attributes via some other
call?  fcntl?

> One could imagine sticking the return in the attribute itself, but I
> don't want to do this. For some things (checksums), the attribute will
> contain a pointer to a buffer - that's fine. But I don't want the
> attributes themselves to be writeable.

One could imagine that attributes don't return anything, because, well,
they're properties of something else, and properties don't return
anything.

Cheers,
Jeff
