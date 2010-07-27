Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab0G0QjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:39:00 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53360 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0G0Qi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:38:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G1loS+DakABq2JadwGe+zZtGceqF75FTyAs0+++SUjrcYIsvfW7tbMmwUuqW+zNI1j
         hVh4vNl/jQzKKODBpCjmtm7aHtBQgTMKGsfHoxi12MXpTnkU7YKKuz75sDxuQjiDGovu
         U0+xhe5FY+yzlfaEh5rOcPAdpvgZOIcd+C/q0=
Date: Tue, 27 Jul 2010 09:38:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH] sysrq: don't hold the sysrq_key_table_lock during
 the handler
Message-ID: <20100727163852.GA5961@core.coreip.homeip.net>
References: <1280138042-1576-1-git-send-email-dfeng@redhat.com>
 <20100726105148.GB14198@hmsreliant.think-freely.org>
 <20100726174153.GD14609@core.coreip.homeip.net>
 <20100726203420.GB18789@hmsreliant.think-freely.org>
 <20100727081552.GB32084@core.coreip.homeip.net>
 <20100727115754.GC6303@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727115754.GC6303@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 07:57:54AM -0400, Neil Horman wrote:
> On Tue, Jul 27, 2010 at 01:15:52AM -0700, Dmitry Torokhov wrote:
> > On Mon, Jul 26, 2010 at 04:34:20PM -0400, Neil Horman wrote:
> > > On Mon, Jul 26, 2010 at 10:41:54AM -0700, Dmitry Torokhov wrote:
> > > > On Mon, Jul 26, 2010 at 06:51:48AM -0400, Neil Horman wrote:
> > > > > On Mon, Jul 26, 2010 at 05:54:02PM +0800, Xiaotian Feng wrote:
> > > > > <snip>
> > > > > 
> > > > > This creates the possibility of a race in the handler.  Not that it happens
> > > > > often, but sysrq keys can be registered and unregistered dynamically.  If that
> > > > > lock isn't held while we call the keys handler, the code implementing that
> > > > > handler can live in a module that gets removed while its executing, leading to
> > > > > an oops, etc.  I think the better solution would be to use an rcu lock here.
> > > > 
> > > > I'd simply changed spinlock to a mutex.
> > > > 
> > > I don't think you can do that safely in this path, as sysrqs will be looked up
> > > in both process (echo t > /proc/sysrq-trigger) context and in interrupt
> > > (alt-sysrq-t) context.  If a mutex is locked and you try to take it in interrupt
> > > context, you get a sleeping-in-interrupt panic IIRC
> > > 
> > 
> > Yes, indeed. But then even RCU will not really help us since keyboard
> > driver will have inpterrupts disabled anyways.
> > 
> 
> Hm, thats true.  I suppose the right thing to do then is grab a reference on any
> sysrq implemented within code that might be considered transient before
> releasing the lock.  I've not tested this patch out, but it should do what we
> need, in that it allows us to release the lock without having to worry about the
> op list changing underneath us, or having the module with the handler code
> dissappear
> 

That would only help if you also offload execution to a workqueue (which
may not be desirable in all cases) since keyboard driver^H^H input core
still calls into SysRq code holding [another] spinlock with interrupts
disabled.

-- 
Dmitry
