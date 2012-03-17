Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2CQDGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 23:06:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48145 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2CQDGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 23:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1203152149190.20644@file.rdu.redhat.com>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
	<Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
	<20120306215947.GB27051@google.com>
	<Pine.LNX.4.64.1203131742230.24876@file.rdu.redhat.com>
	<CABqD9hYUVpC-NQ_WQ5bH8ZxLein+zxHQHDGJzwyRWHokMiPSbg@mail.gmail.com>
	<Pine.LNX.4.64.1203152149190.20644@file.rdu.redhat.com>
Date: Fri, 16 Mar 2012 22:06:10 -0500
Message-ID: <CABqD9hav7MCrCfJ-5k0duvitXh2AOSk2of1MFZZmyv=kmoXb8w@mail.gmail.com>
Subject: Re: [PATCH] dm: remake of the verity target
From: Will Drewry <wad@chromium.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        Elly Jones <ellyjones@chromium.org>, Milan Broz <mbroz@redhat.com>,
        Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 8:16 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> Hi Will
>
>
> On Wed, 14 Mar 2012, Will Drewry wrote:
>
>> Hi Mikulas,
>>
>> This is a nice rewrite and takes advantage of your dm-bufio layer. I
>> wish it'd existed (and or we wrote it :) in 2009 when we started this
>> work!  Some comments below:
>>
>> > ---
>> > +static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
>> > +{
>> > +       int i;
>> > +       for (i = v->levels - 2; i >= 0; i--) {
>> > +               sector_t hash_block_start;
>> > +               sector_t hash_block_end;
>> > +               verity_hash_at_level(v, io->block, i, &hash_block_start, NULL);
>> > +               verity_hash_at_level(v, io->block + io->n_blocks - 1, i, &hash_block_end, NULL);
>> > +               if (!i) {
>> > +                       unsigned cluster = prefetch_cluster;
>> > +        /* barrier to stop GCC from re-reading prefetch_cluster again */
>> > +                       barrier();
>> > +                       cluster >>= v->data_dev_block_bits;
>>
>> Would:
>>   unsigned cluster = prefetch_cluster >> v->data_dev_block_bits;
>> not have similar behavior without a barrier?  (Yeah yeah I could
>> compile and see, but I was curious if you already had.)
>>
>> Since the max iterations here is 61 in a worst-case, I don't think
>> it's a big deal to barrier() each time, just thought I'd ask.
>>
>> > +                       if (unlikely(!cluster))
>> > +                               goto no_prefetch_cluster;
>> > +                       if (unlikely(cluster & (cluster - 1)))
>> > +                               cluster = 1 << (fls(cluster) - 1);
>> > +
>> > +                       hash_block_start &= ~(sector_t)(cluster - 1);
>> > +                       hash_block_end |= cluster - 1;
>> > +                       if (unlikely(hash_block_end >= v->hash_blocks))
>> > +                               hash_block_end = v->hash_blocks - 1;
>> > +               }
>> > +no_prefetch_cluster:
>> > +               dm_bufio_prefetch(v->bufio, hash_block_start,
>> > +                                       hash_block_end - hash_block_start + 1);
>
> The problem here is this. If you look at the code, you think that after
> the clause "if (unlikely(!cluster)) goto no_prefetch_cluster;", cluster
> can't be zero. But this assumption is wrong. The C compiler is allowed to
> transform the above code into:
>
> unsigned cluster;
> if (!(prefetch_cluster >> v->data_dev_block_bits))
>        goto no_prefetch_cluster;
> cluster = prefetch_cluster >> v->data_dev_block_bits;
> if (unlikely(cluster & (cluster - 1)))
>        cluster = 1 << (fls(cluster) - 1);
>
> I know it's suboptimal, but the C compiler is just allowed to perform this
> transformation. Now, if you know that "prefetch_cluster" can change
> asynchronously by another thread running simultaneously, the condition "if
> (!(prefetch_cluster >> v->data_dev_block_bits))" is useless ---
> prefetch_cluster may change just after this condition and we won't catch
> the zero value. (if the cluster value is zero in the above code, it ends
> up in hash_block_end being ORed with -1 and the prefetch goes wild over
> the whole hash device).
>
> That's why I put that "barrier()" there. It would be better to declare
> "prefetch_cluster" as volatile, but the module param macros issue warnings
> if the variable is volatile.
>
> Or maybe I can change it this way:
> "unsigned cluster = *(volatile unsigned *)&prefetch_cluster", it could be
> better than the "barrier()".

I think that'd read a little bit more clearly, and I think the C
standard supports that approach. If it doesn't work in practice, the
barrier isn't the worst.

>> > +       case STATUSTYPE_TABLE:
>> > +               DMEMIT("%u %s %s %llu %u %s ",
>> > +                       0,
>> > +                       v->data_dev->name,
>> > +                       v->hash_dev->name,
>>
>> I understand the new approach is to use major:minor instead of the
>> device name.  I don't care which, but I believe agk@ requested that.
>
> All the device mappers report dm_dev->name in their status routine, so I
> do it this way too.
>
>> > +static int verity_ioctl(struct dm_target *ti, unsigned cmd,
>> > +                       unsigned long arg)
>> > +{
>> > +       struct dm_verity *v = ti->private;
>> > +       int r = 0;
>> > +
>> > +       if (v->data_start ||
>> > +           ti->len != i_size_read(v->data_dev->bdev->bd_inode) >> SECTOR_SHIFT)
>> > +               r = scsi_verify_blk_ioctl(NULL, cmd);
>> > +
>>
>> Is it worth supporting ioctl at all given these hoops?  Nothing stops
>> a privileged user from directly running the ioctl on the underlying
>> device/devices, it's just very inconvenient :)
>
> I don't know. The other dm targets attempt to pass-thru ioctls too.
>
> You need ioctl pass-thru if you want to run it over a cd-rom because
> the iso9660 filesystem needs to send an ioctl to find its superblock.
> Other than that I don't know if other filesystems need ioctls.

Makes sense. I just think the passthrough condition is ugly, but at
least it provides some support.

>> > +       if (ti->len > i_size_read(v->data_dev->bdev->bd_inode) >> SECTOR_SHIFT) {
>> > +               ti->error = "Data device si too small";
>>
>> s/si/is
>>
>> Should this also check ti->start + ti->len to ensure it isn't reading
>> off the end or do you just rely on the requests failing?
>
> ti->start is the offset in the target table --- so it shouldn't be checked
> here (for example, you can map a verity device having 1024 blocks to a
> sector offset 1000000 in the table --- so ti->start == 1000000 and ti->len
> == 1024 --- in this case, you have test that the underlying device has at
> least 1024 blocks, but you shouldn't test it for 1000000 sectors ---
> 1000000 is offset in the table, not required device size.
>
> But this reminds me that I had the size test wrong in verity_map ...
> fixed.

Well at least some good came of it!  I typed ti->start, but I had mean
v->data_start.  However, I was misinterpreting the i_size_read as
giving the last sector not the actual size, so my comment was still
pointless.

>> > +MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
>>
>> As per linux/module.h, I'd welcome additional authors as per the
>> lkml/patch lineage:
>> MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
>> MODULE_AUTHOR("Will Drewry <wad@chromium.org>");
>
> OK, I added you there.

Very much appreciated.

>> Regardless, I'll just be happy to see this functionality merge.
>>
>> > +MODULE_DESCRIPTION(DM_NAME " target for transparent disk integrity checking");
>> > +MODULE_LICENSE("GPL");
>> > +
>> > Index: linux-3.3-rc6-fast/drivers/md/dm-bufio.c
>>
>> This should be in a separate patch I think.
>
> Yes, it is a separate patch.
>
>> >                b->hold_count++;
>>
>> Are these hold_counts safe on architectures with weak memory models?
>> Should they be atomic_ts?   I haven't looked at them in context, but
>> based on what I see here they make me a bit nervous.
>>
>> Thanks for jumping in to the fray!  None of my comments are blocking,
>> so I believe the following is appropriate (if not
>> s/Signed-off/Reviewed-by/).
>>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>>
>> cheers!
>> will
>
> hold_count is read or changed only when we hold dm_bufio_client->lock, so
> it doesn't have to be atomic.

Ah nice!  The little snippet had me worried, but I should've looked at
the full context first.

Thanks!
will
