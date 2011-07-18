Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab1GRGcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 02:32:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018Ab1GRGb7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 02:31:59 -0400
MIME-Version: 1.0
In-Reply-To: <20110718020818.GW11013@ZenIV.linux.org.uk>
References: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
 <CA+55aFw5LhGq-a6mAhgZbGP2FJ+tnV9HRxKoiFuVYbttOo2tNw@mail.gmail.com>
 <20110717231610.GR11013@ZenIV.linux.org.uk> <CA+55aFxEGKgx+_xy+Lnt=84wRzE9TyznL3VCNSqWs7HC_H35_A@mail.gmail.com>
 <alpine.LSU.2.00.1107171641130.1274@sister.anvils> <20110718002524.GU11013@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1107171740260.1327@sister.anvils> <20110718020818.GW11013@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 17 Jul 2011 23:31:03 -0700
Message-ID: <CA+55aFwXgcWxvAz7w1f_HYyzdm9b9EBJfrWhF1FW7EA3zpbJPg@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix race in rcu lookup of pruned dentry
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 7:08 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Jul 17, 2011 at 06:13:34PM -0700, Hugh Dickins wrote:
>
>> And in the genuine negative dentry case: at present (with or without
>> my or Linus's patches) there is no final nd->seq check, is there?
>
> For stat() - no, there isn't.  We really bail out with -ENOENT, no matter
> what.  Racy, which is what you are hitting.

The fundamental bug is in the dentry pruning. Not in lookup. If the
lookup sees a negative dentry, it will currently return ENOENT. Not
unlazy the thing like you claim. Your patch makes it unlazy the RCU
walk for a negative dentry and then retry that it currently doesn't -
for both the racy case (nobody cares, since that isn't performance
critical) _and_ for the normal real negative case.

And it's that "normal real negative case" that I really think that
your "goto unlazy" is just wrong. It's right for the sequence number
change, but not for the "!inode" case.

Now, I do agree that maybe that case simply should check the dentry
sequence count. I wish all cases did. Hugh patch did that. But the
reason I dislike Hugh's patch is that when I say "I wish they all
did", I mean that I dislike the special casing. And Hugh's patch just
adds *more* special casing for that NULL entry - I'd wish we just
always did it regardless of whether it was NULL or not.

So I claim that your patch changes *way* more than mine does. I think
I'd prefer Hugh's over that one. I still think that right now, my
one-liner is actually the one that changes things the least (and I
don't mean in size of patch, but in behavior and logic).

                         Linus
