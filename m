Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1GNJrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 05:47:21 -0400
Received: from brockman.in8.de ([85.214.220.56]:46989 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997Ab1GNJrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 05:47:19 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jul 2011 05:47:19 EDT
Message-ID: <4E1EB8E5.3030404@jan-o-sch.net>
Date: Thu, 14 Jul 2011 11:37:41 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Ric Wheeler <rwheeler@redhat.com>,
        Nico Schottelius <nico-lkml-20110623@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: Mis-Design of Btrfs?
References: <20110623105337.GD3753@ethz.ch>	<20110627164637.377314e2@notabene.brown>	<4E0AF091.9030301@redhat.com>	<20110714155620.6e9ac2cc@notabene.brown>	<4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown>
In-Reply-To: <20110714163836.35a729c1@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 14.07.2011 08:38, NeilBrown wrote:
> I imagine a new field in 'struct bio' which was normally zero but could be
> some small integer.  It is only meaningful for read.
> When 0 it means "get this data way you like".
> When non-zero it means "get this data using method N", where the different
> methods are up to the device.
> 
> For a mirrored RAID, method N means read from device N-1.
> For stripe/parity RAID, method 1 means "use other data blocks and parity
> blocks to reconstruct data.
> 
> The default for non RAID devices is to return EINVAL for any N > 0.
> A remapping device (dm-linear, dm-stripe etc) would just pass the number
> down.  I'm not sure how RAID1 over RAID5 would handle it... that might need
> some thought.
> 
> So if btrfs reads a block and the checksum looks wrong, it reads again with
> a larger N.  It continues incrementing N and retrying until it gets a block
> that it likes or it gets EINVAL.  There should probably be an error code
> (EAGAIN?) which means "I cannot work with that number, but try the next one".

I like this idea. It comes pretty close to what btrfs is currently doing
(what was the reason for this thread being started, wasn't it?), only
not within struct bio.

The way you describe the extra parameter is input only. I think it would
be a nice add on if we knew which "N" was used when "0" passed for the
request. At least for the RAID1 case, I'd like to see that when I submit
a bio with method (or whatever we call it) "0", it comes back with the
method field set to the value that reflects the method the device
actually used. Obviously, when passing non-zero values, the bio would
have to come back with that value unmodified.

That way, we'll get more control on the retry algorithms and are free to
decide not to use the failed method again, if we like.

Setting "method" on the return path might be valuable not only for
RAID1, but I haven't thought that trough.

-Jan
