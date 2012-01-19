Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab2ASOBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:01:07 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47459 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567Ab2ASOBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:01:03 -0500
Date: Thu, 19 Jan 2012 14:00:58 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
Message-ID: <20120119140058.GA19036@arm.com>
References: <gi39bcyff8.fsf@mx10.gouders.net>
 <20120119110121.GC9268@arm.com>
 <gi1uqvsx8n.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gi1uqvsx8n.fsf@karga.hank.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 12:16:56PM +0000, Dirk Gouders wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> > On Wed, Jan 18, 2012 at 07:32:59PM +0000, Dirk Gouders wrote:
> >> Freeing unused kernel memory: 608k freed
> >> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> >> BUG: unable to handle kernel paging request at ffffffff818b232b
> >> IP: [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
...
> >> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
> >> RIP  [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
> >
> > I don't really see how kmemleak could cause such error (or any of the
> > recent changes I have made). It looks like some of the code in the
> > .init.text section is not executable.

Ah, the interesting part - 0xcc is the poison value for freed initmem.
And from the kernel logs you posted Linux frees the initmem and later
calls kmemleak_late_init() which should have been in the .init.text
section.

The kmemleak_late_init() function is defined as:

static int __init kmemleak_late_init(void)
{
...
}
late_initcall(kmemleak_late_init);

and it must *not* be called after the initmem has been freed. Was there
any change in the x86 or generic code with regards to the freeing of the
init memory?

-- 
Catalin
