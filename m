Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1HZRlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:41:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab1HZRlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:41:53 -0400
Message-ID: <4E57D17E.9020806@redhat.com>
Date: Fri, 26 Aug 2011 13:01:50 -0400
From: Eric Paris <eparis@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
CC: Eric Paris <eparis@parisplace.org>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Smack: SMACK_IOCLOADACCESS
References: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com> <CACLa4pvbaWM8jRJvBW2NvN2OLK8x4wP44pfdUQ9He1fZwWYcfA@mail.gmail.com> <CADjiTvBkwusfjdE=PQ5B=MPMxr1bewR6v9qoqq6yMNWjp-BeLQ@mail.gmail.com>
In-Reply-To: <CADjiTvBkwusfjdE=PQ5B=MPMxr1bewR6v9qoqq6yMNWjp-BeLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2011 12:05 PM, Sakkinen, Jarkko wrote:
> On Fri, Aug 26, 2011 at 3:50 PM, Eric Paris <eparis@parisplace.org> wrote:
>> On Fri, Aug 26, 2011 at 1:52 AM, Jarkko Sakkinen
>> <jarkko.sakkinen@intel.com> wrote:
>>> IOCTL call for /smack/load that takes access rule in
>>> the same format as they are written into /smack/load.
>>> Sets errno to zero if access is allowed and to EACCES
>>> if not.
>>>
>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
>>
>> [SELinux maintainer here, but Casey knew to already take what I say
>> with a grain of salt]
>>
>> I'm not telling you to do anything differently, just telling you what
>> SELinux does, and why we do it.  SELinux has a file in selinuxfs
>> called 'access.'  The file can be opened and one can write a rule into
>> the file.  One then calls read and gets back a structure which
>> contains all of the permissions information allowed for the
>> source/target/class.  In SELinux we calculate all of the permissions
>> for the tuple at once so providing all of the information at once can
>> make a lot of sense.  libselinux provides libraries that will cache
>> these decisions in the userspace program and quickly answer the same
>> (or similar) questions later.
>>
>> http://userspace.selinuxproject.org/trac/browser/libselinux/src/compute_av.c
> 
> Thank you for this information. One thing that concerns
> me in this approach is the scenario where things serialize
> to the following sequence:
> 
> - Process A does open()
> - Process B does open()
> - Process A does write()
> - Process B does write()
> - Process A does read()
> - ... (sequence continues)
> 
> What's the end result?

SELinux attaches the information needed to the struct file private area
inside the kernel using the kernel provided fs/libfs.c functions
simple_transation_*.  Which means that 2 processes have no issues
interfering with each other.  A multi threaded or misbehaving
application may get EBUSY on write() if another write()/read() combo is
in progress.  Its nice that the kernel has libraries which solve this
problem for us!

I don't know SMACK internals, but if one ever wants to have SMACK
userspace object managers the ability for the interface to only be able
to return a single value might be an eventual bottleneck.

Like I said, do whatever you guys think is best, but I'm constantly
going to point out and ask for LSM similarities when possible!

-Eric
