Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083Ab1IKNqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 09:46:11 -0400
Received: from nm7-vm0.bullet.mail.ird.yahoo.com ([77.238.189.222]:29107 "HELO
	nm7-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754077Ab1IKNqK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 09:46:10 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 751775.81558.bm@omp1007.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Otk3hhCFLxH7mAwtzlbTNoOCxLP1TB3GTQOahtyr08/FDu6tm0DF6lfNH2QlJ2ka3M8rT0+tDVLXsqV2oS0zmGznvqYie1sjiRRljnubTEK8pSvmB6HCMJiu9t/lz68G1negtscIM55+yuE2ItRyVI0mFavijv7DHlsIFwWHCyk=;
X-YMail-OSG: yCGS894VM1lVNkO8A.ZBJMIim7qHVNMzfsY6jZp4BzK5Lsg
 MuhPnSLHIJuYpOR0JhfnK1lYYZYrbueJVBNR0KvElnDGbhwQtWAjo97SK.RW
 _EAsgjVzZmbvbm552rUA2hFq_n7wrHC8xD.G.Rgg_EAtDteINh2x6E7dadAf
 z8AIDqVLfpJL3lnt651JbQHM8Da29vhAiFE7OKhFt7Vig9rBpNcQO.3RfQXQ
 5Nlj0nEiSrWRtWNpwrLMW.KFYbs4CKURyaUWfFuv80TUs2p14IKC7nQPuUBg
 BPD8MXEzDsNIOVXBPuRSUy9n.PrV1kZbPV66IXATrhR127lCAeQHPstPg3ld
 3MsVulLpEg7GsaHnlu0uuUCaxO7IT9wsX82KSMb3X.ILQ8w6aKmniS8misig
 INqXqSbSrkTeiQrH77xE-
X-Mailer: YahooMailClassic/14.0.5 YahooMailWebService/0.8.113.315625
Message-ID: <1315748768.65310.YahooMailClassic@web29513.mail.ird.yahoo.com>
Date: Sun, 11 Sep 2011 14:46:08 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Pavel Ivanov <paivanof@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@tuxera.com>
In-Reply-To: <CAG1a4rt5wLihR-ZkUD78WRbHk39xWP0ypJzMe4K5G1O-k12-MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sun, 11/9/11, Pavel Ivanov <paivanof@gmail.com> wrote:

> How about the following patch?
> 
> 
> Subject: [PATCH] hfsplus: Allow to mount filesystem with
> block size
> greater than PAGE_SIZE
> 
> Commit c6d5f5fa (hfsplus: lift the 2TB size limit) added
> call to
> generic_check_addressable() but used the system's internal
> block size
> which can be larger than PAGE_SIZE and will cause
> generic_check_addressable() to return -EINVAL in this case.
> This
> results in impossibility to mount file systems with such
> block sizes.
> To fix it we have to use block size understandable by
> generic_check_addressable() and adjust number of blocks
> accordingly.
> 
> Signed-off-by: Pavel Ivanov <paivanof@gmail.com>
> Cc: <stable@kernel.org>
> ---
> 
> diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
> index c106ca2..26ac5a5 100644
> --- a/fs/hfsplus/super.c
> +++ b/fs/hfsplus/super.c
> @@ -399,8 +399,17 @@ static int hfsplus_fill_super(struct
> super_block
> *sb, void *data, int silent)
>      if (!sbi->rsrc_clump_blocks)
>         
> sbi->rsrc_clump_blocks = 1;
> 
> -    err =
> generic_check_addressable(sbi->alloc_blksz_shift,
> -           
>        
> sbi->total_blocks);
> +    /*
> +     * Check that filesystem data
> can be addressed by sector_t. Obvious way
> +     * to do that is to call
> generic_check_addressable with alloc_blksz_shift
> +     * and total_blocks as
> parameters. But alloc_blksz_shift can be greater
> +     * than PAGE_SIZE_SHIFT and
> in this case it won't be accepted by
> +     * generic_check_addressable.
> s_blocksize_bits will always be accepted
> +     * and difference between it
> and alloc_blksz_shift will be always in
> +     * fs_shift.
> +     */
> +    err =
> generic_check_addressable(sb->s_blocksize_bits,
> +           
> (u64)sbi->total_blocks << sbi->fs_shift);
>      if (err) {
>          printk(KERN_ERR
> "hfs: filesystem size too large.\n");
>          goto out_free_vhdr;

Why is the u64 needed? If it is needed, it probably means sbi->total_blocks should have been u64 in the first place.

