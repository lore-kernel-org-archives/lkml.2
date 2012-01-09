Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2AIMpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 07:45:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50068 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab2AIMpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 07:45:14 -0500
MIME-Version: 1.0
In-Reply-To: <871ur99vzf.fsf@rustcorp.com.au>
References: <1325951076.860.2.camel@mop> <871ur99vzf.fsf@rustcorp.com.au>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 9 Jan 2012 13:44:52 +0100
Message-ID: <CAPXgP12rUUYfRy6QB5Z4Rwdday3hNHubCsSRY4gMDYuQGs3oJg@mail.gmail.com>
Subject: Re: [PATCH] modules: sysfs - export: taint, address, size
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jon Masters <jcm@redhat.com>, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 08:27, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Sat, 07 Jan 2012 16:44:36 +0100, Kay Sievers <kay.sievers@vrfy.org> wrote:

>> Recent tools do not use /proc to retrieve module information. A few values
>> are currently missing from sysfs.
>
> Well, strace says lsmod still does.  Is libkmod doing something
> different?

Yes, kmod used /sys only.

There is current code to read the size, to provide the 'lsmod' output,
but that will be removed.

> Should we be deprecating /proc/modules?

In the longer run, yes.

We still aim for leaving everything that isn't process- or
namespace-related (which, with some stretch is always process-related)
alone, and use /sys for it.

>> +static size_t module_flags_taint(struct module *mod, char *buf)
>> +{
>> +     size_t l = 0;
>> +
>> +     if (mod->taints & (1 << TAINT_PROPRIETARY_MODULE))
>> +             buf[l++] = 'P';
>> +     else if (mod->taints & (1 << TAINT_OOT_MODULE))
>> +             buf[l++] = 'O';
>> +     if (mod->taints & (1 << TAINT_FORCED_MODULE))
>> +             buf[l++] = 'F';
>> +     if (mod->taints & (1 << TAINT_CRAP))
>> +             buf[l++] = 'C';
>> +     /*
>> +      * TAINT_FORCED_RMMOD: could be added.
>> +      * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
>> +      * apply to modules.
>> +      */
>> +     return l;
>> +}
>
> The else here is weird.  Shouldn't we leave the exclusion elsewhere?

You mean the 'else if ... TAINT_OOT_MODULE'?  It's a one-to-one copy
of the current code, which just moved up a bit.

Disconnect the two flags form each other?

>> +static ssize_t show_address(struct module_attribute *mattr,
>> +                         struct module_kobject *mk, char *buffer)
>> +{
>> +     return sprintf(buffer, "0x%pK\n", mk->mod->module_core);
>> +}
>> +
>> +struct module_attribute module_address =
>> +     __ATTR(address, 0444, show_address, NULL);
>> +
>> +static ssize_t show_size(struct module_attribute *mattr,
>> +                     struct module_kobject *mk, char *buffer)
>> +{
>> +     return sprintf(buffer, "%u\n", mk->mod->init_size + mk->mod->core_size);
>> +}
>> +
>> +struct module_attribute module_size =
>> +     __ATTR(size, 0444, show_size, NULL);
>
> This copies a past mistake, and is definitely wrong.  Either expose both
> pointers and sizes, or don't include init_size here.  Sure, it'll
> normally be 0, but if not it's confusing...

Ah, good to know, mod->init_size is 0 for all modules here, so we
should just drop mod->init_size and maybe name the 'size' attribute to
'coresize'?

> But the bigger question is: Why are we exposing these sizes?
> /proc/modules did since 2.2, or before, but that doesn't make it the
> best option...

Good question, I doubt it is too useful, it's just that 'lsmod' shows
it, so we wanted to show too.

Kay
