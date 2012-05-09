Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2EIG52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:57:28 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37791 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2EIG51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:57:27 -0400
Date: Wed, 9 May 2012 01:57:17 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: [ 024/167] [PATCH] md: dont call ->add_disk unless there is good
 reason.
Message-ID: <20120509065717.GB32230@burratino>
References: <20120509055029.588587017@decadent.org.uk>
 <20120509055032.897593072@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509055032.897593072@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ben Hutchings wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.
[...]
> commit ed209584c38fb74b7eecc03e5b1bfe674e591bd8 upstream.
>
> Commit 7bfec5f35c68121e7b18
>
>    md/raid5: If there is a spare and a want_replacement device, start replacement.
>
> cause md_check_recovery to call ->add_disk much more often.
> Instead of only when the array is degraded, it is now called whenever
> md_check_recovery finds anything useful to do, which includes
> updating the metadata for clean<->dirty transition.
> This causes unnecessary work, and causes info messages from ->add_disk
> to be reported much too often.

Does 3.2.y need this?  Commit 7bfec5f35c68121e7b18 (aka v3.3-rc3~3^2~22)
does not seem to be part of the 3.2-stable tree.

Jonathan

> So refine md_check_recovery to only do any actual recovery checking
> (including ->add_disk) if MD_RECOVERY_NEEDED is set.
> 
> This fix is suitable for 3.3.y:
> 
> Reported-by: Jan Ceuleers <jan.ceuleers@computer.org>
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/md/md.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b572e1e..8beb19c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7560,14 +7560,14 @@ void md_check_recovery(struct mddev *mddev)
>  		 * any transients in the value of "sync_action".
>  		 */
>  		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> -		clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>  		/* Clear some bits that don't mean anything, but
>  		 * might be left set
>  		 */
>  		clear_bit(MD_RECOVERY_INTR, &mddev->recovery);
>  		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
>  
> -		if (test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
> +		if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> +		    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
>  			goto unlock;
>  		/* no recovery is running.
>  		 * remove any failed drives, then
