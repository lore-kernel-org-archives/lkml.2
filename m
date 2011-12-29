Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1L2RGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 12:06:35 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40775 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1L2RGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 12:06:33 -0500
MIME-Version: 1.0
Date: Thu, 29 Dec 2011 20:06:32 +0300
Message-ID: <CA+X1aCQRpJ_NwJBSBp+vDN37p+oipJNz=6T5LdJdqzxTiSWWWA@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: psusi@cfl.rr.com
Cc: vgoyal@redhat.com, joe@perches.com, kzak@redhat.com,
        linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip,

The patch seems to have some problems:

1. Typo in part_nr_sects_write_begin:

> +	write_seqcount_begin(&seq);

It should be write_seqcount_begin(seq). Similar issue in
part_nr_sects_write_end().

2. part_nr_sects_write_begin/end is never called.

3. part->seq should be initialized with seqcount_init().

Btw, do we really need both part_nr_sects_write_begin and
part_nr_sects_write_end? What about:

#if BITS_PER_LONG == 32 && defined(CONFIG_LBDAF)
static inline void part_nr_sects_write(struct hd_struct *part,
sector_t nr_sects)
{
        write_seqcount_begin(&part->seq);
        part->nr_sects = nr_sects;
        write_seqcount_end(&part->seq);
}
#else
static inline void part_nr_sects_write(struct hd_struct *part,
sector_t nr_sects)
{
        part->nr_sects = nr_sects;
}
#endif

and use part_nr_sects_write(part, length) instead of part->nr_sects =
length in case BLKPG_RESIZE_PARTITION?

Thanks,
Maxim
