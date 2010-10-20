Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0JTA0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 20:26:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355Ab0JTA0N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 20:26:13 -0400
MIME-Version: 1.0
In-Reply-To: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 19 Oct 2010 17:25:38 -0700
Message-ID: <AANLkTikgHG+COx7Bps4NhbiLywUvPcwoQWhN1CWU6yUc@mail.gmail.com>
Subject: Re: [PATCH 1/6] IMA: move read/write counters into struct inode
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 3:58 PM, Eric Paris <eparis@redhat.com> wrote:
>
> This patch does the minimum needed to move the location of the data.  Further
> cleanups, especially the location of counter updates, may still be possible.

Hmm. The end result looks fine (adding four bytes to struct inode in
order to avoid all the complexity seems reasonable), but I do get the
feeling that this should likely be the last in the series, so that the
VFS level files would get minimal changes. IOW, do the cleanups inside
the IMA code first, and then do the switch-over to using counters in
the inode last.

Well, not last, since I think you need to do this before you can do
the "only allocate iint when needed" only after you've moved the
counters. But I think the logical order would be
 - switch to rbtree
 - drop opencount
 - switch counts to 'unsigned int'
 - drop iint->writecount and use i_writecount instead
 - move the remaining readcount to i_readcount
 - only allocate iint when necessary

That way you'd only have _one_ patch that touches <linux/fs.h>, rather
than four, and the remaining patches would all be to security/ima.

But maybe I missed some reason for this particular ordering.

Oh, and btw, due to alignment reasons it looks like the 4-byte
i_readcount would take 8 bytes due to bad structure packing. I don't
know if that is avoidable, but I do think it would make more sense to
put it next to i_writecount instead of in between two pointers. That
still doesn't help (we've got 3 32-bit values next to each other), but
it's at least -closer- to working out.

                         Linus
