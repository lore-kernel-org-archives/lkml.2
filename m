Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351Ab2C2XTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:19:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760223Ab2C2XTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:19:13 -0400
Message-ID: <4F74EDEC.5020804@redhat.com>
Date: Thu, 29 Mar 2012 20:19:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Greg K H <gregkh@linuxfoundation.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/14] edac: rewrite the sysfs code to use struct device
References: <1333040821-6253-1-git-send-email-mchehab@redhat.com> <1333040821-6253-2-git-send-email-mchehab@redhat.com> <20120329220300.GA16491@kroah.com>
In-Reply-To: <20120329220300.GA16491@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 29-03-2012 19:03, Greg K H escreveu:
> On Thu, Mar 29, 2012 at 02:06:48PM -0300, Mauro Carvalho Chehab wrote:
>> +static void mci_attr_release(struct device *device)
>>  {
>> -	int err;
>> -
>> -	debugf4("%s()\n", __func__);
>> -
>> -	while (sysfs_attrib) {
>> -		debugf4("%s() sysfs_attrib = %p\n",__func__, sysfs_attrib);
>> -		if (sysfs_attrib->grp) {
>> -			struct mcidev_sysfs_group_kobj *grp_kobj;
>> -
>> -			grp_kobj = kzalloc(sizeof(*grp_kobj), GFP_KERNEL);
>> -			if (!grp_kobj)
>> -				return -ENOMEM;
>> -
>> -			grp_kobj->grp = sysfs_attrib->grp;
>> -			grp_kobj->mci = mci;
>> -			list_add_tail(&grp_kobj->list, &mci->grp_kobj_list);
>> -
>> -			debugf0("%s() grp %s, mci %p\n", __func__,
>> -				sysfs_attrib->grp->name, mci);
>> -
>> -			err = kobject_init_and_add(&grp_kobj->kobj,
>> -						&ktype_inst_grp,
>> -						&mci->edac_mci_kobj,
>> -						sysfs_attrib->grp->name);
>> -			if (err < 0) {
>> -				printk(KERN_ERR "kobject_init_and_add failed: %d\n", err);
>> -				return err;
>> -			}
>> -			err = edac_create_mci_instance_attributes(mci,
>> -					grp_kobj->grp->mcidev_attr,
>> -					&grp_kobj->kobj);
>> -
>> -			if (err < 0)
>> -				return err;
>> -		} else if (sysfs_attrib->attr.name) {
>> -			debugf4("%s() file %s\n", __func__,
>> -				sysfs_attrib->attr.name);
>> -
>> -			err = sysfs_create_file(kobj, &sysfs_attrib->attr);
>> -			if (err < 0) {
>> -				printk(KERN_ERR "sysfs_create_file failed: %d\n", err);
>> -				return err;
>> -			}
>> -		} else
>> -			break;
>> -
>> -		sysfs_attrib++;
>> -	}
>> -
>> -	return 0;
>> +	debugf1("Releasing mci device %s\n", dev_name(device));
>>  }
> 
> Sweet, as per the documentation in the Documentation/kobjects.txt file,
> I get to publically mock you for thinking you are smarter than the
> kernel and this is an acceptable way to "outwhit" the driver core from
> spitting errors at you when the kobject is released.

There's nothing there to free: all EDAC structures are allocated once
(see edac_mc_alloc() and edac_align_ptr() logic, at drivers/edac/edac_mc.c).

Even the struct device for all csrows/channels/mcu is done on a single alloc
there. Trying to free it earlier would cause a segfault.

I didn't wrote that logic, nor I was tempted to change it: as this subsystem 
is focused on memory error detection, having every data structure used there
on a single page helps to minimize the probability of having an error at the 
memory used to store the EDAC data.
> 
> Please fix this up, it's unacceptable.
> 
>> +static void mc_attr_release(struct device *device)
>> +{
>> +	debugf1("Releasing device %s\n", dev_name(device));
>> +}
> 
> Hey, you did it again, not nice :(
> 
> You also just leaked memory as well :(

There's no memory leak. The allocated memory is freed at edac_mc_del_mc()
(also at drivers/edac/edac_mc.c).

> 
> Please fix.
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

