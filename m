Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0JTOrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:47:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab0JTOrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:47:13 -0400
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org
In-Reply-To: <20101020143845.GB22271@elte.hu>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
	 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
	 <1287506215.2530.187.camel@localhost.localdomain>
	 <20101019165530.GT19804@ZenIV.linux.org.uk>
	 <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
	 <1287528546.2530.277.camel@localhost.localdomain>
	 <20101020143845.GB22271@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 10:46:36 -0400
Message-ID: <1287585996.2530.294.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 16:38 +0200, Ingo Molnar wrote:
> * Eric Paris <eparis@redhat.com> wrote:
> 
> > Executive summary of the day's work:
> > Yesterday morning: 944 bytes per inode in core
> > Yesterday night: 24 bytes per inode in core
> > Tonight: 4 bytes per inode in core.
> > 
> > That's a x236 time reduction in memory usage.  No I didn't even start looking at a 
> > freezer.  Which could bring that 4 down to 0, but would add a scalability penalty 
> > on all inodes when IMA was enabled.
> 
> Why not use inode->i_security intelligently? That already exists so that way it's 0 
> bytes.
> 
> Thanks,

It still wouldn't be 0 bytes since there would be a 1-1 mapping from
inode to i_security structs.  It would just be hiding the memory
somewhere else so it's harder to spot.  And that's exactly how we got
into this situation, instead of just doing thing in the inode we hid it
away in a radix tree node and ima_iint_cache.  In any case it would
require a secondary structure

struct generic_lsm_inode_structure
{
	IMA Fields
	void *lsm_inode_structure;
}

Which means yet another pointer to the real per LSM inode struct.  So it
would actually likely cost memory....

The real reason I don't pursue this route is because of the litany of
different ways this pointer is used in different LSMs (or not used at
all.)  And we all know that LSM authors aren't known for seeing the
world the same way as each other.  As a maintainer of one of those LSMs
even I'm scared to try pushing that forward....

