Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab2AERan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:30:43 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45627 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab2AERam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:30:42 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
References: <CA+55aFyzqCVwpuRNOt8a=fdoDq_khsbSHBs6cT=TLuzQ7ixwgg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jan 2012 09:30:22 -0800
X-Google-Sender-Auth: IyTdZWsn5cVzEa1Hs5Uro-9yCqQ
Message-ID: <CA+55aFyYE3_bU5Gr59aSd3zZGAeGo_D66os3o9vZjyVyMhocng@mail.gmail.com>
Subject: Re: Broken ioctl error returns (was Re: [PATCH 2/3] block: fail SCSI
 passthrough ioctls on partition devices)
To: Paolo Bonzini <pbonzini@redhat.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 9:02 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Added, linux-media and Mauro to the Cc, because I'm about to commit
> something like the attached patch to see if anything breaks. We may
> have to revert it if things get too nasty, but we should have done
> this years and years ago, so let's hope not.

Ok, so "It works for me". I'll delay committing it in case somebody
has some quick obvious fixes or comments (like noticing other cases
like the blk_ioctl.c one), but on the whole I think I'll commit it
later today, just so that it will be as early as possible in the merge
window in case there is ENOTTY/EINVAL confusion.

The good news is that no user space can *ever* care about
ENOTTY/EINVAL in the "generic case", since different drivers have
returned different error returns for years. So user space that doesn't
know exactly what it is dealing with will pretty much by definition
not be affected. Except perhaps in a good way - if it uses "perror()"
or "strerror()" or similar, it will now give a much better error
string of "Inappropriate ioctl for device".

However, some applications don't work with "generic devices", but
instead work with a very specific device or perhaps a very specific
subset.

So the exception would be user space apps that know exactly which
driver they are talking about, and that particular driver used to
always return EINVAL before, and now the ENOIOCTLCMD -> ENOTTY fix
means that it returns the proper ENOTTY - and the application has
never seen it, and never tested against it, and breaks.

I don't *think* this happens outside of the media drivers, but we'll
see. It may be that we will have to make certain drivers return EINVAL
explicitly rather than ENOIOCTLCMD and add a comment about why. Sad,
if so, so we'll have little choice. Let's see what the breakage (if
any - cross your fingers) looks like.

                               Linus
