Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1D0Hl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 03:41:28 -0400
Received: from mx0.aculab.com ([213.249.233.131]:48674 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751734Ab1D0Hl1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 03:41:27 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V4] POWER: perf_event: Skip updating kernel counters if register value shrinks
Date: Wed, 27 Apr 2011 08:40:36 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8ACFA@saturn3.aculab.com>
In-Reply-To: <1302891150-8121-1-git-send-email-emunson@mgebm.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V4] POWER: perf_event: Skip updating kernel counters if register value shrinks
Thread-Index: Acv7mKefZwlhdR0kSa61AWY390WAfwJFTC7w
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric B Munson" <emunson@mgebm.net>, <benh@kernel.crashing.org>
Cc: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@elte.hu>,
        <acme@ghostprotocols.net>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <anton@samba.org>, <stable@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I keep telling Eric that the code below is incorrect
modulo arithimetic...

> +static u64 check_and_compute_delta(u64 prev, u64 val)
> +{
> +	u64 delta = (val - prev) & 0xfffffffful;
> +
> +	/*
> +	 * POWER7 can roll back counter values, if the new value is
smaller
> +	 * than the previous value it will cause the delta and the
counter to
> +	 * have bogus values unless we rolled a counter over.  If a
coutner is
> +	 * rolled back, it will be smaller, but within 256, which is the
maximum
> +	 * number of events to rollback at once.  If we dectect a
rollback
> +	 * return 0.  This can lead to a small lack of precision in the
> +	 * counters.
> +	 */
> +	if (prev > val && (prev - val) < 256)
> +		delta = 0;
> +
> +	return delta;

The code should detect rollback by looking at the value of 'delta'
otherwise there are horrid end effects near 2^32-1.

For instance:
	u32 delta = val - prev;
	return delta & 0x80000000 ? 0 : delta;


   David




