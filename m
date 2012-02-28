Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2B1ELa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 23:11:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38410 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2B1EL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 23:11:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.233.165 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Mon, 27 Feb 2012 20:10:53 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Ware, Ryan R" <ryan.r.ware@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        James Morris <jmorris@namei.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] tmpfs: security xattr setting on inode creation
In-Reply-To: <CAGGTEhPQ6OLgqZbbAwE=3Xj8qE2iNhLOk5LdkGU13WxbY=qb2w@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1202272003380.1574@eggly.anvils>
References: <1329990365-23779-1-git-send-email-jarkko.sakkinen@intel.com> <alpine.LRH.2.02.1202241913400.30742@tundra.namei.org> <alpine.LSU.2.00.1202241904070.22389@eggly.anvils> <20120227144602.07f5ec33.akpm@linux-foundation.org>
 <CAGGTEhPQ6OLgqZbbAwE=3Xj8qE2iNhLOk5LdkGU13WxbY=qb2w@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012, Ware, Ryan R wrote:
> On Tue, Feb 28, 2012 at 7:46 AM, Andrew Morton <akpm@linux-foundation.org>wrote:
> > On Fri, 24 Feb 2012 19:19:22 -0800 (PST)
> > Hugh Dickins <hughd@google.com> wrote:
> >...
> > > +             if (!new_xattr->name) {
> > > +                     kfree(new_xattr);
> > > +                     return -ENOMEM;
> > > +             }
> > > +
> > > +             memcpy(new_xattr->name, XATTR_SECURITY_PREFIX,
> > > +                    XATTR_SECURITY_PREFIX_LEN);
> > > +             memcpy(new_xattr->name + XATTR_SECURITY_PREFIX_LEN,
> > > +                    xattr->name, len);
> > > +
> > > +             spin_lock(&info->lock);
> > > +             list_add(&new_xattr->list, &info->xattr_list);
> > > +             spin_unlock(&info->lock);
> > > +     }
> > > +
> > > +     return 0;
> > > +}
> >
> > So if there's a kmalloc failure partway through the array, we leave a
> > partially xattrified inode in place.
> >
> > Are we sure this is OK?
> >
> 
> I'm guessing Jarkko can clean that up a bit.  It wouldn't be a good idea to
> leave inaccurate data structures laying around during failure cases.

Andrew raises a good concern, but Jarkko got it just right and no
change is needed: any xattrs already allocated are properly linked
on info->xattr_list, then when security_inode_init_security() fails
(with an error other than EOPNOTSUPP) the failing inode is iput(),
which ends up in shmem_evict_inode(), which kfree()s those xattrs
(and their names) on info->xattr_list.

Hugh
