Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab3ABOcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 09:32:20 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:18239 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682Ab3ABOcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 09:32:17 -0500
Date: Wed, 2 Jan 2013 14:32:16 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Hugh Dickins <hughd@google.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/2] tmpfs mempolicy: fix /proc/mounts corrupting
 memory
In-Reply-To: <alpine.LNX.2.00.1301020153090.18049@eggly.anvils>
Message-ID: <0000013bfbad4630-c888f29b-7294-4685-8164-87e2fb136796-000000@email.amazonses.com>
References: <alpine.LNX.2.00.1301020153090.18049@eggly.anvils>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2013, Hugh Dickins wrote:

> Recent NUMA enhancements are not to blame: this dates back to 2.6.35,
> when commit e17f74af351c "mempolicy: don't call mpol_set_nodemask()
> when no_context" skipped mpol_parse_str()'s call to mpol_set_nodemask(),
> which used to initialize v.preferred_node, or set MPOL_F_LOCAL in flags.
> With slab poisoning, you can then rely on mpol_to_str() to set the bit
> for node 0x6b6b, probably in the next page above the caller's stack.

Ugly. But 2.6.35 means that the patch was not included in several
enterprise linux releases.

> I don't understand why MPOL_LOCAL is described as a pseudo-policy:
> it's a reasonable policy which suffers from a confusing implementation
> in terms of MPOL_PREFERRED with MPOL_F_LOCAL.  I believe this would be
> much more robust if MPOL_LOCAL were recognized in switch statements
> throughout, MPOL_F_LOCAL deleted, and MPOL_PREFERRED use the (possibly
> empty) nodes mask like everyone else, instead of its preferred_node
> variant (I presume an optimization from the days before MPOL_LOCAL).
> But that would take me too long to get right and fully tested.

The current approaches to implementing NUMA scheduling are making
MPOL_LOCAL an explicit policy. See
https://patchwork.kernel.org/patch/1703641/.

Does that address the concerns?
