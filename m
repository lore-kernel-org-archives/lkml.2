Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab1CDCAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 21:00:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64754 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917Ab1CDCAq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 21:00:46 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimXhGRsuL3Z51msS_YEtsa4UZuN9XW8Xb+hu_KN@mail.gmail.com>
References: <1299137483-10975-1-git-send-email-ksumrall@android.com>
	<AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com>
	<4D6FDDB1.3060209@teksavvy.com>
	<AANLkTimXhGRsuL3Z51msS_YEtsa4UZuN9XW8Xb+hu_KN@mail.gmail.com>
Date: Thu, 3 Mar 2011 18:00:45 -0800
Message-ID: <AANLkTinQ30f-7bi8QSBjwcmHXH6aydqws1vrFMMaMCWc@mail.gmail.com>
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
 remount filesystems ro
From: Ken Sumrall <ksumrall@android.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Lord <kernel@teksavvy.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing a single byte to /proc/sysrq-trigger is an asynchronous
operation, with no obvious way to be informed that it has completed
the remount.  I did actually try this at first, but the reboot
happened before the remount finished.  I could of course add a sleep
of a few seconds, but just how long to wait is not obvious, nor is it
a guarantee that the remount will always finish in the time chosen.
I'm heading down the path of reading /proc/mounts and remounting all
read-wirte filesystems backed by a block device as read-only.

___
Ken


On Thu, Mar 3, 2011 at 3:36 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 3, 2011 at 10:28 AM, Mark Lord <kernel@teksavvy.com> wrote:
>> On 11-03-03 12:45 PM, Linus Torvalds wrote:
>>>
>>> If you can change whatever user-land process that does the reboot
>>> system call (and clearly you can, since you're adding new commands and
>>> using those), then why the heck don't you just do the remount-ro from
>>> that same user land?
>>
>> Is there a system call for emergency_remount_*() ?
>> I've been writing to /proc/proc/sysrq-trigger to accomplish this.
>
> So I don't know what this has to do with "emergency_remount()" - we're
> talking about a regular controlled shutdown/reset. The fact that the
> patch used the emergency_remount() code seems to be purely an
> implementation issue, nothing more.
>
> And while sysrq-trigger certainly works (when it's enabled, but that's
> true of /proc too, of course), I do think it's a rather odd way of
> solving the problem, when the simple "just remount read-only" is what
> the code actually _wants_ to do.
>
> But you're certainly right that it takes less code to open
> /proc/sysrq-trigger and writing a single byte to it than it does to do
> the straightforward "let's just do the normal mount thing".
>
>                             Linus
>
