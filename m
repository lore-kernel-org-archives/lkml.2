Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab0EJVKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:10:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab0EJVKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:10:30 -0400
X-Authority-Analysis: v=1.1 cv=nrqrmdtKPnrEe5McJVoaEKFzY/lexCxOe+Stj/aSkNs= c=1 sm=0 a=H3ye9l9LKTQA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=CrcsiEUOVWRLc7bLdHQA:9 a=AUtfvQEl0e0MPRh-irjT9w0Iz2YA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [rfc] x86,perf: P4 PMU -- use hash for p4_get_escr_idx
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20100510152708.GS5104@lenovo>
References: <20100510152708.GS5104@lenovo>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 10 May 2010 17:10:27 -0400
Message-ID: <1273525827.22438.4489.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 19:27 +0400, Cyrill Gorcunov wrote:

>  static int p4_get_escr_idx(unsigned int addr)
>  {
> -	unsigned int i;
> +	unsigned int idx = P4_ESCR_MSR_IDX(addr);
>  
> -	for (i = 0; i < ARRAY_SIZE(p4_escr_map); i++) {
> -		if (addr == p4_escr_map[i])
> -			return i;
> -	}
> +	BUG_ON(idx >= P4_ESCR_MSR_TABLE_SIZE);
> +	BUG_ON(!p4_escr_table[idx]);

Is there any softer way to handle this. IOW, must it be a BUG_ON()? or
can you add a WARN_ON() and pass back something that will cause it to
fail a bit nicer.

A BUG_ON() may panic the box and if you are in X on a laptop, all you
see is that your box locked up hard. If this is a WARN_ON() and you can
prevent further damage to the computer (no file corruption or anything)
then the user may notice, "Oh, my dmesg has this nasty error here", and
report something useful.

You could do:

	if (WARN_ON(idx >= P4_ESCR_MSR_TABLE_SIZE))
		return -1;

or whatever.

Thanks,

-- Steve

>  
> -	return -1;
> +	return idx;
>  }
>  

