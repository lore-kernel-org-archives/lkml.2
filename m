Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1EWN1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:27:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51044 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1EWN1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:27:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PBiSsD7zgHf4gaGLCBXBy/9FqYKCkhLNxxPWFZFJUnWNOKwOx1ygcrCJCZmIyyQVbD
         D7Fnez9PLZzkQ+tU1jmEbN7YuIuEvGlOnYX6rjwLc6EVH5XTN/UGlelCbNGPFQLKxtva
         gi/1DxrP+9R8otqZ4ADdUXp4pjgxTpCJ+69pk=
MIME-Version: 1.0
In-Reply-To: <m1mxid7of6.fsf@fess.ebiederm.org>
References: <BANLkTim7xn8tM4wTyd_m_nwUQg_CUTapeA@mail.gmail.com>
 <m14o4mavod.fsf@fess.ebiederm.org> <BANLkTinqX_=TLU3TuKJFFTJBBxm1scZ3Ew@mail.gmail.com>
 <m1mxid7of6.fsf@fess.ebiederm.org>
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 23 May 2011 16:26:47 +0300
Message-ID: <BANLkTinH7h2+Vj6o=c03FoPt3nAZ3VU0oQ@mail.gmail.com>
Subject: Re: [v3 00/39] faster tree-based sysctl implementation
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:32 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Mostly it is simplicity.  There is also the fact that the spin lock is
> used in the implementation of something that is essentially a
> reader/writer lock already.


The amount of time in which the spin lock is held in the current
implementation can be quite large: in __register_sysctl_paths:

https://github.com/mirrors/linux-2.6/blob/v2.6.39/kernel/sysctl.c#L1887

	spin_lock(&sysctl_lock);
	for (set = header->set; set; set = set->parent)
		list_for_each_entry(p, &set->list, ctl_entry)
			try_attach(p, header);
	spin_unlock(&sysctl_lock);


For N=10^5 headers and try_attach=O(N) it's not a very good locking mechanism.

That's why I opted for a rwlock for each dir's subdirs/tables.


> In that context I'm not certain I am comfortable with separating proc
> inode usage from other proc usage. But I haven't read through that
> section of your code well enough yet to tell if you are making sense.


Proc inode usage (->count) was already separate from other proc usage (->use).
It was not separate from other header references (shared in ->count).

I separated the two because when I call unregister on a header I need
to decide whether to really unregister it (->unregistering=true and no
one can see this header and anything under it any more) or just
decrement a reference.

In the current implementation a header is only created by a
__register_sysctl_paths call and it's clear that at unregister we have
to set ->unregistering.
In my implementation headers are created dynamically to create new
directory elements. I need to know when to unregister such a header
regardless of any possible procfs inode references.

https://github.com/luciang/linux-2.6-new-sysctl/blob/v4-new-sysctl-alg/kernel/sysctl.c#L2390



I pushed a new version:
git://github.com/luciang/linux-2.6-new-sysctl.git v4-new-sysctl-alg

I undid int->u8 for ctl_procfs_refs.

I left the ->permissions hook get it's namespace form current->
because rewriting history for that change trips on too many patches
and a new parameter can be very easily added later when needed. Hope
this is ok with you.


I'd like to send patches for review to archs/drivers/etc. that
register only tables of files, not whole sysctl trees.
The patches don't depend on anything from this series.

Examples:
* http://thread.gmane.org/gmane.linux.kernel/1137032/focus=1137089
* http://thread.gmane.org/gmane.linux.kernel/1137032/focus=1137087


I'd like an OK-GO from you.

-- 
 .
..: Lucian
