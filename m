Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab2CCA6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 19:58:04 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51825 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2CCA6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 19:58:02 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.133.151 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F516811.8060800@zytor.com>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org> <4F516811.8060800@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Mar 2012 16:57:40 -0800
X-Google-Sender-Auth: h4VqAt3aFxCAFAknUEqK9ecv9k0
Message-ID: <CA+55aFzoOOCOU-N6Zaq8Dd+U0no0a9U5ndU-LA_TrctM5tPP2Q@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 4:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> My biggest concern is what happens when this happens to be at the end of
> mapped kernel memory and we overrun the page?

Yes. It's very unlikely, and it never happens with the dentry data
itself (the name is always aligned for those).

But it *can* happen if:

 - the page contains the filename we copied from user space

 - the page is the last page mapped

 - the filename is PATH_MAX in size (or very close)

 - the last component is sufficiently unaligned

but I was thinking we'd just make sure not to free the last page, and
just solve it that way.

I was playing around with other ideas (take the page fault and fix it
up), but those are all really complicated when the notion of "don't
use the last page" is so much simpler.

                      Linus
