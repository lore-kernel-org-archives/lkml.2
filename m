Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab0LMSYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:24:53 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47332 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab0LMSYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 13:24:51 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/35] writeback: increase min pause time on concurrent dirtiers
In-Reply-To: Your message of "Mon, 13 Dec 2010 22:47:02 +0800."
             <20101213150328.284979629@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <20101213144646.341970461@intel.com>
            <20101213150328.284979629@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1292264611_4828P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Dec 2010 13:23:31 -0500
Message-ID: <15881.1292264611@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020207.4D0664A6.00E7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1292264611_4828P
Content-Type: text/plain; charset=us-ascii

On Mon, 13 Dec 2010 22:47:02 +0800, Wu Fengguang said:
> Target for >60ms pause time when there are 100+ heavy dirtiers per bdi.
> (will average around 100ms given 200ms max pause time)

> --- linux-next.orig/mm/page-writeback.c	2010-12-13 21:46:16.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2010-12-13 21:46:16.000000000 +0800
> @@ -659,6 +659,27 @@ static unsigned long max_pause(unsigned 
>  }
>  
>  /*
> + * Scale up pause time for concurrent dirtiers in order to reduce CPU overheads.
> + * But ensure reasonably large [min_pause, max_pause] range size, so that
> + * nr_dirtied_pause (and hence future pause time) can stay reasonably stable.
> + */
> +static unsigned long min_pause(struct backing_dev_info *bdi,
> +			       unsigned long max)
> +{
> +	unsigned long hi = ilog2(bdi->write_bandwidth);
> +	unsigned long lo = ilog2(bdi->throttle_bandwidth);
> +	unsigned long t;
> +
> +	if (lo >= hi)
> +		return 1;
> +
> +	/* (N * 10ms) on 2^N concurrent tasks */
> +	t = (hi - lo) * (10 * HZ) / 1024;

Either I need more caffeine, or the comment doesn't match the code
if HZ != 1000?

--==_Exmh_1292264611_4828P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNBmSjcC3lWbTT17ARAhaGAJ4hO1vSUX2dOFYhTxtx4nolhPInvQCg+b7T
10xDTpJ05qAcw1zJI4oYpr0=
=JhtH
-----END PGP SIGNATURE-----

--==_Exmh_1292264611_4828P--

