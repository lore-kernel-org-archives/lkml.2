Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab0CaFwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 01:52:11 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45756 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab0CaFwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 01:52:08 -0400
MIME-Version: 1.0
In-Reply-To: <m14ojxh0mz.fsf@fess.ebiederm.org>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org> <ac3eb2511003301153i43a60720hb015071e2c992199@mail.gmail.com> 
	<m14ojxh0mz.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 31 Mar 2010 07:51:49 +0200
Message-ID: <s2hac3eb2511003302251rcbae8767ne21e9daf1546c849@mail.gmail.com>
Subject: Re: [PATCH 0/6] tagged sysfs support
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       Serge Hallyn <serue@us.ibm.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 01:04, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Kay Sievers <kay.sievers@vrfy.org> writes:
>> On Tue, Mar 30, 2010 at 20:30, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>
>>> The main short coming of using multiple network namespaces today
>>> is that only network devices for the primary network namespaces
>>> can be put in the kobject layer and sysfs.
>>>
>>> This is essentially the earlier version of this patchset that was
>>> reviewed before, just now on top of a version of sysfs that doesn't
>>> need cleanup patches to support it.
>>
>> Just to check if we are not in conflict with planned changes, and how
>> to possibly handle them:
>>
>> There is the plan and ongoing work to unify classes and buses, export
>> them at /sys/subsystem in the same layout of the current /sys/bus/.
>> The decision to export buses and classes as two different things
>> (which they aren't) is the last major piece in the sysfs layout which
>> needs to be fixed.
>
> Interesting.  We will symlinks ie:
> /sys/class -> /sys/subsystem
> /sys/bus -> /sys/subsystem
> to keep from breaking userspace.

Yeah, /sys/bus/, which is the only sane layout of the needlessly
different 3 versions of the same thing (bus, class, block).

/sys/bus/<subsys> can just be a plain symlinks to the
/sys/subsystem/<subsys> directories.

/sys/class/<subsys> *could* be a symlink to the
/sys/subsystem/<subsys>/devices/ directory, but we really don't want
to continue to stupidly mix subsystem-wide control files with device
lists anymore. The "devices" directory needs to be a strict list of
devices, not some collection of random stuff, that it is today. :)

So we either leave all the conceptually broken class attributes behind
us, and put them at the  /sys/subsystem/<subsys>/ level only, or we
need to create the /sys/class/<subsys>/* stuff all as symlinks like we
do today. I expect, we have to create /sys/class as we do today.

Another problem to solve is that sysfs does not allow us to symlink
regular files, only directories, so we can currently not create the
class-wide attributes as symlinks to the proper file in
/sys/subsystem/.

>> It would mean that /sys/subsystem/net/devices/* would look like
>> /sys/class/net/* today. But at the /sys/subsystem/net/ directory could
>> be global network-subsystem-wide control files which would need to be
>> namespaced too. (The network subsystem does not use subsytem-global
>> files today, but a bunch of other classes do.)
>>
>> This could be modeled into the current way of doing sysfs namespaces?
>> A /sys/bus/<subsystem>/ directory hierarchy would need to be
>> namespaced, not just a single plain directory with symlinks. Would
>> that work?
>
> I'm not entirely clear on what you are doing but it all sounds like it
> will fit within what I am doing.

The goal is to unify the 3 needlessly different versions of "device
lists of the same subsystem". We have /sys/class, /sys/bus,
/sys/block, and all of them will be unified at /sys/subsystem/ leaving
the old names as compat links only. Unlike block and class, the
/sys/subsystem/<subsys> directory can be extended with custom
subdirectories and files, without mixing random files into device
lists.

With /sys/subsystem/, userspace can uniquely identify and find all
devices at /sys/<subsys>/devices/<device-name>/ with only the
subsystem and the device name.

All devices in /sys/devices already have a symlink called "subsystem"
which will point back to the corresponding /sys/subsystem/<subsys>
directory, and the event environment already contains a variable
SUBSYSTEM with the name.

That would be the first time sysfs device interfaces have some idea of
consistency. :)

> Right now I have /sys/class/net,
> /sys/devices/virtual/net and a bunch of other net directories becoming
> tagged and only showing up in the appropriately mounted sysfs.  We
> track them all in the class kset and as long as we extend that capability
> when the subsystem change happens in sysfs all should be well.

Ok, sounds good.

> Today we have /sys/class/net/bonding_master.  For now I have that as
> an untagged but the implementation is aware of which network namespace
> your current process is in.  Thinking about that a little more it
> would be better to make that file tagged so that userspace can see
> different versions for the different network namespaces.  Joy.

Yeah, that might make more sense in the end.

> I expect other control files will be the same.

Sounds like, yes.

> In general it doesn't make sense to add control files for networking.
> as they easily conflict with legal network device names and thus create
> the possibility of breaking someones userspace.

Yeah, it did not makes sense it the first place to mix devices lists
with global attributes. It's a real mess what people do in sysfs.

Thanks,
Kay
