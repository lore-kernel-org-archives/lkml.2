Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab2JBVlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:41:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37000 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab2JBVlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:41:18 -0400
Date: Tue, 2 Oct 2012 14:41:13 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121002214113.GV26488@google.com>
References: <20121001222341.GF26488@google.com>
 <20121001231222.GB14533@lenny.home.zabbo.net>
 <20121001232235.GH26488@google.com>
 <20121001234439.GC14533@lenny.home.zabbo.net>
 <20121002002216.GI26488@google.com>
 <20121002174323.GE14533@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002174323.GE14533@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 10:43:23AM -0700, Zach Brown wrote:
> > The generic code wouldn't know about any user pointers inside
> > attributes, so it'd have to be downstream consumers. Hopefully there
> > won't be many attributes with user pointers in them (I don't expect
> > there to be), so we won't have too much of this messyness.
> 
> I really don't like this.  We should have learned this lesson with ioctl
> structs that are nested pointers.

I will in no way claim to be skilled at kernel/userspace interface
design (my expertise is more in the block layer), so feel free to
educate me as much as you have the patience for :)

The comparision with ioctl is definitely apt. (And I don't care for
ioctl either, my first preference is for textual interfaces wherever
possible - but I don't think that's a reasonable approach here :p)

I'm not sure what you're exact complaint about nested pointers is - I
agree we want to avoid pointers as much as they can, for multiple
reasons. I do expect to get rid of one layer of indirection eventually,
but that'll probably require new syscalls.

Also, I emphatically hope and expect that nested pointers will _not_ be
the norm.

> What about security bits that are trying to determine if attributes are
> OK?

Seems to me it'd be no different from security considerations when
introducing new ioctls. I.e., messy, ad hoc, easy to get wrong, but
sometimes no way around it.

It really has to be ad hoc if it's extensible, unfortunately.

The only way of getting around _that_ would be with some kind of
reflective type system, so that generic code could parse (in some
fashion) the types of the various attributes, and for pointers copy the
user data into the kernel and do whatever access controls in generic
code.

Which might not be a crazy idea if it could be applied to ioctls...
hmm...

> What about contexts that can't easily deal with userspace pointers?  We
> tend to copy into relatively more accessible kernel memory as early as
> possible.

That tends not to be the case submission side. submit_bio() and
make_request functions are all run in normal process context.

And also, like I mentioned I expect nested pointers to be fairly unusual
so this shouldn't come up often.

> What about fuse trying to extend this interface out to their fs clients?
> Look at the horrible mess it implements to bounce nested ioctl data
> parsing between the kernel's user pointer copying and the fuse client's
> parsing of that copied data.

Ugh, yeah that's something I should look into/think about. It's been
ages since I looked at fuse, and I never looked at how it handled ioctls
(not sure if that even existed when i was looking at it).

> Let's not do this again, please.  I think it's a fallacy to claim that
> the interface can be opaque to high levels and only parsed by lower
> levels.  The interface should be explicit and fully specified on entry
> so that all levels have trivial access to it.

Hmm - that is definitely a good principle.

To restate a bit, the parsing and validation ought to be done in generic
centralized code to the greatest extent possible (I _think_ that it's
not always possible in general, but maybe it will be in practice).

Also - IMO, one of the nastier things about ioctls is that
parsing/validation tends to be completely mixed with implementation. It
would be nice to get away from that.

Pondering a bit - that actually is the situation with my patch for
attributes that are simple data; it's just data and the data is
trivially accessible at all levels.

But, this isn't just an issue for attributes that contain user pointers
- the first attribute we prototyped was the proxy_pid attr, so a process
can have io done in another cgroup's context.

That requires validation, permission checking, and depending on how it's
used refcounting. That stuff _definitely_ shouldn't be buried in the
middle of block/cfq-iosched.c.

Two approaches I can think of:

For every attr, define a struct user_iocb_attr_foo and struct
kern_iocb_attr_foo. Outside of the attr parsing code, nothing in the
kernel sees the user version - they see a kern version which has had
said parsing/validation done on it.

I do like this approach in that it ought to make things easy to
audit/hard to screw up.

One difficulty I can see with that approach is refcounting - if
parsing/validation is done on kernel entry, we've got to take refcounts
to whatever kernel structures are referred to (like a different
task_struct). This can often be avoided if we delay parsing/validation
until when it's actually used, and then use rcu.

Or maybe we could go with a halfway approach - the userspace structs are
passed around within the kernel like in my existing patch, but for any
attr that isn't simple data we define a parse_iocb_attr_foo function,
and those functions are implemented in a common location - not scattered
around defined where they're used.
