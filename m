Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab2IXSRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 14:17:55 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37212 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab2IXSRv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 14:17:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?Q?Pawe=C5=82?= Sikora <pluto@pld-linux.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        arekm@pld-linux.org, baggins@pld-linux.org,
        Herbert Poetzl <herbert@13thfloor.at>
References: <5092540.GORQ1kUuNX@localhost>
	<CA+55aFymD=QGptAxjSEWffDSA94dtAjPjy-ox76fYWgHn9m+kA@mail.gmail.com>
	<2819949.zde5vZ04eb@localhost>
	<20120924112300.GE20655@MAIL.13thfloor.at>
Date: Mon, 24 Sep 2012 11:17:42 -0700
In-Reply-To: <20120924112300.GE20655@MAIL.13thfloor.at> (Herbert Poetzl's
	message of "Mon, 24 Sep 2012 13:23:00 +0200")
Message-ID: <87sja7uvy1.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19lPsNPiJ+uAnQkfvBj66Jv5n/I75YR85E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0176]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_05 8+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Pawe=c5=82 Sikora <pluto@pld-linux.org>?=
X-Spam-Relay-Country: 
Subject: Re: [2.6.38-3.x] [BUG] soft lockup - CPU#X stuck for 23s! (vfs, autofs, vserver)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Poetzl <herbert@13thfloor.at> writes:

> On Mon, Sep 24, 2012 at 07:23:55AM +0200, Paweł Sikora wrote:
>> On Sunday 23 of September 2012 18:10:30 Linus Torvalds wrote:
>>> On Sat, Sep 22, 2012 at 11:09 PM, Paweł Sikora <pluto@pld-linux.org> wrote:
>
>>>>         br_read_lock(vfsmount_lock);
>
>>> The vfsmount_lock is a "local-global" lock, where a read-lock
>>> is rather cheap and takes just a per-cpu lock, but the
>>> downside is that a write-lock is *very* expensive, and can
>>> cause serious trouble.
>
>>> And the write lock is taken by the [un]mount() paths. Do *not*
>>> do crazy things. If you do some insane "unmount and remount
>>> autofs" on a 1s granularity, you're doing insane things.
>
>>> Why do you have that 1s timeout? Insane.
>
>> 1s unmount timeout is *only* for fast bug reproduction (in few
>> seconds after opteron startup) and testing potential patches.
>> normally with 60s timeout it happens in few minutes..hours
>> (depends on machine i/o+cpu load) and makes server unusable
>> (permament soft-lockup).
>
>> can we redesign vserver's mnt_is_reachable() for better locking
>> to avoid total soft-lockup?
>
> currently we do:
>
>         br_read_lock(&vfsmount_lock);
>         root = current->fs->root;
>         root_mnt = real_mount(root.mnt);
>         point = root.dentry;
>
>         while ((mnt != mnt->mnt_parent) && (mnt != root_mnt)) {
>                 point = mnt->mnt_mountpoint;
>                 mnt = mnt->mnt_parent;
>         }
>
>         ret = (mnt == root_mnt) && is_subdir(point, root.dentry);
>         br_read_unlock(&vfsmount_lock);
>
> and we have been considering to move the br_read_unlock()
> right before the is_subdir() call
>
> if there are any suggestions how to achieve the same
> with less locking I'm all ears ...

Herbert, why do you need to filter the mounts that show up in a mount
namespace at all?  I would think a far more performant and simpler
solution would be to just use mount namespaces without unwanted mounts.

I'd like to blame this on the silly rcu_barrier in
deactivate_locked_super that should really be in the module remove path,
but that happens after we drop the br_write_lock.

The kernel take br_read_lock(&vfs_mount_lokck) during every rcu path
lookup so mnt_is_reachable isn't particular crazy just for taking the
lock.

I am with Linus on this one.  Paweł even 60s for your mount timeout
looks too short for your workload.  All of the readers that take
br_read_lock(&vfsmount_lock) seem to be showing up in your oops.  The
only thing that seems to make sense is you have a lot of unmount
activity running back to back, keeping the lock write held.

The only other possible culprit I can see is that it looks like
mnt_is_reachable changes reading /proc/mounts to be something
worse than linear in the number of mounts and reading /proc/mounts
starts taking the vfsmount_lock.  All minor things but when you
are pushing things hard they look like things that would add up.

Eric
