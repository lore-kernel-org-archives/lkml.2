Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab0J1Wil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:38:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37484 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab0J1Wig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:38:36 -0400
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, warthog9@kernel.org, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu, eparis@redhat.com, viro@zeniv.linux.org.uk,
        Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <AANLkTimG6o66SFHskkDOtLqYeSzwKt2c0jR3CWe+sd2w@mail.gmail.com>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20101028222404.GG2715@dastard>
	 <AANLkTimG6o66SFHskkDOtLqYeSzwKt2c0jR3CWe+sd2w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 18:38:30 -0400
Message-ID: <1288305510.2610.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 15:29 -0700, Linus Torvalds wrote:
> On Thu, Oct 28, 2010 at 3:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Why the wrapper functions and locking? Why not an atomic variable like
> > i_writecount?
> 
> Indeed. With moving this more into the VFS, let's just make sure it
> looks like i_writecount as much as possible.
> 
>                       Linus

Would making i_readcount atomic be enough in ima_rdwr_violation_check(),
or would it still need to take the spin_lock? IMA needs guarantees
that the i_readcount/i_writecount won't be updated in between.

        spin_lock(&inode->i_lock);

        if (mode & FMODE_WRITE) {
                if (inode->i_readcount && IS_IMA(inode))
                        send_tomtou = true;
                goto out;
        }

        rc = ima_must_measure(NULL, inode, MAY_READ, FILE_CHECK);
        if (rc < 0)
                goto out;

        if (atomic_read(&inode->i_writecount) > 0)
                send_writers = true;
out:
        spin_unlock(&inode->i_lock);

Wouldn't the same be true in fs/locks:get_setleases()?

Mimi

