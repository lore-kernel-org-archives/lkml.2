Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0EQMEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:04:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab0EQMEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:04:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=OSYbBKpe1VYURWwRBp+68Z2k6e2KIa1v4K1dOMO82M6ArHXS7SX/qee7+FXSHphGV
	Ad0TjdJOdhRJpQJmHW2Lg==
MIME-Version: 1.0
In-Reply-To: <1274097780.5605.4642.camel@twins>
References: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
	 <20100517114605.GB5291@nowhere>
	 <AANLkTil2QBjH2qvnH7VKrg6s7RcKvHC1m0HZkDVDPzv5@mail.gmail.com>
	 <1274097780.5605.4642.camel@twins>
Date: Mon, 17 May 2010 14:04:43 +0200
Message-ID: <AANLkTilJH8RnWjBIY7vrOnXi7w1_z8j9_abD-8tuwL-u@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix errors path in perf_output_begin()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 2:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-05-17 at 13:56 +0200, Stephane Eranian wrote:
>> >> +     if (!data->nr_pages) {
>> >> +             atomic_inc(&data->lost);
>> >> +             goto out;
>> >> +     }
>
>
>> Well, nr_pages = 0 means all you have is the sampling buffer
>> header page. You cannot save any sample, so you  actually
>> loose everything. Perf reports a dozen samples but those
>> are synthetic. The kernel cannot reject an mmap() for
>> just one page because of the remapped counters, thus it
>> has to handle this gracefully and at least report the lost
>> samples.
>
> So you want to preserve this state for when you munmap() and mmap()
> again? The only user of data->lost is writing the PERF_RECORD_LOST
> event, which only ever happens when you have pages, so counting it when
> there's no pages seems futile.

You're right. But couldn't you report lost samples in the buffer header as well?
