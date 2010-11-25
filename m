Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0KYK2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 05:28:11 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:45310 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab0KYK2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 05:28:09 -0500
Date: Thu, 25 Nov 2010 11:21:20 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        linux acpi <linux-acpi@vger.kernel.org>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Axel Lin <axel.lin@gmail.com>,
        Thomas Renninger <trenn@suse.de>,
        daniel.lohmann@informatik.uni-erlangen.de,
        Reinhard.Tartler@informatik.uni-erlangen.de,
        Julio.Sincero@informatik.uni-erlangen.de
Subject: Re: debugfs_create_dir return value in acer-wmi, intel_ips and ec_sys
In-Reply-To: <AANLkTikuHbF5FLT4OB8koZRgQkd5Ye7+O6HLrCY_vnq-@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1011251119290.8543@pc-004.diku.dk>
References: <4ceda4f7.0cedd80a.26b4.0222@mx.google.com>
 <Pine.LNX.4.64.1011250653370.15506@ask.diku.dk>
 <AANLkTikuHbF5FLT4OB8koZRgQkd5Ye7+O6HLrCY_vnq-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511572895-1534391515-1290680480=:8543"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511572895-1534391515-1290680480=:8543
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 25 Nov 2010, Corentin Chary wrote:

> On Thu, Nov 25, 2010 at 7:01 AM, Julia Lawall <julia@diku.dk> wrote:
> > On Thu, 25 Nov 2010, Corentin Chary wrote:
> >
> >> Hi,
> >>
> >> I was checking debugfs code in platform/x86, because I want to add
> >> some files to eeepc-wmi. And I found something disturbing.
> >>
> >> The documentation says:
> >>
> >> > This call, if successful, will make a directory called name underneath the
> >> > indicated parent directory.  If parent is NULL, the directory will be
> >> > created in the debugfs root.  On success, the return value is a struct
> >> > dentry pointer which can be used to create files in the directory (and to
> >> > clean it up at the end).  A NULL return value indicates that something went
> >> > wrong.  If ERR_PTR(-ENODEV) is returned, that is an indication that the
> >> > kernel has been built without debugfs support and none of the functions
> >> > described below will work.
> >>
> >> But then, here is the code in acer-wmi:
> >>
> >> > static void remove_debugfs(void)
> >> > {
> >> >       debugfs_remove(interface->debug.devices);
> >> >       debugfs_remove(interface->debug.root);
> >> > }
> >> >
> >> > static int create_debugfs(void)
> >> > {
> >> >        interface->debug.root = debugfs_create_dir("acer-wmi", NULL);
> >> >        if (!interface->debug.root) {
> >> >                printk(ACER_ERR "Failed to create debugfs directory");
> >> >                return -ENOMEM;
> >> >        }
> >>
> >> this code is *not* inside #ifndef CONFIG_DEBUG_FS, so debugfs_create_dir
> >> can return ERR_PTR(-ENODEV) right ?
> >>
> >> Then, remove_debug() will call debugfs_remove(ERR_PTR(-ENODEV)) right ?
> >>
> >> So, acpi-wmi seems to have an issue when debugfs is disabled, that's "ok".
> >>
> >> But then I took a look at intel_ips :
> >>
> >> >        ips->debug_root = debugfs_create_dir("ips", NULL);
> >> >        if (!ips->debug_root) {
> >> >                dev_err(&ips->dev->dev,
> >> >                        "failed to create debugfs entries: %ld\n",
> >> >                        PTR_ERR(ips->debug_root));
> >> >                return;
> >> >        }
> >>
> >> Then PTR_ERR thing is strange, because ips->debug_root can only be NULL
> >> here...
> >> But here, it's ok to only check NULL, because it's inside #ifndef
> >> CONFIG_DEBUG_FS.
> >>
> >> So, two drivers checked, to weird error handling code. I did a quick grep and
> >> opened
> >> the first result: ec_sys.c.
> >>
> >> ec_sys.c depends on CONFIG_ACPI_EC_DEBUGFS but doesn't depend on
> >> CONFIG_DEBUG_FS.
> >>
> >> Here, again, the code only check for != NULL while it could be ERR_PTR(-
> >> ENODEV):
> >>
> >> >        if (ec_device_count == 0) {
> >> >                acpi_ec_debugfs_dir = debugfs_create_dir("ec", NULL);
> >> >                if (!acpi_ec_debugfs_dir)
> >> >                        return -ENOMEM;
> >> >        }
> >> >
> >> >        sprintf(name, "ec%u", ec_device_count);
> >> >        dev_dir = debugfs_create_dir(name, acpi_ec_debugfs_dir);
> >>
> >> Here, acpi_ec_debugfs_dir (that can be an invalid pointer) is used as
> >> a parent dentry, and will be dereferenced without checks.
> >>
> >> I am missing something obvious, or are most of debugfs implementation
> >> broken when debugfs is disabled ?
> 
> Answer to myself, when debugfs is disabled, it's ok to give broken
> dentry pointers to debugfs functions since they won't do anything.
> 
> >> Julia, if I am right, coccinelle could help us right ? Can the tool check
> >> if the code is between #ifdef CONFIG_DEBUGS_FS ? That would help a lot.
> >
> > Unfortunately, at the moment, it can't; there is no matching on #ifdefs.
> > Perhaps it could be added.
> 
> Or better, something to check if a macro is defined in a particular contact ?

Actually, Daniel Lohmann's group has been working on analyzing #ifdef's.   
Perhaps they have a solution to this problem?  I have added them to the CC 
list.

julia



> > I wonder though if sometimes returning NULL and sometimes returning
> > ERR_PTR is something that should be encouraged?  Would one rather convert
> > the NULL case to a specific ERR_PTR case?
> 
> But yeah, I found debugfs API disturbing, but it seems to be done like that to
> ease the "debugfs is disabled case".
> 
> Thanks,
> -- 
> Corentin Chary
> http://xf.iksaif.net
> 
---511572895-1534391515-1290680480=:8543--
