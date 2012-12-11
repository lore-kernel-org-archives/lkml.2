Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab2LKXCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 18:02:47 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55260 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2LKXCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 18:02:45 -0500
MIME-Version: 1.0
In-Reply-To: <CALLzPKbqAa7-vJnXbYFbkaD5NVW=6wHQQMDc_Ww==p1hwQ1EJg@mail.gmail.com>
References: <cover.1353621075.git.dmitry.kasatkin@intel.com>
	<CALLzPKZKd38QJVPfjdNpAFO9hwmRc1asVGkHby1VGRLm89DKyg@mail.gmail.com>
	<CALLzPKZgxO9wRNfJPnSY=G6Gjib7MeEXM4D1A1YZsrVmbs1W6A@mail.gmail.com>
	<1355234914.2356.85.camel@falcor>
	<CA+55aFwA3isRny9JyqxzjoysHbRhiKpBheeEi6VZrnWokt521A@mail.gmail.com>
	<1355249884.2356.108.camel@falcor>
	<CACLa4pvLbrCbivWSNTuxROBf5qDNJZmnFVyQaQ=7qcZRtSfcfg@mail.gmail.com>
	<1355252392.2356.131.camel@falcor>
	<CA+55aFwG31fi9=r0Zta2hoo60vdgM61hbh4BC9Rgs8i7S82Haw@mail.gmail.com>
	<1355255320.2356.148.camel@falcor>
	<CACLa4psVpx8YPcgiQs0FETg8d+zLcjivnks_So6Dpii48pDNBQ@mail.gmail.com>
	<CALLzPKbqAa7-vJnXbYFbkaD5NVW=6wHQQMDc_Ww==p1hwQ1EJg@mail.gmail.com>
Date: Tue, 11 Dec 2012 18:02:43 -0500
Message-ID: <CACLa4pske6okjDj5mRC1+20VhWZmFt+L6j+Y6e=weA7PvD13yw@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: Eric Paris <eparis@parisplace.org>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus made it clear he likes per-inode.  Do a test with per-inode
S_NOIMA.  See how that compares to your 100,000 vs 10,000 lookups.
Then we can discuss with facts if per sb is worth it or not.  We still
don't actually know if 100,000 lookups vs 10,000 lookups really
matters, but at least we'll have some facts...

On Tue, Dec 11, 2012 at 5:57 PM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> On Tue, Dec 11, 2012 at 10:08 PM, Eric Paris <eparis@parisplace.org> wrote:
>> S_PRIVATE is totally unacceptable as it has a meaning across all LSMs,
>> not just IMA.
>>
>> S_NOSEC means 'this is not setuid or setgid and we don't need to do
>> those checks on modify'
>>
>> You are going to need to use a S_NOIMA.
>>
>> Of Dmitry's 90,000 fewer policy lookups using the per sb flag, how
>> many of them are the same inode over and over again which would be
>> circumvented using S_NOIMA per inode flag?
>>
>
> IIRC those were only newly instantiated inodes.
>
> For new inodes, S_NOIMA would not be set and used at that point.
> IMA must do the policy search and then would set the S_NOIMA.
>
> For subsequent calls, S_NOIMA makes sense.
>
> If we would have the SB flag like MS_NOIMA, then we could replicate sb
> flag to inode S_NOIMA flag,
> in similar way as inode_has_no_xattr() does:
>
> static inline void inode_has_no_xattr(struct inode *inode)
> {
>         if (!is_sxid(inode->i_mode) && (inode->i_sb->s_flags & MS_NOSEC))
>                 inode->i_flags |= S_NOSEC;
> }
>
> Then later there is no need to dereference inode->i_sb...
>
> Can we reach conclusion about it?
> Will we have SB flag?
> if yes, then where, s_flags, or in some other field like s_feature_flags?
> if not, then we can stop this discussion...
>
> - Dmitry
>
>>
>>
>> On Tue, Dec 11, 2012 at 2:48 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>>> On Tue, 2012-12-11 at 11:10 -0800, Linus Torvalds wrote:
>>>
>>>> Anyway, the whole "you can do it at file granularity" isn't the bulk
>>>> of my argument (the "we already have the field that makes sense" is).
>>>> But my point is that per-inode is not only the logically more
>>>> straightforward place to do it, it's also the much more flexible place
>>>> to do it. Because it *allows* for things like that.
>>>
>>> Ok. To summarize, S_IMA indicates that there is a rule and that the iint
>>> was allocated.  To differentiate between 'haven't looked/don't know' and
>>> 'definitely not', we need another bit.  For this, you're suggesting
>>> using IS_PRIVATE()?  Hopefully, I misunderstood.
>>>
>>> thanks,
>>>
>>> Mimi
>>>
>>>
>>>
