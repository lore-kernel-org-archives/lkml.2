Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1KGL3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:29:55 -0500
Received: from tango.0pointer.de ([85.214.72.216]:36496 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab1KGL3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:29:54 -0500
Date: Mon, 7 Nov 2011 12:29:52 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Davidlohr Bueso <dave@gnu.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH] tmpfs: support user quotas
Message-ID: <20111107112952.GB25130@tango.0pointer.de>
References: <1320614101.3226.5.camel@offbook>
 <20111107073127.GA7410@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107073127.GA7410@infradead.org>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07.11.11 02:31, Christoph Hellwig (hch@infradead.org) wrote:

>
> On Sun, Nov 06, 2011 at 06:15:01PM -0300, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <dave@gnu.org>
> >
> > This patch adds a new RLIMIT_TMPFSQUOTA resource limit to restrict an individual user's quota across all mounted tmpfs filesystems.
> > It's well known that a user can easily fill up commonly used directories (like /tmp, /dev/shm) causing programs to break through DoS.
>
> Please jyst implement the normal user/group quota interfaces we use for other
> filesystem.

Please don't.

tmpfs by its very nature is volatile, which means that we'd have to
upload the quota data explicitly each time we mount a tmpfs, which means
we'd have to add quite some userspace infrastructure to make tmpfs work
with quota. Either every time a tmpfs is mounted we'd have to apply a
quota for every configured user and every future user to it (which is
simply not realistic) or on every user logging in we'd have to go
through all tmpfs mount points and apply a user-specific quota setting
to it -- which isn't much less ugly and complex. Just using a
user-specific RLIMIT is much much simpler and beautiful there, and
requires almost no changes to userspace.

On top of that I think a global quota over all tmpfs is actually
preferable than a per-tmpfs quota, because what you want to enforce is
that clients cannot drain the pool that tmpfs is backed from but how
they distribute their share of that pool on the various tmpfs mounted
doesn't really matter in order to avoid DoS vulnerabilities.

In short: a resource limit for tmpfs quota looks like the best solution
here, which does exactly what userspace wants.

Lennart

--
Lennart Poettering - Red Hat, Inc.
