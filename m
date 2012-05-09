Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab2EIOBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:01:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab2EIOBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:01:23 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: kdorfman@codeaurora.org
Subject: Re: [PATCH v2 14/16] mmc: block: Implement HPI invocation and handling logic.
Date: Wed, 9 May 2012 14:01:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "Venkatraman S" <svenkatr@ti.com>, linux-mmc@vger.kernel.org,
        cjb@laptop.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.lemberg@sandisk.com, ilan.smith@sandisk.com, lporzio@micron.com,
        rmk+kernel@arm.linux.org.uk
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com> <1336054995-22988-15-git-send-email-svenkatr@ti.com> <3f7a217a08fd2c508576cbac8d26b017.squirrel@www.codeaurora.org>
In-Reply-To: <3f7a217a08fd2c508576cbac8d26b017.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205091401.11894.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:68LsodyIizETltarm6tBmnwOgHySosFvIW59nITylXJ
 GZO36pWQ3l921/lNXDOiZd0zkIIDQzCqEhqaLkSXr9fRL6d8pC
 tCR0j0ghm4ZeIAbCga9x+wsL/OMDk3V0jE3G9Ck5YCzWqtwPeF
 S0eUw5Siyj0vC7FOJNrbcInSjNPBKeXylcicFCheVkh7GO/vRQ
 mu1xtf7ZgS54kWjuYxGsG473ReUFMlEHxlNDBb4kgV3trNr9c3
 zoiw0Ejpj3hvf/DFJz89s4jbnYaLGYR286Utapn+cKjyVTLkNH
 hRr445tsv8F07gbiIRBNdYp0DiV1VMCHOWIn/0i7MuO8vyvbJ4
 P03z3drw326jsW2OrEelRiiB/iP4I+jAKRfcrgl6n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, kdorfman@codeaurora.org wrote:
> > +static bool mmc_can_do_foreground_hpi(struct mmc_queue *mq,
> > +                     struct request *req, unsigned int thpi)
> > +{
> > +
> > +     /*
> > +      * If some time has elapsed since the issuing of previous write
> > +      * command, or if the size of the request was too small, there's
> > +      * no point in preempting it. Check if it's worthwhile to preempt
> > +      */
> > +     int time_elapsed = jiffies_to_msecs(jiffies -
> > +                     mq->mqrq_cur->mmc_active.mrq->cmd->started_time);
> > +
> > +     if (time_elapsed <= thpi)
> > +                     return true;
> Some host controllers (or DMA) has possibility to get the byte count of
> current transaction. It may be implemented as host api (similar to abort
> ops). Then you have more accurate estimation of worthiness.

I'm rather sure that the byte count is not relevant here: it's not
the actual write that is taking so long, it's the garbage collection
that the device does internally before the write actually gets done.
The data transfer is much faster than the time we are waiting for here.

	Arnd
