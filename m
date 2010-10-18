Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab0JRPju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:39:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59080 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab0JRPjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qyms6WO1tkSnnh3XtkQdzMDNxhkJxrd6gT6QYzMPhhBP4edlaAJui2aTAHi09XOCIV
         Bfy+MfQy8KTJz4knpDSZu2jqOJygSWueWRaUWNeCgz8euIGtwu0Jzflhaw3bw1IPDU2z
         ULfcr3okzlaaTA0X3dyw6++QlOjVussCI4Sk4=
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@kernel.dk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1010181015290.755@router.home>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-17-git-send-email-david@fromorbit.com>
	 <20100929215322.ff635d3e.akpm@linux-foundation.org>
	 <20100930061039.GX5665@dastard> <20101016075510.GH19147@amd>
	 <1287217748.2799.68.camel@edumazet-laptop>
	 <20101016020744.366bd9c6.akpm@linux-foundation.org>
	 <1287221475.2799.123.camel@edumazet-laptop>
	 <1287238754.2799.376.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1010181015290.755@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 17:39:40 +0200
Message-ID: <1287416380.2409.13.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 18 octobre 2010 à 10:24 -0500, Christoph Lameter a écrit :
> On Sat, 16 Oct 2010, Eric Dumazet wrote:
> 
> > I based following patch against linux-2.6, I dont know if previous
> > Christoph patch is in a git tree. I'll respin it eventually.
> 
> The prior patch was accepted by Andrew.
> 
> > + * - It is preempt safe, but not IRQ safe (on UP)
> 
> The IRQ safeness depends on the arch. this_cpu_add() in general only
> guarantees safety against preemption. It so happens that the x86
> implementation is irq safe as well.
> 
> The IRQ safety for UP is therefore not an issue if you use this_cpu_add().
> 

Nope, on UP, we dont use a per_cpu field, just a "s64 count".

struct percpu_counter {
        s64 count;
};



> If you want to guarantee irqsafeness then use irqsafe_cpu_add() instead.
> It generates the same code on x86 for SMP but takes care of the UP issues.
> 
> > +static inline void percpu_counter_add_fast(struct percpu_counter *fbc, long amount)
> > +{
> > +	this_cpu_add(*fbc->counters, amount);
> > +}
> 
> What happens in case of counter overflow?
> 

Nothing special, as I stated the usuable width of such counters would be
restricted to a long, not an s64.

It should be enough to count "number of inodes, of sockets, ..."



