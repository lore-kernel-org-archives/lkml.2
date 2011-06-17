Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1FQF6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 01:58:24 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40486 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1FQF6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 01:58:21 -0400
X-AuditID: b753bd60-a1e7aba0000050a4-c7-4dfaecf8e93b
X-AuditID: b753bd60-a1e7aba0000050a4-c7-4dfaecf8e93b
Message-ID: <4DFAECF2.9060105@hitachi.com>
Date: Fri, 17 Jun 2011 14:58:10 +0900
From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org,
        jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 0/3] [RFC] Persistent device name using preferred name
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615153711.GB10160@kroah.com>
In-Reply-To: <20110615153711.GB10160@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

(2011/06/16 0:37), Greg KH wrote:
> On Wed, Jun 15, 2011 at 05:16:10PM +0900, Nao Nishijima wrote:
>> Hi,
>>
>> This patch series provides preferred name into kernel and procfs
>> messages. Preferred name is user's preferred name for a device.
>>
>> The purpose of this feature is to solve the persistent device
>> naming issues which was discussed here:
>>
>>  http://marc.info/?l=linux-scsi&m=130200794615884&w=2
>>
>> There are four issues.
>> 1. kernel messages doesn't show persistent device names
> 
> That is because a persistent device name could be anything, there are
> multiple ways of defining a device, and the kernel will not know them
> all as multiple ones could be in use for the same device.
>

Right, thus I'd like to solve it by assigning a unique preferred name
to each device. I mean, user of preferred name will decide to use one
way of defining a device, then kernel can show the name as a persistent
name for him.　Since this is completely based on user's choice/decision,
no one will　complain about that.


>> 2. procfs messages doesn't show persistent device names
> 
> See above.
> 
>> 3. Some commands didn't support persistent device name in arguments
> 
> Then fix the commands!
> 

Yes, of course. I'd like to fix those commands to accept preferred names.


> Seriously, this could be done by now, it's been over a year since this
> was first discussed.  All distros could have the updated packages by now
> and this would not be an issue.
> 
> I still think this is the correct way to solve the problem as it is a
> userspace issue, not a kernel one.
> 

Agreed. In #3 and #4, I don't think it can solve in kernel space now.

>> 4. Some commands message didn't show persistent device names
> 
> Same as #3.
> 

Yeah. Again, I've changed my mind, I'll try to fix those commands.

>> Then I suggested the intermediate device naming which changes
>> the naming scheme, but it was rejected. I realized that we should
>> use udev to provide persistent device names instead of change the
>> naming scheme.
> 
> Yes.
> 
>> In LKML discussion, a new idea was suggested by James Bottomley.
>> This idea allows kernel messages show preferred names by adding a
>> new attribute to a device, kernel messages show this new attribute.
>> This idea's advantage is not to change the current naming scheme.
>>
>> I tried implementation of preferred name, and then there are two
>> discussion points.
>>
>> (a) Which devices need support?
>> Preferred name is stored in struct device. Therefore it is available
>> for all devices if we make preferred name support with other device
>> types.
>>
>> This patch series only support scsi block device. Is there the device
>> which needs support? (e.g. Ntwork devices, generic SCSI devices, etc.)
>>
>> (b) What kind of procfs form is good?
>> I implemented preferred name something like this,
>>
>> (preferred name assigned foo to sda)
>> #cat /proc/partitions
>> major minor  #blocks  name
>>
>>    8        0  488386584 foo
>>    8        1     194560 foo1
>> ...
>>
>> Do you needs device name filed?
>> Something like this,
>>
>> (preferred name assigned foo to sda)
>> #cat /proc/partitions
>> major minor  #blocks  name preferred
>>
>>    8        0  488386584 sda foo
>>    8        1     194560 sda1 foo1
>> ...
> 
> Sorry, but you can not change the format of procfs files without
> breaking a lot of tools, that's no longer allowed.
> 

OK, I would not change the format of procfs files.

>> Issue 3 and 4 is command releated issue. Commands have to be
>> modified to use preferred name. We need to create library for
>> preferred name.
> 
> Again, this is quite simple and could have been finished by now :(
> 

:(

>> Our goal is to solve those issues, and users can use and see
>> preferred name anywhere.
> 
> I don't see how your proposed solution would solve the issue of
> userspace using different persistant names for the same device.  How
> would it know which one is correct?
> 

My proposal don't use current persistent device names for access. Those
are used in a udev rule as information to identify a device. Something
like this:

(Example: using by-id)
SUBSYSTEM=="block",
ENV{ID_SERIAL}=="scsi-SATA_WDC_WD5000AAKS-_WD-WCASY6088049",
SYMLINK+="disk/by-preferred/foo", PROGRAM=”write_preferred_name %p foo”

To access a device from by-preferred persistently, I create new symbolic
link from /dev/disk/by-preferred/foo to /dev/sdX.

> Again, this is a userspace thing, not a kernel thing, please solve it in
> userspace.
> 

To solve it in userspace, we need mapping of a device name to a device
every boot-up time. But if kernel messages can show preferred name, we
can identify a device from only kernel messages.

Thanks,

-- 
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email： nao.nishijima.xt@hitachi.com
