Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2HIR3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:29:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2HIR3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:29:09 -0400
Message-ID: <5023F360.2050409@redhat.com>
Date: Thu, 09 Aug 2012 14:29:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Dave Peterson <dsp@llnl.gov>, kernel-janitors@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re:
References: <20120809135416.GA13100@localhost>
In-Reply-To: <20120809135416.GA13100@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

Em 09-08-2012 10:54, Fengguang Wu escreveu:
...
> Date: Thu, 9 Aug 2012 21:54:16 +0800
> From: Fengguang Wu <fengguang.wu@intel.com>
> To: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Dave Peterson <dsp@llnl.gov>, kernel-janitors@vger.kernel.org,
>         Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
>         linux-kernel@vger.kernel.org
> Message-ID: <20120809135416.GA13100@localhost>
> MIME-Version: 1.0
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> User-Agent: Mutt/1.5.21 (2010-09-15)
> X-RedHat-Spam-Score: -5.111  (BAYES_00,MISSING_SUBJECT,RCVD_IN_DNSWL_HI,T_RP_MATCHES_RCVD)
> X-Scanned-By: MIMEDefang 2.68 on 10.5.11.24
> X-Scanned-By: MIMEDefang 2.68 on 10.5.110.17
>
> Subject: possible double free in edac_mc_alloc()
> Reply-To:
> User-Agent: Heirloom mailx 12.5 6/20/10

There is an extra space between the email headers and the Subject...
due to that I almost deleted this message, considering it as spam.

> 
> Hi,
> 
> coccinelle warns about:
> 
> + drivers/edac/edac_mc.c:429:9-23: ERROR: reference preceded by free on line 429
> 
> and that line does look strange: the 'i' seems like a temporary value
> used in previous loops, and it won't change at all in the current
> loop. Which means the same mci->csrows[i] get freed once and again.
> It might also do double free for the previous kfree(csr) line.
> 
> vim +429 drivers/edac/edac_mc.c
> 
>     416         if (mci->dimms) {
>     417                 for (i = 0; i < tot_dimms; i++)
>     418                         kfree(mci->dimms[i]);
>     419                 kfree(mci->dimms);
>     420         }
>     421         if (mci->csrows) {
>     422                 for (chn = 0; chn < tot_channels; chn++) {
>     423                         csr = mci->csrows[chn];
>     424                         if (csr) {
>     425                                 for (chn = 0; chn < tot_channels; chn++)
>     426						kfree(csr->channels[chn]);
>     427					kfree(csr);
>     428				}
>   > 429				kfree(mci->csrows[i]);

It should likely be:
	kfree(mci->csrows[csr])
instead. This is likely due to one of the countless rebases I had to do on it,
in order to make everybody happy. I suspect that, in the past, this loop was also
using 'i' as the index variable.

Care to write us a patch fixing it? My HD crashed yesterday... I'm somewhat
busy today recovering from it, and doing some backup/restore stuff.

Thanks!
Mauro

>     430			}
>     431			kfree(mci->csrows);
>     432		}
> 
> ---
> 0-DAY kernel build testing backend         Open Source Technology Centre
> Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation
> 

