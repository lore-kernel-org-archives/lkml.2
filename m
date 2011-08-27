Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203Ab1H0GGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 02:06:48 -0400
Received: from mga07.intel.com ([143.182.124.22]:25970 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751010Ab1H0GGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 02:06:44 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Aug 2011 02:06:44 EDT
MIME-Version: 1.0
In-Reply-To: <4E57D17E.9020806@redhat.com>
References: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com>
	<CACLa4pvbaWM8jRJvBW2NvN2OLK8x4wP44pfdUQ9He1fZwWYcfA@mail.gmail.com>
	<CADjiTvBkwusfjdE=PQ5B=MPMxr1bewR6v9qoqq6yMNWjp-BeLQ@mail.gmail.com>
	<4E57D17E.9020806@redhat.com>
Date: Sat, 27 Aug 2011 08:57:03 +0300
Message-ID: <CADjiTvC5tLUmxNvZq_uORqMNFLEZiQ3XuG2aQ17r2ZHZOWefJg@mail.gmail.com>
Subject: Re: [PATCH] Smack: SMACK_IOCLOADACCESS
From: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
To: Eric Paris <eparis@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 8:01 PM, Eric Paris <eparis@redhat.com> wrote:
> On 08/26/2011 12:05 PM, Sakkinen, Jarkko wrote:
>> On Fri, Aug 26, 2011 at 3:50 PM, Eric Paris <eparis@parisplace.org> wrote:
>>> On Fri, Aug 26, 2011 at 1:52 AM, Jarkko Sakkinen
>>> <jarkko.sakkinen@intel.com> wrote:
>>>> IOCTL call for /smack/load that takes access rule in
>>>> the same format as they are written into /smack/load.
>>>> Sets errno to zero if access is allowed and to EACCES
>>>> if not.
>>>>
>>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
>>>
>>> [SELinux maintainer here, but Casey knew to already take what I say
>>> with a grain of salt]
>>>
>>> I'm not telling you to do anything differently, just telling you what
>>> SELinux does, and why we do it.  SELinux has a file in selinuxfs
>>> called 'access.'  The file can be opened and one can write a rule into
>>> the file.  One then calls read and gets back a structure which
>>> contains all of the permissions information allowed for the
>>> source/target/class.  In SELinux we calculate all of the permissions
>>> for the tuple at once so providing all of the information at once can
>>> make a lot of sense.  libselinux provides libraries that will cache
>>> these decisions in the userspace program and quickly answer the same
>>> (or similar) questions later.
>>>
>>> http://userspace.selinuxproject.org/trac/browser/libselinux/src/compute_av.c
>>
>> Thank you for this information. One thing that concerns
>> me in this approach is the scenario where things serialize
>> to the following sequence:
>>
>> - Process A does open()
>> - Process B does open()
>> - Process A does write()
>> - Process B does write()
>> - Process A does read()
>> - ... (sequence continues)
>>
>> What's the end result?
>
> SELinux attaches the information needed to the struct file private area
> inside the kernel using the kernel provided fs/libfs.c functions
> simple_transation_*.  Which means that 2 processes have no issues
> interfering with each other.  A multi threaded or misbehaving
> application may get EBUSY on write() if another write()/read() combo is
> in progress.  Its nice that the kernel has libraries which solve this
> problem for us!
>
> I don't know SMACK internals, but if one ever wants to have SMACK
> userspace object managers the ability for the interface to only be able
> to return a single value might be an eventual bottleneck.

You're right. his looks like another doable way to implement
it.

I do buy your argument that it would good if Smack
would use equivalent API that is used in other places
where similar scenario applies. I'm preparing a refactored
patch that uses simple_transaction API

>
> Like I said, do whatever you guys think is best, but I'm constantly
> going to point out and ask for LSM similarities when possible!
>
> -Eric
>

/Jarkko
