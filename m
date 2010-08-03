Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab0HCRSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:18:05 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44431 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab0HCRSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:18:03 -0400
MIME-Version: 1.0
In-Reply-To: <4C583EE6.4030203@kernel.org>
References: <1280776623-1337-1-git-send-email-wad@chromium.org> 
	<4C583EE6.4030203@kernel.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 3 Aug 2010 19:17:15 +0200
Message-ID: <AANLkTim=fyBDjZORcBygeb6hXQ1bdruufrF7KLqfUfzK@mail.gmail.com>
Subject: Re: [PATCH RFC] efi: add and expose efi_partition_by_guid
To: Tejun Heo <tj@kernel.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jens.axboe@oracle.com>, Karel Zak <kzak@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 18:08, Tejun Heo <tj@kernel.org> wrote:
> On 08/02/2010 09:17 PM, Will Drewry wrote:
>> EFI's GPT partitioning scheme expects that all partitions have a unique
>> identifiers.  After initial partition scanning, this information is
>> completely lost to the rest of the kernel.
>>
>> efi_partition_by_guid exposes GPT parsing support in a limited fashion
>> to allow other portions of the kernel to map a partition from GUID to
>> map.

> Kay, you were talking about using GUID in GPT for finding out root
> device and so on.  Does this fit your use case too?  If not it would
> be nice to find out something which can be shared.

Yeah, we have something similar in mind since a while, to be able to
safely boot a box without an initramfs, and to be able to to specify
something like:
  root=PARTUUID=6547567-575-7567-567567-57
  root=PARTLABEL=foo
on the kernel commandline.

The current 'blkid' already reports stuff like, to have the same
information in userspace:
  $ blkid -p -oudev /dev/sde1
  ID_FS_LABEL=10GB
  ID_FS_LABEL_ENC=10GB
  ID_FS_UUID=5aafa1bb-70a7-4fe6-b93f-30658ec99fac
  ID_FS_UUID_ENC=5aafa1bb-70a7-4fe6-b93f-30658ec99fac
  ID_FS_VERSION=1.0
  ID_FS_TYPE=ext4
  ID_FS_USAGE=filesystem
  ID_PART_ENTRY_SCHEME=gpt
  ID_PART_ENTRY_UUID=1f765dcb-5214-bd47-b1c5-f2f18848335e
  ID_PART_ENTRY_TYPE=a2a0d0eb-e5b9-3344-87c0-68b6b72699c7
  ID_PART_ENTRY_NUMBER=1

I guess we want to store these identifiers directly into the partition
structure, independent of the partition format, so any code can
register a callback for a new block device, and can just check if
that's the device in question. Walking the block devices would just be
something usual provided by the driver core, instead of having some
specific EFI walk functions.

Kay
