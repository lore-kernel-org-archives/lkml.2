Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2DXGOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:14:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:21628 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2DXGOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:14:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="135966394"
From: Andi Kleen <andi@firstfloor.org>
To: Toby Goodwin <toby@mythic-beasts.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fixing NFS over OpenVPN
References: <1335200249.5607.41.camel@rocinante.mythic-beasts.com>
Date: Mon, 23 Apr 2012 23:14:39 -0700
In-Reply-To: <1335200249.5607.41.camel@rocinante.mythic-beasts.com> (Toby
	Goodwin's message of "Mon, 23 Apr 2012 17:57:28 +0100")
Message-ID: <m2ehrdodv4.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toby Goodwin <toby@mythic-beasts.com> writes:
>
> I believe I know how to fix this, but would appreciate some guidance.
> Part of the solution is to specify the "--mlock" flag to openvpn -- this
> exists so that secrets are never written to swap, but as a side effect
> it prevents openvpn from ever page faulting.

mlock does not prevent page faulting. It merely prevents existing pages
getting swapped out, but new pages can be definitely be faulted in.
Your explanation would only make sense if all swappable memory 
in the system is tied up in the openvpn process, which is unlikely.

That said there may be still deadlocks if openvpn needs any new
memory for writing data, but that has nothing to do with mlock.

In fact the mlock should make it more stable under swapping, but you
still have the problem you describe next.

> userland AF_INET socket. (This is the socket through which OpenVPN sends
> its encrypted packets to the remote end of the tunnel.) I haven't
> discovered any way for userland to request a particular allocation
> policy for a socket, please let me know if I've missed something.

Just changing to GFP_NOIO will not fully solve the problem. 

You really would need a preallocated mempool of pages for the socket
(similar to Mel Gorman/ Peter Ziljstra's swap-over-NFS
patchkit). Essentially the whole IO path needs to be able to work
without allocating new memory.
>
> Is there a better way to solve this?

Probably parts of openvpn would need to move into the kernel.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
