Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1BOPsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 10:48:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:34492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab1BOPsx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 10:48:53 -0500
Subject: Re: [PATCH v3 4/6] KVM-GST: KVM Steal time registration
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <4D5A9091.6090506@redhat.com>
References: <1297448364-14051-1-git-send-email-glommer@redhat.com>
	 <1297448364-14051-5-git-send-email-glommer@redhat.com>
	 <4D5A9091.6090506@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Feb 2011 16:48:47 +0100
Message-ID: <1297784927.2413.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 16:41 +0200, Avi Kivity wrote:
> > +static int kvm_register_steal_time(void)
> > +{
> > +     int cpu = smp_processor_id();
> > +     int low, high, ret;
> > +     struct kvm_steal_time *st =&per_cpu(steal_time, cpu);
> > +
> > +     if (!hypervisor_steal_time)
> > +             return 0;
> 
> You're using hypervisor_steal_time to communicate the existence of the 
> feature.  Yuck. 

Yeah, ideally we make steal_time_clock() a proper paravirt op with:

u64 native_steal_time_clock(int cpu)
{
	WARN_ONCE(1, "Using steal_time_clock() on actual hardware..\n");
	return 0;
}

And use paravirt_enabled() to avoid calling it where possible. Then once
we have all the jump_label stuff sorted we can make paravirt_enabled() a
static_branch() and it'll just go away on native.


