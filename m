Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab2DTCb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 22:31:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58691 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2DTCbX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 22:31:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120420004303.GB6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor> <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor> <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor> <20120420004303.GB6871@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Apr 2012 19:31:01 -0700
X-Google-Sender-Auth: O-dqhtfY9hjp96bmBsO6lKbzv_A
Message-ID: <CA+55aFxQR8g3TycW7nOVjjnnsaWWW-Gh74-bV6rUm+7SRTm25g@mail.gmail.com>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 5:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> However, there's an approach that might be feasible.  Most of the time
> the final fput() *is* done without any locks held and there's a very
> large subclass of those call sites - those that come via fput_light().
> What we could do, and what might be maintainable is:
>        * prohibit fput_light() with locks held.  Right now we are very
> close to that (or already there - I haven't finished checking).
>        * convert low-hanging fget/fput in syscalls to fget_light/fput_light.
> Makes sense anyway.

Many of them would make sense, yes (looking at vfs_fstatat() etc.

But a lot of fput() calls come from close() -> filp_close -> fput().

And the "fput_light()" model *only* works together with fget_light()
as it is now.

So I do think you need some other model. Of course, we can just do
"fput_light(file, 1)" instead - that seems pretty ugly, though. But
just making "fput()" do a defer on the last count sounds actively
*wrong* for things like close(), which may actually have serious
consistency guarantees (ie the process doing the close() may "know"
that it is the last user, and depend on the fact that the close() did
actually delete the inode etc.

                 Linus
