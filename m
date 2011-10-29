Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1J2XgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:36:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51214 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab1J2XgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:36:09 -0400
MIME-Version: 1.0
In-Reply-To: <20111029223935.GB3952@suse.de>
References: <CANq1E4SovxjRsuDN3PMqCnjBMMQeHWnvbwreXJWcDj7D7wUxWw@mail.gmail.com>
	<20111029223935.GB3952@suse.de>
Date: Sun, 30 Oct 2011 01:36:08 +0200
Message-ID: <CANq1E4QwjDOb0x_HcarwY4cM=P5NXoL6351=ivy-NLP9ZnVoJA@mail.gmail.com>
Subject: Re: [BUG] kobject module-ref race-condition or unsafe module_put(THIS_MODULE)
From: David Herrmann <dh.herrmann@googlemail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 30, 2011 at 12:39 AM, Greg KH <gregkh@suse.de> wrote:
> On Sat, Oct 29, 2011 at 07:52:47PM +0200, David Herrmann wrote:
>> Hi
>>
>> I currently do not understand how kobjects keep a reference to the
>> owning module. Lets assume I provide a "release" method via a
>> kobj_type for my kobject. I want to go sure my module is still alive
>> when this method is called. Otherwise, this "release" method would be
>> no longer available and we would jump into invalid memory. Therefore,
>> I need to take a reference to my own module. This seems trivial.
>> However, how do I release this reference again?
>> The most simple solution might be calling module_put(THIS_MODULE) in
>> my "release" method. However, if this call drops the module-refcount
>> to 0 and immediately removes the module, the module_put() returns to
>> my "release" function which now is no longer available.
>>
>> It seems quite unlikely that the cleanup of a module is faster than
>> two function-returns, however, theoretically there is a race
>> condition.
>>
>> The following example is based on fs/char_dev.c. Lets assume my module
>> provides a  kobject structure. On init I take a ref to myself with
>> try_module_get(THIS_MODULE).
>
> No, never do that, why would you?
>
>> I add my own kobj_type with the following release function:
>>
>> static void mydev_put(struct mydev *p)
>> {
>>       if (p) {
>>               kobject_put(&p->kobj);
>>               module_put(THIS_MODULE);
>>       }
>> }
>
> Ick, don't do that.
>
>> How can we go sure that module_put() doesn't free my own module before
>> it returns? Isn't a call to module_put(THIS_MODULE) always unsafe
>> (unless I own at least two references)?
>
> Yes, that's why you shouldn't be doing this :)
>
>> Maybe I have missed some important fact here, but this seems quite
>> unsafe to me. Adding a "owner" field to a kobj_type would fix that
>> issue for kobjects/devices.
>
> No, let's determine exactly what you are trying to do first, and why in
> the world you are dealing with "raw" kobjects.  You should almost never
> never never do that.
>
> What driver are you writing?  Have a pointer to the code somewhere?

Initially, I was looking at hci_dev at net/bluetooth/hci_core.c and
hci_sysfs.c. It registers a "struct device" with a device_type
structure and a static release function. I was wondering how I can be
sure that the "release" function is still available when it is called.
I couldn't find any module reference in "struct device" nor can I be
sure that the module is still loaded when the device is freed.

There are several bugfixes in padovan's tree and pending on the ML so
I can't point you to the source. Reading net/bluetooth/hci* really
doesn't help here. However, what should I do in the following case:

I provide hci_alloc_dev() which creates a hci_dev with an embedded
"struct device" and hci_dev_get/put which map to get/put_device(). The
device is registered with a "device_type" including a "release"
callback which simply calls kfree() on the hci_dev.
Now how can I be sure the "release" callback pointing to my function
is still available when a device is freed? When unloading the
bluetooth module I cannot wait for all hci_dev structures to be
freed(). This would make ref-counts useless. What is the recommended
way to do that?

Also, module_put(THIS_MODULE) is used quite frequently in the tree.
Some cases use it in error-paths where they actually know they have
another reference. But quite many places use it the wrong way. See for
instance drivers/watchdog/softdog.c.

> greg k-h
>

I am confused. I don't know how to protect "struct device" structures
as they don't have an "owner" field.

Regards
David
