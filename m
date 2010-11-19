Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0KSRu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:50:58 -0500
Received: from fieldses.org ([174.143.236.118]:54617 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652Ab0KSRu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:50:56 -0500
Date: Fri, 19 Nov 2010 12:50:53 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Dave Chinner <david@fromorbit.com>,
        David Safford <safford@watson.ibm.com>
Subject: Re: [PATCH v1.2 0/5] IMA: making i_readcount a first class inode
 citizen (reposting)
Message-ID: <20101119175053.GC29148@fieldses.org>
References: <1290121382-4039-1-git-send-email-zohar@linux.vnet.ibm.com>
 <AANLkTin9sYf99fQ_w7Bp4N6Gsm3PR0akpCU=4YEkOaez@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin9sYf99fQ_w7Bp4N6Gsm3PR0akpCU=4YEkOaez@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:31:10PM -0800, Linus Torvalds wrote:
> On Thu, Nov 18, 2010 at 3:02 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >
> > This patchset separates the incrementing/decrementing of the i_readcount, in
> > the VFS layer, from other IMA functionality, by replacing the current
> > ima_counts_get() call with i_readcount_inc(). Its unclear whether this call to
> > increment i_readcount should be made earlier, like i_writecount.  Currently the
> > call is situated immediately after the switch from put_filp() to fput() for
> > cleanup.
> 
> Well, it seems nicer than the situation we have now. So I'm certainly
> ok with seeing this merged for 2.6.38 (through the security tree?) if
> nobody has objections.
> 
> It's a bit sad to have another atomic in the open path, but if the
> lease people want this and are ok with just the counter (no races?)
> then it seems worth it.

Having thought about it more, I'm no longer convinced it will be useful
for leases.

It seems attractive to replace the current d_count/i_count checks by an
i_readcount check, but:

	1) as long as break_lease() is called before i_readcount_inc(),
	   there's a window between the two where setlease has no way to
	   tell whether a read open is about to happen;

	2) more importantly, it won't help file servers, which need more
	   than mutual exclusion between opens and leases.

Number 2 in more detail:

Write leases exist to let a file server (nfsd or Samba) tell a client
that it has exclusive access to a file, so that the client can delay
writes, knowing that it will be notified on lease break (and given a
chance to write back dirty data) before someone else can look at the
file.

But say someone modifies a file on a client and then runs "make" on the
server.  The "make" needs to know about the modifications.  But make only
stat's the file, doesn't open it....

We can break leases on stat, but on its own that's racy--setlease needs
some way to determine whether a lease is in progress.  And i_readlease()
doesn't help there, unless we decide we're going to temporarily
increment that around every stat.  (But if another atomic in the open
path is bad, another in the stat path sounds worse--and it's probably
not the semantics ima needs anyway.)

--b.
