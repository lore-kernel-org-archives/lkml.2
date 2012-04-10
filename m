Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2DJQXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:23:20 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61127 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2DJQXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:23:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120407080027.GA2584@quack.suse.cz>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120404145134.GC12676@redhat.com>
	<20120407080027.GA2584@quack.suse.cz>
Date: Tue, 10 Apr 2012 11:23:16 -0500
Message-ID: <CAH2r5mvLVnM3Se5vBBsYzwaz5Ckp3i6SVnGp2T0XaGe9_u8YYA@mail.gmail.com>
Subject: Re: [Lsf] [RFC] writeback and cgroup
From: Steve French <smfrench@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>, ctalbott@google.com, rni@google.com,
        andrea@betterlinux.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org,
        linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com,
        cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 7, 2012 at 3:00 AM, Jan Kara <jack@suse.cz> wrote:
>  Hi Vivek,
>
> On Wed 04-04-12 10:51:34, Vivek Goyal wrote:
>> On Tue, Apr 03, 2012 at 11:36:55AM -0700, Tejun Heo wrote:
>> [..]
>> > IIUC, without cgroup, the current writeback code works more or less
>> > like this.  Throwing in cgroup doesn't really change the fundamental
>> > design.  Instead of a single pipe going down, we just have multiple
>> > pipes to the same device, each of which should be treated separately.
>> > Of course, a spinning disk can't be divided that easily and their
>> > performance characteristics will be inter-dependent, but the place to
>> > solve that problem is where the problem is, the block layer.
>>
>> How do you take care of thorottling IO to NFS case in this model? Current
>> throttling logic is tied to block device and in case of NFS, there is no
>> block device.
>  Yeah, for throttling NFS or other network filesystems we'd have to come
> up with some throttling mechanism at some other level. The problem with
> throttling at higher levels is that you have to somehow extract information
> from lower levels about amount of work so I'm not completely certain now,
> where would be the right place. Possibly it also depends on the intended
> usecase - so far I don't know about any real user for this functionality...

Remember to distinguish between the two ends of the network file system.
There are slightly different problems.   The client has to be able to
expose the number of requests (and size of writes, or equivalently
number of pages it can write at one time) so that writeback is not done
too aggressively.  File servers have to be able to
discover the i/o limits dynamically of the underlying volume (not the
block device, but potentially a pool of devices) so it can tell
the client how much i/o it can send.  For SMB2 server (Samba) and
eventually for NFS, how many simultaneous requests it
can support will allow them to sanely set the number of "credits"
on each response - ie tell the client how many requests
are allowed in flight to a particular export.

In the case of block device throttling - other than the file system
internally using such APIs who would use block device specific
throttling - only the file system knows where it wants to put hot data,
and in the case of btrfs, doesn't the file system manage the
storage pool.   The block device should be transparent to the
user in the long run, and only the volume visible.


-- 
Thanks,

Steve
