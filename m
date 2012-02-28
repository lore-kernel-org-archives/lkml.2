Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab2B1Dqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 22:46:36 -0500
Received: from mga10.intel.com ([192.55.52.92]:36198 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753423Ab2B1Dqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 22:46:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ryan.r.ware@intel.com designates 10.152.147.202 as permitted sender) smtp.mail=ryan.r.ware@intel.com
MIME-Version: 1.0
In-Reply-To: <20120227144602.07f5ec33.akpm@linux-foundation.org>
References: <1329990365-23779-1-git-send-email-jarkko.sakkinen@intel.com>
	<alpine.LRH.2.02.1202241913400.30742@tundra.namei.org>
	<alpine.LSU.2.00.1202241904070.22389@eggly.anvils>
	<20120227144602.07f5ec33.akpm@linux-foundation.org>
Date: Tue, 28 Feb 2012 12:46:13 +0900
Message-ID: <CAGGTEhP=jbA664fbbZaVEN5Bxq9_3iiV84ME8QSTUohv2JLkqw@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: security xattr setting on inode creation
From: "Ware, Ryan R" <ryan.r.ware@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        James Morris <jmorris@namei.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 7:46 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 24 Feb 2012 19:19:22 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
>
> > +/*
> > + * Callback for security_inode_init_security() for acquiring xattrs.
> > + */
> > +static int shmem_initxattrs(struct inode *inode,
> > +                         const struct xattr *xattr_array,
> > +                         void *fs_info)
> > +{
> > +     struct shmem_inode_info *info = SHMEM_I(inode);
> > +     const struct xattr *xattr;
> > +     struct shmem_xattr *new_xattr;
> > +     size_t len;
> > +
> > +     for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> > +             new_xattr = shmem_xattr_alloc(xattr->value,
> > xattr->value_len);
> > +             if (!new_xattr)
> > +                     return -ENOMEM;
> > +
> > +             len = strlen(xattr->name) + 1;
> > +             new_xattr->name = kmalloc(XATTR_SECURITY_PREFIX_LEN + len,
> > +                                       GFP_KERNEL);
> > +             if (!new_xattr->name) {
> > +                     kfree(new_xattr);
> > +                     return -ENOMEM;
> > +             }
> > +
> > +             memcpy(new_xattr->name, XATTR_SECURITY_PREFIX,
> > +                    XATTR_SECURITY_PREFIX_LEN);
> > +             memcpy(new_xattr->name + XATTR_SECURITY_PREFIX_LEN,
> > +                    xattr->name, len);
> > +
> > +             spin_lock(&info->lock);
> > +             list_add(&new_xattr->list, &info->xattr_list);
> > +             spin_unlock(&info->lock);
> > +     }
> > +
> > +     return 0;
> > +}
>
> So if there's a kmalloc failure partway through the array, we leave a
> partially xattrified inode in place.
>
> Are we sure this is OK?

I'm guessing Jarkko can clean that up a bit.  It wouldn't be a good
idea to leave inaccurate data structures laying around during failure
cases.

Ryan
