Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab1D1Nm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:42:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60111 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1D1NmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:42:25 -0400
Subject: Re: [BUG] fatal hang untarring 90GB file, possibly writeback
 related.
From: Colin Ian King <colin.king@ubuntu.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: James Bottomley <james.bottomley@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
In-Reply-To: <1303993705-sup-5213@think>
References: <1303920553.2583.7.camel@mulgrave.site>
	 <1303921583-sup-4021@think> <1303923000.2583.8.camel@mulgrave.site>
	 <1303923177-sup-2603@think> <1303924902.2583.13.camel@mulgrave.site>
	 <1303925374-sup-7968@think> <1303926637.2583.17.camel@mulgrave.site>
	 <1303934716.2583.22.camel@mulgrave.site> <1303990590.2081.9.camel@lenovo>
	 <1303993705-sup-5213@think>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 14:42:20 +0100
Message-ID: <1303998140.2081.11.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2011-04-28 at 08:29 -0400, Chris Mason wrote:
> Excerpts from Colin Ian King's message of 2011-04-28 07:36:30 -0400:
> > One more data point to add, I've been looking at an identical issue when
> > copying large amounts of data.  I bisected this - and the lockups occur
> > with commit 
> > 3e7d344970673c5334cf7b5bb27c8c0942b06126 - before that I don't see the
> > issue. With this commit, my file copy test locks up after ~8-10
> > iterations, before this commit I can copy > 100 times and don't see the
> > lockup.
> 
> Well, that's really interesting.  I tried with compaction on here and
> couldn't trigger it, but this (very very lightly) tested patch might
> help.
> 
Thanks Chris,

I've given this a soak test but I still see the same lockup.

> It moves the writeout throttle before the goto restart, and also makes
> sure we do at least one cond_resched before we loop.
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6771ea7..cb08b41 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1934,12 +1934,14 @@ restart:
>  	if (inactive_anon_is_low(zone, sc))
>  		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
>  
> +	throttle_vm_writeout(sc->gfp_mask);
> +
>  	/* reclaim/compaction might need reclaim to continue */
>  	if (should_continue_reclaim(zone, nr_reclaimed,
> -					sc->nr_scanned - nr_scanned, sc))
> +					sc->nr_scanned - nr_scanned, sc)) {
> +		cond_resched();
>  		goto restart;
> -
> -	throttle_vm_writeout(sc->gfp_mask);
> +	}
>  }
>  
>  /*


