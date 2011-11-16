Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab1KPRje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:39:34 -0500
Received: from mtv-iport-4.cisco.com ([173.36.130.15]:31639 "EHLO
	mtv-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab1KPRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:39:33 -0500
X-IronPort-AV: E=Sophos;i="4.69,522,1315180800"; 
   d="scan'208";a="14664981"
Date: Wed, 16 Nov 2011 09:39:32 -0800 (PST)
From: Victor Kamensky <kamensky@cisco.com>
To: Ralf Baechle <ralf@linux-mips.org>
cc: David Daney <david.daney@cavium.com>,
        "manesoni@cisco.com" <manesoni@cisco.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: Re: [PATCH 2/4] MIPS Kprobes: Deny probes on ll/sc instructions
In-Reply-To: <20111116121207.GA5079@linux-mips.org>
Message-ID: <Pine.GSO.4.58.1111160847340.381@infra-view9.cisco.com>
References: <20111108170336.GA16526@cisco.com> <20111108170535.GC16526@cisco.com>
 <4EB98A8E.4060900@cavium.com> <Pine.GSO.4.58.1111081504560.10959@infra-view9.cisco.com>
 <20111116121207.GA5079@linux-mips.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

Please see inline

On Wed, 16 Nov 2011, Ralf Baechle wrote:

> On Tue, Nov 08, 2011 at 03:26:42PM -0800, Victor Kamensky wrote:
>
> > > s/insturctions/instructions/
> > >
> > > Not only is it a bad idea, it will probably make them fail 100% of the time.
> > >
> > > It is also an equally bad idea to place a probe between any LL and SC
> > > instructions.  How do you prevent that?
> >
> > As per below code comment we don't prevent that. There is no way to do
> > that.
>
> Similar to the way that the addresses of loads and stores from userspace
> are recorded in a special section we could build a list of forbidden
> address range.
>
> Is it worth it?

Yes, probably it could be done this way. It would require to change all
places where ll/sc used. Infrastructure to look at those tables in kernel
and in all loaded modules will be required. Cost of check in kprobes layer
will go up as well, but probably on acceptable level.

In my personal opinion benefits it would bring will not worth the effort.

Couple more, hopefully relevant, notes:

- on kprobes CPU independent layer there is already __kprobes marker
  (attribute section) that could be used to mark function where kprobes
  insertion is not allowed. So one may use it, albeit on function level
  granularity, not code range.

- in my personal opinion all these checks have just practical meaning and
  practical limitations. For example current mips kprobes check whether
  instruction is in delay slot looks at previous 4 bytes to match jump or
  branch instruction pattern. It works and really helps in 99.99% of the
  cases but it will break in some exotic case where the instruction
  follows data (jump table for example) or padding that happens to match
  jump or branch instruction pattern. Or even if instruction follows jump
  and branch instruction, it could be jumped directly on it (i.e serve as
  branch delay slot in one case and regular instruction in another case).
  In all such obscure cases current delay slot instruction check would
  produce false positive. And it is perfectly fine, given practical
  consideration. I just bring this to illustrate my point that in this
  sort of situations, where we are trying to prevent API caller to shot
  himself/herself in the foot, we don't need to push to absolute
  solutions, just practical one.

Thanks,
Victor

>   Ralf
>
