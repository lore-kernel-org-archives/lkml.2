Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab1HZWB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 18:01:56 -0400
Received: from nm20-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.165]:21639 "HELO
	nm20-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750910Ab1HZWBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 18:01:55 -0400
X-Yahoo-Newman-Id: 346350.21307.bm@omp1046.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _C4sCmMVM1lZ6u1wGGTcdt7w5bjKnZb5TQwxAKgSAM._6pq
 d1UBvFRBlByQivXxH.UIYoI6vjDakp7lH06XPwDZ1gkgLOCSqfdXhqKL.iBE
 OekdllP9g2it6z_SnzS1at4odLEJfU07Xj4dPNTcgO.K5OHbNP5_YF6fF2ee
 14OX5u5aOG3JAmaKPbkhrI94xPme4Ykr8t4axcXDltOzq7Lui_I2Jm64WAzX
 GwJ5AOQl1tUWr0S4t4rSq7sbuEhpyE4RZP..V4bWVAVLWw.QHD1WFKyThQHv
 s_L0YWR2cl4iZBqJ2jxPyduMYM0D3Mp_ORBoK62prw.jWzVIluqPKYG6pBJF
 sjJb48bkdShvmQefP89jqe_PsU7tRO9ghNjB2vlve2qnL4KTzSoMR5vmrzwr
 ufBG7gsZSubcgUI_LrVetBeNOJUxo_VJfEzknxXYNOQhU.dpKY5HUNFbLaW7
 8M7lZKt6VkZlswGIwAnJGIwLTyNby5lrOsBBQOU41FDV8IroLRV1wsZD7dqe
 xO4HP9A0KIsWq4GxZniR1WPJ1tLhD7yExqHwEvCNmDS5.4S00L16qYw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E58175A.9090209@schaufler-ca.com>
Date: Fri, 26 Aug 2011 14:59:54 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: SMACK_IOCLOADACCESS
References: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com> <CACLa4pvbaWM8jRJvBW2NvN2OLK8x4wP44pfdUQ9He1fZwWYcfA@mail.gmail.com> <CADjiTvBkwusfjdE=PQ5B=MPMxr1bewR6v9qoqq6yMNWjp-BeLQ@mail.gmail.com> <4E57D17E.9020806@redhat.com>
In-Reply-To: <4E57D17E.9020806@redhat.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2011 10:01 AM, Eric Paris wrote:
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
>>> [SELinux maintainer here, but Casey knew to already take what I say
>>> with a grain of salt]
>>>
>>> I'm not telling you to do anything differently, just telling you what
>>> SELinux does, and why we do it.  SELinux has a file in selinuxfs
>>> called 'access.'  The file can be opened and one can write a rule into
>>> the file.  One then calls read and gets back a structure which
>>> contains all of the permissions information allowed for the
>>> source/target/class.  In SELinux we calculate all of the permissions
>>> for the tuple at once so providing all of the information at once can
>>> make a lot of sense.  libselinux provides libraries that will cache
>>> these decisions in the userspace program and quickly answer the same
>>> (or similar) questions later.
>>>
>>> http://userspace.selinuxproject.org/trac/browser/libselinux/src/compute_av.c
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
> SELinux attaches the information needed to the struct file private area
> inside the kernel using the kernel provided fs/libfs.c functions
> simple_transation_*.  Which means that 2 processes have no issues
> interfering with each other.  A multi threaded or misbehaving
> application may get EBUSY on write() if another write()/read() combo is
> in progress.  Its nice that the kernel has libraries which solve this
> problem for us!
>
> I don't know SMACK internals, but if one ever wants to have SMACK
> userspace object managers the ability for the interface to only be able
> to return a single value might be an eventual bottleneck.

Better to have a single question answered as required and with
complete accuracy than to carry around the baggage necessary to
maintain a cached duplicate of the kernel's rules and all the
bookkeeping that requires. SELinux libraries probably have to
make a system call just to determine if the caches they are
maintaining are out of date.

>
> Like I said, do whatever you guys think is best, but I'm constantly
> going to point out and ask for LSM similarities when possible!

I'm going to argue that in this case the interface puts
excessive burden on the user space code understanding a
peculiar behavior and that an ioctl is significantly more
appropriate to the task at hand. Even if there is precedence
for doing it using transaction IO the scheme smells of foul
sorcery.

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

