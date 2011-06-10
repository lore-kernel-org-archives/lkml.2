Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab1FJC4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 22:56:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45390 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1FJC4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 22:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TIXwK7z6pLyWE7Apjdb0UzC86TmbVW8GzbAgkE84U8PszC1oiEP1+r8YokIynMg8nK
         71tWv7myrEVB1SMCsYsLjP2Z3dE8x3SUK8E6dVilM9CykuOo49Osz3YE9dMjbcVJuN66
         85CwRN488Vu8zniy9zdfbyuBJLoZsV8R6ufHA=
MIME-Version: 1.0
In-Reply-To: <20110609153328.c00b23c0.akpm@linux-foundation.org>
References: <BANLkTi=dndbsjqbF7nTDJ0Qpvs=WNP=W6A@mail.gmail.com>
	<1307485173-32010-1-git-send-email-wad@chromium.org>
	<20110609153328.c00b23c0.akpm@linux-foundation.org>
Date: Thu, 9 Jun 2011 21:56:45 -0500
Message-ID: <BANLkTikJpjeoarMCEhaQ69g7UyM9-PqpVw@mail.gmail.com>
Subject: Re: [PATCH v2] init: add root=PARTUUID=UUID,PARTNROFF=%d support
From: Will Drewry <wad@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Jens Axboe <jaxboe@fusionio.com>, Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 5:33 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue,  7 Jun 2011 17:19:33 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> Expand root=PARTUUID=UUID syntax to support selecting a root partition
>> by integer offset from a known, unique partition.  This approach
>> provides similar properties to specifying a device and partition number,
>> but using the UUID as the unique path prior to evaluating the offset.
>>
>> For example,
>>   root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B,PARTNROFF=1
>> selects the partition with UUID 99DE.. then select the next
>> partition.
>>
>> This change is motivated by a particular usecase in Chromium OS where
>> the bootloader can easily determine what partition it is on (by UUID)
>> but doesn't perform general partition table walking.
>>
>> That said, support for this model provides a direct mechanism for the
>> user to modify the root partition to boot without specifically needing
>> to extract each UUID or update the bootloader explicitly when the root
>> partition UUID is changed (if it is recreated to be larger, for
>> instance).  Pinning to a /boot-style partition UUID allows the arbitrary
>> root partition reconfiguration/modifications with slightly less
>> ambiguity than just [dev][partition] and less stringency than the
>> specific root partition UUID.
>>
>> At present, PARTNROFF is tied to PARTUUID use and must follow
>> immediately.  It is possible to expand support to other values of root=
>> or to add other key-value attributes and orderings, but it seems
>> unnecessary to add the infrastructure without a concrete need.
>>
>> ...
>>
>>  init/do_mounts.c |   34 ++++++++++++++++++++++++++++++----
>>  1 files changed, 30 insertions(+), 4 deletions(-)
>
> I have bad news.
>
> akpm:/usr/src/linux-3.0-rc2> grep -rl 'root=' Documentation
> Documentation/scsi/sym53c8xx_2.txt
> Documentation/scsi/ncr53c8xx.txt
> Documentation/kernel-parameters.txt
> Documentation/virtual/uml/UserModeLinux-HOWTO.txt
> Documentation/virtual/lguest/lguest.txt
> Documentation/filesystems/nfs/nfsroot.txt
> Documentation/filesystems/affs.txt
> Documentation/filesystems/ubifs.txt
> Documentation/m68k/kernel-options.txt
> Documentation/power/swsusp-dmcrypt.txt
> Documentation/early-userspace/README
> Documentation/kdump/kdump.txt
> Documentation/devicetree/booting-without-of.txt
> Documentation/security/Smack.txt
> Documentation/md.txt
> Documentation/ia64/xen.txt
> Documentation/intel_txt.txt
> Documentation/initrd.txt
> Documentation/x86/boot.txt
> Documentation/sound/oss/mwave
> Documentation/arm/SA1100/Assabet
> Documentation/frv/booting.txt
> Documentation/networking/cs89x0.txt
> Documentation/networking/cxgb.txt
> Documentation/init.txt
>
> Please work out which Documentation files need updating?

I wouldn't say that it's bad news - I'll track down the place that
seems to make the most sense.

>> index c0851a8..35329b2 100644
>> --- a/init/do_mounts.c
>> +++ b/init/do_mounts.c
>> @@ -85,12 +85,15 @@ no_match:
>>
>>  /**
>>   * devt_from_partuuid - looks up the dev_t of a partition by its UUID
>> - * @uuid:    36 byte char array containing a hex ascii UUID
>> + * @uuid:    min 36 byte char array containing a hex ascii UUID
>>   *
>>   * The function will return the first partition which contains a matching
>>   * UUID value in its partition_meta_info struct.  This does not search
>>   * by filesystem UUIDs.
>>   *
>> + * If @uuid is followed by a ",PARTNROFF=%d", then the number will be
>> + * extracted and used as an offset from the partition identified by the UUID.
>> + *
>>   * Returns the matching dev_t on success or 0 on failure.
>>   */
>>  static dev_t devt_from_partuuid(char *uuid_str)
>> @@ -98,6 +101,16 @@ static dev_t devt_from_partuuid(char *uuid_str)
>>       dev_t res = 0;
>>       struct device *dev = NULL;
>>       u8 uuid[16];
>> +     struct gendisk *disk;
>> +     struct hd_struct *part;
>> +     int offset = 0;
>> +
>> +     if (strlen(uuid_str) < 36)
>> +             goto done;
>> +
>> +     /* Check for optional partition number offset attributes. */
>> +     if (uuid_str[36])
>> +             sscanf(&uuid_str[36], ",PARTNROFF=%d", &offset);
>
> Syntax errors here will be silently ignored.  I expect that's common in
> this area of code, but please take a look, see if we should do
> something to help the poor user.

Sounds good. I can see a few ways to bubble up useful information and
still trigger the classic error path (potential partitions) too, I
think.

>> @@ -143,8 +171,6 @@ dev_t name_to_dev_t(char *name)
>>  #ifdef CONFIG_BLOCK
>>       if (strncmp(name, "PARTUUID=", 9) == 0) {
>>               name += 9;
>> -             if (strlen(name) != 36)
>> -                     goto fail;
>>               res = devt_from_partuuid(name);
>>               if (!res)
>>                       goto fail;
>
> The code changes the behaviour of name_to_dev_t(), so we should
> consider all callers.  That's hibernation, block2mtd and md.  Have you
> thought about (or perhaps tested) these code paths?  Does it make sense
> to use the extended syntax in these cases?  Is it possible to do so?
> Does it work?  etc.

Good question(s) - given that name_to_dev_t is init-internal, I had
forgotten there were still a fair number of consumers.  I'll review
the code paths in the places where I can't test them outright and make
a note and/or appropriate changes.

Thanks for the feedback!
will
