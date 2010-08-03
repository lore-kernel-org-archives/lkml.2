Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab0HCRzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:55:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62548 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab0HCRzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:55:12 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTim=fyBDjZORcBygeb6hXQ1bdruufrF7KLqfUfzK@mail.gmail.com>
References: <1280776623-1337-1-git-send-email-wad@chromium.org>
	<4C583EE6.4030203@kernel.org>
	<AANLkTim=fyBDjZORcBygeb6hXQ1bdruufrF7KLqfUfzK@mail.gmail.com>
Date: Tue, 3 Aug 2010 12:55:10 -0500
Message-ID: <AANLkTi=z+rg7JH97PMswCzL1PXy_SiAQXYrwhF5Q=ZX1@mail.gmail.com>
Subject: Re: [PATCH RFC] efi: add and expose efi_partition_by_guid
From: Will Drewry <wad@chromium.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, axboe@kernel.dk,
        Karel Zak <kzak@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 12:17 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Tue, Aug 3, 2010 at 18:08, Tejun Heo <tj@kernel.org> wrote:
>> On 08/02/2010 09:17 PM, Will Drewry wrote:
>>> EFI's GPT partitioning scheme expects that all partitions have a unique
>>> identifiers.  After initial partition scanning, this information is
>>> completely lost to the rest of the kernel.
>>>
>>> efi_partition_by_guid exposes GPT parsing support in a limited fashion
>>> to allow other portions of the kernel to map a partition from GUID to
>>> map.
>
>> Kay, you were talking about using GUID in GPT for finding out root
>> device and so on.  Does this fit your use case too?  If not it would
>> be nice to find out something which can be shared.
>
> Yeah, we have something similar in mind since a while, to be able to
> safely boot a box without an initramfs, and to be able to to specify
> something like:
>  root=PARTUUID=6547567-575-7567-567567-57
>  root=PARTLABEL=foo
> on the kernel commandline.

Cool. So I'd like this as well (at least the UUID part), and I'd like
this to be available for other consumers in the kernel, like
dm_get_device() or at least for mapped device targets to implement
support for themselves.  (I have a separate patch for
mimicking md= for device mapper devices which I should probably post
to the lists again soon.)

> The current 'blkid' already reports stuff like, to have the same
> information in userspace:
>  $ blkid -p -oudev /dev/sde1
>  ID_FS_LABEL=10GB
>  ID_FS_LABEL_ENC=10GB
>  ID_FS_UUID=5aafa1bb-70a7-4fe6-b93f-30658ec99fac
>  ID_FS_UUID_ENC=5aafa1bb-70a7-4fe6-b93f-30658ec99fac
>  ID_FS_VERSION=1.0
>  ID_FS_TYPE=ext4
>  ID_FS_USAGE=filesystem
>  ID_PART_ENTRY_SCHEME=gpt
>  ID_PART_ENTRY_UUID=1f765dcb-5214-bd47-b1c5-f2f18848335e
>  ID_PART_ENTRY_TYPE=a2a0d0eb-e5b9-3344-87c0-68b6b72699c7
>  ID_PART_ENTRY_NUMBER=1
>
> I guess we want to store these identifiers directly into the partition
> structure, independent of the partition format, so any code can
> register a callback for a new block device, and can just check if
> that's the device in question. Walking the block devices would just be
> something usual provided by the driver core, instead of having some
> specific EFI walk functions.

Yeah - when I use this function, I end up doing a walk over all the
block devices, checking if they are whole disk entries, then calling
the efi_partition_by_guid() function. (Or the walker which I posted
separately.)  It's not ideal but it has the smallest impact on the
existing code. (Not having disk_type available is irritating though.)

Would the type GUID and unique GUID be viable additions to a more
public struct?  If they were CONFIG_EFI_PARTITION guarded, then they
wouldn't waste memory for systems without GPT support, but it seems a
bit specific.  Also, I don't think it'd make sense to put it in the
partition struct as that represents the on-disk format for some tables
(from a quick scan over the code).  However, hd_struct looks the
sanest to me.

I'd be happy to pull together a potential change that exposes this
data once after disk (re)scan, but I'd hate to do so in a way that'd
be fundamentally unacceptable (but I don't want to end up down the
deep hole of adding support across all the part tables either if I can
:).

So I could see something like:

struct hd_struct {
...
#ifdef CONFIG_EFI_PARTITION
  efi_guid_t type_guid;
  efi_guid_t uuid;
  u16 label[72 / ...];
};

Alternatively, a slightly more generic option might be:

#ifdef CONFIG_PARTITION_INFO
  /* ASCII hex-formatted uuids inclusive of hyphens */
  u8 type_guid[MAX_HD_STRUCT_UUID_SIZE];
  u8 uuid[MAX_HD_STRUCT_UUID_SIZE];
  u16 label[MAX_HD_STRUCT_NAME + sizeof(u16)];
#endif


Any way, if any of this seems slightly palatable, let me know.  I'd
love to make this data accessible to the rest of the kernel.

thanks!
will
