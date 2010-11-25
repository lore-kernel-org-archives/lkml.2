Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab0KYGk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:40:27 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45043 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0KYGkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:40:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X1raGMLr1SlMjITZbQxKPSBDjzStkTloeJyUgxkihcKnxsHpunda1EL/TV1OQETkON
         LMLz4OFRLQzH4mS4izqXmbfftCgrxGNdptUjZbfkAlOL88OPQXqUTgtmJpu4yB5Kt+Ci
         XctKJu7K2PV2MdTVMxbqNceM3JeTwKAmojgFA=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1011250653370.15506@ask.diku.dk>
References: <4ceda4f7.0cedd80a.26b4.0222@mx.google.com>
	<Pine.LNX.4.64.1011250653370.15506@ask.diku.dk>
Date: Thu, 25 Nov 2010 07:40:23 +0100
Message-ID: <AANLkTikuHbF5FLT4OB8koZRgQkd5Ye7+O6HLrCY_vnq-@mail.gmail.com>
Subject: Re: debugfs_create_dir return value in acer-wmi, intel_ips and ec_sys
From: Corentin Chary <corentin.chary@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        linux acpi <linux-acpi@vger.kernel.org>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Axel Lin <axel.lin@gmail.com>,
        Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 7:01 AM, Julia Lawall <julia@diku.dk> wrote:
> On Thu, 25 Nov 2010, Corentin Chary wrote:
>
>> Hi,
>>
>> I was checking debugfs code in platform/x86, because I want to add
>> some files to eeepc-wmi. And I found something disturbing.
>>
>> The documentation says:
>>
>> > This call, if successful, will make a directory called name underneath the
>> > indicated parent directory.  If parent is NULL, the directory will be
>> > created in the debugfs root.  On success, the return value is a struct
>> > dentry pointer which can be used to create files in the directory (and to
>> > clean it up at the end).  A NULL return value indicates that something went
>> > wrong.  If ERR_PTR(-ENODEV) is returned, that is an indication that the
>> > kernel has been built without debugfs support and none of the functions
>> > described below will work.
>>
>> But then, here is the code in acer-wmi:
>>
>> > static void remove_debugfs(void)
>> > {
>> >       debugfs_remove(interface->debug.devices);
>> >       debugfs_remove(interface->debug.root);
>> > }
>> >
>> > static int create_debugfs(void)
>> > {
>> >        interface->debug.root = debugfs_create_dir("acer-wmi", NULL);
>> >        if (!interface->debug.root) {
>> >                printk(ACER_ERR "Failed to create debugfs directory");
>> >                return -ENOMEM;
>> >        }
>>
>> this code is *not* inside #ifndef CONFIG_DEBUG_FS, so debugfs_create_dir
>> can return ERR_PTR(-ENODEV) right ?
>>
>> Then, remove_debug() will call debugfs_remove(ERR_PTR(-ENODEV)) right ?
>>
>> So, acpi-wmi seems to have an issue when debugfs is disabled, that's "ok".
>>
>> But then I took a look at intel_ips :
>>
>> >        ips->debug_root = debugfs_create_dir("ips", NULL);
>> >        if (!ips->debug_root) {
>> >                dev_err(&ips->dev->dev,
>> >                        "failed to create debugfs entries: %ld\n",
>> >                        PTR_ERR(ips->debug_root));
>> >                return;
>> >        }
>>
>> Then PTR_ERR thing is strange, because ips->debug_root can only be NULL
>> here...
>> But here, it's ok to only check NULL, because it's inside #ifndef
>> CONFIG_DEBUG_FS.
>>
>> So, two drivers checked, to weird error handling code. I did a quick grep and
>> opened
>> the first result: ec_sys.c.
>>
>> ec_sys.c depends on CONFIG_ACPI_EC_DEBUGFS but doesn't depend on
>> CONFIG_DEBUG_FS.
>>
>> Here, again, the code only check for != NULL while it could be ERR_PTR(-
>> ENODEV):
>>
>> >        if (ec_device_count == 0) {
>> >                acpi_ec_debugfs_dir = debugfs_create_dir("ec", NULL);
>> >                if (!acpi_ec_debugfs_dir)
>> >                        return -ENOMEM;
>> >        }
>> >
>> >        sprintf(name, "ec%u", ec_device_count);
>> >        dev_dir = debugfs_create_dir(name, acpi_ec_debugfs_dir);
>>
>> Here, acpi_ec_debugfs_dir (that can be an invalid pointer) is used as
>> a parent dentry, and will be dereferenced without checks.
>>
>> I am missing something obvious, or are most of debugfs implementation
>> broken when debugfs is disabled ?

Answer to myself, when debugfs is disabled, it's ok to give broken
dentry pointers to debugfs functions since they won't do anything.

>> Julia, if I am right, coccinelle could help us right ? Can the tool check
>> if the code is between #ifdef CONFIG_DEBUGS_FS ? That would help a lot.
>
> Unfortunately, at the moment, it can't; there is no matching on #ifdefs.
> Perhaps it could be added.

Or better, something to check if a macro is defined in a particular contact ?

> I wonder though if sometimes returning NULL and sometimes returning
> ERR_PTR is something that should be encouraged?  Would one rather convert
> the NULL case to a specific ERR_PTR case?

But yeah, I found debugfs API disturbing, but it seems to be done like that to
ease the "debugfs is disabled case".

Thanks,
-- 
Corentin Chary
http://xf.iksaif.net
