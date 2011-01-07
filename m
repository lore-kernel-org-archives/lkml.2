Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab1AGUfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:35:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56862 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab1AGUez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:34:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=irct5oG6OKlUCWAub/BD9Se8Y3L+0segWhQghUEQGGveaJRoccJWgKUoWY4+FVFbka
         MKb5UIuU5gJWDerb9vMp2TL7tItJm6Q7QqoduArpBOsRrZtCDazeQozOYzA6ADPUjt/V
         hEfP6pzIK/wcSsoFYmp0RdbNjyKEHj/vATHWY=
Message-ID: <4D2777FC.6040509@gmail.com>
Date: Fri, 07 Jan 2011 21:30:52 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 01/17] pramfs: documentation
References: <4D25AF02.60208@gmail.com> <AANLkTimGt5hi+TpFHWxktJEg3tcDQmmARdqFqzAt++OQ@mail.gmail.com>
In-Reply-To: <AANLkTimGt5hi+TpFHWxktJEg3tcDQmmARdqFqzAt++OQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/01/2011 19:42, Tony Luck ha scritto:
> On Thu, Jan 6, 2011 at 4:01 AM, Marco Stornelli
> <marco.stornelli@gmail.com> wrote:
>> +accessed data that must survive system reboots and power cycles. An
>> +example usage might be system logs under /var/log, or a user address
>> +book in a cell phone or PDA.
> 
> Some usage model questions:
> 
> How do you handle errors?  I see that there are a few sanity checks in the
> "mount" path ... but there would seem to be several opportunities for the
> file system to get corrupted in other ways.  Since you don't have a block
> device, a standard "fsck" program looks challenging (though I guess you
> could mmap("/dev/mem") to peek & poke at the filesystem before trying
> to mount it).

Actually not (at least when strict devmem options is turned on) because
the memory region is marked exclusive at the moment (only a design
constraint). About the errors: pramfs does not maintain file data in the
page caches for normal file I/O, so no writeback, the read/write
operation are done with direct io and they are always sync. The data are
write protected in hw when the arch provide this facility (x86 does).
Inode contains a checksum and when there are problems they are marked as
bad. Superblock contains checksum and there is a redundant superblock.

> Some sort of recovery path would seem useful for the "address
> book" use model ... or do you just expect users to back their address book
> up (to the cloud?) and have the phone just make a clean filesystem if any
> errors are found?

Yeah maybe the address book can be a case not perfectly suitable, but it
was only an example. I thought about the fs as a "cache" in this use
case. However the designer can use this area whatever he wants,
recently I saw in a project this fs used as a system cache for decrypted
files where the files were stored in flash encrypted, so I think it's
flexible.

> What about quotas?  You have a fixed amount of persistent space, and
> presumably a number of apps that the user installs on their device that
> may like to use pramfs to store data.  Do you need some kernel enforcement
> to stop one rogue application from using up all the space? Or do you expect that
> this would be handled in some library level interface that applications will
> use to access pramfs?

Sincerely in my embedded systems I've never used quotas even to save
footprint (for the kernel support I mean). I don't think it's an hot
feature in this case and other fs for embedded use as ubifs, jffs2 etc.
don't support it.

Marco
