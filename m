Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2LKW5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:57:36 -0500
Received: from mga06.intel.com ([134.134.136.21]:39500 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754622Ab2LKW5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:57:34 -0500
MIME-Version: 1.0
In-Reply-To: <CACLa4psVpx8YPcgiQs0FETg8d+zLcjivnks_So6Dpii48pDNBQ@mail.gmail.com>
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
Date: Wed, 12 Dec 2012 00:57:21 +0200
Message-ID: <CALLzPKbqAa7-vJnXbYFbkaD5NVW=6wHQQMDc_Ww==p1hwQ1EJg@mail.gmail.com>
Subject: Re: [PATCH 0/2] ima: policy search speedup
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 10:08 PM, Eric Paris <eparis@parisplace.org> wrote:
> S_PRIVATE is totally unacceptable as it has a meaning across all LSMs,
> not just IMA.
>
> S_NOSEC means 'this is not setuid or setgid and we don't need to do
> those checks on modify'
>
> You are going to need to use a S_NOIMA.
>
> Of Dmitry's 90,000 fewer policy lookups using the per sb flag, how
> many of them are the same inode over and over again which would be
> circumvented using S_NOIMA per inode flag?
>

IIRC those were only newly instantiated inodes.

For new inodes, S_NOIMA would not be set and used at that point.
IMA must do the policy search and then would set the S_NOIMA.

For subsequent calls, S_NOIMA makes sense.

If we would have the SB flag like MS_NOIMA, then we could replicate sb
flag to inode S_NOIMA flag,
in similar way as inode_has_no_xattr() does:

static inline void inode_has_no_xattr(struct inode *inode)
{
	if (!is_sxid(inode->i_mode) && (inode->i_sb->s_flags & MS_NOSEC))
		inode->i_flags |= S_NOSEC;
}

Then later there is no need to dereference inode->i_sb...

Can we reach conclusion about it?
Will we have SB flag?
if yes, then where, s_flags, or in some other field like s_feature_flags?
if not, then we can stop this discussion...

- Dmitry

>
>
> On Tue, Dec 11, 2012 at 2:48 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>> On Tue, 2012-12-11 at 11:10 -0800, Linus Torvalds wrote:
>>
>>> Anyway, the whole "you can do it at file granularity" isn't the bulk
>>> of my argument (the "we already have the field that makes sense" is).
>>> But my point is that per-inode is not only the logically more
>>> straightforward place to do it, it's also the much more flexible place
>>> to do it. Because it *allows* for things like that.
>>
>> Ok. To summarize, S_IMA indicates that there is a rule and that the iint
>> was allocated.  To differentiate between 'haven't looked/don't know' and
>> 'definitely not', we need another bit.  For this, you're suggesting
>> using IS_PRIVATE()?  Hopefully, I misunderstood.
>>
>> thanks,
>>
>> Mimi
>>
>>
>>
