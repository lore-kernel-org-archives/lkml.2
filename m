Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2JDWt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:49:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38214 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755203Ab2JDWtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:49:55 -0400
Date: Thu, 4 Oct 2012 23:49:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20121004224950.GL13292@decadent.org.uk>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225203.249985461@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001225203.249985461@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 133/180] cciss: fix incorrect scsi status reporting
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:54:10AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> commit b0cf0b118c90477d1a6811f2cd2307f6a5578362 upstream.
> 
> Delete code which sets SCSI status incorrectly as it's already been set
> correctly above this incorrect code.  The bug was introduced in 2009 by
> commit b0e15f6db111 ("cciss: fix typo that causes scsi status to be
> lost.")

That commit was in 2.6.33 and it changed the '<' to '<<'.  It hasn't
been backported to 2.6.32.y.
 
[...]
> diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
> index 3315268..ad8e592 100644
> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -747,17 +747,7 @@ complete_scsi_command( CommandList_struct *cp, int timeout, __u32 tag)
>  		{
>  			case CMD_TARGET_STATUS:
>  				/* Pass it up to the upper layers... */
> -				if( ei->ScsiStatus)
> -                		{
> -#if 0
> -                    			printk(KERN_WARNING "cciss: cmd %p "
> -					"has SCSI Status = %x\n",
> -                        			cp,  
> -						ei->ScsiStatus); 
> -#endif
> -					cmd->result |= (ei->ScsiStatus < 1);
[...]

Unless ei->ScsiStatus can be negative (it is declared as int, but
I don't think it's actually meant to be negative), this statement
is a no-op.  (It was present for the entire life of this driver up
until 2.6.33, so I suspect that is the case.)  So this backported
patch is unnecessary cleanup, not a bug fix.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
