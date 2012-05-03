Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab2ECPFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:05:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab2ECPFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:05:03 -0400
Message-ID: <4FA29E9E.8090401@suse.de>
Date: Thu, 03 May 2012 17:05:02 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: Kernel oops in sym_int_sir
References: <4FA143BC.2010702@canonical.com>
In-Reply-To: <4FA143BC.2010702@canonical.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 04:25 PM, Stefan Bader wrote:
> While looking at a bug report [1] I found that the immediate cause of the crash
> was in that specific case the reference cp->cmd for a printk:
> 
> /*
>   * The device didn't switch to MSG IN phase after
>   * having reselected the initiator.
>   */
>  case SIR_RESEL_NO_MSG_IN:
>          scmd_printk(KERN_WARNING, cp->cmd,
>                          "No MSG IN phase after reselection\n");
>          goto out_stuck;
> 
> Unfortunately cp (that is returned by sym_ccb_from_dsa()) is NULL. This probably
> is as old as 2.6.24 when this patch added the scmd_printk:
> 
> commit 3fb364e089e05c35ead55a08d56d3004193681f6
> Author: Matthew Wilcox <matthew@wil.cx>
> Date: Fri Oct 5 15:55:10 2007 -0400
> 
>     [SCSI] sym53c8xx: Use scmd_printk where appropriate
> 
> A quick research looks like it might be other cases where this happened[2].
> Maybe more often (or solely?) when running in a VM (KVM). I even found some post
> that looks like it tries to fix just this problem[3].
> 
> However without more knowledge about that driver it could also be a problem in
> the hardware emulation so that normally cp == NULL should never happen. Or it
> might be that the emulation is just running sufficiently "different" to cause
> races to happen which never would be observed on real hardware.
> 
> Would [3] still make sense?
> 
cp->cmd == NULL would point to a race with SCSI command completion,
basically the same issue USB is facing right now.
So yes, it can happen (as you've seen), so I would got for [3].
And if only to avoid the Oops and figure out what _really_ went
wrong here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
