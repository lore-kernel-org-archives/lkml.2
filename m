Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0KVB7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 20:59:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:48486 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab0KVB7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 20:59:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,232,1288594800"; 
   d="scan'208";a="628978468"
Subject: Re: [RFC] persistent store
From: Huang Ying <ying.huang@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
References: <4ce85e437577ae827@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 09:59:35 +0800
Message-ID: <1290391175.2903.132.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tony,

On Sun, 2010-11-21 at 07:48 +0800, Luck, Tony wrote:
> Here's a patch based on some discussions I had with Thomas
> Gleixner at plumbers conference that implements a generic
> layer for persistent storage usable to pass tens or hundreds
> of kilobytes of data from the dying breath of a crashing
> kernel to its successor.
> 
> The usage model I'm envisioning is that a platform driver
> will register with this code to provide the actual storage.
> I've tried to make this interface general, but I'm working
> from a sample of one (the ACPI ERST code), so if anyone else
> has some persistent store that can't be handled by this code,
> speak up and we can put in the necessary tweaks.
> 
> My assumptions are that the data that Linux cares about will
> be wrapped in some error record structure with a header, and
> possibly a footer that the device code needs. So the driver
> specifies how much padding to put around a buffer to make
> life easy for it.  It also specifies the maximum number of
> bytes that can be saved in one record.

This patch provides a general "read" interface for kmsg_dumper and some
other persistent storage users. Another possible choice is to just
extend the original interface to add persistent store support. For
example, we can add a "read" function in kmsg_dumper, and output the
content of persistent store via extend /dev/kmsg via prefix every line
comes from persistent store or adding some "ioctl" to do that. (But it
seems that nobody likes "ioctl").

> There are three callback functions from the generic code to
> the driver:
> 
> "reader" which iterates over all records currently in the
> store - returning type, size and a record identifier as
> well as the actual data.
> 
> "writer" which writes a record with a type to the persistent store

I think it is necessary to require this to be NMI safe (in comments?),
because hardware error handler may need to write to persistent storage
in NMI context. Or we can add a "flag" field to let storage provider
advocate its capability of NMI safe.

> "eraser" which takes a record identifier, and clears that item
> from the store.
> 
> 
> The Linux user visible interface is via /sys (similar to
> the "efivars" interface)
> 
> # ls -l /sys/firmware/pstore
> total 0
> -r--r--r-- 1 root root 0 2010-11-20 11:03 dmesg-0
> --w------- 1 root root 0 2010-11-20 11:03 erase
> 
> The "type" of error record I mentioned earlier is used to
> name the files ... saved console logs from kmsg_dmp() are
> named with a "dmesg" prefix as shown above.
> 
> Once an error record has been viewed, analysed, saved. The
> user can request it to be cleared by writing its name to the
> "erase" file:
> 
> # echo "dmesg-0" > erase
> 
> Answers to a few questions that I think you might ask:
> 
> 1) "Why do you only allow one platform driver to register?"
>   I only have one such driver.  Adding more is easy from the "read" side
>   (just collect all the records from all devices and remember where they
>   came from so you can call the correct "eraser" function).  But the "write"
>   side opens up questions that I don't have good answers for:
>   - Which device(s) should error records be written to?
>     All of them? Start with one and move on when it is
>     full?  Write some types of records to one device?

The persistent storage may be full, and the writing may fail. So I think
we can just try to write one by one, until the first success writing.

[...]
> + * Erase records by writing their filename to the "erase" file. E.g.
> + *     # echo "dmesg-0" > erase
> + */
> +static ssize_t pstore_erase(struct file *filp, struct kobject *kobj,
> +                           struct bin_attribute *bin_attr,
> +                           char *buf, loff_t pos, size_t count)
> +{
> +       struct pstore_entry *search_pstore, *n;
> +       int len1, len2, found = 0;
> +
> +       len1 = count;
> +       if (buf[len1 - 1] == '\n')
> +               len1--;
> +
> +       spin_lock(&pstore_lock);
> +
> +       /*
> +        * Find this record
> +        */
> +       list_for_each_entry_safe(search_pstore, n, &pstore_list, list) {
> +               len2 = strlen(search_pstore->name);
> +               if (len1 == len2 && memcmp(buf, search_pstore->name,
> +                                          len1) == 0) {
> +                       found = 1;
> +                       break;
> +               }
> +       }
> +       if (!found) {
> +               spin_unlock(&pstore_lock);
> +               return -EINVAL;
> +       }
> +
> +       if (psinfo->eraser)
> +               if (psinfo->eraser(search_pstore->id)) {
> +                       spin_unlock(&pstore_lock);
> +                       return -EIO;
> +               }
> +
> +       list_del(&search_pstore->list);
> +
> +       spin_unlock(&pstore_lock);
> +
> +       sysfs_remove_bin_file(&pstore_kset->kobj, &search_pstore->attr);

It seems that the corresponding memory is not freed after erasing.

Best Regards,
Huang Ying


