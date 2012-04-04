Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab2DDTXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 15:23:37 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49599 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab2DDTXf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 15:23:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120404184909.GB29686@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120404145134.GC12676@redhat.com>
	<20120404184909.GB29686@dhcp-172-17-108-109.mtv.corp.google.com>
Date: Wed, 4 Apr 2012 14:23:34 -0500
Message-ID: <CAH2r5mvP56D0y4mk5wKrJcj+=OZ0e0Q5No_L+9a8a=GMcEhRew@mail.gmail.com>
Subject: Re: [Lsf] [RFC] writeback and cgroup
From: Steve French <smfrench@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, ctalbott@google.com, rni@google.com,
        andrea@betterlinux.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org,
        linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 1:49 PM, Tejun Heo <tj@kernel.org> wrote:
> Hey, Vivek.
>
> On Wed, Apr 04, 2012 at 10:51:34AM -0400, Vivek Goyal wrote:
>> On Tue, Apr 03, 2012 at 11:36:55AM -0700, Tejun Heo wrote:
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
>
> On principle, I don't think it has be any different.  Filesystems's
> interface to the underlying device is through bdi.  If a fs is block
> backed, block pressure should be propagated through bdi, which should
> be mostly trivial.  If a fs is network backed, we can implement a
> mechanism for network backed bdis, so that they can relay the pressure
> from the server side to the local fs users.
>
> That said, network filesystems often show different behaviors and use
> different mechanisms for various reasons and it wouldn't be too
> surprising if something different would fit them better here or we
> might need something supplemental to the usual mechanism.

For the network file system clients, we may be close already,
but I don't know how to allow servers like Samba or Apache
to query btrfs, xfs etc. for this information.

superblock -> struct backing_dev_info is probably fine as long
as we aren't making that structure more block device specific.
Current use of bdi is a little hard to understand since
there are 25+ fields in the structure.  Is their use/purpose written
up anywhere?  I have a feeling we are under-utilizing what
is already there.  In any case bdi is "backing" info not "block"
specific info.  Since bdi can be assigned to a superblock
and an inode, it seems reasonable for either network or local.

Note that it isn't just traditional network file systems (nfs and cifs and smb2)
but also virtualization (virtfs) and some special purpose file systems
for which block device specific interfaces to higher layers (above the fs)
are an awkward way to think about congestion.   What
about a case of a file system like btrfs that could back a
volume to a pool of devices and distribute hot/cold data
across multiple physical or logical devices?

By the way, there may be less of a problem with current
network file system clients due to small limits on simultaneous i/o.
Until recently NFS client had a low default slot count of 16 IIRC and
it was not much better for cifs.   The typical cifs server defaulted
to allowing a client to only send 50 simultaneous requests to that
server at one time ...
The cifs protocol allows more (up to 64K) and in 3.4 the client now
can send more requests (up to 32K) if the server is so configured.

With SMB2 since "credits" are returned on every response, fast
servers (e.g. Samba running on a good clustered file system,
or a good NAS box) may end up allowing thousands of simultaneous
requests if they have the resources to handle this.   Unfortunately,
the Samba server developers do not know how to request information
on superblock->bdi congestion information from user space.
I vaguely remember bdi debugging info available in sysfs, but how
would an application find out how congested the underlying volume
it is exporting is.

-- 
Thanks,

Steve
