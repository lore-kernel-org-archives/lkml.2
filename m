Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2IXLsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 07:48:47 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:35502 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab2IXLsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 07:48:45 -0400
X-Greylist: delayed 1541 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Sep 2012 07:48:45 EDT
Date: Mon, 24 Sep 2012 13:23:00 +0200
From: Herbert Poetzl <herbert@13thfloor.at>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        arekm@pld-linux.org, baggins@pld-linux.org
Subject: Re: [2.6.38-3.x] [BUG] soft lockup - CPU#X stuck for 23s! (vfs, autofs, vserver)
Message-ID: <20120924112300.GE20655@MAIL.13thfloor.at>
Mail-Followup-To: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	arekm@pld-linux.org, baggins@pld-linux.org
References: <5092540.GORQ1kUuNX@localhost> <CA+55aFymD=QGptAxjSEWffDSA94dtAjPjy-ox76fYWgHn9m+kA@mail.gmail.com> <2819949.zde5vZ04eb@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2819949.zde5vZ04eb@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 07:23:55AM +0200, Paweł Sikora wrote:
> On Sunday 23 of September 2012 18:10:30 Linus Torvalds wrote:
>> On Sat, Sep 22, 2012 at 11:09 PM, Paweł Sikora <pluto@pld-linux.org> wrote:

>>>         br_read_lock(vfsmount_lock);

>> The vfsmount_lock is a "local-global" lock, where a read-lock
>> is rather cheap and takes just a per-cpu lock, but the
>> downside is that a write-lock is *very* expensive, and can
>> cause serious trouble.

>> And the write lock is taken by the [un]mount() paths. Do *not*
>> do crazy things. If you do some insane "unmount and remount
>> autofs" on a 1s granularity, you're doing insane things.

>> Why do you have that 1s timeout? Insane.

> 1s unmount timeout is *only* for fast bug reproduction (in few
> seconds after opteron startup) and testing potential patches.
> normally with 60s timeout it happens in few minutes..hours
> (depends on machine i/o+cpu load) and makes server unusable
> (permament soft-lockup).

> can we redesign vserver's mnt_is_reachable() for better locking
> to avoid total soft-lockup?

currently we do:

        br_read_lock(&vfsmount_lock);
        root = current->fs->root;
        root_mnt = real_mount(root.mnt);
        point = root.dentry;

        while ((mnt != mnt->mnt_parent) && (mnt != root_mnt)) {
                point = mnt->mnt_mountpoint;
                mnt = mnt->mnt_parent;
        }

        ret = (mnt == root_mnt) && is_subdir(point, root.dentry);
        br_read_unlock(&vfsmount_lock);

and we have been considering to move the br_read_unlock()
right before the is_subdir() call

if there are any suggestions how to achieve the same
with less locking I'm all ears ...

best,
Herbert

> BR,
> Paweł.

> ps).
> i'm adding Herbert to CC.
