Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1GFSBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:01:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38669 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab1GFSBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110705135348.cb835073.akpm@linux-foundation.org>
References: <1309468207-24199-1-git-send-email-wad@chromium.org>
	<20110705135348.cb835073.akpm@linux-foundation.org>
Date: Wed, 6 Jul 2011 13:01:12 -0500
Message-ID: <CABqD9hY7xLWLeeFiKGdMT8VveXQAv3PgC-ZGPdd4qO1AfgDZWw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] init: add root=PARTUUID=UUID/PARTNROFF=%d support
From: Will Drewry <wad@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        Jens Axboe <jaxboe@fusionio.com>, Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 3:53 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 30 Jun 2011 16:10:06 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> Expand root=PARTUUID=UUID syntax to support selecting a root partition
>> by integer offset from a known, unique partition.  This approach
>> provides similar properties to specifying a device and partition number,
>> but using the UUID as the unique path prior to evaluating the offset.
>>
>> For example,
>>   root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B/PARTNROFF=1
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
>> ...
>>
>>  static dev_t devt_from_partuuid(char *uuid_str)
>> @@ -98,6 +101,22 @@ static dev_t devt_from_partuuid(char *uuid_str)
>>       dev_t res = 0;
>>       struct device *dev = NULL;
>>       u8 uuid[16];
>> +     struct gendisk *disk;
>> +     struct hd_struct *part;
>> +     int offset = 0;
>> +
>> +     if (strlen(uuid_str) < 36)
>> +             goto done;
>
> I think this secretly changes behaviour?  Previously the code would have
> accepted a less-than-36-byte UUID and would have done <something> with
> it.  Now, it fails.
>
> What was <something>, and what is the reason for this (undocumented!)
> change?

Nice catch.  Initially and currently, the only caller to
devt_from_partuuid is name_to_dev_t.  name_to_dev_t() was forking on
PARTUUID and length == UUID length.  However, if someone had called
directly into devt_from_partuuid, no bounds checking would've occurred
and out of bounds reads may have resulted.

This just moves the check into devt_from_partuuid to unify the length
checking logic with the functional logic.  Now devt_from_partuuid is
safer (kinda) for other init-time callers and allows for detecting
additions.  (E.g., if Kay wants to add more / arguments.)

>> +     /* Check for optional partition number offset attributes. */
>> +     if (uuid_str[36]) {
>> +             /* Explicitly fail on poor PARTUUID syntax. */
>> +             if (sscanf(&uuid_str[36], "/PARTNROFF=%d", &offset) != 1) {
>> +                     printk(KERN_ERR "VFS: PARTUUID= is invalid.\n"
>> +                      "Expected PARTUUID=<valid-uuid-id>[/PARTNROFF=%%d]\n");
>
> The check isn't complete - afacit input of the form PARTNROFF=42foo
> will be treated as PARTNROFF=42?

Completely true.  I can post another version that either pulls a
trailing %c (which should fail) or uses %n.  I have somewhat limited
internet connectivity right now, but I will follow up with a final
clean up when I can (>~week)

Thanks for the close review!
will
