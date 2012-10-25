Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab2JYGof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:44:35 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58136 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2JYGod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:44:33 -0400
MIME-Version: 1.0
In-Reply-To: <1351143839.18115.57.camel@falcor>
References: <20121018193831.GD18147@redhat.com>
	<874nlrv2ni.fsf@xmission.com>
	<20121019020630.GA27052@redhat.com>
	<877gqnnnf0.fsf@xmission.com>
	<20121019143112.GB27052@redhat.com>
	<871ugqb4gj.fsf@xmission.com>
	<20121023131854.GA16496@redhat.com>
	<20121023145920.GD16496@redhat.com>
	<20121023154123.GA30730@srcf.ucam.org>
	<87d309xhmc.fsf_-_@xmission.com>
	<20121024171926.GD1821@redhat.com>
	<1351143839.18115.57.camel@falcor>
Date: Wed, 24 Oct 2012 23:44:32 -0700
X-Google-Sender-Auth: 2QShXc5N7knaR8j1-kVusQrfgq4
Message-ID: <CAGXu5j+3CNmm6L2+18OKCairhS90N4SJ0zoZKVy+d5ncE67pbA@mail.gmail.com>
Subject: Re: [RFC] Kdump with signed images
From: Kees Cook <keescook@chromium.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Matthew Garrett <mjg@redhat.com>, Khalid Aziz <khalid@gonehiking.org>,
        kexec@lists.infradead.org, horms@verge.net.au,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 10:43 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Wed, 2012-10-24 at 13:19 -0400, Vivek Goyal wrote:
>> On Tue, Oct 23, 2012 at 09:44:59AM -0700, Eric W. Biederman wrote:
>> > Matthew Garrett <mjg@redhat.com> writes:
>> >
>> > > On Tue, Oct 23, 2012 at 10:59:20AM -0400, Vivek Goyal wrote:
>> > >
>> > >> But what about creation of a new program which can call kexec_load()
>> > >> and execute an unsigned kernel. Doesn't look like that will be
>> > >> prevented using IMA.
>
> Like the existing kernel modules, kexec_load() is not file descriptor
> based.  There isn't an LSM or IMA-appraisal hook here.
>
>> > > Right. Trusting userspace would require a new system call that passes in
>> > > a signature of the userspace binary, and the kernel would then have to
>> > > verify the ELF object in memory in order to ensure that it
>> > > matches the signature. Verifying that the copy on the filesystem is
>> > > unmodified isn't adequate - an attacker could simply have paused the
>> > > process and injected code.
>
> I haven't looked at kexec_load() in detail, but like kernel modules, I
> think the better solution would be to pass a file descriptor, especially
> if you're discussing a new system call.  (cc'ing Kees.)

Yeah, it looks like kexec_load could use a nearly identical new
syscall that uses an fd, just like init_module is getting.

Another area, kind of related, is firmware loading. The interface for
that is a bit weird, if the documentation is up to date:

        echo 1 > /sys/$DEVPATH/loading
        cat $HOTPLUG_FW_DIR/$FIRMWARE > /sysfs/$DEVPATH/data
        echo 0 > /sys/$DEVPATH/loading

It looks like there's a filp on the reader:

static ssize_t firmware_data_read(struct file *filp, struct kobject *kobj,
                                  struct bin_attribute *bin_attr,
                                  char *buffer, loff_t offset, size_t count)

But it's not clear to me yet if we'll actually get the firmware file,
or if we'll get a random pipe we can't evaluate. Has anyone looked at
handling "signed" firmware loading yet?

-Kees

-- 
Kees Cook
Chrome OS Security
