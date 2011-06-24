Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1FXTxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 15:53:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46999 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab1FXTxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 15:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kfe38C/F1hy5dKzSpiH0d0vsCjfcz4S75hikDf3ZvtHUX/wIbyq+/U7urpcBhHvuoU
         Dah3AX4WlcgWhM6WV/lspGJZsw6gfLjdvUnkkV60E6r677HiX2d+9gYfVC1cIxXnAOii
         QdUH7daQR/tkUVltz+M9CyWwfqWCHXZoYFD8g=
MIME-Version: 1.0
In-Reply-To: <BANLkTikJpjeoarMCEhaQ69g7UyM9-PqpVw@mail.gmail.com>
References: <BANLkTi=dndbsjqbF7nTDJ0Qpvs=WNP=W6A@mail.gmail.com>
	<1307485173-32010-1-git-send-email-wad@chromium.org>
	<20110609153328.c00b23c0.akpm@linux-foundation.org>
	<BANLkTikJpjeoarMCEhaQ69g7UyM9-PqpVw@mail.gmail.com>
Date: Fri, 24 Jun 2011 14:53:18 -0500
Message-ID: <BANLkTimzZ5aRBiCm1TSy4yzfGUdchPeuMA@mail.gmail.com>
Subject: Re: [PATCH v2] init: add root=PARTUUID=UUID,PARTNROFF=%d support
From: Will Drewry <wad@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 9:56 PM, Will Drewry <wad@chromium.org> wrote:
> On Thu, Jun 9, 2011 at 5:33 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Tue,  7 Jun 2011 17:19:33 -0500
>> Will Drewry <wad@chromium.org> wrote:
>>
>>> Expand root=PARTUUID=UUID syntax to support selecting a root partition
>>> by integer offset from a known, unique partition.  This approach
>>> provides similar properties to specifying a device and partition number,
>>> but using the UUID as the unique path prior to evaluating the offset.
>>>
>>> For example,
>>>   root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B,PARTNROFF=1
>>> selects the partition with UUID 99DE.. then select the next
>>> partition.
>>>
>>> This change is motivated by a particular usecase in Chromium OS where
>>> the bootloader can easily determine what partition it is on (by UUID)
>>> but doesn't perform general partition table walking.
>>>
>>> That said, support for this model provides a direct mechanism for the
>>> user to modify the root partition to boot without specifically needing
>>> to extract each UUID or update the bootloader explicitly when the root
>>> partition UUID is changed (if it is recreated to be larger, for
>>> instance).  Pinning to a /boot-style partition UUID allows the arbitrary
>>> root partition reconfiguration/modifications with slightly less
>>> ambiguity than just [dev][partition] and less stringency than the
>>> specific root partition UUID.
>>>
>>> At present, PARTNROFF is tied to PARTUUID use and must follow
>>> immediately.  It is possible to expand support to other values of root=
>>> or to add other key-value attributes and orderings, but it seems
>>> unnecessary to add the infrastructure without a concrete need.
>>>
>>> ...
>>>
>>>  init/do_mounts.c |   34 ++++++++++++++++++++++++++++++----
>>>  1 files changed, 30 insertions(+), 4 deletions(-)
>>
>> I have bad news.
>>
>> akpm:/usr/src/linux-3.0-rc2> grep -rl 'root=' Documentation
>> Documentation/scsi/sym53c8xx_2.txt
>> Documentation/scsi/ncr53c8xx.txt
>> Documentation/kernel-parameters.txt
>> Documentation/virtual/uml/UserModeLinux-HOWTO.txt
>> Documentation/virtual/lguest/lguest.txt
>> Documentation/filesystems/nfs/nfsroot.txt
>> Documentation/filesystems/affs.txt
>> Documentation/filesystems/ubifs.txt
>> Documentation/m68k/kernel-options.txt
>> Documentation/power/swsusp-dmcrypt.txt
>> Documentation/early-userspace/README
>> Documentation/kdump/kdump.txt
>> Documentation/devicetree/booting-without-of.txt
>> Documentation/security/Smack.txt
>> Documentation/md.txt
>> Documentation/ia64/xen.txt
>> Documentation/intel_txt.txt
>> Documentation/initrd.txt
>> Documentation/x86/boot.txt
>> Documentation/sound/oss/mwave
>> Documentation/arm/SA1100/Assabet
>> Documentation/frv/booting.txt
>> Documentation/networking/cs89x0.txt
>> Documentation/networking/cxgb.txt
>> Documentation/init.txt
>>
>> Please work out which Documentation files need updating?
>
> I wouldn't say that it's bad news - I'll track down the place that
> seems to make the most sense.
>
>>> index c0851a8..35329b2 100644
>>> --- a/init/do_mounts.c
>>> +++ b/init/do_mounts.c
>>> @@ -85,12 +85,15 @@ no_match:
>>>
>>>  /**
>>>   * devt_from_partuuid - looks up the dev_t of a partition by its UUID
>>> - * @uuid:    36 byte char array containing a hex ascii UUID
>>> + * @uuid:    min 36 byte char array containing a hex ascii UUID
>>>   *
>>>   * The function will return the first partition which contains a matching
>>>   * UUID value in its partition_meta_info struct.  This does not search
>>>   * by filesystem UUIDs.
>>>   *
>>> + * If @uuid is followed by a ",PARTNROFF=%d", then the number will be
>>> + * extracted and used as an offset from the partition identified by the UUID.
>>> + *
>>>   * Returns the matching dev_t on success or 0 on failure.
>>>   */
>>>  static dev_t devt_from_partuuid(char *uuid_str)
>>> @@ -98,6 +101,16 @@ static dev_t devt_from_partuuid(char *uuid_str)
>>>       dev_t res = 0;
>>>       struct device *dev = NULL;
>>>       u8 uuid[16];
>>> +     struct gendisk *disk;
>>> +     struct hd_struct *part;
>>> +     int offset = 0;
>>> +
>>> +     if (strlen(uuid_str) < 36)
>>> +             goto done;
>>> +
>>> +     /* Check for optional partition number offset attributes. */
>>> +     if (uuid_str[36])
>>> +             sscanf(&uuid_str[36], ",PARTNROFF=%d", &offset);
>>
>> Syntax errors here will be silently ignored.  I expect that's common in
>> this area of code, but please take a look, see if we should do
>> something to help the poor user.
>
> Sounds good. I can see a few ways to bubble up useful information and
> still trigger the classic error path (potential partitions) too, I
> think.
>
>>> @@ -143,8 +171,6 @@ dev_t name_to_dev_t(char *name)
>>>  #ifdef CONFIG_BLOCK
>>>       if (strncmp(name, "PARTUUID=", 9) == 0) {
>>>               name += 9;
>>> -             if (strlen(name) != 36)
>>> -                     goto fail;
>>>               res = devt_from_partuuid(name);
>>>               if (!res)
>>>                       goto fail;
>>
>> The code changes the behaviour of name_to_dev_t(), so we should
>> consider all callers.  That's hibernation, block2mtd and md.  Have you
>> thought about (or perhaps tested) these code paths?  Does it make sense
>> to use the extended syntax in these cases?  Is it possible to do so?
>> Does it work?  etc.
>
> Good question(s) - given that name_to_dev_t is init-internal, I had
> forgotten there were still a fair number of consumers.  I'll review
> the code paths in the places where I can't test them outright and make
> a note and/or appropriate changes.

Upon further inspection, the code changes would not directly break any
existing code, but PARTUUID=...,PARTNROFF= would not be usable via the
other entrypoints to name_to_dev_t.  E.g., block2mtd or md because
they take in comma-separated parameters prior to calling
name_to_dev_t.  That seems like it'd be less than ideal.

Kay,  Do you have a strong preference around the ,PARTNROFF= syntax?
I'm not sure what the cleanest approach is, but I'm inclined to finish
other patch cleanup (and documentation) and repost with '/' as the
separator instead of ','.   At present ',' is reused across several
places where devices are supplied by "name", but '/' is expected as
part of the normal path semantic.  The other option would be to use
':' instead. ':' isn't usually overloaded as it is expected as part of
a the device major:minor naming scheme, but slashes seem more sane
even if weird:

  PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF/PARTNROFF=1

I'll repost along these lines unless someone indicates that this is
too grotesque to consider.

Thanks!
will
