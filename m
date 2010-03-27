Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0C0AVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 20:21:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab0C0AVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 20:21:10 -0400
Date: Fri, 26 Mar 2010 20:20:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, jens.axboe@oracle.com,
       mrubin@google.com, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, dpshah@google.com,
       Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 0/4] io-controller: Use names rather than major:minor
Message-ID: <20100327002056.GA9280@redhat.com>
References: <20100325180310.25299.64877.stgit@meat.mtv.corp.google.com> <4BAC0E7D.9080305@cn.fujitsu.com> <20100326152012.GB18128@redhat.com> <1786ab031003261554y40c21bc8sb4ea2f347c2c8bf8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1786ab031003261554y40c21bc8sb4ea2f347c2c8bf8@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 03:54:40PM -0700, Chad Talbott wrote:
> On Fri, Mar 26, 2010 at 8:20 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Mar 26, 2010 at 09:31:41AM +0800, Gui Jianfeng wrote:
> >> +int blk_lookup_devname(dev_t devt, char *name)
> >> +{
> 
> [ snip... loop through all block devices for devt ...snip ]
> 
> >> So we can keep dev_t in blkio layer, and export to user a device name by calling
> >> this function. Also, we retrive device number by calling blk_lookup_devt().
> >> This change might keep things much simple. Jens, do you have any thoughts?
> >>
> > I agree with Gui that lets keep the dev_t the core in blkio layer. Keeping
> > a pointer to gendisk in request queue is becoming little messy.
> 
> Agreed on leaving gendisk pointer out of request_queue.  In doing
> further investigation, I've found that it's up to the driver to
> maintain the association between gendisk and request_queue, and some
> drivers put multiple gendisk behind a single request_queue, so the
> back pointer would be ill-specified.
> 
> > But if that does not work for you, then I would also like to keep things
> > simple and translate dev_t to diskname during read routine. Similiarly,
> > while somebody is putting policy, use blk_lookup_devt().
> 
> I like the simplicity of blk_lookup_devt(), but I don't like the idea
> of iterating through all block devices on every lookup of the name.
> Perhaps we could cache the name somewhere?

Setting up the policies is not a fast path. So iterating through
devices probably is not a bad idea. Caching infact will make it more
complicated.

It is no different than than /proc/diskstat which is also iterating
through all the devices.

In fact blk_lookup_devt() is also doing the same thing, iterating
through all the block_class devices.

> 
> Actually, the name is the name of the *queue* (or the key in
> blk-cgroup), because as I mentioned above there can be a many to one
> relationship between disks and queues in general.
> 

What is the significance of one queue serving to multiple gendisk
structures. How this relationship is handled in /sys/block?

> The more I think about it, the more it seems to make sense to extend
> blkio_policy_ops to include a function to get the name of the key.
> blk-cgroup makes no current use of the dev, except to invent a name
> for the request_queue whose policy is being set or printed.  It could
> be argued that the thing being scheduled has a better idea of the name
> of that thing.

request_queue is something internal to block layer. To a user, block
deivce will make sense (device file, major:minor, and sysfs disk name).
So keeping a name for request queue also and implmeneting a function
in blkio_policy_ops to retrieve that name, does not make much sense
to me.
  
> 
> > But this will lead to issue of how do you now display both device number
> > and disk name in the output. May be following.
> >
> > major:minor  diskname  data
> >
> > I am not sure if people are fond of multiple values in a single file. At
> > the same time for setting the rules or deleting the rules, it will make
> > syntax complicated/confusing. Also will require breaking ABI for existing
> > blkio.time, blkio.sectors, blkio.dequeue files.
> 
> I don't like this, either.  It breaks ABI and is more confusing for users.
> 
> > So I would prefer to keep the major/minor number based interface for
> > follwing reasons.
> >
> > - Chaning it now breaks ABI.
> > - Other cgroup controller "device" is also using major/minor number based
> >  interface for device access policy. So it is consistent with other
> >  controller.
> 
> Which controllers are these?
> 

linux-2.6/Documentation/cgroups/devices.txt

> > - Displaying both device major/minor and diskname is an option but that
> >  makes the file format syntax little complicated and new rule setting
> >  or removoal confusing.
> 
> A few messages back you mentioned that you preferred device names
> because they would be better for users of the system.  If there was a
> simple implementation, would you still be behind a new name-based
> interface?  We could go that direction and maintain ABI by deprecating
> current interface and making a new interface with names.
> 
> If you can't tell, I'm a big fan of using the name! :)  It's *much*
> more consistent with the interfaces in /sys.

/sys provides facility to access device both through device number
(/sys/dev/block/<major:minor>) and disk name (/sys/block/<diskname>). So
I don't know why do you think it is more consistent with /sys if we
use diskname.

In general user space seems to be accessing devices using device files.
For example, blockdev utility. These device file inodes in turn store
major/minor number of device and then get to respective gendisk object.

I think one advantage of major:minor number scheme is that it is simple
and there is no confusion. For example, looks like device mapper layer
can create multiple device files for same disk. On my system, multipath target
has created /dev/mapper/mpathe and also /dev/dm-3 which is referring to
same device. /sys/block has dm-3 created under it.

brw-rw---- 1 root disk 253, 3 2010-03-25 22:57 /dev/mapper/mpathe
brw-rw---- 1 root disk 253, 3 2010-03-25 22:57 /dev/dm-3

Now lets somebody is accessing the device using /dev/mapper/mpathe, he
can easily extract the major:minor of this device and see if there is
any rule for that device. If we keep rules in disk name, then application
shall have to go through the all the /sys/block/diskname entries and
first figure out diskname and then grep for that disk name in rules.

So in case of multiple device files for same disk, I think retrieving
major/minor and then doing lookup in rules file is easier. Keeping rules
in terms of disk names is more intutive in the case of single device
file and diskname being same as device file (/dev/sda). 

So because major:minor number scheme is simple, does not break ABI, is
consistent with "devices" cgroup controller, works well in case of
multiple device files for same disk, I kind of like it and wouldn't
mind continuing with it.
  
Thanks
Vivek
