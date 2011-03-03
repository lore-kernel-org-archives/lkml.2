Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab1CCVDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:03:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758665Ab1CCVDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:03:11 -0500
MIME-Version: 1.0
In-Reply-To: <87tyfk7x0c.fsf@devron.myhome.or.jp>
References: <20110303032454.GI22723@ZenIV.linux.org.uk> <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
 <20110303060352.GK22723@ZenIV.linux.org.uk> <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
 <87tyfk7x0c.fsf@devron.myhome.or.jp>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Mar 2011 13:02:50 -0800
Message-ID: <AANLkTinJPQtcBQsBd+OmioywcxSgzWXFgqMBSrfx8e6D@mail.gmail.com>
Subject: Re: [RFC] st_nlink after rmdir() and rename()
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 12:46 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
>
> But, some commands see i_nlink (IIRC, it's checking i_nlink == 2, to
> know empty dir or not).

Actually, that would be a serious bug in the application.

The traditional rule of thumb is that a directory with i_nlink==1 has
a "I'm not counting at all".

For example, I think that's the rule that 'find' uses to decide if a
directory can have subdirectories (and when it could try to stop
scanning early): i_nlink == 1 means that yes, it _can_ have
subdirectories, we just don't know how many.

So checking i_nlink==2 is actually a user-level bug.

> So we have to simulate some levels. I guess you
> are not saying we don't need to care it at all though.

I'm saying that it should just work to set i_nlink=1 and not do
anything at all. Ever. It's a valid model for directory counts.

Seriously - that's what isofs does, for example. It does mean that
'find' for certain cases gets bit more expensive, but on the other
hand, other operations are a lot _less_ expensive.

We might well try that as a FAT mount option, to let people decide
whether they really do want the "scan directories all the time" or
only the "let 'find' scan directories when it needs to" behavior.

                      Linus
