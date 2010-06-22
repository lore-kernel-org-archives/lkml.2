Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab0FVNzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 09:55:53 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:60391 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758236Ab0FVNzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 09:55:50 -0400
Message-ID: <4C20C098.1010200@euromail.se>
Date: Tue, 22 Jun 2010 15:54:32 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Jiri Kosina <jkosina@suse.cz>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] Introduce buflock, a one-to-many circular buffer mechanism
 (rev2)
References: <1277060705-3363-1-git-send-email-rydberg@euromail.se> <20100621161610.fdfe23a6.akpm@linux-foundation.org>
In-Reply-To: <20100621161610.fdfe23a6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OR3vw-000844-86.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OR3vw-000844-86 da82b44e002f6e25d4ab82568d799457
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
[...]
> I don't understand why this has "lock" in its name.
> 
> The API itself is a mixture of "bufwrite_foo" and "bufread_foo".
> 
> It's all a bit chaotic.  I'd suggest picking a sane name for the whole
> subsytem - perhaps "mrbuf" for "multi reader buffer"?  Then
> consistently name all interface functions as "mrbuf_foo". 
> mrbuf.h, mrbuf_write_lock(), etc.

Point taken.

>> +static __always_inline bool __must_check bufread_retry(struct buflock_reader *br, const struct buflock_writer *bw)
>> +{
>> +	smp_rmb();
>> +	if (unlikely(((br->tail - br->last) & bw->page) < bw->next - br->last))
>> +		return true;
>> +	++br->tail;
>> +	if (unlikely(br->head - br->tail > bw->page))
>> +		br->tail = br->head;
>> +	return false;
>> +}
> 
> This looks too large to be inlined.
> 
> What's the __always_inline for?  Was gcc uninlining this within
> separate compilation units?

As you say, the function is large, and I am uncertain about the rules regarding
compiler reordering across general function calls. Starting a general function
with a memory barrier feels weird. Perhaps the function should be split?

Thanks,
Henrik

