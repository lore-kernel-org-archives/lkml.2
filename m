Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab1CVShb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:37:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281Ab1CVSh1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:37:27 -0400
MIME-Version: 1.0
In-Reply-To: <E1Q264S-0001Fy-HU@pomaz-ex.szeredi.hu>
References: <20110322152602.053930811@szeredi.hu> <20110322153014.560003169@szeredi.hu>
 <AANLkTikQt9JRp4jx9qcTEr6nKMppA8Gj3=E12aFUGUYs@mail.gmail.com> <E1Q264S-0001Fy-HU@pomaz-ex.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2011 11:37:06 -0700
Message-ID: <AANLkTi=dyEoBVAPLMfuG4_jVencSW00PeE3_z+APsL=t@mail.gmail.com>
Subject: Re: [PATCH 1/6 v7] vfs: add i_op->open()
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 11:12 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> Why don't you just pass in the filp to the ->open routine, and drop
>> that "flags" argument. Maybe other filesystems want to use ->open, but
>> don't want to put_filp() on the filp we already allocated, only to
>> allocate a new one?
>
> Maybe, although I don't see the reason to do that.  Why keep the
> original one?  It doesn't contain any information besides the flags
> and the dentry/vfsmount.

Umm? Because that way you can avoid allocating a new one?

So let's turn your questions on its head: why do you insist on
free'ing the old one, WHEN YOU KNOW THAT THE ->open ROUTINE NEEDS TO
ALLOCATE A NEW ONE?

Sure, in _your_ case, you'll get a new filp because you're going to do
a whole new open of a lower-level filesystem, but if the ->open
routine is all about just your case, then I don't want it as a VFS
layer operation. So for your filesystem, you will always discard the
old one as useless. But that's purely an implementation detail for
you. It has nothing to do with the VFS interfaces.

So why do that idiotic free, only to force the callee to then
re-allocate a new "struct file"?

                           Linus
