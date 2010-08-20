Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0HTPTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 11:19:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab0HTPTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 11:19:38 -0400
Subject: Re: struct fanotify_event_metadata
From: Eric Paris <eparis@redhat.com>
To: Andreas Schwab <schwab@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Andreas Gruenbacher <agruen@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <m339u976sx.fsf@hase.home>
References: <m21va1ozqx.fsf@igel.home>
	 <201008191644.29299.tvrtko.ursulin@sophos.com>
	 <1282240426.21419.1716.camel@acb20005.ipt.aol.com>
	 <201008201002.16235.tvrtko.ursulin@sophos.com> <m3pqxd7ift.fsf@hase.home>
	 <1282310016.21419.2161.camel@acb20005.ipt.aol.com>
	 <m339u976sx.fsf@hase.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 11:19:30 -0400
Message-ID: <1282317570.15124.20.camel@dhcp231-77.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 15:27 +0200, Andreas Schwab wrote:
> Eric Paris <eparis@redhat.com> writes:
> 
> > Can you help me understand the packed attribute and why it hurts in this
> > case?
> 
> It changes the alignment of all applicable objects to 1 which means that
> the compiler cannot assume _any_ aligment.  Thus on STRICT_ALIGNMENT
> targets it has to use more expensive access methods to avoid generating
> unaligned loads and stores (unless it can infer proper alignment from
> the context).

Andreas suggested (I accidentally dropped the list when I ask him) I use
natural alignment and explicit padding rather than ((packed))

I'm open to the idea but I want to make it idiot proof (aka I won't
screw it up later)  My best offhand idea would be to do something like
so:

Expose this to userspace:
struct fanotify_event_metadata {
        __u32 event_len;
        __u32 vers;
        __s32 fd;
        __u64 mask;
        __s64 pid;
};

Wrap this in #ifdef KERNEL
struct fanotify_event_metadata_packed {
        __u32 event_len;
        __u32 vers;
        __s32 fd;
        __u64 mask;
        __s64 pid;
} __attribute__ ((packed));

Then add:
BUILD_BUG_ON(sizeof(struct fanotify_event_metadata) != 
             sizeof(struct fanotify_event_metadata_packed);

Is that a good way to make the actual object non-packed but keep myself
from ever letting it fail alignment and padding requirements?

-Eric

