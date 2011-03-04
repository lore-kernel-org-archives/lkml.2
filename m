Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229Ab1CDCee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 21:34:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759195Ab1CDCed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 21:34:33 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTinQ30f-7bi8QSBjwcmHXH6aydqws1vrFMMaMCWc@mail.gmail.com>
References: <1299137483-10975-1-git-send-email-ksumrall@android.com>
 <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com>
 <4D6FDDB1.3060209@teksavvy.com> <AANLkTimXhGRsuL3Z51msS_YEtsa4UZuN9XW8Xb+hu_KN@mail.gmail.com>
 <AANLkTinQ30f-7bi8QSBjwcmHXH6aydqws1vrFMMaMCWc@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Mar 2011 18:33:36 -0800
Message-ID: <AANLkTi=UuVxtvLqWq=8gTGQyoNKmJwvs3Kr=xSWHbxtx@mail.gmail.com>
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
 remount filesystems ro
To: Ken Sumrall <ksumrall@android.com>
Cc: Mark Lord <kernel@teksavvy.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 6:00 PM, Ken Sumrall <ksumrall@android.com> wrote:
>
> Writing a single byte to /proc/sysrq-trigger is an asynchronous
> operation, with no obvious way to be informed that it has completed
> the remount.

Right you are. That's something of a misfeature, but it comes from the
way sysrq works: obviously the "real" sysrq thing is about keyboard
input, so all the sysrq stuff has to be async.

The fact that that async nature then ends up also affecting the
/proc/sysrq-trigger case (which _could_ be synchronous) is a bit sad
in this case.

That said, I obviously think that just doing the read-only mount
yourself is the right thing to do regardless, and the sysrq thing
would have been just a cute/ugly hack if it had worked.

> I'm heading down the path of reading /proc/mounts and remounting all
> read-wirte filesystems backed by a block device as read-only.

So just as a practical matter: while it's quite possible that the nice
seq_printf() model of /proc/mounts means that it should work correctly
even if you read each line individually and then re-mount while
holding the file open, I would suggest that you read the whole file
into a buffer before you then start changing the mounts.

Otherwise, _if_ we ever were to actually move the filesystem on our
internal list of mounts when we re-mount it, you might otherwise end
up seeign the same filesystem multiple times (or the reverse - missing
some filesystem).

Basically, I'm saying that you should try to avoid changing mount
information in between read() calls to /proc/mounts. It might cause
confusion.

                                        Linus
