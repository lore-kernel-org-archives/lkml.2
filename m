Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0DSKoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 06:44:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab0DSKn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 06:43:59 -0400
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
In-Reply-To: <4BCA02D1.2020608@redhat.com>
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>
	 <1271356648-5108-2-git-send-email-glommer@redhat.com>
	 <4BCA026D.3070309@redhat.com>  <4BCA02D1.2020608@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 12:43:56 +0200
Message-ID: <1271673836.1674.757.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-17 at 21:49 +0300, Avi Kivity wrote:
> On 04/17/2010 09:48 PM, Avi Kivity wrote:
> >
> >>
> >> +static u64 last_value = 0;
> >
> > Needs to be atomic64_t.
> >
> >> +
> >>   cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
> >>   {
> >>       struct pvclock_shadow_time shadow;
> >>       unsigned version;
> >>       cycle_t ret, offset;
> >> +    u64 last;
> >>
> >>
> >> +    do {
> >> +        last = last_value;
> >
> > Otherwise, this assignment can see a partial update.
> 
> On a 32-bit guest, that is.

Right, do bear in mind that the x86 implementation of atomic64_read() is
terrifyingly expensive, it is better to not do that read and simply use
the result of the cmpxchg.


