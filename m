Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab2AWGjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 01:39:51 -0500
Received: from pop3.cz.nyklogistics.com ([194.212.236.253]:52741 "EHLO
	nbgentoo.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750979Ab2AWGju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 01:39:50 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jan 2012 01:39:50 EST
Date: Mon, 23 Jan 2012 07:33:14 +0100
From: Lubos Kolouch <lubos.kolouch@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit
 cd9dde44f47501394b9f0715b6a36a92aa74c0d0
Message-ID: <20120123063313.GA2113@nbgentoo>
References: <jfe47e$5dn$1@dough.gmane.org>
 <86mx9gkjlv.fsf@sumi.keithp.com>
 <20120121184453.GA2698@nbgentoo>
 <86hazokcb7.fsf@sumi.keithp.com>
 <20120122102912.GA2123@nbgentoo>
 <867h0j83vx.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867h0j83vx.fsf@sumi.keithp.com>
X-Operating-System: Linux nbgentoo 3.3.0-rc1-dirty
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 22, 2012, 20:00:18, Keith Packard wrote:
> On Sun, 22 Jan 2012 11:29:12 +0100, Lubos Kolouch <lubos.kolouch@gmail.com> wrote:
> 
> > Thanks, here you go:
> > dmesg after boot - http://paste.pocoo.org/show/538625/
> > dmesg after failed resume - http://paste.pocoo.org/show/538626/
> 
> Ok, looks like my theory is correct. We're fitting a 24bpp mode to an
> 18bpp data rate, which doesn't work.
> 
> I'm in the middle of bisecting a bluetooth failure in 3.3-rc1, so I
> don't have a working kernel at present, but here's a section of
> intel_dp.c in the intel_dp_mode_fixup function:
> 
>   	int max_clock = intel_dp_max_link_bw(intel_dp) == DP_LINK_BW_2_7 ? 1 : 0;
> -	int bpp = mode->private_flags & INTEL_MODE_DP_FORCE_6BPC ? 18 : 0;
> +	int bpp = mode->private_flags & INTEL_MODE_DP_FORCE_6BPC ? 18 : 24;
>  	static int bws[2] = { DP_LINK_BW_1_62, DP_LINK_BW_2_7 };
> 
> (this is completely hand-generated, so 'patch' will almost certainly not work)
> 
> This will force it to use the correct bpp when computing the bandwidth
> used by the new mode. This should fix your problem. If so, I'll have a
> larger patch which stops the underlying function from (almost always
> incorrectly) using the current bpp when computing bandwidth.
> 
> -- 
> keith.packard@intel.com
Thanks, I applied it and it seems to solve the issue!

dmesg after boot - http://paste.pocoo.org/show/539115/
dmesg after OK resume - http://paste.pocoo.org/show/539117/

Lubos
