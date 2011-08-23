Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab1HWTRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:17:24 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:35429 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab1HWTRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:17:20 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E53FEA9.3010408@cam.ac.uk>
Date: Tue, 23 Aug 2011 20:25:29 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Greg KH <greg@kroah.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Sysfs group create for empty groups.
References: <1313576222-27743-1-git-send-email-jic23@cam.ac.uk> <4E4BEBFD.3040004@cam.ac.uk> <20110823003352.GA5982@kroah.com> <4E538896.3050006@cam.ac.uk>
In-Reply-To: <4E538896.3050006@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/11 12:01, Jonathan Cameron wrote:
> On 08/23/11 01:33, Greg KH wrote:
>> On Wed, Aug 17, 2011 at 05:27:41PM +0100, Jonathan Cameron wrote:
>>> On 08/17/11 11:17, Jonathan Cameron wrote:
>>>> The following is a quick stab at avoiding a hideous work around
>>>> we are currently using in IIO.  In some cases we have entire
>>>> attribute groups that are created from descriptions an array
>>>> of struct iio_chan_spec.  To keep the reference counts sane
>>>> and cause subdirectories to be created we are currently using
>>>> dummy groups and dummy attribute arrays (provided once in the
>>>> core).  This series is an initial probably stupid approach
>>>> to avoiding this.
>>>>
>>>> Greg has expressed some doubts about whether subdirectories are
>>>> ever a good idea, but the problem occurs for the top level
>>>> directory as well (handled by patch 1).
>>>>
>>>> Note, all attributes are created at probe time.  Ultimately we
>>>> are just respinning the create_group code to allow us to create
>>>> the attributes from a device description rather than statically
>>>> allocating them in each driver (results in a massive reduction
>>>> in repeated code).
>>>>
>>>> All opinions welcomed.
>>>>
>>>> (this is definitely an rfc, the code isn't even tested yet)
>>> Now tested and looks fine, so I've pushed it to our iio dev tree
>>> (which is re based a few times a day currently so I can always
>>> drop it again ;)
>>
>> Can you show me how you would use this so I could try to understand it a
>> bit better?
> Sorry, should have pointed you at an example.
> 
> See our iio-dev tree for the full code (some of it is in your staging tree
> as well).
> http://git.kernel.org/?p=linux/kernel/git/jic23/iio-blue.git;a=summary
> 
> Summary:
> 
> Sysfs attributes are created from struct iio_chan_spec arrays. These structures
> describe the facilities and characteristics of a physical device channel in
> a compact fashion. Sometimes there are no other attributes thus we currently
> end up with dummy attribute_groups in the core that are registered.  The
> purpose of this is to keep the reference counts consistent.
> 
> Details:
> 
> The core of the matter is that we have channel descriptions for every
> channel on a device.  This encodes most of the information about the
> channel in a consistent compact way (there are a few more unusual cases
> we are still working out how to handle).  The sysfs control and data reading
> attributes are generated from these struct iio_chan_spec structure arrays
> rather than existing as a static set of attributes as they previously did.
> 
> This change (suggested by Arnd) has two big advantages:
> 1) Massive reduction in boilerplate code.
> 2) Enforced consistency of interface across drivers.
> 
> The base directory contains simple read attributes for the files and
> stuff like calibration offsets.  In many cases there are other elements
> in there not handled by iio_chan_spec. When that happens we register the
> group of other attributes first and then use sysfs_add_file_to_group to
> add the other attributes as they are created from the description.
> A klist keeps track of the attributes added so they can be cleanly
> removed later.
> 
> Key function is __iio_add_chan_devattr in industrialio-core.c
> int __iio_add_chan_devattr(const char *postfix,
> 			   const char *group,
> 			   struct iio_chan_spec const *chan,
> 			   ssize_t (*readfunc)(struct device *dev,
> 					       struct device_attribute *attr,
> 					       char *buf),
> 			   ssize_t (*writefunc)(struct device *dev,
> 						struct device_attribute *attr,
> 						const char *buf,
> 						size_t len),
> 			   u64 mask,
> 			   bool generic,
> 			   struct device *dev,
> 			   struct list_head *attr_list)
> {
> 	int ret;
> 	struct iio_dev_attr *iio_attr, *t;
> 
> 	iio_attr = kzalloc(sizeof *iio_attr, GFP_KERNEL);
> 	if (iio_attr == NULL) {
> 		ret = -ENOMEM;
> 		goto error_ret;
> 	}
> 	ret = __iio_device_attr_init(&iio_attr->dev_attr,
> 				     postfix, chan,
> 				     readfunc, writefunc, generic);
> 	if (ret)
> 		goto error_iio_dev_attr_free;
> 	iio_attr->c = chan;
> 	iio_attr->address = mask;
> 	list_for_each_entry(t, attr_list, l)
> 		if (strcmp(t->dev_attr.attr.name,
> 			   iio_attr->dev_attr.attr.name) == 0) {
> 			if (!generic)
> 				dev_err(dev, "tried to double register : %s\n",
> 					t->dev_attr.attr.name);
> 			ret = -EBUSY;
> 			goto error_device_attr_deinit;
> 		}
> 
> 	ret = sysfs_add_file_to_group(&dev->kobj,
> 				      &iio_attr->dev_attr.attr, group);
> 	if (ret < 0)
> 		goto error_device_attr_deinit;
> 
> 	list_add(&iio_attr->l, attr_list);
> 
> 	return 0;
> 
> error_device_attr_deinit:
> 	__iio_device_attr_deinit(&iio_attr->dev_attr);
> error_iio_dev_attr_free:
> 	kfree(iio_attr);
> error_ret:
> 	return ret;
> }
> 
> 
> Call to __iio_device_attr_init builds the attribute name up and then
> it performs checks for double registration (valid to try for 'generic'
> attributes - but not others. When it is marked generic it means
> it applies to a number of channels in_accel_scale for example applies to
> all registered in_accel channels and it simply will not be added if
> already there).
> 
> The file is added with sysfs_add_file_to_group.
> 
> So ultimately we have a dynamic equivalent of what goes on in
> sysfs_create_group with a const group.  We could in theory
> do two passes - first to work out what space is needed and second
> to create a suitable attribute_group, but it's a lot uglier than
> doing it in a single pass through the chan_spec structure array (made
> so by the need to handle those 'generic' attributes.)  An alternative
> is to do all but the sysfs_add_file_to_group and then build an
> attribute group from our existing klist of attributes.
> 
> Basically I'm happy to do anything that makes this work. If we
> agree there is a reason to have sysfs_add_file_to_group available
> then to my mind we should also allow for empty groups. Right now
> it looks like there are only a few users of that (I count about 6 with
> 2 of them in IIO).
> 
> The group add of an empty group is simply to get the reference count
> consistent. 
> 
> The slightly more involved case is for the scanelements subdirectory.
> This describes the contents of the any buffers that the driver supports
> and is often (but not quite always) generated entirely from the iio_chan_spec
> structure arrays provided by the drivers.  It's in a subdirectory as purely
> a means of grouping elements related to a particular task (buffer description)
> rather than any inherent requirement. This case motivates the allowing a group
> with a null pointer in .attrs to avoid having a
> struct attribute *dummy_attrs[] = {NULL};
> which is ugly.
> 
> So what do you recommend?
Having just come across Bart's documentation patches to the driver-model
docs I now understand the userspace issue (misunderstood what you said
the other day).  Basically if it isn't done through the groups element
of struct device userspace won't know the attributes have been created.

Will see if I can rework the registration code to build up a suitable cache
of what will be in the attribute groups for each device. This dynamic
cache can then be used to build up everything needed before the
device_register occurs.  It's going to be somewhat clunky but contained
within the IIO core so not too bad.

So upshot is ignore this patch set.  The hack with the dummy groups
will have to stand for 3.1 in IIO.

Thanks,

Jonathan

