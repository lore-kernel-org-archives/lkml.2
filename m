Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2CAP7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 10:59:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48648 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2CAP7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 10:59:34 -0500
MIME-Version: 1.0
In-Reply-To: <1330596839.2704.15.camel@menhir>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
 <1330596839.2704.15.camel@menhir>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Mar 2012 07:59:13 -0800
X-Google-Sender-Auth: ieFY0KWhFeUAXG1DFFlhKKjs26Q
Message-ID: <CA+55aFz1g3RsiEoWm0vDgb4VE-EbJpdx_6nACJzm57DP1rRnKw@mail.gmail.com>
Subject: Re: .. anybody know of any filesystems that depend on the exact VFS
 'namehash' implementation?
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 2:13 AM, Steven Whitehouse <swhiteho@redhat.com> wrote:
>
> GFS2 is guilty as charged, m'lud! (but see below...)
>
> from fs/gfs2/dentry.c:
>
> static int gfs2_dhash(const struct dentry *dentry, const struct inode *inode,
>                struct qstr *str)
> {
>        str->hash = gfs2_disk_hash(str->name, str->len);
>        return 0;
> }

Ok, that's fine. As long as you also use your own well-defined
hash-function rather than just depend on the default VFS one, I don't
care. It's only the default one I'd be optimizing.

You'd obviously not get the performance advantage either, but since I
don't even know whether it's really worth it in the first place, not a
big worry (those kernel routines can be about 5% of CPU time each
under loads that are very pathname-intensive, and it looks like I
could shave maybe 10-20% off them for the best case, so we're talking
*maybe* a percentage point on some specific loads).

And yeah, if some filesystem actually depends on the current default
VFS hash we can always work around it by filesystems just making the
current hash function explicit like you already do in gfs2.

                       Linus
