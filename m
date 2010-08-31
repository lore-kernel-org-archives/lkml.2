Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab0HaPWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:22:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757541Ab0HaPWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:22:06 -0400
Message-ID: <4C7D1E1B.4020700@redhat.com>
Date: Tue, 31 Aug 2010 11:22:03 -0400
From: Daniel J Walsh <dwalsh@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc14 Thunderbird/3.1
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Harald Hoyer <harald@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov, greg@kroah.com,
        sds@tycho.nsa.gov
Subject: Re: selinux vs devtmpfs (vs udev)
References: <1282950052.3284.110.camel@dhcp231-106.rdu.redhat.com>	 <AANLkTi=aEdKM_hunJmPzXxPqkrbok+_C6QUKf8v=Q+18@mail.gmail.com>	 <1283210070.3284.139.camel@dhcp231-106.rdu.redhat.com>	 <4C7CC107.1050304@redhat.com> <4C7D0DAD.9030505@redhat.com>	 <4C7D141A.9060102@redhat.com>  <4C7D1868.3090701@redhat.com> <1283267765.3284.150.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1283267765.3284.150.camel@dhcp231-106.rdu.redhat.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/31/2010 11:16 AM, Eric Paris wrote:
> On Tue, 2010-08-31 at 10:57 -0400, Daniel J Walsh wrote:
>> On 08/31/2010 10:39 AM, Harald Hoyer wrote:
>>> On 08/31/2010 04:11 PM, Daniel J Walsh wrote:
>>>> On 08/31/2010 04:44 AM, Harald Hoyer wrote:
>>>>> On 08/31/2010 01:14 AM, Eric Paris wrote:
>>>>>> On Sat, 2010-08-28 at 11:57 +0200, Kay Sievers wrote:
>>>>>>> On Sat, Aug 28, 2010 at 01:00, Eric Paris<eparis@redhat.com>   wrote:
>>>>>>
>>>>>>>> In the new new days of devtmpfs things aren't as nice.  The kernel is
>>>>>>>> magically creating files in /dev.  These are getting created with the
>>>>>>>> 'default' SELinux context.  So herein lies the problem.
>>>>>>>>
>>>>>>>> The first program that tries to access these files get denied by
>>>>>>>> SELinux.  Now udev actually has logic in it to fix the label on any
>>>>>>>> closed device file, so udev will at that point swoop in, fix the
>>>>>>>> label,
>>>>>>>> and the next program that tries to use the file will work just
>>>>>>>> fine.  Oh
>>>>>>>> fun!
>>>>>>
>>>>>>> Udev should still label all device nodes, even when they are created
>>>>>>> by the kernel. Devtmpfs or not should not make a difference here.
>>>>>>>
>>>>>>> I guess it's a udev bug introduced with:
>>>>>>>
>>>>>>> http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=578cc8a8085a47c963b5940459e475ac5f07219c
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> and we just need to fix that.
>>>>>>
>>>>>> Looks like the likely cause.  I see a note in one of the bugzillas that
>>>>>> says:
>>>>>>
>>>>>> Aug 30 14:03:09 pippin udevd-work[347]: preserve file '/dev/dri/card0',
>>>>>> because it has correct dev_t
>>>>>>
>>>>>> Which is certainly the part of code in question.  Do you have a quick
>>>>>> fix in mind that you plan to push upstream or should I ask the RH udev
>>>>>> guy to come up with something?
> 
>>>>> The RH udev guy says:
>>>>>
>>>>> This patch was introduced, because Red Hat engineers requested, that the
>>>>> selinux context should not be modified, after they set their own custom
>>>>> context (virtual machine management).
>>>>>
>>>>> So, either we differentiate between "add" and "change" events, or we
>>>>> should check against the "kernel default" selinux context, before we
>>>>> call udev_selinux_lsetfilecon().
> 
> How does udev get notification of add and change events?  add vs change
> seems like the best medium term solution.
> 
> Short term checking for the 'default' and resetting if it is default
> seems like a reasonable solution. But of course determining that default
> is not as easy as you might like.
> 
> Dan has suggested 2 heuristics.
> 
> 1) do not change if the MLS component is not ":s0"
>    - this is a terrible hack.  don't do it.
> 2) only change if the label is the same as the parent
>    - this is a lot better, but I'd still a heuristic of the next one
> 
> I suggest a third options: Calculate the default at startup and on every
> policy load and fix object labels if they are the default.  I'm sure Dan
> knows a code example of how to do the calculation.  The pseudocode looks
> something like:


> 
> lookup the label on /dev
> lookup the label on the initial task
> ask the kernel what the resulting label on a file transition with those
> two pieces of information will be.


NOOOOO

libvirt is going in and changing fixed_disk_device_t:s0 to svirt_t:c0,c124

We do not want udev to see this and ask what label a device should have
if libvirtd_t created a chr_file in device_t.

> 
> It's sad to write all this code when I know the answer 99.9999999999% of
> the time already, but if we are going to do it right.......
> 
> -Eric
> 
I think either figure out if the device is newly created versus modified
or check the parent directory.
> 
> --
> This message was distributed to subscribers of the selinux mailing list.
> If you no longer wish to subscribe, send mail to majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAkx9HhsACgkQrlYvE4MpobM1yQCeLyZiOUGQMG25Y/DYwzAsrxmp
OzMAoKGe6d3LV3PZFVXbHul1A+mKc6lE
=GZ7i
-----END PGP SIGNATURE-----
