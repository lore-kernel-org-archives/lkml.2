Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab1DWA4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 20:56:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55643 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab1DWA4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 20:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ajLgUDVPe2orWsMmsQI99xd63MLE5SmZHI6MRqiC1b4z8HLRhGAHLpTrrnvaMT6+cT
         EQeMXsHaycHOMI+s1H94g5jqq0kfcQSUq6Lp2nM6dgu32Mv0pymH/YIZ/BC/QarOV3yf
         x9ekt87tcym1dChSRd2anfhpoTVZQg4ViIFSM=
Date: Sat, 23 Apr 2011 02:56:10 +0200
From: Tejun Heo <htejun@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110423005610.GC1576@mtj.dyndns.org>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA45CA7.9040102@teksavvy.com>
 <4DA467FB.6020905@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA467FB.6020905@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about delay.  -EWASTRAVELING

On Tue, Apr 12, 2011 at 10:55:55AM -0400, Mark Lord wrote:
> >> One thing I noticed was that there is no spinlock around the
> >> mv_save_cached_regs/mv_edma_cfg in mv_hardreset (unlike mv_port_start and
> >> mv_port_stop); why is this?
> > 
> > The mv_hardreset path is run from a libata-eh thread,
> > and it assumes it has exclusive access to the hardware.
> 
> Mmm.. another suspect is sata_mv's ".sff_irq_clear" function.
> I don't see any locking in libata-sff.c before calling that one.
> 
> Tejun -- should libata-sff grab ap->lock before calling .sff_irq_clear,
> or is that up to the LLD to do?

It depends.  The basic assumption is that inside a single port, most
of exclusions are achieved implicit either by command protocol or
freeze/thaw mechanism - ie. either the port is in known state and
accesses are interlocked or the port is frozen and irq handler won't
do anything interfering with EH until EH brings the port back to sane
state.  If something goes wrong in the process, the port will get
frozen and reset, so we should be able to survive most conditions.

Ports on the same host are a bit more complicated.  Only a single EH
can proceed on a host.  ie. EHs for two separate ports won't proceed
at the same time (ap->eh_owner); however, this doesn't prevent from
normal issue path of another path racing with EH of another port.  In
this case, the EH routine should grab the host lock explicitly.  The
latter case wasn't common so the compromise for simplicity.

Thanks.

-- 
tejun
