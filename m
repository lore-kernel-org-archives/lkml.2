Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936687Ab0COUMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:12:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38369 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936641Ab0COUMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:12:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B9E94AA.1030405@s5r6.in-berlin.de>
Date: Mon, 15 Mar 2010 21:12:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       diegoliz@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH] staging: winbond: mds.c whitspace, indentation etc.
References: <1268670973-6223-1-git-send-email-lindley@coyote.org>
In-Reply-To: <1268670973-6223-1-git-send-email-lindley@coyote.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Lindley wrote:
> I fixed most of the problems found by checkpatch.pl.
> Some long lines are left and some KERN_..
> This is a new revised patch against master with changes
> after comments from Stefan Richter and Dan Carpenter.
> Forget the old one.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---
>  drivers/staging/winbond/mds.c |  652 ++++++++++++++++++++++-------------------
>  1 files changed, 351 insertions(+), 301 deletions(-)

Lars, thanks for the revision.  The patch can surely go in as-is.  But
let me comment on some small things to take into consideration in future
updates of this kind.

[...]
> +	if (!boGroupAddr) {
> +		/*NOTE : If the protection mode is enabled and the MSDU will be
> +		 *	 fragmented, the tx rates of MPDUs will all be DSSS
> +		 *	 rates. So it will not use CTS-to-self in this case.
> +		 *	 CTS-To-self will only be used when without
> +		 *	 fragmentation. -- 20050112
> +		 */

/*
 * In the canonical multi-line comment form, the first line contains
 * only the /* characters but no text.
 */

[...]
> +			} else {
> +				/* CTS + 1 SIFS + CTS duration
> +				 * CTS Rate : ?? Mega bps
> +				 * CTS frame length = 14 bytes
> +				 */
> +			    if (pT01->T01_plcp_header_length) /*long preamble*/
> +				Duration += LONG_PREAMBLE_PLUS_PLCPHEADER_TIME;
> +			    else
> +				Duration += SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
> +
> +				Duration += (((112 + Rate - 1) / Rate)
> +						+ DEFAULT_SIFSTIME);
>  			}
>  		}

There is still this one indentation by 3 tabs plus 4 spaces, which
should be 4 tabs (and the next level 5 tabs of course).  However, this
only shows the /real/ problem here:  Mds_DurationSet() is too long a
function, doing too much with too deep nesting.  Other functions in
mds.c with this problem are Mds_BodyCopy(), Mds_Tx(),
Mds_SendComplete()... IOW the majority of this file.

Eventually, somebody who knows what the sub-blocks of these functions
are for should break them out into own small functions with fitting
names.  Since I am entirely oblivious about WLAN things, I can't propose
a patch myself though.

(Needless to say, such a refactoring update should not be done within in
a large-scale whitespace cleanup patch to minimize the risk of mistakes.)

[...]
> -			//----20061009 add by anson's endian
> +			/* ----20061009 add by anson's endian */
>  			pNextT00->value = cpu_to_le32(pNextT00->value);
> -			pT01->value = cpu_to_le32( pT01->value );
> -			//----end 20061009 add by anson's endian
> +			pT01->value = cpu_to_le32(pT01->value);
> +			/* ----end 20061009 add by anson's endian */

Code history information went into a comment here.  Elsewhere too.

>  			buffer += OffsetSize;
> -			pT01 = (PT01_DESCRIPTOR)(buffer+4);
> -			if (i != 1)	//The last fragment will not have the next fragment
> -				pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
> +			pT01 = (PT01_DESCRIPTOR)(buffer + 4);
> +			if (i != 1)	/* The last fragment will not have the
> +					 * next fragment
> +					 */
> +				pNextT00 = (PT00_DESCRIPTOR)(buffer + OffsetSize);
>  		}

This iss seen multiple times in your patch.  IMO it would have been
better for readability if you kept such comments as single-line
comments, crossing the 80 characters boundary (which is a guideline, not
a dogma).  I.e.:

if (i != 1) /* last fragment won't have the next fragment */
	pNextT00 = (PT00_DESCRIPTOR)(buffer + OffsetSize);

or much better:

/* The last fragment will not have the next fragment */
if (i != 1)
	pNextT00 = (PT00_DESCRIPTOR)(buffer + OffsetSize);

There are many instances in this file where a comment would IMO be
better placed above a statement rather than behind a statement.

[...]
> -	// Set more frag bit
> -	TargetBuffer[1] |= 0x04;// Set more frag bit
> +	/* Set more frag bit */
> +	TargetBuffer[1] |= 0x04;/* Set more frag bit*/

Duplicate comment.

[...]
> -		if( ctmp1 == 108) ctmp2 = 7;
> -		else if( ctmp1 == 96 ) ctmp2 = 6; // Rate convert for USB
> -		else if( ctmp1 == 72 ) ctmp2 = 5;
> -		else if( ctmp1 == 48 ) ctmp2 = 4;
> -		else if( ctmp1 == 36 ) ctmp2 = 3;
> -		else if( ctmp1 == 24 ) ctmp2 = 2;
> -		else if( ctmp1 == 18 ) ctmp2 = 1;
> -		else if( ctmp1 == 12 ) ctmp2 = 0;
> -		else if( ctmp1 == 22 ) ctmp2 = 3;
> -		else if( ctmp1 == 11 ) ctmp2 = 2;
> -		else if( ctmp1 == 4  ) ctmp2 = 1;
> -		else ctmp2 = 0; // if( ctmp1 == 2  ) or default
> -
> -		if( i == 0 )
> +		pMds->TxRate[pDes->Descriptor_ID][i] = ctmp1; /* backup the ta
> +							       * rate and fall
> +							       * back rate
> +							       */
> +
> +		if (ctmp1 == 108)
> +			ctmp2 = 7;
> +		else if (ctmp1 == 96)
> +			ctmp2 = 6;	/* Rate convert for USB */
> +		else if (ctmp1 == 72)
> +			ctmp2 = 5;
> +		else if (ctmp1 == 48)
> +			ctmp2 = 4;
> +		else if (ctmp1 == 36)
> +			ctmp2 = 3;
> +		else if (ctmp1 == 24)
> +			ctmp2 = 2;
> +		else if (ctmp1 == 18)
> +			ctmp2 = 1;
> +		else if (ctmp1 == 12)
> +			ctmp2 = 0;
> +		else if (ctmp1 == 22)
> +			ctmp2 = 3;
> +		else if (ctmp1 == 11)
> +			ctmp2 = 2;
> +		else if (ctmp1 == 4)
> +			ctmp2 = 1;
> +		else
> +			ctmp2 = 0;	/* if (ctmp1 == 2) or default */

This should be written as a "switch (ctmp1)" block.  (Also something
that is better done separately from a wholesale whitespace cleanup.)
-- 
Stefan Richter
-=====-==-=- --== -====
http://arcgraph.de/sr/
