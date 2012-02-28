Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2B1Fv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 00:51:28 -0500
Received: from mga05.intel.com ([192.55.52.89]:11469 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755772Ab2B1Fv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 00:51:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jarkko.sakkinen@intel.com designates 10.60.26.133 as permitted sender) smtp.mail=jarkko.sakkinen@intel.com
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1202272003380.1574@eggly.anvils>
References: <1329990365-23779-1-git-send-email-jarkko.sakkinen@intel.com>
	<alpine.LRH.2.02.1202241913400.30742@tundra.namei.org>
	<alpine.LSU.2.00.1202241904070.22389@eggly.anvils>
	<20120227144602.07f5ec33.akpm@linux-foundation.org>
	<CAGGTEhPQ6OLgqZbbAwE=3Xj8qE2iNhLOk5LdkGU13WxbY=qb2w@mail.gmail.com>
	<alpine.LSU.2.00.1202272003380.1574@eggly.anvils>
Date: Tue, 28 Feb 2012 07:51:26 +0200
Message-ID: <CADjiTvCViw4tZ9HvH-s8a2_8uW82BwfXz3PLQmEEVAVC0PbDwg@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: security xattr setting on inode creation
From: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: "Ware, Ryan R" <ryan.r.ware@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 6:10 AM, Hugh Dickins <hughd@google.com> wrote:
> On Tue, 28 Feb 2012, Ware, Ryan R wrote:
>> On Tue, Feb 28, 2012 at 7:46 AM, Andrew Morton <akpm@linux-foundation.org>wrote:
>> > On Fri, 24 Feb 2012 19:19:22 -0800 (PST)
>> > Hugh Dickins <hughd@google.com> wrote:
>> >...
>> > > +             if (!new_xattr->name) {
>> > > +                     kfree(new_xattr);
>> > > +                     return -ENOMEM;
>> > > +             }
>> > > +
>> > > +             memcpy(new_xattr->name, XATTR_SECURITY_PREFIX,
>> > > +                    XATTR_SECURITY_PREFIX_LEN);
>> > > +             memcpy(new_xattr->name + XATTR_SECURITY_PREFIX_LEN,
>> > > +                    xattr->name, len);
>> > > +
>> > > +             spin_lock(&info->lock);
>> > > +             list_add(&new_xattr->list, &info->xattr_list);
>> > > +             spin_unlock(&info->lock);
>> > > +     }
>> > > +
>> > > +     return 0;
>> > > +}
>> >
>> > So if there's a kmalloc failure partway through the array, we leave a
>> > partially xattrified inode in place.
>> >
>> > Are we sure this is OK?
>> >
>>
>> I'm guessing Jarkko can clean that up a bit.  It wouldn't be a good idea to
>> leave inaccurate data structures laying around during failure cases.
>
> Andrew raises a good concern, but Jarkko got it just right and no
> change is needed: any xattrs already allocated are properly linked
> on info->xattr_list, then when security_inode_init_security() fails
> (with an error other than EOPNOTSUPP) the failing inode is iput(),
> which ends up in shmem_evict_inode(), which kfree()s those xattrs
> (and their names) on info->xattr_list.

Yeah, that's how I understood it too. These the are places where
security_inode_init_security() is called:

- http://lxr.free-electrons.com/source/mm/shmem.c#L1459
- http://lxr.free-electrons.com/source/mm/shmem.c#L1590

>
> Hugh

/Jarkko
