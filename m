Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1BROy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:54:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:36000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab1BROyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:54:22 -0500
Subject: Re: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data,
 SW events
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@ghostprotocols.net, paulus@samba.org
In-Reply-To: <4D5E8338.8010602@cisco.com>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
	 <1298008433-22911-2-git-send-email-daahern@cisco.com>
	 <1298026821.5226.642.camel@laptop>  <4D5E8338.8010602@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 15:55:38 +0100
Message-ID: <1298040938.5226.771.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 07:33 -0700, David Ahern wrote:
> 
> On 02/18/11 04:00, Peter Zijlstra wrote:
> > On Thu, 2011-02-17 at 22:53 -0700, David Ahern wrote:
> >> This check does not work out for 64-bit counter:
> >>
> >>     sizeof(u32) + sizeof(u64) = 4 + 8 = 12
> >>
> >> which does not pass the WARN_ON_ONCE test. I'm guessing (hoping
> >> really) that the intent is that the size of the raw data is a
> >> multiple of 4 bytes, not 8.
> > 
> > No the data must come in 8bytes strides.
> > 
> 
> Then the sizeof the size field needs to be moved to u64; right now it is
> u32:

That's a false conclusion.

> struct perf_raw_record {
>     u32             size;
>     void                *data;
> };

> So size should be changed to u64 rather than modifying the WARN_ON_ONCE?

No.

> Another gotcha is in perf_output_sample there is:
>             struct {
>                 u32 size;
>                 u32 data;
>             } raw = {
>                 .size = sizeof(u32),
>                 .data = 0,
>             };
> 
> While that meets the 8-byte stride I was concerned that changing the
> size field to u64 breaks ABI.

It would.

No, what you need to do is provide data that is sized such that it
matches the 8b stride adding padding where needed.

Anyway, I don't think you need RAW at all.

