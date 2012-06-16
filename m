Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2FPP2l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 11:28:41 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50299 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2FPP2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 11:28:40 -0400
Date: Sat, 16 Jun 2012 08:28:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Fengguang Wu <wfg@linux.intel.com>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] printk: use logbuf_mutex_lock to stop syslog_seq
 from going wild
Message-ID: <20120616152836.GB7914@kroah.com>
References: <1339821655-14059-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1339850558.905.10.camel@foo>
 <20120616125922.GE2231@yliu-dev.sh.intel.com>
 <20120616132052.GA12272@localhost>
 <20120616132832.GG2231@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120616132832.GG2231@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 09:28:32PM +0800, Yuanhan Liu wrote:
> On Sat, Jun 16, 2012 at 09:20:52PM +0800, Fengguang Wu wrote:
> > On Sat, Jun 16, 2012 at 08:59:22PM +0800, Yuanhan Liu wrote:
> > > On Sat, Jun 16, 2012 at 02:42:38PM +0200, Kay Sievers wrote:
> > > > On Sat, 2012-06-16 at 12:40 +0800, Yuanhan Liu wrote:
> > > > > Although syslog_seq and log_next_seq stuff are protected by logbuf_lock
> > > > > spin log, it's not enough. Say we have two processes A and B, and let
> > > > > syslog_seq = N, while log_next_seq = N + 1, and the two processes both
> > > > > come to syslog_print at almost the same time. And No matter which
> > > > > process get the spin lock first, it will increase syslog_seq by one,
> > > > > then release spin lock; thus later, another process increase syslog_seq
> > > > > by one again. In this case, syslog_seq is bigger than syslog_next_seq.
> > > > > And latter, it would make:
> > > > >    wait_event_interruptiable(log_wait, syslog != log_next_seq)
> > > > > don't wait any more even there is no new write comes. Thus it introduce
> > > > > a infinite loop reading.
> > > > 
> > > > Oh, multiple readers on the same shared file descriptor are not useful,
> > > > but sure, that needs fixing. Thanks for tracking that down!
> > > > 
> > > > Looks like the same issue existed in the original code already, it's
> > > > just that it was granular at a single character level, and not a line,
> > > > and the seqnum which icreases one-by-one, so the issue was hard to
> > > > trigger.
> > > 
> > > Yes,  I think so, too.
> > > 
> > > > 
> > > > We better make the mutexes interruptible, right?
> > > 
> > > Yes, you are right.
> > 
> > It might be better to do them in two standalone patches?
> > One is a bug fix, the other improves user responsiveness.
> > 
> > Either way, you may add my superficial
> > 
> > Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>
> 
> Too late; I just sent it out ;(
> 
> Anyway, thanks for your Reviewed-by very much. I hope commiter can add
> this for me.

I will do so, thanks.

greg k-h
